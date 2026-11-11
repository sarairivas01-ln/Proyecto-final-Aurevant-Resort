<?php
namespace App\Http\Controllers\API;
use App\Http\Controllers\Controller;
use App\Models\Cliente;
use App\Models\Habitacion;
use App\Models\Mesa;
use App\Models\Pedido;
use App\Models\ReservaHotel;
use App\Models\Solicitud;
use Illuminate\Support\Facades\DB;
class DashboardController extends Controller
{
    public function index()
    {
        $hoy = now()->toDateString();
        // ---------- KPIs ----------
        $reservacionesHoy = ReservaHotel::whereDate('fecha_inicio', $hoy)->count();
        $totalHabitaciones = Habitacion::count();
        // Ocupadas = reservas vigentes hoy (no el estado de la tabla habitaciones)
        $ocupadas = ReservaHotel::whereDate('fecha_inicio', '<=', $hoy)
            ->whereDate('fecha_fin', '>=', $hoy)
            ->whereIn('estado', ['confirmada', 'ocupada'])
            ->count();
        $clientesHoy = Cliente::whereDate('created_at', $hoy)->count();
        $solicitudesPendientes = Solicitud::where('estado', 'pendiente')->count();
        // ---------- Habitaciones por estado ----------
        $porEstado = Habitacion::select('estado', DB::raw('count(*) as total'))
            ->groupBy('estado')
            ->pluck('total', 'estado');
        // ---------- Reservaciones (todas: tarjetas + dona) ----------
        $reservaciones = ReservaHotel::with(['cliente', 'habitacion'])
            ->orderByDesc('fecha_inicio')
            ->get();
        // ---------- Check-in de hoy ----------
        $checkins = ReservaHotel::with(['cliente', 'habitacion'])
            ->whereDate('fecha_inicio', $hoy)
            ->whereIn('estado', ['confirmada', 'pendiente'])
            ->get();
        // ---------- Check-out de hoy ----------
        $checkouts = ReservaHotel::with(['cliente', 'habitacion'])
            ->whereDate('fecha_fin', $hoy)
            ->whereIn('estado', ['confirmada', 'ocupada'])
            ->get();
        // ---------- Próximas reservaciones ----------
        $proximas = ReservaHotel::with(['cliente', 'habitacion'])
            ->whereDate('fecha_inicio', '>', $hoy)
            ->orderBy('fecha_inicio')
            ->limit(4)
            ->get();
        // ---------- Restaurante / Bar ----------
        $mesasOcupadas = Mesa::where('estado', 'ocupada')->count();
        $mesasTotal    = Mesa::count();
        $pedidosActivos = Pedido::whereIn('estado', ['pendiente', 'en preparacion', 'servido'])
            ->count();
        $ventaDelDia = Pedido::whereDate('fecha_pedido', $hoy)
            ->where('estado', 'pagado')
            ->sum('total');
        return response()->json([
            'kpis' => [
                'reservaciones_hoy'      => $reservacionesHoy,
                'habitaciones_ocupadas'  => $ocupadas,
                'habitaciones_total'     => $totalHabitaciones,
                'clientes_hoy'           => $clientesHoy,
                'solicitudes_pendientes' => $solicitudesPendientes,
                'mesas_ocupadas'         => $mesasOcupadas,
                'mesas_total'            => $mesasTotal,
                'pedidos_activos'        => $pedidosActivos,
                'venta_del_dia'          => (float) $ventaDelDia,
            ],
            'estado_habitaciones' => [
                'disponibles'   => $porEstado['Disponible']    ?? 0,
                'ocupadas'      => $ocupadas,
                'mantenimiento' => $porEstado['Mantenimiento'] ?? 0,
                'limpieza'      => $porEstado['Limpieza']      ?? 0,
            ],
            'reservaciones' => $reservaciones,
            'checkins'      => $checkins,
            'checkouts'     => $checkouts,
            'proximas'      => $proximas,
        ]);
    }
}
