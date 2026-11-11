<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('detalle_pedidos', function (Blueprint $table) {
    $table->id('id_detalle');
    $table->foreignId('id_pedido')
          ->constrained('pedidos', 'id_pedido')
          ->cascadeOnDelete();
    $table->foreignId('id_platillo')
          ->nullable()
          ->constrained('platillos', 'id_platillo')
          ->nullOnDelete();
    $table->foreignId('id_bebida')
          ->nullable()
          ->constrained('bebidas', 'id_bebida')
          ->nullOnDelete();
    $table->integer('cantidad');
    $table->decimal('precio_unitario', 10, 2)->after('cantidad');
    $table->decimal('subtotal', 10, 2)->default(0)->after('precio_unitario');
    $table->timestamps();
});
    }
    public function down(): void
    {
        Schema::dropIfExists('detalle_pedidos');
    }
};
