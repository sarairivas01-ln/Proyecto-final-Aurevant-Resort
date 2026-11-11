<?php
namespace App\Http\Controllers\API;
use App\Http\Controllers\Controller;
use App\Models\Habitacion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;
class HabitacionController extends Controller
{
    public function index()
    {
        return response()->json(Habitacion::all());
    }
    public function store(Request $request)
    {
        $data = $request->validate([
            'numero'       => 'required|string|max:10|unique:habitaciones,numero',
            'tipo'         => 'required|string|max:50',
            'descripcion'  => 'nullable|string',
            'precio_noche' => 'required|numeric|min:0.01',
            'capacidad'    => 'required|integer|min:1',
            'vista'        => 'required|string',
            'balcon'       => 'boolean',
            'estado'       => 'required|in:Disponible,Ocupada,Mantenimiento',
            'activa'       => 'boolean',
            'img'          => 'nullable|image|max:4096',
        ]);
        if ($request->hasFile('img')) {
            $data['img'] = $request->file('img')->store('habitaciones', 'public');
        } else {
            unset($data['img']);   // 👈 CAMBIO
        }
        $habitacion = Habitacion::create($data);
        return response()->json($habitacion, 201);
    }
    public function update(Request $request, $id)
    {
        $habitacion = Habitacion::findOrFail($id);
        $data = $request->validate([
            'numero'       => [
                'required', 'string', 'max:10',
                Rule::unique('habitaciones', 'numero')->ignore($id, 'id_habitacion'),
            ],
            'tipo'         => 'required|string|max:50',
            'descripcion'  => 'nullable|string',
            'precio_noche' => 'required|numeric|min:0.01',
            'capacidad'    => 'required|integer|min:1',
            'vista'        => 'required|string',
            'balcon'       => 'boolean',
            'estado'       => 'required|in:Disponible,Ocupada,Mantenimiento',
            'activa'       => 'boolean',
            'img'          => 'nullable|image|max:4096',
        ]);
        if ($request->hasFile('img')) {
            if ($habitacion->img) {
                Storage::disk('public')->delete($habitacion->img);
            }
            $data['img'] = $request->file('img')->store('habitaciones', 'public');
        } else {
            unset($data['img']);   // 👈 CAMBIO: conserva la imagen actual
        }
        $habitacion->update($data);
        return response()->json($habitacion->fresh());
    }
    public function toggle($id)
    {
        $habitacion = Habitacion::findOrFail($id);
        $habitacion->activa = !$habitacion->activa;
        $habitacion->save();
        return response()->json($habitacion);
    }
}
