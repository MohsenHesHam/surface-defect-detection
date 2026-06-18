# Complete API Documentation

## Base URL
```
https://domain.com/api
```

---

## Authentication Endpoints

### 1. Register User
**Endpoint:** `POST /auth/register`
**Auth:** Public
**Request Body:**
```json
{
  "full_name": "string",
  "email": "string",
  "phone": "string",
  "password": "string (min 8 chars)"
}
```
**Response (201):**
```json
{
  "status": true,
  "success": true,
  "message": "User registered successfully",
  "data": {
    "id": 29,
    "full_name": "mostafa hassan saad",
    "email": "mostafahassansaadeldeen@gmail.com",
    "phone": "01008838221",
    "avatar": "https://domain.com/storage/avatars/user_29.png"
  }
}
```

### 2. Login
**Endpoint:** `POST /auth/login`
**Auth:** Public
**Request Body:**
```json
{
  "email": "string",
  "password": "string"
}
```
**Response (200):**
```json
{
  "status": true,
  "success": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "token": "string"
  }
}
```

### 3. Logout
**Endpoint:** `POST /auth/logout`
**Auth:** Required (Bearer Token)
**Response (200):**
```json
{
  "status": true,
  "success": true,
  "message": "Logout successful"
}
```

### 4. Get Current User
**Endpoint:** `GET /auth/me`
**Auth:** Required
**Response (200):**
```json
{
  "status": true,
  "success": true,
  "message": "User retrieved successfully",
  "data": { ... user object ... }
}
```

### 5. Send Email Verification
**Endpoint:** `POST /auth/send-email-verification`
**Auth:** Public
**Request Body:**
```json
{
  "email": "string"
}
```
**Response (200):**
```json
{
  "status": true,
  "message": "Verification code sent to email"
}
```

### 6. Verify Email
**Endpoint:** `POST /auth/verify-email`
**Auth:** Public
**Request Body:**
```json
{
  "email": "string",
  "code": "string"
}
```
**Response (200):**
```json
{
  "status": true,
  "message": "Email verified successfully"
}
```

### 7. Send Phone Verification
**Endpoint:** `POST /auth/send-phone-verification`
**Auth:** Public
**Request Body:**
```json
{
  "phone": "string"
}
```

### 8. Verify Phone
**Endpoint:** `POST /auth/verify-phone`
**Auth:** Public
**Request Body:**
```json
{
  "phone": "string",
  "code": "string"
}
```

---

## User Profile Endpoints

### 1. Get User Profile
**Endpoint:** `GET /profile`
**Auth:** Required
**Response (200):**
```json
{
  "status": true,
  "success": true,
  "message": "User profile retrieved successfully",
  "data": {
    "id": 29,
    "full_name": "mostafa hassan saad",
    "email": "mostafahassansaadeldeen@gmail.com",
    "phone": "01008838221",
    "avatar": "https://domain.com/storage/avatars/user_29.png",
    "role": "user",
    "account_status": "active",
    "is_online": true,
    "last_seen_at": "2026-06-17T17:34:00.000000Z",
    "is_email_verified": true,
    "email_verified_at": "2026-04-21T14:00:00.000000Z",
    "is_phone_verified": false,
    "phone_verified_at": null,
    "theme": "light",
    "today_scans": 4,
    "total_scans": 35
  }
}
```

### 2. Update User Profile
**Endpoint:** `PUT /profile`
**Auth:** Required
**Request Body:**
```json
{
  "full_name": "string (optional)",
  "email": "string (optional)",
  "phone": "string (optional)",
  "theme": "light|dark (optional)"
}
```
**Response (200):** Same as Get Profile

### 3. Update User Settings
**Endpoint:** `PUT /profile/settings`
**Auth:** Required
**Request Body:**
```json
{
  "language": "string (optional)",
  "theme": "light|dark (optional)",
  "push_notifications": "boolean (optional)",
  "email_notifications": "boolean (optional)"
}
```
**Response (200):** User object with settings

### 4. Upload Avatar
**Endpoint:** `POST /upload-avatar`
**Auth:** Required
**Content-Type:** multipart/form-data
**Request Body:**
```
avatar: File (jpg, jpeg, png, max 2MB)
```
**Response (200):** User object with new avatar URL

---

## Scans Endpoints

### 1. List All Scans (Basic - No Images/Stats)
**Endpoint:** `GET /scans`
**Auth:** Required
**Query Parameters:**
- `page`: int (optional)
- `per_page`: int (optional, default 15)

**Response (200):**
```json
{
  "status": true,
  "success": true,
  "message": "Scans list retrieved successfully",
  "data": [
    {
      "id": 42,
      "user_id": 29,
      "scan_type": "ai_detection",
      "status": "completed",
      "total_images": 1,
      "completed_at": "2026-04-22T20:12:09.000000Z",
      "created_at": "2026-04-22T20:12:05.000000Z",
      "updated_at": "2026-04-22T20:12:09.000000Z"
    }
  ]
}
```

### 2. Get Specific Scan (Full Details)
**Endpoint:** `GET /scans/{scan_id}`
**Auth:** Required
**Response (200):**
```json
{
  "status": true,
  "success": true,
  "message": "Scan retrieved successfully",
  "data": {
    "id": 42,
    "user_id": 29,
    "scan_type": "ai_detection",
    "status": "completed",
    "total_images": 1,
    "completed_at": "2026-04-22T20:12:09.000000Z",
    "created_at": "2026-04-22T20:12:05.000000Z",
    "updated_at": "2026-04-22T20:12:09.000000Z",
    "user": { ... user object ... },
    "images": [ ... images array ... ],
    "statistics": { ... statistics object ... }
  }
}
```

### 3. Get Scan Images Only
**Endpoint:** `GET /scans/{scan_id}/images`
**Auth:** Required
**Response (200):**
```json
{
  "status": true,
  "success": true,
  "message": "Scan images retrieved successfully",
  "data": [
    {
      "id": 39,
      "scan_id": 42,
      "image_path": "https://domain.com/storage/images/original.jpg",
      "processed_image_path": "https://domain.com/storage/images/annotated.jpg",
      "file_size": 8002,
      "resolution": "200x200",
      "created_at": "2026-04-22T20:12:09.000000Z",
      "updated_at": "2026-04-22T20:12:09.000000Z"
    }
  ]
}
```

### 4. Get Scan Statistics Only
**Endpoint:** `GET /scans/{scan_id}/statistics`
**Auth:** Required
**Response (200):**
```json
{
  "status": true,
  "success": true,
  "message": "Scan statistics retrieved successfully",
  "data": {
    "id": 40,
    "scan_id": 42,
    "total_defects": 1,
    "passed_count": 0,
    "defect_count": 1,
    "accuracy": 0.98,
    "processing_time": 1450,
    "created_at": "2026-04-22T20:12:09.000000Z",
    "updated_at": "2026-04-22T20:12:09.000000Z"
  }
}
```

### 5. Create Scan
**Endpoint:** `POST /scans`
**Auth:** Required
**Request Body:**
```json
{
  "user_id": "integer (required)",
  "scan_type": "string (required)",
  "total_images": "integer (optional)"
}
```
**Response (201):** Scan object with all details

### 6. Update Scan
**Endpoint:** `PUT /scans/{scan_id}`
**Auth:** Required
**Request Body:**
```json
{
  "scan_type": "string (optional)",
  "status": "pending|processing|completed|failed (optional)",
  "completed_at": "datetime (optional)"
}
```
**Response (200):** Updated scan object

### 7. Delete Scan
**Endpoint:** `DELETE /scans/{scan_id}`
**Auth:** Required
**Response (204):** No content

### 8. Get Scan Flutter Report
**Endpoint:** `GET /scans/{scan_id}/flutter-report`
**Auth:** Required
**Response (200):**
```json
{
  "statistics": {
    "passedCount": 0,
    "defectCount": 1,
    "totalDefects": 1,
    "accuracy": 0.98,
    "successRate": 0.0
  },
  "scanData": [
    {
      "originalImagePath": "https://domain.com/storage/images/original.jpg",
      "processedImage": "https://domain.com/storage/images/annotated.jpg",
      "defectType": "scratch",
      "confidence": 0.95
    }
  ]
}
```

### 9. Detect Defect (Upload Image for AI Detection)
**Endpoint:** `POST /scans/detect-defect`
**Auth:** Required
**Content-Type:** multipart/form-data
**Request Body:**
```
scan_id: integer (optional - creates new scan if not provided)
image: File (required - jpg, png, jpeg, gif, max 10MB)
```
**Response (201):** Scan with detected defects

---

## Images Endpoints

### 1. List Images (Can Filter by Scan ID)
**Endpoint:** `GET /images`
**Auth:** Required
**Query Parameters:**
- `scan_id`: integer (optional) - Filter images by scan_id

**Response (200):**
```json
{
  "status": true,
  "success": true,
  "message": "Images retrieved successfully",
  "data": [
    {
      "id": 39,
      "scan_id": 42,
      "image_path": "https://domain.com/storage/images/original.jpg",
      "processed_image_path": "https://domain.com/storage/images/annotated.jpg",
      "file_size": 8002,
      "resolution": "200x200",
      "created_at": "2026-04-22T20:12:09.000000Z",
      "updated_at": "2026-04-22T20:12:09.000000Z"
    }
  ]
}
```

### 2. Get Specific Image
**Endpoint:** `GET /images/{image_id}`
**Auth:** Required
**Response (200):** Image object

### 3. Create/Upload Image
**Endpoint:** `POST /images`
**Auth:** Required
**Content-Type:** multipart/form-data
**Request Body:**
```
scan_id: integer (required)
file: File (required)
processed_image_path: string (optional)
file_size: integer (optional)
resolution: string (optional)
```
**Response (201):** Created image object

### 4. Update Image
**Endpoint:** `PUT /images/{image_id}`
**Auth:** Required
**Request Body:**
```json
{
  "processed_image_path": "string (optional)",
  "resolution": "string (optional)"
}
```
**Response (200):** Updated image object

### 5. Delete Image
**Endpoint:** `DELETE /images/{image_id}`
**Auth:** Required
**Response (204):** No content

---

## Image Defects Endpoints

### 1. List Image Defects
**Endpoint:** `GET /image-defects`
**Auth:** Required
**Response (200):**
```json
{
  "status": true,
  "data": [
    {
      "id": 1,
      "image_id": 39,
      "defect_category_id": 1,
      "confidence": 0.95,
      "bounding_box": {
        "x": 100,
        "y": 150,
        "width": 50,
        "height": 60
      },
      "created_at": "2026-04-22T20:12:09.000000Z",
      "updated_at": "2026-04-22T20:12:09.000000Z"
    }
  ]
}
```

### 2. Get Specific Defect
**Endpoint:** `GET /image-defects/{defect_id}`
**Auth:** Required
**Response (200):** Defect object

### 3. Create Defect
**Endpoint:** `POST /image-defects`
**Auth:** Required
**Request Body:**
```json
{
  "image_id": "integer (required)",
  "defect_category_id": "integer (required)",
  "confidence": "float (required)",
  "bounding_box": {
    "x": "integer",
    "y": "integer",
    "width": "integer",
    "height": "integer"
  }
}
```

### 4. Update Defect
**Endpoint:** `PUT /image-defects/{defect_id}`
**Auth:** Required

### 5. Delete Defect
**Endpoint:** `DELETE /image-defects/{defect_id}`
**Auth:** Required
**Response (204):** No content

---

## Defect Categories Endpoints

### 1. List All Categories
**Endpoint:** `GET /defect-categories`
**Auth:** Required
**Response (200):**
```json
{
  "status": true,
  "data": [
    {
      "id": 1,
      "name": "scratches",
      "description": "Surface scratches on steel surface",
      "severity_level": "medium",
      "created_at": "2026-04-19T05:58:29.000000Z",
      "updated_at": null
    }
  ]
}
```

### 2. Get Specific Category
**Endpoint:** `GET /defect-categories/{category_id}`
**Auth:** Required

### 3. Create Category
**Endpoint:** `POST /defect-categories`
**Auth:** Required (Admin)
**Request Body:**
```json
{
  "name": "string (required)",
  "description": "string (optional)",
  "severity_level": "low|medium|high (optional)"
}
```

### 4. Update Category
**Endpoint:** `PUT /defect-categories/{category_id}`
**Auth:** Required (Admin)

### 5. Delete Category
**Endpoint:** `DELETE /defect-categories/{category_id}`
**Auth:** Required (Admin)
**Response (204):** No content

---

## Scan Statistics Endpoints

### 1. List All Statistics
**Endpoint:** `GET /scan-statistics`
**Auth:** Required
**Response (200):**
```json
{
  "status": true,
  "data": [
    {
      "id": 40,
      "scan_id": 42,
      "total_defects": 1,
      "passed_count": 0,
      "defect_count": 1,
      "accuracy": 0.98,
      "processing_time": 1450,
      "created_at": "2026-04-22T20:12:09.000000Z",
      "updated_at": "2026-04-22T20:12:09.000000Z"
    }
  ]
}
```

### 2. Get Specific Statistic
**Endpoint:** `GET /scan-statistics/{statistic_id}`
**Auth:** Required

### 3. Create Statistic
**Endpoint:** `POST /scan-statistics`
**Auth:** Required (Admin)
**Request Body:**
```json
{
  "scan_id": "integer (required)",
  "total_defects": "integer (optional)",
  "passed_count": "integer (optional)",
  "defect_count": "integer (optional)",
  "accuracy": "numeric 0-100 (optional)",
  "processing_time": "integer (optional)"
}
```

### 4. Update Statistic
**Endpoint:** `PUT /scan-statistics/{statistic_id}`
**Auth:** Required

### 5. Delete Statistic
**Endpoint:** `DELETE /scan-statistics/{statistic_id}`
**Auth:** Required (Admin)
**Response (204):** No content

---

## User Management Endpoints (Admin Only)

### 1. List All Users
**Endpoint:** `GET /users`
**Auth:** Required (Admin)
**Response (200):**
```json
{
  "status": true,
  "data": [
    { ... user objects ... }
  ]
}
```

### 2. Get Specific User
**Endpoint:** `GET /users/{user_id}`
**Auth:** Required (Admin)

### 3. Create User
**Endpoint:** `POST /users`
**Auth:** Required (Admin)

### 4. Update User
**Endpoint:** `PUT /users/{user_id}`
**Auth:** Required (Admin)

### 5. Delete User
**Endpoint:** `DELETE /users/{user_id}`
**Auth:** Required (Admin)
**Response (204):** No content

### 6. Promote User to Admin
**Endpoint:** `POST /users/{user_id}/promote-to-admin`
**Auth:** Required (Admin)

### 7. Demote Admin to User
**Endpoint:** `POST /users/{user_id}/demote-to-user`
**Auth:** Required (Admin)

---

## Activities Endpoints

### 1. List Activities
**Endpoint:** `GET /activities`
**Auth:** Required

### 2. Get Specific Activity
**Endpoint:** `GET /activities/{activity_id}`
**Auth:** Required

### 3. Create Activity
**Endpoint:** `POST /activities`
**Auth:** Required

### 4. Update Activity
**Endpoint:** `PUT /activities/{activity_id}`
**Auth:** Required

### 5. Delete Activity
**Endpoint:** `DELETE /activities/{activity_id}`
**Auth:** Required

---

## Notifications Endpoints

### 1. List Notifications
**Endpoint:** `GET /notifications`
**Auth:** Required

### 2. Get Specific Notification
**Endpoint:** `GET /notifications/{notification_id}`
**Auth:** Required

### 3. Create Notification
**Endpoint:** `POST /notifications`
**Auth:** Required

### 4. Mark as Read
**Endpoint:** `POST /notifications/{notification_id}/mark-as-read`
**Auth:** Required

### 5. Update Notification
**Endpoint:** `PUT /notifications/{notification_id}`
**Auth:** Required

### 6. Delete Notification
**Endpoint:** `DELETE /notifications/{notification_id}`
**Auth:** Required

---

## Analytics Endpoints

### 1. Get Analytics Summary
**Endpoint:** `GET /analytics/summary`
**Auth:** Required

### 2. Get Analytics Report
**Endpoint:** `GET /analytics/report/{scan_id?}`
**Auth:** Required
**Query Parameters:**
- `scan_id`: integer (optional)

### 3. Get Analytics History
**Endpoint:** `GET /analytics/history`
**Auth:** Required

---

## User Statistics Endpoints

### 1. Get User Analytics
**Endpoint:** `GET /user-statistics/analytics`
**Auth:** Required

### 2. Get Dashboard Data
**Endpoint:** `GET /user-statistics/dashboard`
**Auth:** Required

### 3. Get History
**Endpoint:** `GET /user-statistics/history`
**Auth:** Required

### 4. Get Recent Activity
**Endpoint:** `GET /user-statistics/recent_activity`
**Auth:** Required

---

## Response Format

All API responses follow this format:

**Success Response:**
```json
{
  "status": true,
  "success": true,
  "message": "string",
  "data": { ... } or [ ... ]
}
```

**Error Response:**
```json
{
  "status": false,
  "message": "string",
  "errors": { ... }
}
```

**Status Codes:**
- `200` - OK
- `201` - Created
- `204` - No Content
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Unprocessable Entity
- `500` - Server Error
- `503` - Service Unavailable

---

## Key Points for Frontend Integration

1. **Scans List** - Use `/scans` endpoint (returns only basic scan data, lightweight)
2. **Scan Details** - Use `/scans/{id}` endpoint (includes images and statistics)
3. **Images Only** - Use `/scans/{id}/images` or `/images?scan_id={id}`
4. **Statistics Only** - Use `/scans/{id}/statistics`
5. **User Profile** - Use `/profile` endpoint (includes today_scans and total_scans counts)
6. **Avatar URLs** - Always use the full URL from the response, the server handles path resolution

## Important Notes

- All timestamps are in UTC format (ISO 8601)
- Bearer token required for authenticated endpoints
- Avatar paths are returned as full URLs
- Images are stored in `/storage/` directory
- Pagination uses standard Laravel pagination (page, per_page parameters)
- Empty relationships return empty arrays `[]`
- Null values are preserved in responses
