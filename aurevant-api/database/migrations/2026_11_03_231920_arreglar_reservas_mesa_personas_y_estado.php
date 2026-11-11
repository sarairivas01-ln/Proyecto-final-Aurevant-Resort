<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('reservas_mesa', function (Blueprint $table) {
            $table->renameColumn('num_personas', 'personas');
            $table->string('estado')->default('pendiente')->after('personas');
        });
        Schema::table('detalle_pedidos', function (Blueprint $table) {
            $table->decimal('subtotal', 10, 2)->default(0)->after('precio_unitario');
        });
    }
    public function down(): void
    {
        Schema::table('detalle_pedidos', function (Blueprint $table) {
            $table->dropColumn('subtotal');
        });
        Schema::table('reservas_mesa', function (Blueprint $table) {
            $table->dropColumn('estado');
            $table->renameColumn('personas', 'num_personas');
        });
    }
};
