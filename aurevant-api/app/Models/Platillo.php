<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
class Platillo extends Model
{
    use HasFactory;
    protected $table = 'platillos';
    protected $primaryKey = 'id_platillo';
    public $incrementing = true;
    protected $keyType = 'int';
    protected $fillable = [
        'nombre',
        'descripcion',
        'precio',
        'categoria',
        'tipo',
        'ingredientes',
        'img',
        'activo',
    ];
    protected $casts = [
        'precio' => 'decimal:2',
        'activo' => 'boolean',
    ];
}
