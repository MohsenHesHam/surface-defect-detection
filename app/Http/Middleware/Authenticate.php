<?php

namespace App\Http\Middleware;

use Illuminate\Auth\Middleware\Authenticate as Middleware;

class Authenticate extends Middleware
{
    /**
     * Get the path the user should be redirected to when they are not authenticated.
     */
    protected function redirectTo($request)
    {
        // For API requests (or when client expects JSON), do not return
        // a redirect path. Returning null causes a 401 JSON response.
        if ($request->expectsJson() || $request->is('api/*')) {
            return null;
        }

        // Fallback to web login route if it exists; otherwise return null.
        if (function_exists('route')) {
            try {
                return route('login');
            } catch (\Throwable $e) {
                return null;
            }
        }

        return null;
    }
}
