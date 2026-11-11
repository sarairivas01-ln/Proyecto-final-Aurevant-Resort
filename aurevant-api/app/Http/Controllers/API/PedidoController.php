<?php
namespace App\Http\Controllers\API;
use App\Http\Controllers\Controller;
use App\Models\Pedido;
use App\Models\Platillo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
class PedidoController extends Controller
{
    public function index()
    {
        $pedidos = Pedido::with([
            'reservaMesa.mesa',
            'reservaMesa.cliente',
            'detalles.platillo',
            'detalles.bebida',
        ])->orderBy('id_pedido', 'desc')->get();
        return response()->json($pedidos);
    }
    public function show($id)
    {
        $pedido = Pedido::with([
            'reservaMesa.mesa',
            'reservaMesa.cliente',
            'detalles.platillo',
            'detalles.bebida',
        ])->findOrFail($id);
        return response()->json($pedido);
    }
    public function store(Request $request)
    {
        $datos = $request->validate([
            'id_reserva_mesa'     => 'required|exists:reservas_mesa,id_reserva_mesa',
            'items'               => 'required|array|min:1',
            'items.*.id_platillo' => 'required|exists:platillos,id_platillo',
            'items.*.cantidad'    => 'required|integer|min:1',
        ]);
        DB::beginTransaction();
        try {
            $pedido = Pedido::create([
                'id_reserva_mesa' => $datos['id_reserva_mesa'],
                'fecha_pedido'    => now()->toDateString(),
                'hora_pedido'     => now()->toTimeString(),
                'total'           => 0,
                'estado'          => 'pendiente',
            ]);
            $total = 0;
            foreach ($datos['items'] as $item) {
                $platillo = Platillo::findOrFail($item['id_platillo']);
                $subtotal = $platillo->precio * $item['cantidad'];
                $total += $subtotal;
                $pedido->detalles()->create([
                    'id_platillo'     => $platillo->id_platillo,
                    'id_bebida'       => null,
                    'cantidad'        => $item['cantidad'],
                    'precio_unitario' => $platillo->precio,
                    'subtotal'        => $subtotal,
                ]);
            }
            $pedido->update(['total' => $total]);
            DB::commit();
            return response()->json(
                $pedido->load('reservaMesa.mesa', 'reservaMesa.cliente', 'detalles.platillo', 'detalles.bebida'),
                201
            );
        } catch (\Throwable $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'No se pudo crear el pedido.',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }
    public function update(Request $request, $id)
    {
        $pedido = Pedido::findOrFail($id);
        $datos = $request->validate([
            'estado' => 'required|in:pendiente,en_preparacion,servido,pagado',
        ]);
        $pedido->update($datos);
        if ($datos['estado'] === 'pagado' && $pedido->reservaMesa?->mesa) {
            $pedido->reservaMesa->mesa->update(['estado' => 'disponible']);
        }
        return response()->json(
            $pedido->load('reservaMesa.mesa', 'reservaMesa.cliente', 'detalles.platillo', 'detalles.bebida')
        );
    }
    public function destroy($id)
    {
        $pedido = Pedido::findOrFail($id);
        $pedido->detalles()->delete();
        $pedido->delete();
        return response()->json(['ok' => true]);
    }
}
