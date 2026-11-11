<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('bebidas', function (Blueprint $table) {
            $table->id('id_bebida');
            $table->string('nombre', 100);
            $table->text('descripcion')->nullable();
            $table->decimal('precio', 10, 2);
            $table->string('tipo', 50);
            $table->text('ingredientes')->nullable();
            $table->timestamps();
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('bebidas');
    }
};
