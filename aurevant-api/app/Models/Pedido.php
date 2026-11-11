<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Pedido extends Model
{
    protected $table = 'pedidos';
    protected $primaryKey = 'id_pedido';
    protected $fillable = [
        'id_reserva_mesa',
        'fecha_pedido',
        'hora_pedido',
        'estado',
        'total',
    ];
    public function reservaMesa()
    {
        return $this->belongsTo(ReservaMesa::class, 'id_reserva_mesa', 'id_reserva_mesa');
    }
    public function detalles()
    {
        return $this->hasMany(DetallePedido::class, 'id_pedido', 'id_pedido');
    }
}
