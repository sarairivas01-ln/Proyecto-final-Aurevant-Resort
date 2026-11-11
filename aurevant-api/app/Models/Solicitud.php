<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Solicitud extends Model
{
    protected $table = 'solicitudes';
    protected $primaryKey = 'id_solicitud';
    protected $fillable = [
        'id_cliente', 'id_habitacion', 'fecha_inicio', 'fecha_fin', 'personas', 'estado'
    ];
    public function cliente()
    {
        return $this->belongsTo(Cliente::class, 'id_cliente', 'id_cliente');
    }
    public function habitacion()
    {
        return $this->belongsTo(Habitacion::class, 'id_habitacion', 'id_habitacion');
    }
}
