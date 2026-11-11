<?php
namespace App\Http\Controllers\API;
use App\Http\Controllers\Controller;
use App\Models\Mesa;
use App\Models\ReservaMesa;
use Illuminate\Http\Request;
class MesaController extends Controller
{
    public function index()
    {
        $this->liberarVencidas();
        return response()->json(
            Mesa::with(['reservas.cliente'])->orderBy('id_mesa')->get()
        );
    }
    public function publicas()
    {
        $this->liberarVencidas();
        return Mesa::where('estado', 'disponible')
            ->select('id_mesa', 'capacidad', 'ambiente', 'estado')
            ->orderBy('id_mesa')
            ->get();
    }
    public function liberarVencidas(): void
    {
        Mesa::whereNotNull('liberar_en')
            ->where('liberar_en', '<=', now())
            ->update(['estado' => 'disponible', 'liberar_en' => null]);
    }
    public function store(Request $request)
    {
        $datos = $request->validate([
            'capacidad' => 'required|integer|min:1',
            'ambiente'  => 'required|in:terraza,chimenea,ventanal',
            'estado'    => 'required|in:disponible,ocupada,reservada',
        ]);
        return response()->json(Mesa::create($datos), 201);
    }
    public function update(Request $request, $id)
    {
        $mesa = Mesa::findOrFail($id);
        $datos = $request->validate([
            'capacidad' => 'sometimes|integer|min:1',
            'ambiente'  => 'sometimes|in:terraza,chimenea,ventanal',
            'estado'    => 'sometimes|in:disponible,ocupada,reservada',
        ]);
        if (isset($datos['estado'])) {
            if ($datos['estado'] === 'disponible') {
                ReservaMesa::where('id_mesa', $mesa->id_mesa)
                    ->whereIn('estado', ['pendiente', 'confirmada'])
                    ->update(['estado' => 'cancelada']);
                $datos['liberar_en'] = null;
            } else {
                $datos['liberar_en'] = now()->addMinutes(5);
            }
        }
        $mesa->update($datos);
        return response()->json($mesa->load('reservas.cliente'));
    }
    public function destroy($id)
    {
        $mesa = Mesa::findOrFail($id);
        if ($mesa->reservas()->whereIn('estado', ['pendiente', 'confirmada'])->exists()) {
            return response()->json([
                'message' => 'No se puede eliminar: la mesa tiene reservas activas.',
            ], 409);
        }
        $mesa->delete();
        return response()->json(['ok' => true]);
    }
}
