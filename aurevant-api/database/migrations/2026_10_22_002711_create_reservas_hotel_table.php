<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reservas_hotel', function (Blueprint $table) {
            $table->id('id_reserva');
            $table->foreignId('id_cliente')
                  ->constrained('clientes', 'id_cliente')
                  ->cascadeOnDelete();
            $table->foreignId('id_habitacion')
                  ->constrained('habitaciones', 'id_habitacion')
                  ->cascadeOnDelete();
            $table->date('fecha_inicio');
            $table->date('fecha_fin');
            $table->enum('estado', ['confirmada', 'pendiente', 'cancelada'])
                  ->default('pendiente');
            $table->timestamps();
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('reservas_hotel');
    }
};
