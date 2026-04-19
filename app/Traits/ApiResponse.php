<?php

namespace App\Traits;

trait ApiResponse
{
    /**
     * Return a success response
     */
    public function successResponse($data = null, $message = 'Operation successful', $statusCode = 200)
    {
        return response()->json([
            'status' => true,
            'success' => true,
            'message' => $message,
            'data' => $data,
        ], $statusCode);
    }

    /**
     * Return a list response (array of items)
     */
    public function listResponse($items, $message = 'Items retrieved successfully', $statusCode = 200)
    {
        return response()->json([
            'status' => true,
            'success' => true,
            'message' => $message,
            'data' => $items,
        ], $statusCode);
    }

    /**
     * Return an error response
     */
    public function errorResponse($message = 'An error occurred', $statusCode = 400, $errors = null)
    {
        return response()->json([
            'status' => false,
            'success' => false,
            'message' => $message,
            'errors' => $errors,
        ], $statusCode);
    }

    /**
     * Return a paginated response
     */
    public function paginatedResponse($items, $message = 'Items retrieved successfully', $statusCode = 200)
    {
        return response()->json([
            'status' => true,
            'success' => true,
            'message' => $message,
            'data' => $items->items(),
            'pagination' => [
                'total' => $items->total(),
                'per_page' => $items->perPage(),
                'current_page' => $items->currentPage(),
                'last_page' => $items->lastPage(),
                'from' => $items->firstItem(),
                'to' => $items->lastItem(),
            ],
        ], $statusCode);
    }
}
