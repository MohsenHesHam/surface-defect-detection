<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'postmark' => [
        'key' => env('POSTMARK_API_KEY'),
    ],

    'resend' => [
        'key' => env('RESEND_API_KEY'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],

    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel' => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],

    'ai_detection' => [
        'base_url' => env('FASTAPI_URL', 'http://localhost:8001'),
        'timeout' => (int) env('FASTAPI_TIMEOUT', 30),
        'class_map' => [
            'cr' => [
                'name' => 'crazing',
                'description' => 'Fine network of surface cracks',
                'severity_level' => 'high',
            ],
            'in' => [
                'name' => 'inclusion',
                'description' => 'Foreign material inside the metal',
                'severity_level' => 'medium',
            ],
            'pa' => [
                'name' => 'patches',
                'description' => 'Irregular patches or discoloration',
                'severity_level' => 'medium',
            ],
            'pi' => [
                'name' => 'pitted',
                'description' => 'Small pits or holes on the surface',
                'severity_level' => 'low',
            ],
            'ro' => [
                'name' => 'rolled',
                'description' => 'Surface marks from rolling process',
                'severity_level' => 'low',
            ],
            'sc' => [
                'name' => 'scratches',
                'description' => 'Surface scratches on steel surface',
                'severity_level' => 'medium',
            ],
        ],
    ],

];
