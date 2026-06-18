-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 17, 2026 at 03:13 PM
-- Server version: 11.8.6-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u608200362_php_database`
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

--
-- Dumping data for table `activities`
--

INSERT INTO `activities` (`id`, `user_id`, `scan_id`, `title`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, 44, 58, 'Verification', 'Hostinger activity check', 'completed', '2026-04-26 13:16:10', '2026-04-26 13:16:11');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `expiration` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
(1, 'scratches', 'Surface scratches on steel surface', 'medium', '2026-04-19 05:58:29', NULL),
(2, 'crazing', 'Fine network of surface cracks', 'high', '2026-04-19 05:58:29', NULL),
(3, 'patches', 'Irregular patches or discoloration', 'medium', '2026-04-19 05:58:29', NULL),
(4, 'pitted', 'Small pits or holes on the surface', 'low', '2026-04-19 05:58:29', NULL),
(5, 'inclusion', 'Foreign material inside the metal', 'medium', '2026-04-19 05:58:29', NULL),
(6, 'rolled', 'Surface marks from rolling process', 'low', '2026-04-19 05:58:29', NULL),
(9, 'rolled-in_scale', 'Auto-created from AI detection result', 'medium', '2026-04-22 22:01:30', '2026-04-22 22:01:30'),
(10, 'pitted_surface', 'Auto-created from AI detection result', 'medium', '2026-04-22 22:04:45', '2026-04-22 22:04:45');

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

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`id`, `scan_id`, `image_path`, `processed_image_path`, `file_size`, `resolution`, `created_at`, `updated_at`) VALUES
(39, 42, '/storage/images/DJzMapskAMvAZZGShaB3cPKf.jpg', '/storage/images/EOpKSOmzbv1CnXZ2CTbuGyrb_annotated.jpg', 8002, '200x200', '2026-04-22 22:12:09', '2026-04-22 22:12:09'),
(40, 43, '/storage/images/xXr9RYGVvOHhRD62Kfl3N5bV.jpg', '/storage/images/3n4k03spaYwVQbYeqie9lHXj_annotated.jpg', 68920, '960x1280', '2026-04-24 16:48:55', '2026-04-24 16:48:55'),
(41, 44, '/storage/images/6AFnaVqgEwrVTtLgW6hpKTaB.jpg', '/storage/images/sVCU5Rt6LprD81Yvy6SBxDrb_annotated.jpg', 91770, '960x1280', '2026-04-24 16:51:07', '2026-04-24 16:51:07'),
(42, 45, '/storage/images/guQ8KuS9e3LiKCJ23SiOFk0D.jpg', '/storage/images/N1by3R07qbd50e0uY03wTDbz_annotated.jpg', 91770, '960x1280', '2026-04-24 16:52:43', '2026-04-24 16:52:43'),
(43, 46, '/storage/images/F548tW3ehHUnqC14M9NDaXz6.png', '/storage/images/CPPyiCXB7lyUq0ZnSo381dMV_annotated.jpg', 125027, '1152x2496', '2026-04-24 16:55:48', '2026-04-24 16:55:48'),
(44, 47, '/storage/images/s67bHHxMCga8sMzMSwyuWLZN.jpg', '/storage/images/avJDb5Xo9vEDW0sjvnkqD6t8_annotated.jpg', 91770, '960x1280', '2026-04-25 13:02:10', '2026-04-25 13:02:10'),
(45, 48, '/storage/images/vagbNLfnNoKQzef7Kd6VlhKC.jpg', '/storage/images/UdOEUR4WQCDcIKyLMCIET9mm_annotated.jpg', 83458, '960x1280', '2026-04-25 14:16:43', '2026-04-25 14:16:43'),
(46, 49, '/storage/images/XGpGVWxVaeWjwtPr3GPdD7Bd.jpg', '/storage/images/wbOHdymscmJYLUj9SIv9eL9O_annotated.jpg', 88208, '960x1280', '2026-04-25 18:22:47', '2026-04-25 18:22:47'),
(47, 50, '/storage/images/LZ6kF7HQujfWjpsDeMZb7vfu.jpg', '/storage/images/OBnI78MXwuZ8w8aTKJKQdASO_annotated.jpg', 91770, '960x1280', '2026-04-25 19:21:52', '2026-04-25 19:21:52'),
(48, 51, '/storage/images/ZeDv1ak26ksZynqr4HM9W0sK.jpg', '/storage/images/Aa93ho4QkqbpiN8pge4l7cIG_annotated.jpg', 91770, '960x1280', '2026-04-25 19:24:28', '2026-04-25 19:24:28'),
(49, 52, '/storage/images/2F7p3aQnkTuANCXqIdfevwXO.jpg', '/storage/images/TdKq7lhnm2bcx5ic7fOOt6KB_annotated.jpg', 62633, '960x1280', '2026-04-25 19:56:15', '2026-04-25 19:56:15'),
(50, 53, '/storage/images/TITGLv21PuSMNitpmyNRDnNE.png', '/storage/images/sLVtJ2R2ztQ3F4aib1Sf7dSD_annotated.jpg', 1298996, '1536x1024', '2026-04-25 20:05:31', '2026-04-25 20:05:31'),
(51, 54, '/storage/images/EEbSGPWnAmnY1SzetBhm6jKQ.jpg', '/storage/images/aoGxY1c98iJaU5nfsAvE0mE3_annotated.jpg', 88160, '960x1280', '2026-04-25 21:12:44', '2026-04-25 21:12:44'),
(52, 55, '/storage/images/PXzy5i5Xe9fy3h1BesFPjGCU.jpg', '/storage/images/2JRopTlmH4efjyeL6WozxeW6_annotated.jpg', 8474, '200x200', '2026-04-25 22:16:29', '2026-04-25 22:16:29'),
(53, 56, '/storage/images/aWFs82siLsJ2mlgSqkbixkf5.jpg', '/storage/images/lv4WB8GGOUjF8MEd5CfG0X80_annotated.jpg', 8474, '200x200', '2026-04-25 23:01:40', '2026-04-25 23:01:40'),
(54, 57, '/storage/images/OnXo6vy9q69R56KoxRqQeZ3H.jpg', '/storage/images/Js3Ynk6h6XfdLO6FpUmtox9S_annotated.jpg', 8474, '200x200', '2026-04-26 11:57:29', '2026-04-26 11:57:29'),
(55, 58, '/storage/images/hostinger-test.jpg', '/storage/images/p.jpg', 1234, NULL, '2026-04-26 13:16:08', '2026-04-26 13:16:09'),
(56, 59, '/storage/images/Fvo3mt1HJB1BGPyumrnHlMnC.jpg', '/storage/images/aJmDR6liTdtgY2ykYRwvHwBH_annotated.jpg', 88184, '960x1280', '2026-04-26 13:52:13', '2026-04-26 13:52:13'),
(57, 60, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/TneGeYNjx0RclIKtG9eHIHG3.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/yB1rqPmQy9ac52d7xPopav4M_annotated.jpg', 14382, '200x200', '2026-04-26 14:49:25', '2026-04-26 14:49:25'),
(58, 61, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/9IcbY4Tv9rHyV5AZWcIJJRXs.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/GFGvtOosSbx9p7mWmi9nU3r6_annotated.jpg', 14382, '200x200', '2026-04-26 15:00:54', '2026-04-26 15:00:54'),
(59, 62, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/b71rWn5aWbJDrxiLDT4p3b5O.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/HU8fc0QMCXiCmrZxQNSYLT7H_annotated.jpg', 14382, '200x200', '2026-04-26 15:01:07', '2026-04-26 15:01:07'),
(60, 63, '/storage/images/m11QHda61FS0s1a02sPByo2Q.jpg', '/storage/images/o3ZS6ruEjmGjMi3dcE7MYUt7_annotated.jpg', 14382, '200x200', '2026-04-26 21:59:13', '2026-04-26 21:59:13'),
(61, 64, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/3Pq5VXcAqoCBOpGQBJjeIzjJ.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/dzQFBLUxl5KZckKcHZTFEubb_annotated.jpg', 91770, '960x1280', '2026-04-26 22:55:33', '2026-04-26 22:55:33'),
(62, 65, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/MK68rLytr96GAQqWs7k0pdJ5.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/ydz4yAQbdrL258sNoOgI0SRD_annotated.jpg', 66093, '960x1280', '2026-04-26 22:55:59', '2026-04-26 22:55:59'),
(63, 66, '/storage/images/xyV4Lr0qHAOVgEgKIhqq5jsr.jpg', '/storage/images/6qMLIkiQFKn0Zc6DNXZQEjRL_annotated.jpg', 62633, '960x1280', '2026-04-26 22:58:17', '2026-04-26 22:58:17'),
(64, 67, '/storage/images/moTaB7iEwrgPxz4f2YXvSAoy.jpg', '/storage/images/TVrgO1t3Zx9IEETqNdtQWtlU_annotated.jpg', 14382, '200x200', '2026-04-26 23:01:01', '2026-04-26 23:01:01'),
(65, 68, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/GiWaYTkQjToO2BTTt7Hb8cJY.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/eR24wL0GmDIsTcaLyQwz08SK_annotated.jpg', 14382, '200x200', '2026-04-26 23:03:30', '2026-04-26 23:03:30'),
(66, 69, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/xasL4dcXW308ipxzUwTOXLdh.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/U8Qv1zZfsr73sLqsBVfnnGXN_annotated.jpg', 14382, '200x200', '2026-04-26 23:05:06', '2026-04-26 23:05:06'),
(67, 70, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/hWjuPS9g0OAYHnxzzgACjOpf.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/0RogwcmDz9gFU4eonFJ20b6G_annotated.jpg', 14382, '200x200', '2026-04-26 23:05:24', '2026-04-26 23:05:24'),
(68, 71, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/KGIZmbP006mUMJMSX8FqJ6k5.png', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/cZeOGGRMLR3JBkbHNtuNk10K_annotated.jpg', 4482574, '2730x1536', '2026-04-26 23:05:59', '2026-04-26 23:05:59'),
(69, 72, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/NxUK3SnG9kg04gZGAyk0lyMe.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/ZACOQzgshYEZypXvB5UqBaPZ_annotated.jpg', 6995, '200x200', '2026-04-26 23:06:32', '2026-04-26 23:06:32'),
(70, 73, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/kat5alBQ2aCtdHOpVu1TQZSZ.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/l9VesRHf9HTY5RofmAKUKirS_annotated.jpg', 88237, '960x1280', '2026-04-26 23:13:19', '2026-04-26 23:13:19'),
(71, 74, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/mTmPFe9qT9OnxhiqnvV1Px7W.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/cdKYXZMDTOVOobUFav90iPkX_annotated.jpg', 88237, '960x1280', '2026-04-26 23:13:20', '2026-04-26 23:13:20'),
(72, 75, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/ZCxuSVrvkxw2Ukk1Pz7sRe8v.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/nHzBneGGBrZ31OYyEWMvQFGW_annotated.jpg', 91770, '960x1280', '2026-04-26 23:21:58', '2026-04-26 23:21:58'),
(73, 76, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/AhFu1YcuIAry7JvAf5vAD8wu.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/6ByslP1DbLITEIWIneSMKUU5_annotated.jpg', 6995, '200x200', '2026-04-26 23:45:57', '2026-04-26 23:45:57'),
(74, 77, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/Je3hY2T5x3JgIihN5H1AYdXM.png', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/z9VkfvFz9iUWHW02JgT12Yzy_annotated.jpg', 125027, '1152x2496', '2026-04-27 00:23:47', '2026-04-27 00:23:47'),
(75, 78, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/Vm3tDfHMojPtu4XJOBVflR2V.png', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/yBqdKRVU1GF7tqs79Ktgky2I_annotated.jpg', 125027, '1152x2496', '2026-04-27 00:23:47', '2026-04-27 00:23:47'),
(76, 79, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/6YejITHrvUz1qkkROj2ZSKcu.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/daxpKqsG0LlYx9lo3vfh4q07_annotated.jpg', 6995, '200x200', '2026-04-27 00:48:00', '2026-04-27 00:48:00'),
(77, 80, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/bBokVNLiBnjSAGaVNDlRWEt9.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/S9hj50nb1wLQAEDpg0tvYddR_annotated.jpg', 6995, '200x200', '2026-04-27 04:11:53', '2026-04-27 04:11:53'),
(78, 81, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/z54LH0Rkz5y4y5CtBe9P1n3q.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/XFJ10SSvkemSt46DBnFqr5SM_annotated.jpg', 14382, '200x200', '2026-04-27 04:16:30', '2026-04-27 04:16:30'),
(79, 82, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/Tp8hLtDkfYuPGztMQUN9uFKC.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/K5ZgyKTz9C8wPRY1ha5BYhQO_annotated.jpg', 14382, '200x200', '2026-04-27 04:18:56', '2026-04-27 04:18:56'),
(80, 83, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/mYgKJAfgP73mmHGNqCvVy2WZ.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/yKHPtx5kNsPUiE5jzkgEV7ri_annotated.jpg', 880003, '4000x3000', '2026-04-27 05:25:24', '2026-04-27 05:25:24'),
(81, 84, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/1jYoQ1Zscgyx5XJnq2KOGeIj.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/xUw5TpYY0AnU4eqebcpCttjJ_annotated.jpg', 2198103, '4624x3472', '2026-04-27 05:27:17', '2026-04-27 05:27:17'),
(82, 85, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/LWEV3ymW99ravV7nOsqP5Qh6.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/J5CBU5qs7as20ztZYfFpS6ZV_annotated.jpg', 1830017, '4624x3472', '2026-04-27 05:29:03', '2026-04-27 05:29:03'),
(83, 86, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/fq4lTjFv8cZ6sYd4Oeh1Vrmk.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/pJtagR0J50zyvsjGA7YSp5OG_annotated.jpg', 9158, '200x200', '2026-04-27 05:40:03', '2026-04-27 05:40:03'),
(84, 87, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/dw32JfYLaoXtmrLCznGYnU26.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/6Jt2Qz0eRp1AZypm8rPsATdv_annotated.jpg', 9158, '200x200', '2026-04-27 05:43:32', '2026-04-27 05:43:32'),
(85, 88, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/WbeZ0oHpUVbxTai9J6teFykw.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/oVJzbBj70ZiQ5e7PjczDpupz_annotated.jpg', 9158, '200x200', '2026-04-27 05:45:01', '2026-04-27 05:45:01'),
(86, 89, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/U2YTYGCVRPDrrW2hoFwykztN.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/ILb42k2k2zoktZeBSiI2qWIP_annotated.jpg', 2731545, '4000x3000', '2026-04-28 19:38:15', '2026-04-28 19:38:15'),
(87, 90, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/iwlYVviFdiB2ze2DiizHGJhM.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/EouRQsJKoxBxhfAKHZcg1VyM_annotated.jpg', 845661, '4000x3000', '2026-05-07 13:50:26', '2026-05-07 13:50:26'),
(88, 91, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/mwHpdPIFzg2zOBU7HKhl8Bb1.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/GhiSy7PkwmPhZBMCQPxIFPnU_annotated.jpg', 134543, '720x1650', '2026-05-07 13:53:57', '2026-05-07 13:53:57'),
(89, 92, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/MzGGxcRFcXCot1AAjCelF1Q3.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/fynnmDK2vEjHkep8AJyBgzMs_annotated.jpg', 308059, '2296x4080', '2026-05-07 13:58:07', '2026-05-07 13:58:07'),
(90, 93, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/D3tBnVusbPCDR4pDuQp9PHhs.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/31LvsFGbOE1KeIuzKJ7hBqCH_annotated.jpg', 3924, '200x200', '2026-05-07 13:58:33', '2026-05-07 13:58:33'),
(91, 94, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/Hu7QETc82FSX6wgOO2MlkJ2o.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/v8Se2MuObmEuasp2NlJqVHzb_annotated.jpg', 6789, '200x200', '2026-05-07 13:58:46', '2026-05-07 13:58:46'),
(92, 95, 'https://lightgreen-crane-116703.hostingersite.com/storage/images/tw4fPtyqDxd6gHgsttn2JqAj.jpg', 'https://lightgreen-crane-116703.hostingersite.com/storage/images/emPhNZgaaTrpv8PaagG5EqT4_annotated.jpg', 6789, '200x200', '2026-05-07 14:31:19', '2026-05-07 14:31:19'),
(93, 96, 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/Gd7hCjbpGWbSCEZsqEmAuuJy.jpg', 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/nkLSw7vn98vCOs8g6i9P2gof_annotated.jpg', 81565, '960x1280', '2026-05-13 23:50:29', '2026-05-13 23:50:29'),
(94, 97, 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/2yde43DzabPidsVDYXXyrqTh.jpg', 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/BAL4rlVhBPKYnDg9eIQJ5EG4_annotated.jpg', 840922, '4000x3000', '2026-05-16 22:57:58', '2026-05-16 22:57:58'),
(98, 101, 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/T0Jl5aUXX7siAmSRQ1ErBWvc.jpg', 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/fMAkdtTDUmFl8IhSbcoxioIa_annotated.jpg', 8114, '200x200', '2026-06-14 16:24:06', '2026-06-14 16:24:06'),
(99, 103, 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/JnCvGWmfMzcgjBFQQQ7uxZtq.jpg', 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/OHe09X71Ux9OaKYpyjPFcGWl_annotated.jpg', 91770, '960x1280', '2026-06-17 16:02:56', '2026-06-17 16:02:56'),
(100, 104, 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/squq4m7YYXjEwcxrAve1cd8g.jpg', 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/FLSanFKFdbfMYtWgYxmxymtW_annotated.jpg', 85455, '960x1280', '2026-06-17 16:04:38', '2026-06-17 16:04:38'),
(101, 105, 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/RPsjofRx9Jz2zs8sTeuKUECt.jpg', 'https://lightgreen-crane-116703.hostingersite.com/public/storage/images/Q424dXihXVTEzkKGpnKDgDTQ_annotated.jpg', 85284, '960x1280', '2026-06-17 16:24:08', '2026-06-17 16:24:08');

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

--
-- Dumping data for table `image_defects`
--

INSERT INTO `image_defects` (`id`, `image_id`, `defect_category_id`, `confidence`, `bounding_box`, `created_at`, `updated_at`) VALUES
(39, 39, 1, 95.22, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-22 22:12:09', '2026-04-22 22:12:09'),
(40, 40, 1, 96.54, '{\"x\":16,\"y\":232,\"width\":944,\"height\":735}', '2026-04-24 16:48:55', '2026-04-24 16:48:55'),
(41, 41, 9, 96.82, '{\"x\":474,\"y\":971,\"width\":946,\"height\":1280}', '2026-04-24 16:51:07', '2026-04-24 16:51:07'),
(42, 42, 9, 96.82, '{\"x\":474,\"y\":971,\"width\":946,\"height\":1280}', '2026-04-24 16:52:43', '2026-04-24 16:52:43'),
(43, 43, 1, 94.87, '{\"x\":74,\"y\":778,\"width\":1085,\"height\":2043}', '2026-04-24 16:55:48', '2026-04-24 16:55:48'),
(44, 44, 9, 96.82, '{\"x\":474,\"y\":971,\"width\":946,\"height\":1280}', '2026-04-25 13:02:10', '2026-04-25 13:02:10'),
(45, 45, 9, 77.76, '{\"x\":398,\"y\":447,\"width\":946,\"height\":1280}', '2026-04-25 14:16:43', '2026-04-25 14:16:43'),
(46, 46, 1, 88.32, '{\"x\":10,\"y\":607,\"width\":520,\"height\":1250}', '2026-04-25 18:22:47', '2026-04-25 18:22:47'),
(47, 47, 9, 96.82, '{\"x\":474,\"y\":971,\"width\":946,\"height\":1280}', '2026-04-25 19:21:52', '2026-04-25 19:21:52'),
(48, 48, 9, 96.82, '{\"x\":474,\"y\":971,\"width\":946,\"height\":1280}', '2026-04-25 19:24:28', '2026-04-25 19:24:28'),
(49, 49, 1, 95.64, '{\"x\":456,\"y\":1067,\"width\":956,\"height\":1279}', '2026-04-25 19:56:15', '2026-04-25 19:56:15'),
(50, 50, 3, 96.77, '{\"x\":976,\"y\":12,\"width\":1459,\"height\":621}', '2026-04-25 20:05:31', '2026-04-25 20:05:31'),
(51, 51, 1, 84.12, '{\"x\":11,\"y\":627,\"width\":507,\"height\":1256}', '2026-04-25 21:12:44', '2026-04-25 21:12:44'),
(52, 52, 1, 97.47, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-25 22:16:29', '2026-04-25 22:16:29'),
(53, 53, 1, 97.47, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-25 23:01:40', '2026-04-25 23:01:40'),
(54, 54, 1, 97.47, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-26 11:57:29', '2026-04-26 11:57:29'),
(55, 56, 1, 83.23, '{\"x\":11,\"y\":627,\"width\":509,\"height\":1254}', '2026-04-26 13:52:13', '2026-04-26 13:52:13'),
(56, 57, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-26 14:49:25', '2026-04-26 14:49:25'),
(57, 58, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-26 15:00:54', '2026-04-26 15:00:54'),
(58, 59, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-26 15:01:07', '2026-04-26 15:01:07'),
(59, 60, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-26 21:59:13', '2026-04-26 21:59:13'),
(60, 61, 9, 96.82, '{\"x\":474,\"y\":971,\"width\":946,\"height\":1280}', '2026-04-26 22:55:33', '2026-04-26 22:55:33'),
(61, 62, 10, 94.22, '{\"x\":574,\"y\":0,\"width\":944,\"height\":662}', '2026-04-26 22:55:59', '2026-04-26 22:55:59'),
(62, 63, 1, 95.64, '{\"x\":456,\"y\":1067,\"width\":956,\"height\":1279}', '2026-04-26 22:58:17', '2026-04-26 22:58:17'),
(63, 64, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-26 23:01:01', '2026-04-26 23:01:01'),
(64, 65, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-26 23:03:30', '2026-04-26 23:03:30'),
(65, 66, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-26 23:05:06', '2026-04-26 23:05:06'),
(66, 67, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-26 23:05:24', '2026-04-26 23:05:24'),
(67, 68, 3, 94.85, '{\"x\":34,\"y\":945,\"width\":1216,\"height\":1512}', '2026-04-26 23:05:59', '2026-04-26 23:05:59'),
(68, 69, 5, 97.26, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-26 23:06:32', '2026-04-26 23:06:32'),
(69, 70, 1, 88.50, '{\"x\":11,\"y\":601,\"width\":509,\"height\":1251}', '2026-04-26 23:13:19', '2026-04-26 23:13:19'),
(70, 71, 1, 88.50, '{\"x\":11,\"y\":601,\"width\":509,\"height\":1251}', '2026-04-26 23:13:20', '2026-04-26 23:13:20'),
(71, 72, 9, 96.82, '{\"x\":474,\"y\":971,\"width\":946,\"height\":1280}', '2026-04-26 23:21:58', '2026-04-26 23:21:58'),
(72, 73, 5, 97.26, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-26 23:45:57', '2026-04-26 23:45:57'),
(73, 74, 1, 94.87, '{\"x\":74,\"y\":778,\"width\":1085,\"height\":2043}', '2026-04-27 00:23:47', '2026-04-27 00:23:47'),
(74, 75, 1, 94.87, '{\"x\":74,\"y\":778,\"width\":1085,\"height\":2043}', '2026-04-27 00:23:47', '2026-04-27 00:23:47'),
(75, 76, 5, 97.26, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-27 00:48:00', '2026-04-27 00:48:00'),
(76, 77, 5, 97.26, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-27 04:11:53', '2026-04-27 04:11:53'),
(77, 78, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-27 04:16:30', '2026-04-27 04:16:30'),
(78, 79, 9, 90.59, '{\"x\":0,\"y\":0,\"width\":199,\"height\":199}', '2026-04-27 04:18:56', '2026-04-27 04:18:56'),
(79, 80, 3, 93.03, '{\"x\":72,\"y\":455,\"width\":2938,\"height\":2506}', '2026-04-27 05:25:24', '2026-04-27 05:25:24'),
(80, 81, 9, 96.77, '{\"x\":3912,\"y\":1110,\"width\":4622,\"height\":2905}', '2026-04-27 05:27:17', '2026-04-27 05:27:17'),
(81, 82, 3, 95.92, '{\"x\":68,\"y\":8,\"width\":2228,\"height\":2521}', '2026-04-27 05:29:03', '2026-04-27 05:29:03'),
(82, 83, 9, 98.03, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-27 05:40:03', '2026-04-27 05:40:03'),
(83, 84, 9, 98.03, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-27 05:43:32', '2026-04-27 05:43:32'),
(84, 85, 9, 98.03, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-04-27 05:45:01', '2026-04-27 05:45:01'),
(85, 86, 3, 88.95, '{\"x\":0,\"y\":59,\"width\":1043,\"height\":2828}', '2026-04-28 19:38:15', '2026-04-28 19:38:15'),
(86, 87, 5, 64.92, '{\"x\":1952,\"y\":73,\"width\":3995,\"height\":2916}', '2026-05-07 13:50:26', '2026-05-07 13:50:26'),
(87, 88, 3, 95.06, '{\"x\":14,\"y\":0,\"width\":700,\"height\":440}', '2026-05-07 13:53:57', '2026-05-07 13:53:57'),
(88, 89, 2, 82.83, '{\"x\":77,\"y\":3428,\"width\":2220,\"height\":4080}', '2026-05-07 13:58:07', '2026-05-07 13:58:07'),
(89, 90, 5, 96.82, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-05-07 13:58:33', '2026-05-07 13:58:33'),
(90, 91, 9, 96.78, '{\"x\":0,\"y\":0,\"width\":199,\"height\":200}', '2026-05-07 13:58:46', '2026-05-07 13:58:46'),
(91, 92, 9, 96.78, '{\"x\":0,\"y\":0,\"width\":199,\"height\":200}', '2026-05-07 14:31:19', '2026-05-07 14:31:19'),
(92, 93, 1, 53.93, '{\"x\":18,\"y\":0,\"width\":698,\"height\":128}', '2026-05-13 23:50:29', '2026-05-13 23:50:29'),
(93, 94, 3, 83.01, '{\"x\":85,\"y\":3409,\"width\":2936,\"height\":3999}', '2026-05-16 22:57:59', '2026-05-16 22:57:59'),
(97, 98, 5, 96.72, '{\"x\":0,\"y\":0,\"width\":200,\"height\":199}', '2026-06-14 16:24:06', '2026-06-14 16:24:06'),
(98, 99, 9, 96.82, '{\"x\":474,\"y\":971,\"width\":946,\"height\":1280}', '2026-06-17 16:02:56', '2026-06-17 16:02:56'),
(99, 100, 1, 89.73, '{\"x\":6,\"y\":262,\"width\":371,\"height\":767}', '2026-06-17 16:04:38', '2026-06-17 16:04:38'),
(100, 101, 1, 88.93, '{\"x\":6,\"y\":261,\"width\":371,\"height\":768}', '2026-06-17 16:24:08', '2026-06-17 16:24:08');

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
(50, 'App\\Models\\User', 29, 'api-token', '4ccb257106cb9618235007c810c07d98e03f88224cbd82afb34d0e83c8610d5a', '[\"*\"]', NULL, NULL, '2026-04-22 22:10:02', '2026-04-22 22:10:02'),
(51, 'App\\Models\\User', 29, 'api-token', '1cfbcdb42d65a47464c26e5c5e00ae25241bc0355dcb2c0eba2179867af1f6b4', '[\"*\"]', '2026-04-22 22:12:05', NULL, '2026-04-22 22:11:56', '2026-04-22 22:12:05'),
(52, 'App\\Models\\User', 16, 'api-token', '02a4d5a96532d73e322aea1a06b8fdbfe47bc51eb566c3a5781b7c1d2f6ea5d3', '[\"*\"]', '2026-04-25 20:01:00', NULL, '2026-04-22 22:12:28', '2026-04-25 20:01:00'),
(53, 'App\\Models\\User', 16, 'api-token', '62d62f6290a4a5f46c6fa3dfd5bfd3489585a5162c14f8c9790b5fd79d3c1a4c', '[\"*\"]', NULL, NULL, '2026-04-24 15:30:12', '2026-04-24 15:30:12'),
(54, 'App\\Models\\User', 16, 'api-token', '0d3b7dc8fab27e3898872e52f9ca420cb23c7e915ab743fa065b21ee02f685b1', '[\"*\"]', NULL, NULL, '2026-04-24 15:30:17', '2026-04-24 15:30:17'),
(55, 'App\\Models\\User', 16, 'api-token', '6961ea7756281746dabcb815eec039a15b927af9ae882a483318ce56d0238da5', '[\"*\"]', NULL, NULL, '2026-04-24 15:30:34', '2026-04-24 15:30:34'),
(56, 'App\\Models\\User', 16, 'api-token', '8fe8a3f70c656b22dcc12374b30e8b180a3db656fd2ea5dde9cde90c036ae993', '[\"*\"]', NULL, NULL, '2026-04-24 15:31:40', '2026-04-24 15:31:40'),
(57, 'App\\Models\\User', 16, 'api-token', 'cb7fd783708c188b69529c21058b5c6ebb3096ec91b164f2780245ffea5bc342', '[\"*\"]', NULL, NULL, '2026-04-24 15:38:43', '2026-04-24 15:38:43'),
(58, 'App\\Models\\User', 16, 'api-token', '41365b35e5a35606aec595c93dbf08d84ecf9a6ebc9a8371674ff470d49e44c0', '[\"*\"]', NULL, NULL, '2026-04-24 15:40:57', '2026-04-24 15:40:57'),
(59, 'App\\Models\\User', 16, 'api-token', '3308c60fcf8e54c8539333573e0290f4a0972e13789d581aa7c998375bdf9612', '[\"*\"]', NULL, NULL, '2026-04-24 15:42:41', '2026-04-24 15:42:41'),
(60, 'App\\Models\\User', 16, 'api-token', '5d2117b3e3b426f4f313fb57ee355cf1de217a1bc4d419f28c474274711e15dc', '[\"*\"]', NULL, NULL, '2026-04-24 15:42:58', '2026-04-24 15:42:58'),
(61, 'App\\Models\\User', 16, 'api-token', 'b5e2328df92ef3349a210ab80c1bbca3be276764bc96b33315f6fd37d92846f7', '[\"*\"]', NULL, NULL, '2026-04-24 15:44:11', '2026-04-24 15:44:11'),
(62, 'App\\Models\\User', 16, 'api-token', 'a73de219b43d080bf6f9538157d454fe148441659162d11b7efc3b0e7ff52b56', '[\"*\"]', NULL, NULL, '2026-04-24 15:53:18', '2026-04-24 15:53:18'),
(63, 'App\\Models\\User', 16, 'api-token', '56cd993ef313a2d038de9d89301daf509325a5f06bc7faa6b88a2577ba503ef9', '[\"*\"]', NULL, NULL, '2026-04-24 15:53:22', '2026-04-24 15:53:22'),
(64, 'App\\Models\\User', 16, 'api-token', 'ac002fa51524bff1fcdc6018d81612c93666cb3f59f787592af3b1d0826be265', '[\"*\"]', NULL, NULL, '2026-04-24 15:53:29', '2026-04-24 15:53:29'),
(65, 'App\\Models\\User', 16, 'api-token', '36f9c61bc29d7ff3d4655ac44c1d4c2fa98afe3a10a9dee098942432d45c699b', '[\"*\"]', NULL, NULL, '2026-04-24 15:54:06', '2026-04-24 15:54:06'),
(66, 'App\\Models\\User', 16, 'api-token', 'a20594c7f362f5b639152ac454bec8fd42909fcd5badf931b7478304060a7ca8', '[\"*\"]', NULL, NULL, '2026-04-24 15:57:55', '2026-04-24 15:57:55'),
(67, 'App\\Models\\User', 16, 'api-token', 'ea1b22432873152625fce525989cceae45525bbc77fa974456a467aa213d6249', '[\"*\"]', NULL, NULL, '2026-04-24 15:59:59', '2026-04-24 15:59:59'),
(68, 'App\\Models\\User', 16, 'api-token', '6e0b01803eb4b1c84e38f3d009dafb48eff7576c6edf367a78294b1bd2388013', '[\"*\"]', NULL, NULL, '2026-04-24 16:01:06', '2026-04-24 16:01:06'),
(69, 'App\\Models\\User', 16, 'api-token', 'bb29848c90097d9f8372a1da539aa8a268a33fb6434de9457ee3d2c2cbe980ad', '[\"*\"]', NULL, NULL, '2026-04-24 16:06:10', '2026-04-24 16:06:10'),
(70, 'App\\Models\\User', 16, 'api-token', '5556e18271e2570f44c51198f3bc3aed637aaac873166b42bd1479f6e4db4c6e', '[\"*\"]', NULL, NULL, '2026-04-24 16:10:11', '2026-04-24 16:10:11'),
(71, 'App\\Models\\User', 16, 'api-token', '51d9ae9da876d528370fc742a517dbb37c48e8045f7cf454cc004049a508e8ed', '[\"*\"]', NULL, NULL, '2026-04-24 16:10:26', '2026-04-24 16:10:26'),
(72, 'App\\Models\\User', 16, 'api-token', 'b5040d8a94c3f7644e780e5ac819792b0875341428ede174ed9d4b521552f128', '[\"*\"]', NULL, NULL, '2026-04-24 16:11:19', '2026-04-24 16:11:19'),
(73, 'App\\Models\\User', 16, 'api-token', '67838af99409f317a5431b364bcaf7822575af601c470cb4e5b4d11b5c338deb', '[\"*\"]', NULL, NULL, '2026-04-24 16:11:34', '2026-04-24 16:11:34'),
(77, 'App\\Models\\User', 16, 'api-token', '339732726e2c9fb566c50ab99b342bcdad49efd5fee2593932a2fb6be65abb39', '[\"*\"]', '2026-04-25 13:02:23', NULL, '2026-04-24 16:58:42', '2026-04-25 13:02:23'),
(78, 'App\\Models\\User', 29, 'api-token', '3f2e21edccbe6f3fc9d2aad99c0a73492bea8f62843a5d0a4099319dcaf5693f', '[\"*\"]', '2026-04-25 13:11:55', NULL, '2026-04-25 13:11:42', '2026-04-25 13:11:55'),
(80, 'App\\Models\\User', 16, 'api-token', '3a89fd7945ef1102a1121a5070592335fab25f4427782f3cb9093f27352af22f', '[\"*\"]', '2026-04-25 20:05:30', NULL, '2026-04-25 20:02:42', '2026-04-25 20:05:30'),
(81, 'App\\Models\\User', 16, 'api-token', '1ebeaf34a84d88c124b9f13f2b6e475ec42d2725b701d585cea6ac810ed2c907', '[\"*\"]', NULL, NULL, '2026-04-25 20:34:21', '2026-04-25 20:34:21'),
(82, 'App\\Models\\User', 16, 'api-token', '632ca74d28fd22e2727d18ba3fdf5d8dd05807f4462e6e41e6904e3bc5b5940a', '[\"*\"]', NULL, NULL, '2026-04-25 20:50:32', '2026-04-25 20:50:32'),
(84, 'App\\Models\\User', 16, 'api-token', '49830add999d36a57194aecf5c42080b441c3cfc77b562d0a8e1391dd61b0441', '[\"*\"]', NULL, NULL, '2026-04-25 22:05:17', '2026-04-25 22:05:17'),
(85, 'App\\Models\\User', 16, 'api-token', '24ec58e7a9b1bed076cd004874ef213b2f5f146d588473e023f568ffe3c7c283', '[\"*\"]', '2026-04-26 15:01:16', NULL, '2026-04-25 22:06:43', '2026-04-26 15:01:16'),
(86, 'App\\Models\\User', 16, 'api-token', '4789d6d009a2cff62531f19cf9aae0688476968356707a9fb9063cf3cd689fbb', '[\"*\"]', NULL, NULL, '2026-04-25 22:22:58', '2026-04-25 22:22:58'),
(87, 'App\\Models\\User', 16, 'api-token', '08dd9a01b4c67995cbddaec3258c880db3d0548678eb012ae3fcd34e865e8acd', '[\"*\"]', '2026-04-26 01:14:37', NULL, '2026-04-25 23:18:10', '2026-04-26 01:14:37'),
(88, 'App\\Models\\User', 16, 'api-token', 'de7cf1fee199681aa0e122136c159ac3e69e1f37ac5d548683ac898e0fe4478c', '[\"*\"]', NULL, NULL, '2026-04-26 11:53:58', '2026-04-26 11:53:58'),
(89, 'App\\Models\\User', 41, 'api-token', '6a8ab0d69c005d33c526deb20bdd8383204774cddd8c5718fe534461502929b7', '[\"*\"]', NULL, NULL, '2026-04-26 13:12:03', '2026-04-26 13:12:03'),
(90, 'App\\Models\\User', 42, 'api-token', 'a9fd0211faf876932592af21095ab41df10b2cc2d300186341a0dc1cdc614f51', '[\"*\"]', NULL, NULL, '2026-04-26 13:12:29', '2026-04-26 13:12:29'),
(91, 'App\\Models\\User', 44, 'api-token', '8ef74bebc48a0c61d2e5d7f4e346507c34add2508c97469f53a82362f881a1a6', '[\"*\"]', NULL, NULL, '2026-04-26 13:15:50', '2026-04-26 13:15:50'),
(93, 'App\\Models\\User', 16, 'api-token', '2f71f4cf1819ba6bd450bbe40ca545d420686ce0703d56541dccfc0a856bbde9', '[\"*\"]', NULL, NULL, '2026-04-26 13:45:54', '2026-04-26 13:45:54'),
(94, 'App\\Models\\User', 29, 'api-token', 'd08111c14b86e0e4a38009b623a1a68be15c68fd3e6b31907627e62c0367e306', '[\"*\"]', '2026-04-26 13:52:11', NULL, '2026-04-26 13:46:13', '2026-04-26 13:52:11'),
(96, 'App\\Models\\User', 16, 'api-token', '5a45e51fdd5749ddf355fc1a6ff3a0e725ea29a44d473d1de31910c016e2a476', '[\"*\"]', NULL, NULL, '2026-04-26 14:08:08', '2026-04-26 14:08:08'),
(97, 'App\\Models\\User', 16, 'api-token', '5e41c8613e4f2cfa8f9ee3921a2ea02ae08f000239f3c14177c76eba2cc788dc', '[\"*\"]', NULL, NULL, '2026-04-26 14:50:04', '2026-04-26 14:50:04'),
(98, 'App\\Models\\User', 28, 'api-token', 'b492f019a0b0a5317653b090b1840cef2a54963abd2f85383efebb9d5738ec56', '[\"*\"]', '2026-04-26 14:57:23', NULL, '2026-04-26 14:57:04', '2026-04-26 14:57:23'),
(99, 'App\\Models\\User', 37, 'api-token', 'c223e32393335a5845aa3a504fba239da546dcdbc973c9aa75c13ad3fe935604', '[\"*\"]', '2026-04-26 23:12:52', NULL, '2026-04-26 14:58:14', '2026-04-26 23:12:52'),
(100, 'App\\Models\\User', 29, 'api-token', 'a8ec9d7ddcf09b518bb6880dbcda8b4042a1762582b9ed84d364332276bd11d9', '[\"*\"]', '2026-05-13 23:50:23', NULL, '2026-04-26 21:45:18', '2026-05-13 23:50:23'),
(101, 'App\\Models\\User', 37, 'api-token', 'e254430ba920e5b0e9654e52550e1cfabf84971f5ba718f4d2db81e9e120aa78', '[\"*\"]', NULL, NULL, '2026-04-26 21:59:24', '2026-04-26 21:59:24'),
(102, 'App\\Models\\User', 16, 'api-token', '844af99afa48b090a0413ecb58e813111d69bfc5f3b3e8775b2d52898cfc752b', '[\"*\"]', '2026-04-27 04:54:12', NULL, '2026-04-26 22:59:38', '2026-04-27 04:54:12'),
(103, 'App\\Models\\User', 29, 'api-token', '306f2b4cfb7e9802b621dd19b2c67afaa6a1f8738356bfe8d3b47b81629f88d8', '[\"*\"]', '2026-04-27 04:43:08', NULL, '2026-04-26 23:04:49', '2026-04-27 04:43:08'),
(104, 'App\\Models\\User', 45, 'api-token', 'd8757d739e6936cb204276a4773dcdf03190ac15b0dcd94fdd05e8ca8e506f4c', '[\"*\"]', '2026-04-26 23:28:28', NULL, '2026-04-26 23:27:22', '2026-04-26 23:28:28'),
(105, 'App\\Models\\User', 46, 'api-token', '53407edbaf32f50bff661d97c048f2d2fead222718d11f378158f623775a6cd2', '[\"*\"]', '2026-04-27 04:30:13', NULL, '2026-04-26 23:47:38', '2026-04-27 04:30:13'),
(106, 'App\\Models\\User', 46, 'api-token', 'd656898d1be016af88c6786199b853f2792c721a58f8e9408baedcf85a6281ce', '[\"*\"]', NULL, NULL, '2026-04-27 04:11:58', '2026-04-27 04:11:58'),
(107, 'App\\Models\\User', 46, 'api-token', '26b10cf22daf5e619ad5cd5831c195c49b10bf657ad7fab62d1c27ad753f6a65', '[\"*\"]', '2026-04-27 04:53:09', NULL, '2026-04-27 04:42:37', '2026-04-27 04:53:09'),
(108, 'App\\Models\\User', 29, 'api-token', '94c1c9b19600aa9dee039fff63bcea27f7abab17a7df25d66a5e5bc7944329fc', '[\"*\"]', NULL, NULL, '2026-04-27 04:53:39', '2026-04-27 04:53:39'),
(109, 'App\\Models\\User', 29, 'api-token', '77fe89b18dd0c6877195f878f3a0693214e3cf14d5ac615e134350c270379ce9', '[\"*\"]', '2026-06-14 16:23:56', NULL, '2026-04-27 04:54:27', '2026-06-14 16:23:56'),
(110, 'App\\Models\\User', 29, 'api-token', 'a90f6f1f25731f0a949d09e7552fa74eac5dc5bd6e2e4d7f32e00860d9098b9f', '[\"*\"]', '2026-04-28 19:41:38', NULL, '2026-04-27 05:24:06', '2026-04-28 19:41:38'),
(111, 'App\\Models\\User', 29, 'api-token', '5d96efb44fb9ff29c515c3e024d9386833dd70bf0d1c97bea483b3b00d85b570', '[\"*\"]', '2026-04-27 05:45:01', NULL, '2026-04-27 05:39:49', '2026-04-27 05:45:01'),
(112, 'App\\Models\\User', 29, 'api-token', '6fd29e7e3b9351b2f638856d44982caf7188f218df186cb4cd210c0255684b50', '[\"*\"]', '2026-05-16 22:57:52', NULL, '2026-04-28 19:44:25', '2026-05-16 22:57:52'),
(114, 'App\\Models\\User', 16, 'api-token', '8f4d96ef30b7702eb465e7a1054a94fe28aa61ff405f762d085945532a941b50', '[\"*\"]', '2026-05-07 14:31:19', NULL, '2026-05-07 14:30:37', '2026-05-07 14:31:19'),
(115, 'App\\Models\\User', 16, 'api-token', 'e36bf9559949067239e3a3946aa882573d1f5af5bde940b6fea8bd36177a1a85', '[\"*\"]', '2026-06-14 16:43:01', NULL, '2026-05-12 17:45:43', '2026-06-14 16:43:01'),
(116, 'App\\Models\\User', 29, 'api-token', '0a587498e2b115a195906a042479f5b259734d9e05afb3bc5114fb456d03509f', '[\"*\"]', '2026-06-17 16:57:55', NULL, '2026-05-13 23:52:34', '2026-06-17 16:57:55'),
(117, 'App\\Models\\User', 47, 'api-token', '689e6ab1bf275f65d540fe16ad05dca8e48a523098d05cebd46279e881003993', '[\"*\"]', '2026-05-18 06:37:12', NULL, '2026-05-18 06:21:26', '2026-05-18 06:37:12'),
(118, 'App\\Models\\User', 16, 'api-token', 'caa902cecab371b373a82ce0359850702b6c7eb0bc849f95b61e4d27eaf6c556', '[\"*\"]', NULL, NULL, '2026-06-14 16:02:54', '2026-06-14 16:02:54'),
(119, 'App\\Models\\User', 29, 'api-token', '42fe1d3ed19f8ad183df292d43f59ff2635691eca846b560ff89e53610da4acb', '[\"*\"]', '2026-06-14 16:51:44', NULL, '2026-06-14 16:51:43', '2026-06-14 16:51:44'),
(120, 'App\\Models\\User', 29, 'api-token', 'c32b9cbb44651ec3693d0c7bc4271bd4d2aabb7a1f7edddad8b835ca0a6fbcd3', '[\"*\"]', '2026-06-14 17:35:56', NULL, '2026-06-14 17:18:50', '2026-06-14 17:35:56'),
(121, 'App\\Models\\User', 29, 'api-token', 'ef63162efbed6ec56d1f6c5cd90ebbbaabd27a8af780d1a130979cf5f237fd3d', '[\"*\"]', '2026-06-14 17:36:43', NULL, '2026-06-14 17:36:43', '2026-06-14 17:36:43'),
(122, 'App\\Models\\User', 29, 'api-token', '411ac83e3edea1747ba6acfaa16c4bcf261270b3707e37b1c16c7e88f54cc02c', '[\"*\"]', '2026-06-14 18:22:07', NULL, '2026-06-14 18:02:13', '2026-06-14 18:22:07'),
(123, 'App\\Models\\User', 29, 'api-token', '6e6765c0c7ed442f287cbfdcfb820c424c646017db8bd8f9dd52998b635cf69a', '[\"*\"]', '2026-06-16 15:15:44', NULL, '2026-06-14 18:58:55', '2026-06-16 15:15:44');

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

--
-- Dumping data for table `scans`
--

INSERT INTO `scans` (`id`, `user_id`, `scan_type`, `total_images`, `status`, `completed_at`, `created_at`, `updated_at`) VALUES
(42, 29, 'ai_detection', 1, 'completed', '2026-04-22 22:12:09', '2026-04-22 22:12:05', '2026-04-22 22:12:09'),
(43, 16, 'ai_detection', 1, 'completed', '2026-04-24 16:48:55', '2026-04-24 16:48:50', '2026-04-24 16:48:55'),
(44, 16, 'ai_detection', 1, 'completed', '2026-04-24 16:51:07', '2026-04-24 16:51:07', '2026-04-24 16:51:07'),
(45, 16, 'ai_detection', 1, 'completed', '2026-04-24 16:52:43', '2026-04-24 16:52:42', '2026-04-24 16:52:43'),
(46, 16, 'ai_detection', 1, 'completed', '2026-04-24 16:55:48', '2026-04-24 16:55:46', '2026-04-24 16:55:48'),
(47, 16, 'ai_detection', 1, 'completed', '2026-04-25 13:02:10', '2026-04-25 13:02:05', '2026-04-25 13:02:10'),
(48, 16, 'ai_detection', 1, 'completed', '2026-04-25 14:16:43', '2026-04-25 14:16:42', '2026-04-25 14:16:43'),
(49, 16, 'ai_detection', 1, 'completed', '2026-04-25 18:22:47', '2026-04-25 18:22:46', '2026-04-25 18:22:47'),
(50, 16, 'ai_detection', 1, 'completed', '2026-04-25 19:21:52', '2026-04-25 19:21:51', '2026-04-25 19:21:52'),
(51, 16, 'ai_detection', 1, 'completed', '2026-04-25 19:24:28', '2026-04-25 19:24:27', '2026-04-25 19:24:28'),
(52, 16, 'ai_detection', 1, 'pinding', '2026-04-25 19:56:15', '2026-04-25 19:56:14', '2026-04-25 19:56:15'),
(53, 16, 'ai_detection', 1, 'completed', '2026-04-25 20:05:31', '2026-04-25 20:05:30', '2026-04-25 20:05:31'),
(54, 29, 'ai_detection', 1, 'completed', '2026-04-25 21:12:44', '2026-04-25 21:12:43', '2026-04-25 21:12:44'),
(55, 16, 'ai_detection', 1, 'completed', '2026-04-25 22:16:29', '2026-04-25 22:16:27', '2026-04-25 22:16:29'),
(56, 16, 'ai_detection', 1, 'completed', '2026-04-25 23:01:40', '2026-04-25 23:01:40', '2026-04-25 23:01:40'),
(57, 16, 'ai_detection', 1, 'completed', '2026-04-26 11:57:29', '2026-04-26 11:57:25', '2026-04-26 11:57:29'),
(58, 44, 'surface', 0, 'completed', '2026-04-26 13:16:04', '2026-04-26 13:16:04', '2026-04-26 13:16:04'),
(59, 29, 'ai_detection', 1, 'completed', '2026-04-26 13:52:13', '2026-04-26 13:52:11', '2026-04-26 13:52:13'),
(60, 16, 'ai_detection', 1, 'completed', '2026-04-26 14:49:25', '2026-04-26 14:49:24', '2026-04-26 14:49:25'),
(61, 16, 'ai_detection', 1, 'completed', '2026-04-26 15:00:54', '2026-04-26 15:00:54', '2026-04-26 15:00:54'),
(62, 37, 'ai_detection', 1, 'completed', '2026-04-26 15:01:07', '2026-04-26 15:01:06', '2026-04-26 15:01:07'),
(63, 37, 'ai_detection', 1, 'completed', '2026-04-26 21:59:13', '2026-04-26 21:59:10', '2026-04-26 21:59:13'),
(64, 29, 'ai_detection', 1, 'completed', '2026-04-26 22:55:33', '2026-04-26 22:55:32', '2026-04-26 22:55:33'),
(65, 29, 'ai_detection', 2, 'completed', '2026-04-26 22:55:59', '2026-04-26 22:55:58', '2026-04-26 22:55:59'),
(66, 29, 'ai_detection', 1, 'completed', '2026-04-26 22:58:17', '2026-04-26 22:58:16', '2026-04-26 22:58:17'),
(67, 37, 'ai_detection', 1, 'completed', '2026-04-26 23:01:01', '2026-04-26 23:01:01', '2026-04-26 23:01:01'),
(68, 37, 'ai_detection', 1, 'completed', '2026-04-26 23:03:30', '2026-04-26 23:03:30', '2026-04-26 23:03:30'),
(69, 29, 'ai_detection', 1, 'completed', '2026-04-26 23:05:06', '2026-04-26 23:05:05', '2026-04-26 23:05:06'),
(70, 29, 'ai_detection', 1, 'completed', '2026-04-26 23:05:24', '2026-04-26 23:05:24', '2026-04-26 23:05:24'),
(71, 29, 'ai_detection', 1, 'completed', '2026-04-26 23:05:59', '2026-04-26 23:05:58', '2026-04-26 23:05:59'),
(72, 29, 'ai_detection', 1, 'completed', '2026-04-26 23:06:32', '2026-04-26 23:06:31', '2026-04-26 23:06:32'),
(73, 29, 'ai_detection', 1, 'completed', '2026-04-26 23:13:19', '2026-04-26 23:13:18', '2026-04-26 23:13:19'),
(74, 29, 'ai_detection', 1, 'completed', '2026-04-26 23:13:20', '2026-04-26 23:13:19', '2026-04-26 23:13:20'),
(75, 29, 'ai_detection', 1, 'completed', '2026-04-26 23:21:58', '2026-04-26 23:21:57', '2026-04-26 23:21:58'),
(76, 29, 'ai_detection', 1, 'completed', '2026-04-26 23:45:57', '2026-04-26 23:45:57', '2026-04-26 23:45:57'),
(77, 29, 'ai_detection', 1, 'completed', '2026-04-27 00:23:47', '2026-04-27 00:23:45', '2026-04-27 00:23:47'),
(78, 29, 'ai_detection', 1, 'completed', '2026-04-27 00:23:47', '2026-04-27 00:23:45', '2026-04-27 00:23:47'),
(79, 29, 'ai_detection', 1, 'completed', '2026-04-27 00:48:00', '2026-04-27 00:48:00', '2026-04-27 00:48:00'),
(80, 29, 'ai_detection', 1, 'completed', '2026-04-27 04:11:53', '2026-04-27 04:11:52', '2026-04-27 04:11:53'),
(81, 29, 'ai_detection', 1, 'completed', '2026-04-27 04:16:30', '2026-04-27 04:16:29', '2026-04-27 04:16:30'),
(82, 29, 'ai_detection', 1, 'completed', '2026-04-27 04:18:56', '2026-04-27 04:18:55', '2026-04-27 04:18:56'),
(83, 29, 'ai_detection', 1, 'completed', '2026-04-27 05:25:24', '2026-04-27 05:25:23', '2026-04-27 05:25:24'),
(84, 29, 'ai_detection', 1, 'completed', '2026-04-27 05:27:17', '2026-04-27 05:27:13', '2026-04-27 05:27:17'),
(85, 29, 'ai_detection', 1, 'completed', '2026-04-27 05:29:03', '2026-04-27 05:29:01', '2026-04-27 05:29:03'),
(86, 29, 'ai_detection', 1, 'completed', '2026-04-27 05:40:03', '2026-04-27 05:40:03', '2026-04-27 05:40:03'),
(87, 29, 'ai_detection', 1, 'completed', '2026-04-27 05:43:32', '2026-04-27 05:43:32', '2026-04-27 05:43:32'),
(88, 29, 'ai_detection', 1, 'completed', '2026-04-27 05:45:01', '2026-04-27 05:45:01', '2026-04-27 05:45:01'),
(89, 29, 'ai_detection', 1, 'completed', '2026-04-28 19:38:15', '2026-04-28 19:38:08', '2026-04-28 19:38:15'),
(90, 29, 'ai_detection', 1, 'completed', '2026-05-07 13:50:26', '2026-05-07 13:50:20', '2026-05-07 13:50:26'),
(91, 16, 'ai_detection', 1, 'completed', '2026-05-07 13:53:57', '2026-05-07 13:53:55', '2026-05-07 13:53:57'),
(92, 16, 'ai_detection', 1, 'completed', '2026-05-07 13:58:07', '2026-05-07 13:58:05', '2026-05-07 13:58:07'),
(93, 16, 'ai_detection', 1, 'completed', '2026-05-07 13:58:33', '2026-05-07 13:58:31', '2026-05-07 13:58:33'),
(94, 16, 'ai_detection', 1, 'completed', '2026-05-07 13:58:46', '2026-05-07 13:58:46', '2026-05-07 13:58:46'),
(95, 16, 'ai_detection', 1, 'completed', '2026-05-07 14:31:19', '2026-05-07 14:31:19', '2026-05-07 14:31:19'),
(96, 29, 'ai_detection', 1, 'completed', '2026-05-13 23:50:29', '2026-05-13 23:50:23', '2026-05-13 23:50:29'),
(97, 29, 'ai_detection', 1, 'completed', '2026-05-16 22:57:59', '2026-05-16 22:57:51', '2026-05-16 22:57:59'),
(101, 29, 'ai_detection', 1, 'completed', '2026-06-14 16:24:06', '2026-06-14 16:23:56', '2026-06-14 16:24:06'),
(102, 29, 'ai_detection', 0, 'processing', NULL, '2026-06-17 16:01:11', '2026-06-17 16:01:11'),
(103, 29, 'ai_detection', 1, 'completed', '2026-06-17 16:02:56', '2026-06-17 16:02:32', '2026-06-17 16:02:56'),
(104, 29, 'ai_detection', 1, 'completed', '2026-06-17 16:04:38', '2026-06-17 16:04:37', '2026-06-17 16:04:38'),
(105, 29, 'ai_detection', 1, 'completed', '2026-06-17 16:24:08', '2026-06-17 16:24:08', '2026-06-17 16:24:08');

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

--
-- Dumping data for table `scan_statistics`
--

INSERT INTO `scan_statistics` (`id`, `scan_id`, `total_defects`, `passed_count`, `defect_count`, `accuracy`, `processing_time`, `created_at`, `updated_at`) VALUES
(40, 42, 1, 0, 1, 0.00, 0, '2026-04-22 22:12:09', '2026-04-22 22:12:09'),
(41, 43, 3, 0, 2, 0.00, 0, '2026-04-24 16:48:55', '2026-04-24 16:48:55'),
(42, 44, 1, 0, 1, 0.00, 0, '2026-04-24 16:51:07', '2026-04-24 16:51:07'),
(43, 45, 1, 0, 2, 0.00, 0, '2026-04-24 16:52:43', '2026-04-24 16:52:43'),
(44, 46, 1, 0, 1, 0.00, 0, '2026-04-24 16:55:48', '2026-04-24 16:55:48'),
(45, 47, 1, 0, 1, 0.00, 0, '2026-04-25 13:02:10', '2026-04-25 13:02:10'),
(46, 48, 1, 0, 1, 0.00, 0, '2026-04-25 14:16:43', '2026-04-25 14:16:43'),
(47, 49, 1, 0, 1, 0.00, 0, '2026-04-25 18:22:47', '2026-04-25 18:22:47'),
(48, 50, 1, 0, 1, 0.00, 0, '2026-04-25 19:21:52', '2026-04-25 19:21:52'),
(49, 51, 1, 0, 1, 0.00, 0, '2026-04-25 19:24:28', '2026-04-25 19:24:28'),
(50, 52, 1, 0, 3, 0.00, 0, '2026-04-25 19:56:15', '2026-04-25 19:56:15'),
(51, 53, 1, 0, 1, 0.00, 0, '2026-04-25 20:05:31', '2026-04-25 20:05:31'),
(52, 54, 2, 0, 1, 0.00, 0, '2026-04-25 21:12:44', '2026-04-25 21:12:44'),
(53, 55, 1, 0, 1, 0.00, 0, '2026-04-25 22:16:29', '2026-04-25 22:16:29'),
(54, 56, 1, 0, 1, 0.00, 0, '2026-04-25 23:01:40', '2026-04-25 23:01:40'),
(55, 57, 1, 0, 1, 0.00, 0, '2026-04-26 11:57:29', '2026-04-26 11:57:29'),
(56, 58, 0, 0, 0, 50.00, 117, '2026-04-26 13:16:04', '2026-04-26 13:16:16'),
(57, 59, 1, 0, 1, 0.00, 0, '2026-04-26 13:52:13', '2026-04-26 13:52:13'),
(58, 60, 1, 0, 1, 0.00, 0, '2026-04-26 14:49:25', '2026-04-26 14:49:25'),
(59, 61, 1, 0, 1, 0.00, 0, '2026-04-26 15:00:54', '2026-04-26 15:00:54'),
(60, 62, 1, 0, 1, 0.00, 0, '2026-04-26 15:01:07', '2026-04-26 15:01:07'),
(61, 63, 1, 0, 1, 0.00, 0, '2026-04-26 21:59:13', '2026-04-26 21:59:13'),
(62, 64, 1, 0, 1, 0.00, 0, '2026-04-26 22:55:33', '2026-04-26 22:55:33'),
(63, 65, 1, 3, 1, 0.00, 0, '2026-04-26 22:55:59', '2026-04-26 22:55:59'),
(64, 66, 4, 0, 2, 0.00, 0, '2026-04-26 22:58:17', '2026-04-26 22:58:17'),
(65, 67, 1, 0, 1, 0.00, 0, '2026-04-26 23:01:01', '2026-04-26 23:01:01'),
(66, 68, 1, 0, 1, 0.00, 0, '2026-04-26 23:03:30', '2026-04-26 23:03:30'),
(67, 69, 1, 0, 1, 0.00, 0, '2026-04-26 23:05:06', '2026-04-26 23:05:06'),
(68, 70, 1, 0, 1, 0.00, 0, '2026-04-26 23:05:24', '2026-04-26 23:05:24'),
(69, 71, 1, 0, 1, 0.00, 0, '2026-04-26 23:05:59', '2026-04-26 23:05:59'),
(70, 72, 1, 0, 1, 0.00, 0, '2026-04-26 23:06:32', '2026-04-26 23:06:32'),
(71, 73, 1, 0, 1, 0.00, 0, '2026-04-26 23:13:19', '2026-04-26 23:13:19'),
(72, 74, 1, 0, 1, 0.00, 0, '2026-04-26 23:13:20', '2026-04-26 23:13:20'),
(73, 75, 1, 0, 1, 0.00, 0, '2026-04-26 23:21:58', '2026-04-26 23:21:58'),
(74, 76, 1, 0, 1, 0.00, 0, '2026-04-26 23:45:57', '2026-04-26 23:45:57'),
(75, 77, 1, 0, 1, 0.00, 0, '2026-04-27 00:23:47', '2026-04-27 00:23:47'),
(76, 78, 1, 0, 1, 0.00, 0, '2026-04-27 00:23:47', '2026-04-27 00:23:47'),
(77, 79, 1, 0, 1, 0.00, 0, '2026-04-27 00:48:00', '2026-04-27 00:48:00'),
(78, 80, 1, 0, 1, 97.26, 0, '2026-04-27 04:11:53', '2026-04-27 04:11:53'),
(79, 81, 1, 0, 1, 90.59, 0, '2026-04-27 04:16:30', '2026-04-27 04:16:30'),
(80, 82, 1, 0, 1, 90.59, 0, '2026-04-27 04:18:56', '2026-04-27 04:18:56'),
(81, 83, 1, 0, 1, 93.03, 0, '2026-04-27 05:25:24', '2026-04-27 05:25:24'),
(82, 84, 1, 0, 1, 96.77, 0, '2026-04-27 05:27:17', '2026-04-27 05:27:17'),
(83, 85, 1, 0, 1, 95.92, 0, '2026-04-27 05:29:03', '2026-04-27 05:29:03'),
(84, 86, 1, 0, 1, 98.03, 0, '2026-04-27 05:40:03', '2026-04-27 05:40:03'),
(85, 87, 1, 0, 1, 98.03, 0, '2026-04-27 05:43:32', '2026-04-27 05:43:32'),
(86, 88, 1, 0, 1, 98.03, 0, '2026-04-27 05:45:01', '2026-04-27 05:45:01'),
(87, 89, 1, 0, 1, 88.95, 0, '2026-04-28 19:38:15', '2026-04-28 19:38:15'),
(88, 90, 1, 0, 1, 64.92, 0, '2026-05-07 13:50:26', '2026-05-07 13:50:26'),
(89, 91, 1, 0, 1, 95.06, 0, '2026-05-07 13:53:57', '2026-05-07 13:53:57'),
(90, 92, 1, 0, 1, 82.83, 0, '2026-05-07 13:58:07', '2026-05-07 13:58:07'),
(91, 93, 1, 0, 1, 96.82, 0, '2026-05-07 13:58:33', '2026-05-07 13:58:33'),
(92, 94, 1, 0, 1, 96.78, 0, '2026-05-07 13:58:46', '2026-05-07 13:58:46'),
(93, 95, 1, 0, 1, 96.78, 0, '2026-05-07 14:31:19', '2026-05-07 14:31:19'),
(94, 96, 1, 0, 1, 53.93, 0, '2026-05-13 23:50:29', '2026-05-13 23:50:29'),
(95, 97, 1, 0, 1, 83.01, 0, '2026-05-16 22:57:59', '2026-05-16 22:57:59'),
(99, 101, 1, 0, 1, 96.72, 0, '2026-06-14 16:24:06', '2026-06-14 16:24:06'),
(100, 103, 1, 0, 1, 96.82, 0, '2026-06-17 16:02:56', '2026-06-17 16:02:56'),
(101, 104, 1, 0, 1, 89.73, 0, '2026-06-17 16:04:38', '2026-06-17 16:04:38'),
(102, 105, 1, 0, 1, 88.93, 0, '2026-06-17 16:24:08', '2026-06-17 16:24:08');

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
('8ybvFHeGMpSeFFGIk2o8HuxBWAo0ExSSOJyA3raj', NULL, '102.42.78.80', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNEdjMGFyWUxiTllyQjV5VVRJZ2Z5MUVSN3J5cUVrV2FtdWU1MlFhQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbGlnaHRncmVlbi1jcmFuZS0xMTY3MDMuaG9zdGluZ2Vyc2l0ZS5jb20iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1777251158),
('GbHOp585jsLfXczOtFNFBFmE3pT8neRFkNZPefld', NULL, '46.17.174.173', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:98.0) Gecko/20100101 Firefox/98.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHhKY1lpajZFZ2hXdkpRNjBLRGFNeVV3YVZZRTA3N2RtS2dZYXJCUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbGlnaHRncmVlbi1jcmFuZS0xMTY3MDMuaG9zdGluZ2Vyc2l0ZS5jb20iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1778854464),
('Gvwv5D6CUXw1YlyQNlDgv4RebkBLhN5hnwweduLE', NULL, '41.46.146.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ29Zb1p4M1I3WVBGZXJhU2Q1MEY5TE1kMWJuTVlQUHpiaEd0TXRVbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbGlnaHRncmVlbi1jcmFuZS0xMTY3MDMuaG9zdGluZ2Vyc2l0ZS5jb20iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1778594318),
('pMQKPvLhBImIAHgKuyqyOkaziL3bZW5PXSXp73me', NULL, '46.17.174.173', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:98.0) Gecko/20100101 Firefox/98.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibHFaeWJZaGhFQ1ZNVE5iU25Gd1RYT1kwZk1VWENWWEd6U1hGQmJBayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbGlnaHRncmVlbi1jcmFuZS0xMTY3MDMuaG9zdGluZ2Vyc2l0ZS5jb20iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1777515336),
('Xx3dM4crvROx9SJ6TVav29X9ARY6dRTVW9oCbRnc', NULL, '102.42.78.80', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNGVzTTdIRDZDQ1JLZnR6dlI5NkxOWG1KZUNTT0VEUGtHY3F6Yzc5ZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDk6Imh0dHBzOi8vbGlnaHRncmVlbi1jcmFuZS0xMTY3MDMuaG9zdGluZ2Vyc2l0ZS5jb20iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1777213598);

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
(16, 'Mohsen', 'mohsenhesham.110@gmail.com', '01100959301', '$2y$12$oMAiLnGjderT35GfhKlFtu3w3yV/Mr0ZB8eE3j7LJSE1ENAwECcmS', 'avatars/aKjPP7ebZmqutUMn9DlRv8L4LxsLk5iK2dljOAOz.png', '2026-02-28 22:21:55', NULL, 'active', 'admin', '2026-02-23 00:23:54', '2026-06-14 16:43:01'),
(26, 'mohsen', 'mohsen.131123@gmail.com', '0114442424', 'mohsen123', NULL, NULL, NULL, 'active', 'user', '2026-03-01 15:45:45', '2026-03-01 15:45:45'),
(27, 'Test User', 'test_1776525221@example.com', '01196701268', '$2y$12$v4x1RZhpYJ9/ySufZBkdCu8Fm/OZEiEqqxhGSOoPEomCOSUGupofm', NULL, '2026-04-18 13:13:46', NULL, 'active', 'user', '2026-04-18 13:13:42', '2026-04-18 13:13:46'),
(28, 'mohsen99', 'mohsen.99@gmail.com', '0114442299', '$2y$12$K8sFRvGKnVhy6.kAh6eWMeVQdd0CLr/e1V9Gg7Nwt32CMMrrKibUK', 'avatars/r07IUZfxrlPwbEbelfQKSr8iaFGwN4Z1ZeVgkkAI.jpg', NULL, NULL, 'active', 'user', '2026-04-19 03:20:36', '2026-04-26 14:57:23'),
(29, 'mostafa hassan saad', 'mostafahassansaadeldeen@gmail.com', '01008838221', '$2y$12$sApzUOcLFC4KkI1Aok6ld.ieTMgDci53YKS0KBQqxvY0KyIuKh1Ja', 'avatars/iwX1bWZ9qO03KtHyFJyvTsvmksOTbRmtKJsj7RZj.png', NULL, NULL, 'active', 'user', '2026-04-21 15:44:01', '2026-04-27 04:40:25'),
(30, 'mostafa hassan', 'mh910666@gmail.com', '01008838220', '$2y$12$5DufH/UtEQOF9M.Lw6ellO5QjZ6qC06lHAWcO7AjWypbpMQ8XI4Lu', NULL, '2026-04-21 20:59:44', NULL, 'active', 'user', '2026-04-21 19:03:35', '2026-04-21 20:59:44'),
(37, 'ahmed', 'ahmaed@gmail.com', '01123123', '$2y$12$vdohh2FNFwsMVMfAkM/DXeQBbbu4nHekXhIdFOL3PZFXWU1bUZ6H.', 'avatars/WtwOoqfl9QekG23t9pi5snpcVch6gnYKBjmEqeD5.jpg', NULL, NULL, 'active', 'user', '2026-04-25 23:08:06', '2026-04-26 23:12:52'),
(38, 'marina mossa', 'marinamossa70@gmail.com', '01223328002', '$2y$12$y1UPYQqZyoUpSdkO89YJxeHMl5V48P9DpiPqZBWdjobAPb4ngDPdG', NULL, NULL, NULL, 'active', 'user', '2026-04-26 01:17:44', '2026-04-26 01:17:44'),
(39, 'mohsen hesham', 'mohsen@gmail.com', '01100949328', '$2y$12$DnOJabLBA9hIogtXb3NcAeZOlGSKxiIxbDqIUsiOZS0L6oaAz/.1m', NULL, NULL, NULL, 'active', 'user', '2026-04-26 11:53:13', '2026-04-26 11:53:13'),
(40, 'Hostinger Check', 'hostinger_check_1777209093@example.com', '01875065745', '$2y$12$slXz0udqOqTWNqkDIzaBt.1dNTsKx8HKRwYkR1q5OrBUQVht40.nG', NULL, NULL, NULL, 'active', 'user', '2026-04-26 13:11:33', '2026-04-26 13:11:33'),
(41, 'Hostinger Check', 'hostinger_check_1777209123@example.com', '01856234612', '$2y$12$xzoslYFvjubcVlLDGPLoSeOo1S9ltH/1SkNU6tVtAWsHaNbSRMFTS', NULL, NULL, NULL, 'active', 'user', '2026-04-26 13:12:03', '2026-04-26 13:12:03'),
(42, 'Hostinger Check', 'hostinger_check_1777209148@example.com', '01703887177', '$2y$12$bLADIDIvJSPIAKstH6GsH.Y.i9UE33Gl66J70BGBvRJyhtDhEAIiW', NULL, NULL, NULL, 'active', 'user', '2026-04-26 13:12:28', '2026-04-26 13:12:28'),
(43, 'Quick Test', 'quick_1777209183@example.com', '01577421351', '$2y$12$iUzTrZrdOLl9B23e8uaDVu9iSzCQR0yL39KO4B0p.ODdjSIukto4W', NULL, NULL, NULL, 'active', 'user', '2026-04-26 13:13:03', '2026-04-26 13:13:03'),
(44, 'Self Update', 'hostinger_check_1777209349@example.com', '01904574532', '$2y$12$3EppfuKtwYqzciiLjd4Zo.2qZ/gAfkD1gTVIJvhDE0FIHewwMOLR2', NULL, '2026-04-26 13:15:52', '2026-04-26 13:15:54', 'active', 'user', '2026-04-26 13:15:49', '2026-04-26 13:16:02'),
(45, 'ahmed', 'ahmaed123@gmail.com', '01123123123', '$2y$12$yMXQYTF1gErZf266BkMhuuRo.1/uPtYktO4hJu0pYoU0Dlrkw.k0a', 'avatars/Y769PlX1K8ihWAVJTZpByjnW7mlxDHOZ9vmjdMlW.jpg', NULL, NULL, 'active', 'user', '2026-04-26 23:26:53', '2026-04-26 23:28:28'),
(46, 'mohsenhesham', '11mohsen@gmail.com', '011231231233', '$2y$12$RiHZToQZ1pOVvt5McTDzv.MaFB8ww/qjU82TR4yC1o6i3XlobDr9.', 'avatars/x3ub1NQcpKm18t8tlqgkRpocYRb9Zcxe13Y08VDB.png', NULL, NULL, 'active', 'user', '2026-04-26 23:47:12', '2026-04-27 04:30:13');

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
(11, 16, 'en', 'light', 1, 1, '2026-02-23 00:23:55', '2026-04-22 17:49:20'),
(21, 26, 'en', 'light', 1, 1, '2026-03-01 15:45:45', '2026-03-01 15:45:45'),
(22, 27, 'en', 'light', 1, 1, '2026-04-18 13:13:43', '2026-04-18 13:13:43'),
(23, 28, 'en', 'light', 1, 1, '2026-04-19 03:20:36', '2026-04-19 03:20:36'),
(24, 29, 'en', 'light', 1, 1, '2026-04-21 15:44:01', '2026-04-21 15:44:01'),
(25, 30, 'en', 'light', 1, 1, '2026-04-21 19:03:35', '2026-04-21 19:03:35'),
(32, 37, 'en', 'light', 1, 1, '2026-04-25 23:08:06', '2026-04-25 23:08:06'),
(33, 38, 'en', 'light', 1, 1, '2026-04-26 01:17:44', '2026-04-26 01:17:44'),
(34, 39, 'en', 'light', 1, 1, '2026-04-26 11:53:13', '2026-04-26 11:53:13'),
(35, 40, 'en', 'light', 1, 1, '2026-04-26 13:11:33', '2026-04-26 13:11:33'),
(36, 41, 'en', 'light', 1, 1, '2026-04-26 13:12:03', '2026-04-26 13:12:03'),
(37, 42, 'en', 'light', 1, 1, '2026-04-26 13:12:28', '2026-04-26 13:12:28'),
(38, 43, 'en', 'light', 1, 1, '2026-04-26 13:13:03', '2026-04-26 13:13:03'),
(39, 44, 'en', 'light', 1, 1, '2026-04-26 13:15:49', '2026-04-26 13:15:49'),
(40, 45, 'en', 'light', 1, 1, '2026-04-26 23:26:53', '2026-04-26 23:26:53'),
(41, 46, 'en', 'light', 1, 1, '2026-04-26 23:47:12', '2026-04-26 23:47:12');

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `defect_categories`
--
ALTER TABLE `defect_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `image_defects`
--
ALTER TABLE `image_defects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `scans`
--
ALTER TABLE `scans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `scan_statistics`
--
ALTER TABLE `scan_statistics`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `user_settings`
--
ALTER TABLE `user_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

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
