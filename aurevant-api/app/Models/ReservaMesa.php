<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class ReservaMesa extends Model
{
    protected $table = 'reservas_mesa';
    protected $primaryKey = 'id_reserva_mesa';
    protected $fillable = [
    'id_cliente',
    'id_mesa',
    'fecha',
    'hora',
    'personas',
    'estado',
    'expira_en',
];
protected $casts = [
    'expira_en' => 'datetime',
    'fecha'     => 'date',
];
    public function mesa()
    {
        return $this->belongsTo(Mesa::class, 'id_mesa', 'id_mesa');
    }
    public function cliente()
    {
        return $this->belongsTo(Cliente::class, 'id_cliente', 'id_cliente');
    }
    public function pedidos()
    {
        return $this->hasMany(Pedido::class, 'id_reserva_mesa', 'id_reserva_mesa');
    }
}
