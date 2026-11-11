<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Cliente;
use App\Models\Habitacion;
class ReservaHotel extends Model
{
    use HasFactory;
    protected $table = 'reservas_hotel';
    protected $primaryKey = 'id_reserva';
    public $incrementing = true;
    protected $keyType = 'int';
    protected $fillable = [
        'id_cliente',
        'id_habitacion',
        'fecha_inicio',
        'fecha_fin',
        'estado',
    ];
    protected $casts = [
        'fecha_inicio' => 'date:Y-m-d',
        'fecha_fin'    => 'date:Y-m-d',
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
