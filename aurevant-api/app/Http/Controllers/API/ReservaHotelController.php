<?php
namespace App\Http\Controllers\API;
use App\Http\Controllers\Controller;
use App\Models\ReservaHotel;
use Illuminate\Http\Request;
class ReservaHotelController extends Controller
{
    public function index()
    {
        $reservas = ReservaHotel::with(['cliente', 'habitacion'])
            ->orderBy('fecha_inicio', 'desc')
            ->get()
            ->map(fn ($r) => [
                'id_reserva'    => $r->id_reserva,
                'id_cliente'    => $r->id_cliente,
                'id_habitacion' => $r->id_habitacion,
                'cliente'       => $r->cliente->nombre ?? 'Sin cliente',
                'habitacion'    => $r->habitacion->numero ?? 'Sin habitación',
                'fecha_inicio'  => $r->fecha_inicio->format('Y-m-d'),
                'fecha_fin'     => $r->fecha_fin->format('Y-m-d'),
                'estado'        => ucfirst($r->estado),
            ]);
        return response()->json($reservas);
    }
    public function store(Request $request)
    {
        $datos = $request->validate([
            'id_cliente'    => 'required|exists:clientes,id_cliente',
            'id_habitacion' => 'required|exists:habitaciones,id_habitacion',
            'fecha_inicio'  => 'required|date',
            'fecha_fin'     => 'required|date|after:fecha_inicio',
            'estado'        => 'sometimes|in:confirmada,pendiente,cancelada',
        ]);
        $datos['estado'] = $datos['estado'] ?? 'pendiente';
        $reserva = ReservaHotel::create($datos);
        return response()->json($reserva, 201);
    }
    public function update(Request $request, $id)
    {
        $reserva = ReservaHotel::findOrFail($id);
        $datos = $request->validate([
            'id_cliente'    => 'sometimes|exists:clientes,id_cliente',
            'id_habitacion' => 'sometimes|exists:habitaciones,id_habitacion',
            'fecha_inicio'  => 'sometimes|date',
            'fecha_fin'     => 'sometimes|date|after:fecha_inicio',
            'estado'        => 'sometimes|in:confirmada,pendiente,cancelada',
        ]);
        $reserva->update($datos);
        return response()->json($reserva);
    }
    public function destroy($id)
    {
        ReservaHotel::findOrFail($id)->delete();
        return response()->json(['mensaje' => 'Reserva eliminada']);
    }
}
