<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('theme', 20)->default('light')->after('avatar');
        });

        if (Schema::hasTable('user_settings') && Schema::hasColumn('user_settings', 'theme')) {
            $settings = \Illuminate\Support\Facades\DB::table('user_settings')
                ->select('user_id', 'theme')
                ->whereNotNull('theme')
                ->get();

            foreach ($settings as $setting) {
                \Illuminate\Support\Facades\DB::table('users')
                    ->where('id', $setting->user_id)
                    ->update(['theme' => $setting->theme ?: 'light']);
            }
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('theme');
        });
    }
};
