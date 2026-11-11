<?php
namespace App\Http\Controllers\API;
use App\Http\Controllers\Controller;
use App\Models\Cliente;
use App\Models\Mesa;
use App\Models\ReservaMesa;
use Carbon\Carbon;
use Illuminate\Http\Request;
class ReservaMesaController extends Controller
{
    private const MINUTOS_LIBERACION = 5;
    public function index()
    {
        $this->liberarVencidas();
        return ReservaMesa::with('mesa', 'cliente')
            ->orderByDesc('fecha')
            ->orderByDesc('hora')
            ->get();
    }
    public function store(Request $request)
    {
        $datos = $request->validate([
            'id_mesa'  => 'required|exists:mesas,id_mesa',
            'nombre'   => 'required|string|max:100',
            'telefono' => 'required|string|max:20',
            'fecha'    => 'required|date',
            'hora'     => 'required',
            'personas' => 'required|integer|min:1',
        ]);
        $mesa = Mesa::findOrFail($datos['id_mesa']);
        if (strtolower($mesa->estado) === 'ocupada') {
            return response()->json([
                'message' => 'La mesa está ocupada en este momento.',
            ], 422);
        }
        if ($datos['personas'] > $mesa->capacidad) {
            return response()->json([
                'message' => "La mesa solo admite {$mesa->capacidad} personas.",
            ], 422);
        }
        $inicio = Carbon::parse($datos['fecha'] . ' ' . $datos['hora'])->subHours(2);
        $fin    = Carbon::parse($datos['fecha'] . ' ' . $datos['hora'])->addHours(2);
        $conflicto = ReservaMesa::where('id_mesa', $datos['id_mesa'])
            ->whereDate('fecha', $datos['fecha'])
            ->whereIn('estado', ['pendiente', 'confirmada'])
            ->whereBetween('hora', [$inicio->format('H:i:s'), $fin->format('H:i:s')])
            ->exists();
        if ($conflicto) {
            return response()->json([
                'message' => 'Ya existe una reservación para esa mesa en ese horario.',
            ], 422);
        }
        $cliente = Cliente::firstOrCreate(
            ['telefono' => $datos['telefono']],
            ['nombre'   => $datos['nombre']]
        );
        $reserva = ReservaMesa::create([
            'id_mesa'    => $mesa->id_mesa,
            'id_cliente' => $cliente->id_cliente,
            'fecha'      => $datos['fecha'],
            'hora'       => $datos['hora'],
            'personas'   => $datos['personas'],
            'estado'     => 'pendiente',
            'expira_en'  => now()->addMinutes(self::MINUTOS_LIBERACION),
        ]);
        $mesa->update([
            'estado'     => 'reservada',
            'liberar_en' => now()->addMinutes(self::MINUTOS_LIBERACION),
        ]);
        return response()->json($reserva->load('mesa', 'cliente'), 201);
    }
    public function show($id)
    {
        return ReservaMesa::with('mesa', 'cliente')->findOrFail($id);
    }
    public function update(Request $request, $id)
    {
        $reserva = ReservaMesa::findOrFail($id);
        $datos = $request->validate([
            'fecha'    => 'sometimes|date',
            'hora'     => 'sometimes',
            'personas' => 'sometimes|integer|min:1',
            'estado'   => 'sometimes|in:pendiente,confirmada,cancelada',
        ]);
        $reserva->update($datos);
        if (($datos['estado'] ?? null) === 'confirmada') {
            Mesa::where('id_mesa', $reserva->id_mesa)->update([
                'estado'     => 'ocupada',
                'liberar_en' => null,
            ]);
        }
        if (($datos['estado'] ?? null) === 'cancelada') {
            Mesa::where('id_mesa', $reserva->id_mesa)->update([
                'estado'     => 'disponible',
                'liberar_en' => null,
            ]);
        }
        return response()->json($reserva->fresh(['mesa', 'cliente']));
    }
    public function destroy($id)
    {
        $reserva = ReservaMesa::findOrFail($id);
        Mesa::where('id_mesa', $reserva->id_mesa)->update([
            'estado'     => 'disponible',
            'liberar_en' => null,
        ]);
        $reserva->delete();
        return response()->json(['message' => 'Reserva eliminada.']);
    }
    public function cambiarEstado(Request $request, $id)
    {
        $request->validate([
            'estado' => 'required|in:pendiente,confirmada,cancelada',
        ]);
        return $this->update($request, $id);
    }
    private function liberarVencidas()
    {
        Mesa::where('estado', 'reservada')
            ->whereNotNull('liberar_en')
            ->where('liberar_en', '<=', now())
            ->update([
                'estado'     => 'disponible',
                'liberar_en' => null,
            ]);
        ReservaMesa::where('estado', 'pendiente')
            ->whereNotNull('expira_en')
            ->where('expira_en', '<=', now())
            ->update(['estado' => 'cancelada']);
    }
}
