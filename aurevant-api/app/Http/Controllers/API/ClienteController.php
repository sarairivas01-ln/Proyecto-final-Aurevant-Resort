<?php
namespace App\Http\Controllers\API;
use App\Http\Controllers\Controller;
use App\Models\Cliente;
use Illuminate\Http\Request;
class ClienteController extends Controller
{
    public function index()
    {
        return response()->json(Cliente::orderBy('nombre')->get());
    }
    public function store(Request $request)
    {
        $datos = $request->validate([
            'nombre'   => 'required|string|max:100',
            'email'    => 'required|email|max:150|unique:clientes,email',
            'DUI' => 'nullable|string|max:10',
            'telefono' => 'required|string|max:15',
        ]);
        return response()->json(Cliente::create($datos), 201);
    }
    public function update(Request $request, $id)
    {
        $cliente = Cliente::findOrFail($id);
        $datos = $request->validate([
            'nombre'   => 'sometimes|string|max:100',
            'email'    => 'sometimes|email|max:150|unique:clientes,email,' . $id . ',id_cliente',
            'DUI' => 'nullable|string|max:10',
            'telefono' => 'sometimes|string|max:15',
        ]);
        $cliente->update($datos);
        return response()->json($cliente);
    }
    public function destroy($id)
    {
        Cliente::findOrFail($id)->delete();
        return response()->json(['mensaje' => 'Cliente eliminado']);
    }
}
