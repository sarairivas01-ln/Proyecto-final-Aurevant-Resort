<?php
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;
Schedule::call(fn () => app(\App\Http\Controllers\API\MesaController::class)->liberarVencidas())
    ->everyMinute();
Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');
