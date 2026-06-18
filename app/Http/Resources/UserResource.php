<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * We store only the relative avatar path in the database.
     * The API always returns the full public URL for Flutter clients.
     */
    public function toArray(Request $request): array
    {
        $avatarPath = $this->avatar;
        $avatarUrl = null;

        if ($avatarPath) {
            // If avatar path is a full URL already, use it
            if (str_starts_with($avatarPath, 'http')) {
                $avatarUrl = $avatarPath;
            } else {
                // Otherwise, use Storage::url which handles the full path from config
                $avatarUrl = \Illuminate\Support\Facades\Storage::disk('public')->url($avatarPath);
            }
        }

        return [
            'id' => $this->id,
            'name' => $this->full_name,
            'full_name' => $this->full_name,
            'email' => $this->email,
            'phone' => $this->phone,
            'avatar' => $avatarUrl,
            'role' => $this->role ?? 'user',
            'account_status' => $this->account_status ?? 'active',
            'is_online' => $this->is_online ?? false,
            'last_seen_at' => $this->last_seen_at,
            'is_email_verified' => !is_null($this->email_verified_at),
            'email_verified_at' => $this->email_verified_at,
            'is_phone_verified' => !is_null($this->phone_verified_at),
            'phone_verified_at' => $this->phone_verified_at,
            'theme' => $this->theme ?? 'light',
            'today_scans' => $this->scans()->whereDate('created_at', today())->count(),
            'total_scans' => $this->scans()->count(),
        ];
    }
}

