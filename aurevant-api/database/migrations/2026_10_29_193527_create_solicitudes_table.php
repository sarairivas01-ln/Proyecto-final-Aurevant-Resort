<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('solicitudes', function (Blueprint $table) {
    $table->id('id_solicitud');
    $table->foreignId('id_cliente')->constrained('clientes', 'id_cliente');
    $table->foreignId('id_habitacion')->constrained('habitaciones', 'id_habitacion');
    $table->date('fecha_inicio');
    $table->date('fecha_fin');
    $table->integer('personas')->default(1);
    $table->enum('estado', ['pendiente', 'confirmada', 'cancelada'])->default('pendiente');
    $table->timestamps();
});
    }
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('solicitudes');
    }
};
