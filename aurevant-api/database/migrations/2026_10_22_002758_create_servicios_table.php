<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('servicios', function (Blueprint $table) {
            $table->id('id_servicio');
            $table->string('nombre', 100);
            $table->text('descripcion')->nullable();
            $table->enum('categoria', ['spa', 'tour', 'transporte', 'recreacion']);
            $table->decimal('precio', 10, 2);
            $table->integer('duracion_min')->nullable();
            $table->integer('capacidad')->nullable();
            $table->enum('estado', ['disponible', 'no disponible'])
                  ->default('disponible');
            $table->timestamps();
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('servicios');
    }
};
