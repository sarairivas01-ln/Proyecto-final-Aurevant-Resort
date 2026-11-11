-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-11-2026 a las 01:57:00
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `aurevant_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bebidas`
--

CREATE TABLE `bebidas` (
  `id_bebida` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `ingredientes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `bebidas`
--

INSERT INTO `bebidas` (`id_bebida`, `nombre`, `descripcion`, `precio`, `tipo`, `ingredientes`, `created_at`, `updated_at`) VALUES
(1, 'Mojito', 'Cóctel cubano de ron, menta y limón', 6.50, 'coctel', 'ron blanco, menta, limón, azúcar, soda, hielo', '2026-11-03 00:02:17', '2026-11-03 00:02:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `DUI` varchar(10) NOT NULL,
  `telefono` varchar(15) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombre`, `email`, `DUI`, `telefono`, `created_at`, `updated_at`) VALUES
(1, 'María López', 'maria1596@gmail.com', '01234567-8', '7777-1234', '2026-10-28 22:14:29', '2026-10-29 22:29:02'),
(4, 'Luna', 'lunafe32@gmail.com', '09876543-2', '7777-8888', '2026-11-02 23:42:23', '2026-11-02 23:42:23'),
(5, 'Ana', 'anads@gmail.com', '75395341-8', '789-231', '2026-11-05 01:23:48', '2026-11-05 01:23:48'),
(6, 'Carlos Alberto', 'carlos.ramirez87@gmail.com', '04829371-5', '7842-5196', '2026-11-05 01:46:04', '2026-11-05 01:46:04');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedidos`
--

CREATE TABLE `detalle_pedidos` (
  `id_detalle` bigint(20) UNSIGNED NOT NULL,
  `id_pedido` bigint(20) UNSIGNED NOT NULL,
  `id_platillo` bigint(20) UNSIGNED DEFAULT NULL,
  `id_bebida` bigint(20) UNSIGNED DEFAULT NULL,
  `cantidad` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `habitaciones`
--

CREATE TABLE `habitaciones` (
  `id_habitacion` bigint(20) UNSIGNED NOT NULL,
  `numero` varchar(10) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `capacidad` int(11) NOT NULL,
  `precio_noche` decimal(10,2) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `vista` varchar(255) NOT NULL,
  `balcon` tinyint(1) NOT NULL DEFAULT 0,
  `estado` varchar(255) NOT NULL DEFAULT 'Disponible',
  `activa` tinyint(1) NOT NULL DEFAULT 1,
  `img` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `habitaciones`
--

INSERT INTO `habitaciones` (`id_habitacion`, `numero`, `tipo`, `capacidad`, `precio_noche`, `descripcion`, `vista`, `balcon`, `estado`, `activa`, `img`, `created_at`, `updated_at`) VALUES
(1, '101', 'Suite', 2, 220.00, 'Suite panorámica con ventanal de piso a techo hacia la cordillera y chimenea de leña.', 'Montaña', 1, 'Disponible', 1, 'habitaciones/ol6dwnzGiOEsmzzC1r5TGj6yJJLI6Fj9eYmf5bCQ.jpg', '2026-10-28 22:17:59', '2026-10-29 21:11:13'),
(2, '102', 'Suite', 1, 245.00, 'Disfrute de la libertad del aire libre sin renunciar al máximo confort de un hotel de lujo.', 'Bosque', 0, 'Disponible', 1, 'habitaciones/mExaaT5Jumen03YURt0qIkJ4cq8FFjMvfkOLpgFY.jpg', '2026-10-29 21:29:29', '2026-11-05 02:34:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mesas`
--

CREATE TABLE `mesas` (
  `id_mesa` bigint(20) UNSIGNED NOT NULL,
  `capacidad` int(11) NOT NULL,
  `ambiente` enum('terraza','chimenea','ventanal') NOT NULL,
  `estado` enum('disponible','ocupada','reservada') NOT NULL DEFAULT 'disponible',
  `liberar_en` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `mesas`
--

INSERT INTO `mesas` (`id_mesa`, `capacidad`, `ambiente`, `estado`, `liberar_en`, `created_at`, `updated_at`) VALUES
(1, 2, 'terraza', 'disponible', NULL, '2026-11-02 23:05:50', '2026-11-04 21:23:20'),
(2, 4, 'ventanal', 'disponible', NULL, '2026-11-02 23:05:50', '2026-11-04 21:23:20'),
(3, 4, 'chimenea', 'disponible', NULL, '2026-11-02 23:05:50', '2026-11-04 21:23:20'),
(4, 6, 'terraza', 'disponible', NULL, '2026-11-02 23:05:50', '2026-11-04 21:23:20'),
(5, 2, 'chimenea', 'disponible', NULL, '2026-11-05 02:50:34', '2026-11-04 21:23:20'),
(6, 4, 'ventanal', 'disponible', NULL, '2026-11-05 02:50:34', '2026-11-04 21:23:20'),
(7, 6, 'terraza', 'disponible', NULL, '2026-11-05 02:50:34', '2026-11-04 21:23:20'),
(8, 2, 'ventanal', 'disponible', NULL, '2026-11-05 02:50:34', '2026-11-04 21:23:20'),
(9, 4, 'chimenea', 'disponible', NULL, '2026-11-05 02:50:34', '2026-11-04 21:23:20'),
(10, 8, 'terraza', 'disponible', NULL, '2026-11-05 02:50:34', '2026-11-04 21:23:20'),
(11, 2, 'chimenea', 'disponible', NULL, '2026-11-05 02:51:36', '2026-11-04 21:23:20'),
(12, 4, 'ventanal', 'disponible', NULL, '2026-11-05 02:51:36', '2026-11-04 21:23:20'),
(13, 6, 'terraza', 'disponible', NULL, '2026-11-05 02:51:36', '2026-11-04 21:23:20'),
(14, 2, 'ventanal', 'disponible', NULL, '2026-11-05 02:51:36', '2026-11-04 21:23:20'),
(15, 4, 'chimenea', 'disponible', NULL, '2026-11-05 02:51:36', '2026-11-04 21:23:20'),
(16, 8, 'terraza', 'disponible', NULL, '2026-11-05 02:51:36', '2026-11-04 21:23:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_10_22_002620_create_clientes_table', 1),
(5, '2026_10_22_002631_create_habitaciones_table', 1),
(6, '2026_10_22_002653_create_mesas_table', 1),
(7, '2026_10_22_002711_create_reservas_hotel_table', 1),
(8, '2026_10_22_002723_create_reservas_mesa_table', 1),
(9, '2026_10_22_002729_create_pedidos_table', 1),
(10, '2026_10_22_002734_create_platillos_table', 1),
(11, '2026_10_22_002743_create_bebidas_table', 1),
(12, '2026_10_22_002749_create_detalle_pedidos_table', 1),
(13, '2026_10_22_002758_create_servicios_table', 1),
(14, '2026_10_24_225122_create_personal_access_tokens_table', 1),
(15, '2026_10_24_225215_add_rol_to_users_table', 1),
(16, '2026_10_29_193527_create_solicitudes_table', 2),
(17, '2026_11_03_231920_arreglar_reservas_mesa_personas_y_estado', 3),
(18, '2026_11_04_221213_add_estado_expira_to_reservas_mesa', 4),
(19, '2026_11_04_234854_add_liberar_en_to_mesas_table', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedido` bigint(20) UNSIGNED NOT NULL,
  `id_reserva_mesa` bigint(20) UNSIGNED NOT NULL,
  `fecha_pedido` date NOT NULL,
  `hora_pedido` time NOT NULL,
  `estado` enum('en proceso','entregado','cancelado') NOT NULL DEFAULT 'en proceso',
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'aurevant', 'e2ff4290f9ecf50abe47e4658b569c6fd8578ffd97abd17f561b4ef030f94bb4', '[\"*\"]', '2026-10-29 02:16:20', NULL, '2026-10-28 22:38:39', '2026-10-29 02:16:20'),
(2, 'App\\Models\\User', 1, 'aurevant', '3bbf601b5c64990b4020da69e958efd8563c36a49457dc5823ef0c79b7b1e437', '[\"*\"]', '2026-10-29 21:40:23', NULL, '2026-10-29 00:50:22', '2026-10-29 21:40:23'),
(3, 'App\\Models\\User', 2, 'aurevant', '2be9362b9033c973509afa630c418cdaa46acceb0f4600963cfd6eb68e70e87c', '[\"*\"]', NULL, NULL, '2026-10-29 02:18:19', '2026-10-29 02:18:19'),
(4, 'App\\Models\\User', 2, 'aurevant', '06589c7e67e325b7e3b215b9875c6d46859031b32b519b9854a0f1c1194e05d5', '[\"*\"]', '2026-10-29 22:04:16', NULL, '2026-10-29 21:41:01', '2026-10-29 22:04:16'),
(5, 'App\\Models\\User', 1, 'aurevant', '4b33463bb7665a84b258ea61764c09c316e2b5da918a5df3ebfd237adaea21fb', '[\"*\"]', '2026-10-29 22:18:42', NULL, '2026-10-29 22:06:14', '2026-10-29 22:18:42'),
(6, 'App\\Models\\User', 2, 'aurevant', '93c710f13757c309ec49c78bc559dd9858741b73600a49219aae8b7ce43a55b0', '[\"*\"]', '2026-10-29 22:21:33', NULL, '2026-10-29 22:19:23', '2026-10-29 22:21:33'),
(7, 'App\\Models\\User', 1, 'aurevant', '08fc73ac9f7806102b200407410d6d88cb0d564b085146da7d676245e54a12f5', '[\"*\"]', '2026-10-29 22:31:16', NULL, '2026-10-29 22:21:37', '2026-10-29 22:31:16'),
(8, 'App\\Models\\User', 2, 'aurevant', 'fbdf56be4c1758b31d9fb280d1dc362ef72d71da7994260e75d48e9f50642b45', '[\"*\"]', '2026-10-29 23:02:26', NULL, '2026-10-29 22:31:37', '2026-10-29 23:02:26'),
(9, 'App\\Models\\User', 1, 'aurevant', '06c93d443532ff36dad094b68c151b867dca8efbb69ad5bc8d11d1d762cf5c2c', '[\"*\"]', NULL, NULL, '2026-11-03 00:35:42', '2026-11-03 00:35:42'),
(10, 'App\\Models\\User', 1, 'aurevant', '62ebdd074dfabf0cc122cae53202eea9b9be54eee3dc7dbc06bba8d4151c0b2f', '[\"*\"]', NULL, NULL, '2026-11-03 00:38:42', '2026-11-03 00:38:42'),
(11, 'App\\Models\\User', 1, 'aurevant', '8621488951a7e7c7b624fe1f9a32f122d439550ade8ce1c73b5e095e75fa96b3', '[\"*\"]', NULL, NULL, '2026-11-03 00:38:43', '2026-11-03 00:38:43'),
(12, 'App\\Models\\User', 1, 'aurevant', 'a34f488a2b1868dd129e17b1de385256f07552d18ed0ccbcfdd456a23b2a9748', '[\"*\"]', NULL, NULL, '2026-11-03 00:38:44', '2026-11-03 00:38:44'),
(13, 'App\\Models\\User', 1, 'aurevant', '0a0ba6830dddf308c065847e61c15bf090404498b748b503770a0b3014c3cf60', '[\"*\"]', NULL, NULL, '2026-11-03 00:40:51', '2026-11-03 00:40:51'),
(14, 'App\\Models\\User', 1, 'aurevant', 'eabb7fe22e8b1eefb1290fe41122669af161d750cc2aac82d73e29f48b491abd', '[\"*\"]', NULL, NULL, '2026-11-03 00:40:52', '2026-11-03 00:40:52'),
(15, 'App\\Models\\User', 1, 'aurevant', '4e6505217535879e34aab61286559f2700df0de454832dc702cd7011276c1bf3', '[\"*\"]', NULL, NULL, '2026-11-03 00:42:02', '2026-11-03 00:42:02'),
(16, 'App\\Models\\User', 1, 'aurevant', '5cd47ba9cf4e829c642c4886ff4f4a7702c70dede62f633d1d721dfa368c3e8a', '[\"*\"]', '2026-11-03 00:42:07', NULL, '2026-11-03 00:42:06', '2026-11-03 00:42:07'),
(17, 'App\\Models\\User', 2, 'aurevant', 'a41e9643edb7e9c414aaa02d2cb0d39c3b164aea91544c74ddc5fad6b67a3fe1', '[\"*\"]', '2026-11-03 00:44:19', NULL, '2026-11-03 00:42:19', '2026-11-03 00:44:19'),
(18, 'App\\Models\\User', 1, 'aurevant', '9285560b7ff91732e26f7932951656944348a37da8853427fd6c732b81fb633c', '[\"*\"]', '2026-11-03 00:43:19', NULL, '2026-11-03 00:43:18', '2026-11-03 00:43:19'),
(19, 'App\\Models\\User', 1, 'aurevant', 'c1d41888349db29cd228417b2a0e032be34e5399d33cfac4743fab7cd5bf19b5', '[\"*\"]', '2026-11-03 00:43:58', NULL, '2026-11-03 00:43:28', '2026-11-03 00:43:58'),
(20, 'App\\Models\\User', 1, 'aurevant', 'e80285ad060ea19a474821d6fc52cd6c10d835ebc66183625d477104b50c36a5', '[\"*\"]', '2026-11-03 00:53:25', NULL, '2026-11-03 00:44:05', '2026-11-03 00:53:25'),
(21, 'App\\Models\\User', 1, 'aurevant', '34b960d09f55ae8a67812136fe0ccf2e3bf6b6a9141e78b64bcce2af2315b58e', '[\"*\"]', '2026-11-03 00:48:44', NULL, '2026-11-03 00:44:23', '2026-11-03 00:48:44'),
(22, 'App\\Models\\User', 1, 'aurevant', '7a9713962b9fecc389c62ff452b840cd949cfc05e23ed8d18398da14e2f8d97b', '[\"*\"]', '2026-11-03 00:49:19', NULL, '2026-11-03 00:48:48', '2026-11-03 00:49:19'),
(23, 'App\\Models\\User', 1, 'aurevant', 'c315e537223ec7846e5fccd8d81501ed75cf526c47075e0003738a395cf43caf', '[\"*\"]', '2026-11-03 00:51:17', NULL, '2026-11-03 00:49:22', '2026-11-03 00:51:17'),
(24, 'App\\Models\\User', 1, 'aurevant', '5fde06e4dba5c78d5fb253d8c26c1e0004b059137e0200db886311ce55f2fb04', '[\"*\"]', '2026-11-03 00:54:18', NULL, '2026-11-03 00:53:48', '2026-11-03 00:54:18'),
(25, 'App\\Models\\User', 1, 'aurevant', '3b6565fe27ad9a9520ba9e6072c45b89fef8f106f379ff1408a5be841f68b55e', '[\"*\"]', NULL, NULL, '2026-11-03 00:54:25', '2026-11-03 00:54:25'),
(26, 'App\\Models\\User', 2, 'aurevant', '6663a3e6f0808614f00fc0fd2211e553aaf686e759cf5a190187566d493b96c0', '[\"*\"]', '2026-11-03 02:00:15', NULL, '2026-11-03 00:54:34', '2026-11-03 02:00:15'),
(27, 'App\\Models\\User', 1, 'aurevant', 'ef7c53f099aebdaa13bd97dbfafa959fb577e57a8497fff831b84e60fb591592', '[\"*\"]', '2026-11-03 02:00:32', NULL, '2026-11-03 02:00:21', '2026-11-03 02:00:32'),
(28, 'App\\Models\\User', 2, 'aurevant', 'c3d949cf2e019c7c8bb44b65d94753e811527a063e01241abe8d1b7a55516933', '[\"*\"]', '2026-11-03 03:02:22', NULL, '2026-11-03 02:00:43', '2026-11-03 03:02:22'),
(29, 'App\\Models\\User', 1, 'aurevant', 'af4a74217f86e936d5242fa651fb53c30288a8898c217b19a6af855384d74216', '[\"*\"]', '2026-11-03 03:12:26', NULL, '2026-11-03 03:03:04', '2026-11-03 03:12:26'),
(30, 'App\\Models\\User', 1, 'aurevant', '5e7090a0c52ab9415474a59eed1d8ffb2b2175a7eb88b658b191f0ebe36d3ef2', '[\"*\"]', '2026-11-04 01:23:29', NULL, '2026-11-04 01:23:11', '2026-11-04 01:23:29'),
(31, 'App\\Models\\User', 2, 'aurevant', 'e779c4720c27712a3ba7d759b7366b9ec5fb9604bb02381e68fd61564118dd31', '[\"*\"]', '2026-11-04 02:24:38', NULL, '2026-11-04 01:23:40', '2026-11-04 02:24:38'),
(32, 'App\\Models\\User', 1, 'aurevant', '46bad8c61609a8f48c783ddc951ab21ea02db6468ce27b5fe1aa81231fc3d1d2', '[\"*\"]', '2026-11-04 02:54:04', NULL, '2026-11-04 02:54:03', '2026-11-04 02:54:04'),
(33, 'App\\Models\\User', 2, 'aurevant', '8ae68a856f0bb4a8a77ad50a5ef576bb43521b23ae1aabb588764d5b71490b14', '[\"*\"]', '2026-11-04 04:12:50', NULL, '2026-11-04 03:04:46', '2026-11-04 04:12:50'),
(34, 'App\\Models\\User', 1, 'aurevant', '392c305faeb323c5f27b2175e834e0ccbfde1d7770bcbb689e9ce1ed97487693', '[\"*\"]', '2026-11-04 04:23:33', NULL, '2026-11-04 04:12:55', '2026-11-04 04:23:33'),
(35, 'App\\Models\\User', 2, 'aurevant', 'f9d125c1d9eba2c5adf24d2e85986bcdd3113654401d5d5a1db3464e61b236f0', '[\"*\"]', '2026-11-04 04:33:08', NULL, '2026-11-04 04:23:45', '2026-11-04 04:33:08'),
(36, 'App\\Models\\User', 1, 'aurevant', '2155ef90d5f7f7f2e8042fb5f0cc965a9714bd207dda5403083d6b4e84180ccb', '[\"*\"]', NULL, NULL, '2026-11-04 16:11:25', '2026-11-04 16:11:25'),
(37, 'App\\Models\\User', 1, 'aurevant', 'bcec54744f1c18a5deb32d3fcd30115292fad076149b3b870e2803814d5901c2', '[\"*\"]', '2026-11-04 16:14:19', NULL, '2026-11-04 16:11:30', '2026-11-04 16:14:19'),
(38, 'App\\Models\\User', 2, 'aurevant', 'e1d681207265e8db96ce16a39a250cc86824a1560a31529cd3ec3a2262715da8', '[\"*\"]', '2026-11-04 16:25:55', NULL, '2026-11-04 16:16:36', '2026-11-04 16:25:55'),
(39, 'App\\Models\\User', 1, 'aurevant', '23edc7bf22bc30abd98c8ea178bd6f5d9ec3a82921eca4036b26468d70023e22', '[\"*\"]', '2026-11-04 17:17:25', NULL, '2026-11-04 16:30:37', '2026-11-04 17:17:25'),
(40, 'App\\Models\\User', 1, 'aurevant', 'e555698d4710d1887a9c418f9fc6a8b43e097ac4eee599a8b5b6077757960946', '[\"*\"]', '2026-11-04 18:06:27', NULL, '2026-11-04 17:17:31', '2026-11-04 18:06:27'),
(41, 'App\\Models\\User', 2, 'aurevant', 'db6bec4f732d8554597b6fd3368ca8cfc85dda5f4cb8b292e8cd2fdc5f445342', '[\"*\"]', '2026-11-04 18:08:02', NULL, '2026-11-04 18:07:22', '2026-11-04 18:08:02'),
(42, 'App\\Models\\User', 1, 'aurevant', '86eada7fdc83bcab6b0a0f6d22f22400ec0ecea8fbd5eea1cf3ad087efc5c60c', '[\"*\"]', '2026-11-04 23:41:47', NULL, '2026-11-04 18:08:17', '2026-11-04 23:41:47'),
(43, 'App\\Models\\User', 2, 'aurevant', 'c2d70e4b5d919c2e2d7a7b04ac78a364bdc9198a0578313f540bbf019b5ba721', '[\"*\"]', '2026-11-04 23:43:17', NULL, '2026-11-04 23:42:55', '2026-11-04 23:43:17'),
(44, 'App\\Models\\User', 1, 'aurevant', '8a94a314050a35571dd9eeb6fb81889575caa5ccca134bdf2992288e038c48c2', '[\"*\"]', '2026-11-05 00:17:28', NULL, '2026-11-04 23:43:53', '2026-11-05 00:17:28'),
(45, 'App\\Models\\User', 2, 'aurevant', 'c82272766bb059174fb07cddd0525d4c1691cff3a955706e7fd652a93d9dc90c', '[\"*\"]', '2026-11-05 01:28:53', NULL, '2026-11-05 00:17:43', '2026-11-05 01:28:53'),
(46, 'App\\Models\\User', 1, 'aurevant', '7bcfa1c5c7bb7f5d2c4c84eab83965d97690d4c7d647bcab6d479180162be8f1', '[\"*\"]', '2026-11-05 01:50:24', NULL, '2026-11-05 01:29:05', '2026-11-05 01:50:24'),
(47, 'App\\Models\\User', 2, 'aurevant', '181d885a2329c2b47965103f250b62df716d031905f5be88661a4fdb20a90515', '[\"*\"]', '2026-11-05 01:53:50', NULL, '2026-11-05 01:50:52', '2026-11-05 01:53:50'),
(48, 'App\\Models\\User', 1, 'aurevant', 'a5d97dc500da9f11468d0bd04d778ba70c30e131cff46f19e1086d2ae01ed594', '[\"*\"]', '2026-11-05 02:05:04', NULL, '2026-11-05 01:54:13', '2026-11-05 02:05:04'),
(49, 'App\\Models\\User', 2, 'aurevant', '44a4973d51161b5d6277ae79cee175e1ad0514a34d9b922e7f62d7bf1b890cc7', '[\"*\"]', '2026-11-05 02:14:09', NULL, '2026-11-05 02:05:14', '2026-11-05 02:14:09'),
(50, 'App\\Models\\User', 1, 'aurevant', '3371b6c84615d57f5b3fbf3a1283cd4521afea59db827a6dc373e0838d72e8a0', '[\"*\"]', '2026-11-05 02:15:18', NULL, '2026-11-05 02:14:37', '2026-11-05 02:15:18'),
(51, 'App\\Models\\User', 2, 'aurevant', '2c61034eb3fb8c21c09f123a487e3d73e5b1a6669f672458129b4d53f57f7658', '[\"*\"]', '2026-11-05 02:33:49', NULL, '2026-11-05 02:16:37', '2026-11-05 02:33:49'),
(52, 'App\\Models\\User', 1, 'aurevant', '035e945dfee88fb662cf0436afc8cdf9a9911378e310ea003c495960e744069e', '[\"*\"]', '2026-11-05 02:35:03', NULL, '2026-11-05 02:33:53', '2026-11-05 02:35:03'),
(53, 'App\\Models\\User', 2, 'aurevant', '186027b7dfd5e9000445219c928bbf06fc2ddcd1d9db831ecf9c538ae6548b9d', '[\"*\"]', NULL, NULL, '2026-11-05 02:35:07', '2026-11-05 02:35:07'),
(54, 'App\\Models\\User', 2, 'aurevant', 'e8f6e00ea6761d235def989008fec6259bd307ee45a28e79d44dba7655a3e803', '[\"*\"]', '2026-11-05 02:36:06', NULL, '2026-11-05 02:35:11', '2026-11-05 02:36:06'),
(55, 'App\\Models\\User', 1, 'aurevant', '2b3c6c97b274aab27c4ce41f422988cbeb5087b9fdd0ff586a0d61512d08a5fe', '[\"*\"]', '2026-11-05 02:36:14', NULL, '2026-11-05 02:36:09', '2026-11-05 02:36:14'),
(56, 'App\\Models\\User', 2, 'aurevant', 'cb069d73bc4be927fbda18b8ad6808c5499a9dbc34490e391471caaa084ac474', '[\"*\"]', '2026-11-04 21:25:07', NULL, '2026-11-05 02:36:23', '2026-11-04 21:25:07'),
(57, 'App\\Models\\User', 1, 'aurevant', '6c9629c101001c612076647271b53e354160d845478d1c0993a30283df5b39ba', '[\"*\"]', '2026-11-04 21:27:54', NULL, '2026-11-04 21:27:43', '2026-11-04 21:27:54'),
(58, 'App\\Models\\User', 1, 'aurevant', 'e5c38dca996bd62b83a88f3065b9d99f2402ae2d636e2c98b178e267bee989a4', '[\"*\"]', NULL, NULL, '2026-11-04 21:28:00', '2026-11-04 21:28:00'),
(59, 'App\\Models\\User', 2, 'aurevant', '0154a63f5e06ce97fc7d5fb4ac12c8cf6df5a7ac5b61a23c418ac12cc31a844c', '[\"*\"]', '2026-11-04 21:29:37', NULL, '2026-11-04 21:28:03', '2026-11-04 21:29:37'),
(60, 'App\\Models\\User', 1, 'aurevant', '24e17e9e8966fcb95de060f860197680a0596d886e88ada1a92210332e30522c', '[\"*\"]', '2026-11-04 21:35:32', NULL, '2026-11-04 21:30:24', '2026-11-04 21:35:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `platillos`
--

CREATE TABLE `platillos` (
  `id_platillo` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `categoria` varchar(50) NOT NULL,
  `tipo` enum('platillo','bebida') NOT NULL DEFAULT 'platillo',
  `ingredientes` text DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `platillos`
--

INSERT INTO `platillos` (`id_platillo`, `nombre`, `descripcion`, `precio`, `categoria`, `tipo`, `ingredientes`, `img`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'Tacos al pastor', 'Deliciosos tacos de carne de cerdo marinada en un tradicional adobo de chiles y especias, cocinada lentamente al carbón en el clásico \"trompo\". Se sirven en tortillas de maíz calientes, acompañados de piña fresca, cilantro, cebolla picada y un toque de limón.', 12.50, 'Carnes', 'platillo', 'Carne de cerdo (pierna o lomo), adobo de chile guajillo y achiote, piña, tortilla de maíz, cilantro, cebolla, limón.', '/storage/platillos/EHOmAfqxMxJ8thzPIE8uF8gcCGS1EMC2bnaaxBoC.jpg', 1, '2026-10-28 22:50:59', '2026-10-28 22:50:59'),
(2, 'Mojito', 'El Mojito es un cóctel clásico de origen cubano, famoso a nivel mundial por ser altamente refrescante, cítrico y herbáceo, con un equilibrio perfecto entre el dulzor del azúcar y la acidez de la lima.', 5.00, 'Bebidas', 'bebida', '• Ron blanco \r\n• Hierbabuena o menta \r\n• Lima \r\n• Azúcar blanco \r\n• Agua con gas o sifón\r\n• Hielo picado', '/storage/platillos/MeyoDr2jOSAmczbhO9dOFgacADO6X7ITYx9xs0QO.webp', 1, '2026-10-29 21:15:32', '2026-10-29 21:15:32');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas_hotel`
--

CREATE TABLE `reservas_hotel` (
  `id_reserva` bigint(20) UNSIGNED NOT NULL,
  `id_cliente` bigint(20) UNSIGNED NOT NULL,
  `id_habitacion` bigint(20) UNSIGNED NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `estado` enum('confirmada','pendiente','cancelada') NOT NULL DEFAULT 'pendiente',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `reservas_hotel`
--

INSERT INTO `reservas_hotel` (`id_reserva`, `id_cliente`, `id_habitacion`, `fecha_inicio`, `fecha_fin`, `estado`, `created_at`, `updated_at`) VALUES
(4, 1, 1, '2026-10-28', '2026-11-07', 'confirmada', '2026-10-28 22:18:52', '2026-11-04 21:35:32'),
(5, 6, 2, '2026-10-20', '2026-11-06', 'confirmada', '2026-11-05 01:46:33', '2026-11-05 02:27:53');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas_mesa`
--

CREATE TABLE `reservas_mesa` (
  `id_reserva_mesa` bigint(20) UNSIGNED NOT NULL,
  `id_cliente` bigint(20) UNSIGNED NOT NULL,
  `id_mesa` bigint(20) UNSIGNED NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `personas` int(11) NOT NULL,
  `estado` varchar(255) NOT NULL DEFAULT 'pendiente',
  `expira_en` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

CREATE TABLE `servicios` (
  `id_servicio` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `categoria` enum('spa','tour','transporte','recreacion') NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `duracion_min` int(11) DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL,
  `estado` enum('disponible','no disponible') NOT NULL DEFAULT 'disponible',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

CREATE TABLE `solicitudes` (
  `id_solicitud` bigint(20) UNSIGNED NOT NULL,
  `id_cliente` bigint(20) UNSIGNED NOT NULL,
  `id_habitacion` bigint(20) UNSIGNED NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `personas` int(11) NOT NULL DEFAULT 1,
  `estado` enum('pendiente','confirmada','cancelada') NOT NULL DEFAULT 'pendiente',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `rol` varchar(255) NOT NULL DEFAULT 'recepcion',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `rol`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@aurevant.com', 'admin', NULL, '$2y$12$Kr2Jm6rD3qpNsiKVI2UXb.hxoTQICeFXKGBAk.zfz.IXlJv.ch/NC', NULL, '2026-10-28 22:33:40', '2026-10-28 22:33:40'),
(2, 'Recepción', 'recepcion@aurevant.com', 'recepcion', NULL, '$2y$12$ay/Jygdke8L32uLrTDmk2.2PAzuKdAjh4uQuobb4pAXgCLcvA8ryW', NULL, '2026-10-28 22:33:44', '2026-10-28 22:33:44');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bebidas`
--
ALTER TABLE `bebidas`
  ADD PRIMARY KEY (`id_bebida`);

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `clientes_email_unique` (`email`),
  ADD UNIQUE KEY `clientes_dui_unique` (`DUI`);

--
-- Indices de la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `detalle_pedidos_id_pedido_foreign` (`id_pedido`),
  ADD KEY `detalle_pedidos_id_platillo_foreign` (`id_platillo`),
  ADD KEY `detalle_pedidos_id_bebida_foreign` (`id_bebida`);

--
-- Indices de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indices de la tabla `habitaciones`
--
ALTER TABLE `habitaciones`
  ADD PRIMARY KEY (`id_habitacion`),
  ADD UNIQUE KEY `habitaciones_numero_unique` (`numero`);

--
-- Indices de la tabla `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indices de la tabla `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `mesas`
--
ALTER TABLE `mesas`
  ADD PRIMARY KEY (`id_mesa`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `pedidos_id_reserva_mesa_foreign` (`id_reserva_mesa`);

--
-- Indices de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indices de la tabla `platillos`
--
ALTER TABLE `platillos`
  ADD PRIMARY KEY (`id_platillo`);

--
-- Indices de la tabla `reservas_hotel`
--
ALTER TABLE `reservas_hotel`
  ADD PRIMARY KEY (`id_reserva`),
  ADD KEY `reservas_hotel_id_cliente_foreign` (`id_cliente`),
  ADD KEY `reservas_hotel_id_habitacion_foreign` (`id_habitacion`);

--
-- Indices de la tabla `reservas_mesa`
--
ALTER TABLE `reservas_mesa`
  ADD PRIMARY KEY (`id_reserva_mesa`),
  ADD KEY `reservas_mesa_id_cliente_foreign` (`id_cliente`),
  ADD KEY `reservas_mesa_id_mesa_foreign` (`id_mesa`);

--
-- Indices de la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`id_servicio`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indices de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD PRIMARY KEY (`id_solicitud`),
  ADD KEY `solicitudes_id_cliente_foreign` (`id_cliente`),
  ADD KEY `solicitudes_id_habitacion_foreign` (`id_habitacion`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bebidas`
--
ALTER TABLE `bebidas`
  MODIFY `id_bebida` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  MODIFY `id_detalle` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `habitaciones`
--
ALTER TABLE `habitaciones`
  MODIFY `id_habitacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mesas`
--
ALTER TABLE `mesas`
  MODIFY `id_mesa` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id_pedido` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT de la tabla `platillos`
--
ALTER TABLE `platillos`
  MODIFY `id_platillo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `reservas_hotel`
--
ALTER TABLE `reservas_hotel`
  MODIFY `id_reserva` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `reservas_mesa`
--
ALTER TABLE `reservas_mesa`
  MODIFY `id_reserva_mesa` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `servicios`
--
ALTER TABLE `servicios`
  MODIFY `id_servicio` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `id_solicitud` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  ADD CONSTRAINT `detalle_pedidos_id_bebida_foreign` FOREIGN KEY (`id_bebida`) REFERENCES `bebidas` (`id_bebida`) ON DELETE SET NULL,
  ADD CONSTRAINT `detalle_pedidos_id_pedido_foreign` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_pedidos_id_platillo_foreign` FOREIGN KEY (`id_platillo`) REFERENCES `platillos` (`id_platillo`) ON DELETE SET NULL;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidos_id_reserva_mesa_foreign` FOREIGN KEY (`id_reserva_mesa`) REFERENCES `reservas_mesa` (`id_reserva_mesa`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reservas_hotel`
--
ALTER TABLE `reservas_hotel`
  ADD CONSTRAINT `reservas_hotel_id_cliente_foreign` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservas_hotel_id_habitacion_foreign` FOREIGN KEY (`id_habitacion`) REFERENCES `habitaciones` (`id_habitacion`) ON DELETE CASCADE;

--
-- Filtros para la tabla `reservas_mesa`
--
ALTER TABLE `reservas_mesa`
  ADD CONSTRAINT `reservas_mesa_id_cliente_foreign` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservas_mesa_id_mesa_foreign` FOREIGN KEY (`id_mesa`) REFERENCES `mesas` (`id_mesa`) ON DELETE CASCADE;

--
-- Filtros para la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD CONSTRAINT `solicitudes_id_cliente_foreign` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `solicitudes_id_habitacion_foreign` FOREIGN KEY (`id_habitacion`) REFERENCES `habitaciones` (`id_habitacion`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
