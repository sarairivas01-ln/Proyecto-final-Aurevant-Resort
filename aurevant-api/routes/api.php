<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\HabitacionController;
use App\Http\Controllers\API\DashboardController;
use App\Http\Controllers\API\PlatilloController;
use App\Http\Controllers\API\ReservaHotelController;
use App\Http\Controllers\API\ClienteController;
use App\Http\Controllers\API\SolicitudController;
use App\Http\Controllers\API\MesaController;
use App\Http\Controllers\API\PedidoController;
use App\Http\Controllers\API\ReservaMesaController;
// --- PÚBLICAS (sin login) ---
Route::get('/mesas-publicas', [MesaController::class, 'publicas']);
Route::post('/reserva-mesas-publica', [ReservaMesaController::class, 'store']);
Route::post('/login', [AuthController::class, 'login']);
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    // --- HABITACIONES ---
    Route::get('/habitaciones', [HabitacionController::class, 'index']);
    Route::post('/habitaciones', [HabitacionController::class, 'store']);
    Route::put('/habitaciones/{id}', [HabitacionController::class, 'update']);
    Route::post('/habitaciones/{id}', [HabitacionController::class, 'update']);
    Route::post('/habitaciones/imagen', [HabitacionController::class, 'subirImagen']);
    Route::patch('/habitaciones/{id}/toggle', [HabitacionController::class, 'toggle']);
    // --- MESAS ---
    Route::get('/mesas', [MesaController::class, 'index']);
    Route::post('/mesas', [MesaController::class, 'store']);
    Route::put('/mesas/{id}', [MesaController::class, 'update']);
    Route::post('/mesas/{id}', [MesaController::class, 'update']);
    // --- RESERVAS DE MESA ---
    Route::apiResource('reserva-mesas', ReservaMesaController::class);
    Route::patch('/reserva-mesas/{id}/estado', [ReservaMesaController::class, 'cambiarEstado']);
    // --- PEDIDOS ---
    Route::get('/pedidos', [PedidoController::class, 'index']);
    Route::get('/pedidos/{id}', [PedidoController::class, 'show']);
    Route::post('/pedidos', [PedidoController::class, 'store']);
    Route::put('/pedidos/{id}', [PedidoController::class, 'update']);
    // --- MENÚ ---
    Route::get('/platillos', [PlatilloController::class, 'index']);
    Route::get('/platillos/{id}', [PlatilloController::class, 'show']);
    // --- CLIENTES ---
    Route::get('/clientes', [ClienteController::class, 'index']);
    Route::post('/clientes', [ClienteController::class, 'store']);
    Route::put('/clientes/{id}', [ClienteController::class, 'update']);
    // --- RESERVAS DE HOTEL ---
    Route::get('/reservas', [ReservaHotelController::class, 'index']);
    Route::post('/reservas', [ReservaHotelController::class, 'store']);
    Route::put('/reservas/{id}', [ReservaHotelController::class, 'update']);
    Route::post('/reservas/{id}/extender', [ReservaHotelController::class, 'extender']);
    // --- SOLICITUDES ---
    Route::get('/solicitudes', [SolicitudController::class, 'index']);
    Route::post('/solicitudes', [SolicitudController::class, 'store']);
    Route::put('/solicitudes/{id}', [SolicitudController::class, 'update']);
    Route::get('/dashboard', [DashboardController::class, 'index']);
    // --- SOLO ADMIN ---
    Route::middleware('rol:admin')->group(function () {
        Route::post('/platillos', [PlatilloController::class, 'store']);
        Route::put('/platillos/{id}', [PlatilloController::class, 'update']);
        Route::post('/platillos/{id}', [PlatilloController::class, 'update']);
        Route::delete('/platillos/{id}', [PlatilloController::class, 'destroy']);
        Route::delete('/mesas/{id}', [MesaController::class, 'destroy']);
        Route::delete('/pedidos/{id}', [PedidoController::class, 'destroy']);
        Route::delete('/clientes/{id}', [ClienteController::class, 'destroy']);
        Route::delete('/reservas/{id}', [ReservaHotelController::class, 'destroy']);
    });
});
