<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('pedidos', function (Blueprint $table) {
            $table->id('id_pedido');
            $table->foreignId('id_mesa')
                  ->constrained('mesas', 'id_mesa')
                  ->cascadeOnDelete();
            $table->foreignId('id_cliente')
                  ->nullable()
                  ->constrained('clientes', 'id_cliente')
                  ->nullOnDelete();
            $table->decimal('total', 10, 2)->default(0);
            $table->enum('estado', ['pendiente', 'en_preparacion', 'servido', 'pagado'])
                  ->default('pendiente');
            $table->timestamps();
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('pedidos');
    }
};
