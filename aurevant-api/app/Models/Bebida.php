<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bebida extends Model
{
    protected $table = 'bebidas';
    protected $primaryKey = 'id_bebida';
    protected $fillable = ['nombre', 'categoria', 'precio', 'img'];
}
