<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Cliente extends Model
{
    protected $table = 'clientes';
    protected $primaryKey = 'id_cliente';
    public $incrementing = true;
    protected $keyType = 'int';
    protected $fillable = [
        'nombre',
        'apellido',
        'email',
        'telefono',
        'DUI',
    ];
    public function reservas()
    {
        return $this->hasMany(ReservaHotel::class, 'id_cliente', 'id_cliente');
    }
}
