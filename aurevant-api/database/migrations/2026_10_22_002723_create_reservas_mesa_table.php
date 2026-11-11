<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reservas_mesa', function (Blueprint $table) {
            $table->id('id_reserva_mesa');
            $table->foreignId('id_cliente')
                  ->constrained('clientes', 'id_cliente')
                  ->cascadeOnDelete();
            $table->foreignId('id_mesa')
                  ->constrained('mesas', 'id_mesa')
                  ->cascadeOnDelete();
            $table->date('fecha');
            $table->time('hora');
            $table->integer('personas'); 
            $table->integer('num_personas');
            $table->timestamps();
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('reservas_mesa');
    }
};
