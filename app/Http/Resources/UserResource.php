<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

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

        return [
            'id' => $this->id,
            'name' => $this->full_name,
            'full_name' => $this->full_name,
            'email' => $this->email,
            'phone' => $this->phone,
            'avatar' => $avatarPath ? Storage::disk('public')->url($avatarPath) : null,
            'theme' => $this->theme ?? 'light',
        ];
    }
}
