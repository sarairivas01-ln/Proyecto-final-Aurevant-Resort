<?php
namespace App\Http\Controllers\API;
use App\Http\Controllers\Controller;
use App\Models\Platillo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
class PlatilloController extends Controller
{
    public function index()
    {
        return response()->json(
            Platillo::orderBy('id_platillo', 'desc')->get()
        );
    }
    public function show($id)
    {
        return response()->json(Platillo::findOrFail($id));
    }
    public function store(Request $request)
    {
        $datos = $request->validate([
            'nombre'       => 'required|string|max:120',
            'descripcion'  => 'nullable|string',
            'precio'       => 'required|numeric|min:0',
            'categoria'    => 'required|string|max:60',
            'tipo'         => 'required|in:platillo,bebida',
            'ingredientes' => 'nullable|string',
            'activo'       => 'sometimes|boolean',
            'img'          => 'nullable|image|mimes:png,jpg,jpeg,webp|max:2048',
        ]);
        if ($request->hasFile('img')) {
            $datos['img'] = '/storage/' . $request->file('img')->store('platillos', 'public');
        }
        $datos['activo'] = $request->boolean('activo', true);
        $platillo = Platillo::create($datos);
        return response()->json($platillo, 201);
    }
    public function update(Request $request, $id)
    {
        $platillo = Platillo::findOrFail($id);
        $datos = $request->validate([
            'nombre'       => 'required|string|max:120',
            'descripcion'  => 'nullable|string',
            'precio'       => 'required|numeric|min:0',
            'categoria'    => 'required|string|max:60',
            'tipo'         => 'required|in:platillo,bebida',
            'ingredientes' => 'nullable|string',
            'activo'       => 'sometimes|boolean',
            'img'          => 'nullable|image|mimes:png,jpg,jpeg,webp|max:2048',
        ]);
        if ($request->hasFile('img')) {
            if ($platillo->img && str_starts_with($platillo->img, '/storage/')) {
                Storage::disk('public')->delete(str_replace('/storage/', '', $platillo->img));
            }
            $datos['img'] = '/storage/' . $request->file('img')->store('platillos', 'public');
        }
        if ($request->has('activo')) {
            $datos['activo'] = $request->boolean('activo');
        }
        $platillo->update($datos);
        return response()->json($platillo);
    }
    public function destroy($id)
    {
        $platillo = Platillo::findOrFail($id);
        if ($platillo->img && str_starts_with($platillo->img, '/storage/')) {
            Storage::disk('public')->delete(str_replace('/storage/', '', $platillo->img));
        }
        $platillo->delete();
        return response()->json(['mensaje' => 'Platillo eliminado']);
    }
}
