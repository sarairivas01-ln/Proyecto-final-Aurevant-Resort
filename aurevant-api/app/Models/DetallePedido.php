<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class DetallePedido extends Model
{
    protected $table = 'detalle_pedidos';
    protected $primaryKey = 'id_detalle';
    protected $fillable = ['id_pedido', 'id_platillo', 'id_bebida', 'cantidad', 'precio_unitario', 'subtotal'];
    public function platillo()
    {
        return $this->belongsTo(Platillo::class, 'id_platillo', 'id_platillo');
    }
    public function bebida()
{
    return $this->belongsTo(Bebida::class, 'id_bebida', 'id_bebida');
}
}
