<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
class Mesa extends Model
{
    protected $table = 'mesas';
    protected $primaryKey = 'id_mesa';
    protected $fillable = ['capacidad', 'ambiente', 'estado', 'liberar_en'];
    protected $casts = [
        'liberar_en' => 'datetime',
    ];
    public function reservas()
    {
        return $this->hasMany(ReservaMesa::class, 'id_mesa', 'id_mesa');
    }
}
