-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 04, 2026 at 06:24 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `defect_detection`
--

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `scan_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `expiration` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-email_verification_16', 'i:391478;', 1772378736);

-- --------------------------------------------------------

--
-- Table structure for table `defect_categories`
--

CREATE TABLE `defect_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `severity_level` varchar(255) NOT NULL DEFAULT 'medium',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `defect_categories`
--

INSERT INTO `defect_categories` (`id`, `name`, `description`, `severity_level`, `created_at`, `updated_at`) VALUES
(1, 'Scratches', 'Surface scratches on steel surface', 'medium', '2026-02-15 23:47:57', NULL),
(2, 'Cracks', 'Visible structural cracks', 'high', '2026-02-15 23:47:57', NULL),
(3, 'Corrosion', 'Rust and oxidation defects', 'high', '2026-02-15 23:47:57', NULL),
(4, 'Pitting', 'Small holes or pits on surface', 'low', '2026-02-15 23:47:57', NULL),
(5, 'Inclusion', 'Foreign material inclusion inside steel', 'medium', '2026-02-15 23:47:57', NULL),
(6, 'Rolling Mark', 'Marks caused during rolling process', 'low', '2026-02-15 23:47:57', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `scan_id` bigint(20) UNSIGNED NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `processed_image_path` varchar(255) DEFAULT NULL,
  `file_size` bigint(20) DEFAULT NULL,
  `resolution` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `image_defects`
--

CREATE TABLE `image_defects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `image_id` bigint(20) UNSIGNED NOT NULL,
  `defect_category_id` bigint(20) UNSIGNED NOT NULL,
  `confidence` decimal(5,2) DEFAULT NULL,
  `bounding_box` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`bounding_box`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2026_02_15_224444_create_users_table', 1),
(2, '2026_02_15_224445_create_activities_table', 2),
(3, '2026_02_15_224446_create_defect_categories_table', 2),
(4, '2026_02_15_224447_create_scans_table', 2),
(5, '2026_02_15_224448_create_images_table', 2),
(6, '2026_02_15_224449_create_image_defects_table', 2),
(7, '2026_02_15_224450_create_notifications_table', 2),
(8, '2026_02_15_224451_create_scan_statistics_table', 2),
(9, '2026_02_15_224452_create_user_settings_table', 2),
(10, '2026_02_22_193800_create_cache_table', 3),
(11, '2026_02_22_200000_create_personal_access_tokens_table', 4),
(12, '2026_02_23_090000_create_sessions_table', 5),
(13, '2026_03_04_000000_add_role_to_users_table', 6);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'info',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 11, 'api-token', 'a517cce2a4e383acbac6086a0f4fca87ba7854291d164fd7e2c8c782b8be0be3', '[\"*\"]', NULL, NULL, '2026-02-22 19:00:03', '2026-02-22 19:00:03'),
(3, 'App\\Models\\User', 1, 'api-token', '84290304d51b8b7b9322e0947be233bc556a5ec07aab28a0f8f1033a03facb9e', '[\"*\"]', NULL, NULL, '2026-02-22 20:05:10', '2026-02-22 20:05:10'),
(4, 'App\\Models\\User', 14, 'api-token', '6c28d116ccf2a51cedea79079eac61bac6f48cd76262850142062928d162348d', '[\"*\"]', NULL, NULL, '2026-02-22 20:17:09', '2026-02-22 20:17:09'),
(5, 'App\\Models\\User', 1, 'api-token', '0b5260735844824c14a56b1ae0f08d621a626c8fe6f14652a376d0cf9bbf786f', '[\"*\"]', NULL, NULL, '2026-02-22 21:18:13', '2026-02-22 21:18:13'),
(7, 'App\\Models\\User', 1, 'api-token', '1b6a8d8f9646d2847319b616abf0cf34df4c3a77de24bb5bebe1cdfcde8c515f', '[\"*\"]', NULL, NULL, '2026-02-22 21:31:42', '2026-02-22 21:31:42'),
(8, 'App\\Models\\User', 1, 'api-token', 'cfdd25ff12b9e6d9058017b69286c3ec681e646ddc11dd55bf8a30769f639c51', '[\"*\"]', NULL, NULL, '2026-02-22 21:31:52', '2026-02-22 21:31:52'),
(10, 'App\\Models\\User', 1, 'api-token', 'b2c6f5029b01b548e8665081581b5eb41c5e3c697efd6bb2d778b570047805b2', '[\"*\"]', '2026-02-22 22:19:02', NULL, '2026-02-22 22:15:49', '2026-02-22 22:19:02'),
(11, 'App\\Models\\User', 16, 'api-token', '20ceeddc8cc0a31091e0cd944afdea8be764e7dab9fee75ab53f7f94eaaa5397', '[\"*\"]', NULL, NULL, '2026-02-23 00:24:31', '2026-02-23 00:24:31'),
(12, 'App\\Models\\User', 17, 'api-token', '3aa76f99ef5dab7a4798e0c441d90c60f506737a46eb2752bd92bfd1a26142dc', '[\"*\"]', NULL, NULL, '2026-02-23 09:35:37', '2026-02-23 09:35:37'),
(13, 'App\\Models\\User', 19, 'api-token', 'ea61a593c8bd991979fa81b07b17a69a8bc1ad6aa7604407ce54c24169ef6c01', '[\"*\"]', NULL, NULL, '2026-02-28 13:00:47', '2026-02-28 13:00:47'),
(14, 'App\\Models\\User', 16, 'api-token', '4a424eeacfa15ea35e927c4ef5c9d92f5810251d18f52cc4a5a5aebd6fa48282', '[\"*\"]', NULL, NULL, '2026-02-28 13:24:08', '2026-02-28 13:24:08'),
(15, 'App\\Models\\User', 16, 'api-token', '92e0857aa277162134539083aae56e0b77b95a63b16cd1a4ca5ccebffc1e5bf3', '[\"*\"]', NULL, NULL, '2026-02-28 13:28:21', '2026-02-28 13:28:21'),
(16, 'App\\Models\\User', 16, 'api-token', '5f597a4f5e89cff28bb3fbf6867def3d7efc54c5fdedfb15532e34a185fccc1d', '[\"*\"]', '2026-03-01 13:00:56', NULL, '2026-02-28 22:19:43', '2026-03-01 13:00:56'),
(21, 'App\\Models\\User', 16, 'api-token', '6373823cf1ad9ca829c034c7c0cd33bf3616d59e2be02b742e1896c0fbb54bef', '[\"*\"]', '2026-03-01 13:34:03', NULL, '2026-03-01 13:11:02', '2026-03-01 13:34:03'),
(22, 'App\\Models\\User', 16, 'api-token', 'e01e83cb582bef639500a93983f6ecd585d0b4979dbbb7dbafb8047ccf001ec4', '[\"*\"]', '2026-03-01 13:40:38', NULL, '2026-03-01 13:35:12', '2026-03-01 13:40:38'),
(23, 'App\\Models\\User', 16, 'api-token', 'cb3ff39f16da998fc036f510300d63467cadbf226e367ed39fa3cf6131e3c7e2', '[\"*\"]', '2026-03-01 14:00:31', NULL, '2026-03-01 13:53:31', '2026-03-01 14:00:31'),
(24, 'App\\Models\\User', 16, 'api-token', 'ca954f7ee250b98137e4e00603f6dc7c06989498f72461f4eac2bbb17cea879c', '[\"*\"]', '2026-03-01 14:05:43', NULL, '2026-03-01 14:02:07', '2026-03-01 14:05:43'),
(25, 'App\\Models\\User', 16, 'api-token', 'adc49adbed00c3a23bde425393841579d6bababe619aa5b4a2f749c63d23139c', '[\"*\"]', '2026-03-01 15:06:24', NULL, '2026-03-01 15:00:06', '2026-03-01 15:06:24'),
(26, 'App\\Models\\User', 16, 'api-token', 'c7ccb78eec6374670f77e4527d2c8c874071a1f0127c4794f3299b6334914f7a', '[\"*\"]', NULL, NULL, '2026-03-01 15:17:39', '2026-03-01 15:17:39');

-- --------------------------------------------------------

--
-- Table structure for table `scans`
--

CREATE TABLE `scans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `scan_type` varchar(255) NOT NULL,
  `total_images` int(11) NOT NULL DEFAULT 0,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `scan_statistics`
--

CREATE TABLE `scan_statistics` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `scan_id` bigint(20) UNSIGNED NOT NULL,
  `total_defects` int(11) NOT NULL DEFAULT 0,
  `passed_count` int(11) NOT NULL DEFAULT 0,
  `defect_count` int(11) NOT NULL DEFAULT 0,
  `accuracy` decimal(5,2) DEFAULT NULL,
  `processing_time` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` text NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('WacM5re31It2gSbVn0OGGosogSzHOUo3yoIby3sw', NULL, '127.0.0.1', 'PostmanRuntime/7.51.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaFZubVNHZGxqT0p6Nlo3ckozdzNJTHdSOFlMQXR3VERNWmRlMWlZSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1772384784);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `phone_verified_at` timestamp NULL DEFAULT NULL,
  `account_status` varchar(255) NOT NULL DEFAULT 'active',
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `phone`, `password`, `avatar`, `email_verified_at`, `phone_verified_at`, `account_status`, `role`, `created_at`, `updated_at`) VALUES
(16, 'Mohsen', 'mohsenhesham.110@gmail.com', '01100959301', '$2y$12$oMAiLnGjderT35GfhKlFtu3w3yV/Mr0ZB8eE3j7LJSE1ENAwECcmS', NULL, '2026-02-28 22:21:55', NULL, 'active', 'admin', '2026-02-23 00:23:54', '2026-02-28 22:21:55'),
(26, 'mohsen', 'mohsen.131123@gmail.com', '0114442424', '$2y$12$axKLw9WEuKLiN2QidpzxAuqqVcO0hCLGDfSfdvxEHXumQSAz2des2', NULL, NULL, NULL, 'active', 'user', '2026-03-01 15:45:45', '2026-03-01 15:45:45');

-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE `user_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `language` varchar(255) NOT NULL DEFAULT 'en',
  `theme` varchar(255) NOT NULL DEFAULT 'light',
  `push_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `email_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_settings`
--

INSERT INTO `user_settings` (`id`, `user_id`, `language`, `theme`, `push_notifications`, `email_notifications`, `created_at`, `updated_at`) VALUES
(11, 16, 'en', 'light', 1, 1, '2026-02-23 00:23:55', '2026-02-23 00:23:55'),
(21, 26, 'en', 'light', 1, 1, '2026-03-01 15:45:45', '2026-03-01 15:45:45');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activities_user_id_foreign` (`user_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD UNIQUE KEY `cache_key_unique` (`key`);

--
-- Indexes for table `defect_categories`
--
ALTER TABLE `defect_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `defect_categories_name_unique` (`name`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `images_scan_id_foreign` (`scan_id`);

--
-- Indexes for table `image_defects`
--
ALTER TABLE `image_defects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `image_defects_image_id_foreign` (`image_id`),
  ADD KEY `image_defects_defect_category_id_foreign` (`defect_category_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_foreign` (`user_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `scans`
--
ALTER TABLE `scans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `scans_user_id_foreign` (`user_id`);

--
-- Indexes for table `scan_statistics`
--
ALTER TABLE `scan_statistics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `scan_statistics_scan_id_foreign` (`scan_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `user_settings`
--
ALTER TABLE `user_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_settings_user_id_unique` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `defect_categories`
--
ALTER TABLE `defect_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `image_defects`
--
ALTER TABLE `image_defects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `scans`
--
ALTER TABLE `scans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `scan_statistics`
--
ALTER TABLE `scan_statistics`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `user_settings`
--
ALTER TABLE `user_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `activities_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `images`
--
ALTER TABLE `images`
  ADD CONSTRAINT `images_scan_id_foreign` FOREIGN KEY (`scan_id`) REFERENCES `scans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `image_defects`
--
ALTER TABLE `image_defects`
  ADD CONSTRAINT `image_defects_defect_category_id_foreign` FOREIGN KEY (`defect_category_id`) REFERENCES `defect_categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `image_defects_image_id_foreign` FOREIGN KEY (`image_id`) REFERENCES `images` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `scans`
--
ALTER TABLE `scans`
  ADD CONSTRAINT `scans_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `scan_statistics`
--
ALTER TABLE `scan_statistics`
  ADD CONSTRAINT `scan_statistics_scan_id_foreign` FOREIGN KEY (`scan_id`) REFERENCES `scans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_settings`
--
ALTER TABLE `user_settings`
  ADD CONSTRAINT `user_settings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
