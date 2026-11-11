<?php
namespace App\Http\Controllers\API;
use App\Models\Solicitud;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
class SolicitudController extends Controller
{
    public function index()
    {
        return Solicitud::with(['cliente', 'habitacion'])
            ->orderByDesc('created_at')
            ->get();
    }
    public function store(Request $request)
    {
        $datos = $request->validate([
            'id_cliente'    => 'required|exists:clientes,id_cliente',
            'id_habitacion' => 'required|exists:habitaciones,id_habitacion',
            'fecha_inicio'  => 'required|date',
            'fecha_fin'     => 'required|date|after:fecha_inicio',
            'personas'      => 'required|integer|min:1',
        ]);
        $datos['estado'] = 'pendiente';
        return response()->json(Solicitud::create($datos), 201);
    }
    public function update(Request $request, $id)
    {
        $solicitud = Solicitud::findOrFail($id);
        $datos = $request->validate([
            'estado' => 'required|in:pendiente,confirmada,cancelada',
        ]);
        $solicitud->update($datos);
        return response()->json($solicitud);
    }
}
