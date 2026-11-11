<?php
namespace Database\Seeders;
use Illuminate\Database\Seeder;
use App\Models\Mesa;
class MesasSeeder extends Seeder
{
    public function run()
    {
        $faltan = 10 - Mesa::count();
        if ($faltan <= 0) {
            $this->command->info('Ya hay 10 mesas.');
            return;
        }
        $nuevas = [
            ['capacidad' => 2, 'ambiente' => 'chimenea'],
            ['capacidad' => 4, 'ambiente' => 'ventanal'],
            ['capacidad' => 6, 'ambiente' => 'terraza'],
            ['capacidad' => 2, 'ambiente' => 'ventanal'],
            ['capacidad' => 4, 'ambiente' => 'chimenea'],
            ['capacidad' => 8, 'ambiente' => 'terraza'],
        ];
        foreach (array_slice($nuevas, 0, $faltan) as $m) {
            Mesa::create($m + ['estado' => 'disponible']);
        }
        $this->command->info('Total: ' . Mesa::count());
    }
}
