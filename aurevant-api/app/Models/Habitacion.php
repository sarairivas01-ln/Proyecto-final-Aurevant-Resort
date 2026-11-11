<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Habitacion extends Model
{
    protected $table = 'habitaciones';
    protected $primaryKey = 'id_habitacion';
    protected $fillable = [
        'numero', 'tipo', 'capacidad', 'precio_noche', 'descripcion',
        'vista', 'balcon', 'estado', 'activa', 'img',
    ];
    protected $casts = [
        'balcon' => 'boolean',
        'activa' => 'boolean',
        'precio_noche' => 'decimal:2',
    ];
    public function reservas()
{
    return $this->hasMany(ReservaHotel::class, 'id_habitacion', 'id_habitacion');
}
}
