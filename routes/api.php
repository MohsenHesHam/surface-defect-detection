<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ActivityController;
use App\Http\Controllers\DefectCategoryController;
use App\Http\Controllers\ScanController;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\ImageDefectController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\ScanStatisticController;
use App\Http\Controllers\UserSettingController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Authentication routes (public)
Route::group(['prefix' => 'auth'], function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/send-email-verification', [AuthController::class, 'sendEmailVerification']);
    Route::post('/verify-email', [AuthController::class, 'verifyEmail']);
    Route::post('/send-phone-verification', [AuthController::class, 'sendPhoneVerification']);
    Route::post('/verify-phone', [AuthController::class, 'verifyPhone']);
    Route::post('/resend-code', [AuthController::class, 'resendCode']);
    Route::post('/send-password-reset', [AuthController::class, 'sendPasswordResetCode']);
    Route::post('/verify-password-reset', [AuthController::class, 'verifyPasswordResetCode']);
    Route::post('/reset-password', [AuthController::class, 'resetPassword']);
});

// Protected routes (require authentication)
Route::middleware('auth:sanctum')->group(function () {
    // Auth routes
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/me', [AuthController::class, 'me']);

    // User routes
    Route::prefix('users')->group(function () {
        Route::get('/', [UserController::class, 'index']);
        Route::post('/', [UserController::class, 'store']);
        Route::get('/{user}', [UserController::class, 'show']);
        Route::put('/{user}', [UserController::class, 'update']);
        Route::delete('/{user}', [UserController::class, 'destroy']);
        Route::post('/{user}/promote-to-admin', [UserController::class, 'promoteToAdmin']);
        Route::post('/{user}/demote-to-user', [UserController::class, 'demoteToUser']);
    });

    // Profile routes (current authenticated user)
    Route::get('/profile', [UserController::class, 'getProfile']);
    Route::put('/profile', [UserController::class, 'updateProfile']);
    Route::put('/profile/settings', [UserController::class, 'updateSettings']);

    // Activity routes
    Route::prefix('activities')->group(function () {
        Route::get('/', [ActivityController::class, 'index']);
        Route::post('/', [ActivityController::class, 'store']);
        Route::get('/{activity}', [ActivityController::class, 'show']);
        Route::put('/{activity}', [ActivityController::class, 'update']);
        Route::delete('/{activity}', [ActivityController::class, 'destroy']);
    });

    // Defect Category routes
    Route::prefix('defect-categories')->group(function () {
        Route::get('/', [DefectCategoryController::class, 'index']);
        Route::post('/', [DefectCategoryController::class, 'store']);
        Route::get('/{defectCategory}', [DefectCategoryController::class, 'show']);
        Route::put('/{defectCategory}', [DefectCategoryController::class, 'update']);
        Route::delete('/{defectCategory}', [DefectCategoryController::class, 'destroy']);
    });

    // Scan routes
    Route::prefix('scans')->group(function () {
        Route::get('/', [ScanController::class, 'index']);
        Route::post('/', [ScanController::class, 'store']);
        Route::get('/{scan}', [ScanController::class, 'show']);
        Route::put('/{scan}', [ScanController::class, 'update']);
        Route::delete('/{scan}', [ScanController::class, 'destroy']);
        Route::post('/detect-defect', [ScanController::class, 'detectDefect']);
    });

    // Image routes
    Route::prefix('images')->group(function () {
        Route::get('/', [ImageController::class, 'index']);
        Route::post('/', [ImageController::class, 'store']);
        Route::get('/{image}', [ImageController::class, 'show']);
        Route::put('/{image}', [ImageController::class, 'update']);
        Route::delete('/{image}', [ImageController::class, 'destroy']);
    });

    // Image Defect routes
    Route::prefix('image-defects')->group(function () {
        Route::get('/', [ImageDefectController::class, 'index']);
        Route::post('/', [ImageDefectController::class, 'store']);
        Route::get('/{imageDefect}', [ImageDefectController::class, 'show']);
        Route::put('/{imageDefect}', [ImageDefectController::class, 'update']);
        Route::delete('/{imageDefect}', [ImageDefectController::class, 'destroy']);
    });

    // Notification routes
    Route::prefix('notifications')->group(function () {
        Route::get('/', [NotificationController::class, 'index']);
        Route::post('/', [NotificationController::class, 'store']);
        Route::get('/{notification}', [NotificationController::class, 'show']);
        Route::put('/{notification}', [NotificationController::class, 'update']);
        Route::delete('/{notification}', [NotificationController::class, 'destroy']);
        Route::post('/{notification}/mark-as-read', [NotificationController::class, 'markAsRead']);
    });

    // Scan Statistics routes
    Route::prefix('scan-statistics')->group(function () {
        Route::get('/', [ScanStatisticController::class, 'index']);
        Route::post('/', [ScanStatisticController::class, 'store']);
        Route::get('/{scanStatistic}', [ScanStatisticController::class, 'show']);
        Route::put('/{scanStatistic}', [ScanStatisticController::class, 'update']);
        Route::delete('/{scanStatistic}', [ScanStatisticController::class, 'destroy']);
    });

    // User Settings routes
    Route::prefix('user-settings')->group(function () {
        Route::get('/', [UserSettingController::class, 'index']);
        Route::post('/', [UserSettingController::class, 'store']);
        Route::get('/{userSetting}', [UserSettingController::class, 'show']);
        Route::put('/{userSetting}', [UserSettingController::class, 'update']);
        Route::delete('/{userSetting}', [UserSettingController::class, 'destroy']);
    });

    // Current user info
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Analytics
    Route::get('/analytics/summary', [\App\Http\Controllers\AnalyticsController::class, 'summary']);
    Route::get('/analytics/report/{scanId?}', [\App\Http\Controllers\AnalyticsController::class, 'report']);
    Route::get('/analytics/history', [\App\Http\Controllers\AnalyticsController::class, 'history']);
});