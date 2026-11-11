<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('habitaciones', function (Blueprint $table) {
            $table->id('id_habitacion');
            $table->string('numero', 10)->unique();
            $table->string('tipo', 50);
            $table->integer('capacidad');
            $table->decimal('precio_noche', 10, 2);
            $table->text('descripcion')->nullable();
            $table->string('vista');
            $table->boolean('balcon')->default(false);
            $table->string('estado')->default('Disponible');
            $table->boolean('activa')->default(true);
            $table->string('img')->nullable();
            $table->timestamps();
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('habitaciones');
    }
};
