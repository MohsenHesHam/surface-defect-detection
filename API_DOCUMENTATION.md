# API Documentation - Graduation Project

This document describes all available API endpoints for the Graduation Project backend.

## Base URL
```
http://localhost:8000/api
```

## Authentication

Most endpoints require authentication using Bearer tokens (Sanctum). Include the token in the `Authorization` header:

```
Authorization: Bearer {token}
```

---

## Authentication Endpoints (Public)

### 1. Register User
- **Method**: POST
- **Endpoint**: `/auth/register`
- **Auth Required**: No
- **Request Body**:
```json
{
  "full_name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "password": "password123",
  "password_confirmation": "password123"
}
```
- **Response** (201):
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "full_name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "account_status": "pending",
    "created_at": "2026-02-19T10:00:00Z"
  }
}
```

### 2. Login User
- **Method**: POST
- **Endpoint**: `/auth/login`
- **Auth Required**: No
- **Request Body**:
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```
- **Response** (200):
```json
{
  "message": "Login successful",
  "user": {
    "id": 1,
    "full_name": "John Doe",
    "email": "john@example.com"
  },
  "token": "1|abc123xyz",
  "requires_email_verification": false,
  "requires_phone_verification": true
}
```

### 3. Send Email Verification Code
- **Method**: POST
- **Endpoint**: `/auth/send-email-verification`
- **Auth Required**: No
- **Request Body**:
```json
{
  "email": "john@example.com"
}
```
- **Response** (200):
```json
{
  "message": "Verification code sent to email",
  "code": "123456"
}
```

### 4. Verify Email
- **Method**: POST
- **Endpoint**: `/auth/verify-email`
- **Auth Required**: No
- **Request Body**:
```json
{
  "email": "john@example.com",
  "code": "123456"
}
```
- **Response** (200):
```json
{
  "message": "Email verified successfully",
  "user": {
    "id": 1,
    "email_verified_at": "2026-02-19T10:05:00Z"
  }
}
```

### 5. Send Phone Verification Code
- **Method**: POST
- **Endpoint**: `/auth/send-phone-verification`
- **Auth Required**: No
- **Request Body**:
```json
{
  "phone": "+1234567890"
}
```
- **Response** (200):
```json
{
  "message": "Verification code sent to phone",
  "code": "654321"
}
```

### 6. Password Reset - Send Reset Code
- **Method**: POST
- **Endpoint**: `/auth/send-password-reset`
- **Auth Required**: No
- **Request Body**:
```json
{
  "email": "john@example.com"
}
```
- **Response** (200):
```json
{
  "message": "Password reset code sent to email",
  "code": "123456"
}
```

### 7. Password Reset - Verify Reset Code
- **Method**: POST
- **Endpoint**: `/auth/verify-password-reset`
- **Auth Required**: No
- **Request Body**:
```json
{
  "email": "john@example.com",
  "code": "123456"
}
```
- **Response** (200):
```json
{
  "message": "Reset code verified successfully",
  "reset_token": "<temporary_token>"
}
```

### 8. Password Reset - Set New Password
- **Method**: POST
- **Endpoint**: `/auth/reset-password`
- **Auth Required**: No
- **Request Body**:
```json
{
  "email": "john@example.com",
  "reset_token": "<temporary_token>",
  "password": "newpassword123",
  "password_confirmation": "newpassword123"
}
```
- **Response** (200):
```json
{
  "message": "Password changed successfully",
  "user": { /* user data */ }
}
```

### 6. Verify Phone
- **Method**: POST
- **Endpoint**: `/auth/verify-phone`
- **Auth Required**: No
- **Request Body**:
```json
{
  "phone": "+1234567890",
  "code": "654321"
}
```
- **Response** (200):
```json
{
  "message": "Phone verified successfully",
  "user": {
    "id": 1,
    "phone_verified_at": "2026-02-19T10:10:00Z",
    "account_status": "active"
  }
}
```

### 7. Resend Verification Code
- **Method**: POST
- **Endpoint**: `/auth/resend-code`
- **Auth Required**: No
- **Request Body**:
```json
{
  "type": "email",
  "contact": "john@example.com"
}
```
- **Response** (200): Same as send verification endpoints

---

## Protected Endpoints

All endpoints below require authentication token in the `Authorization` header.

### 8. Logout
- **Method**: POST
- **Endpoint**: `/auth/logout`
- **Auth Required**: Yes
- **Response** (200):
```json
{
  "message": "Logged out successfully"
}
```

### 9. Get Current User
- **Method**: GET
- **Endpoint**: `/auth/me`
- **Auth Required**: Yes
- **Response** (200):
```json
{
  "user": {
    "id": 1,
    "full_name": "John Doe",
    "email": "john@example.com",
    "scans": [],
    "activities": [],
    "notifications": [],
    "settings": {}
  }
}
```

---

## User Management Endpoints

### 10. Get All Users
- **Method**: GET
- **Endpoint**: `/users`
- **Auth Required**: Yes

### 11. Create User
- **Method**: POST
- **Endpoint**: `/users`
- **Auth Required**: Yes

### 12. Get User by ID
- **Method**: GET
- **Endpoint**: `/users/{id}`
- **Auth Required**: Yes

### 13. Update User
- **Method**: PUT
- **Endpoint**: `/users/{id}`
- **Auth Required**: Yes

### 14. Delete User
- **Method**: DELETE
- **Endpoint**: `/users/{id}`
- **Auth Required**: Yes

---

### Profile Endpoints (Authenticated User)

#### Get Profile
- **Method**: GET
- **Endpoint**: `/profile`
- **Auth Required**: Yes

#### Update Profile
- **Method**: PUT
- **Endpoint**: `/profile`
- **Auth Required**: Yes
- **Request Body** (any of):
```json
{
  "full_name": "New Name",
  "email": "new@example.com",
  "phone": "+1234567890",
  "avatar": "https://example.com/avatar.jpg"
}
```

#### Update Settings
- **Method**: PUT
- **Endpoint**: `/profile/settings`
- **Auth Required**: Yes
- **Request Body**:
```json
{
  "language": "en",
  "theme": "dark",
  "push_notifications": true,
  "email_notifications": false
}
```


## Scan Management Endpoints

### 15. Get All Scans
- **Method**: GET
- **Endpoint**: `/scans`
- **Auth Required**: Yes

### 16. Create Scan
- **Method**: POST
- **Endpoint**: `/scans`
- **Auth Required**: Yes
- **Request Body**:
```json
{
  "user_id": 1,
  "scan_type": "quality_check",
  "total_images": 10,
  "status": "pending"
}
```

### 17. Get Scan by ID
- **Method**: GET
- **Endpoint**: `/scans/{id}`
- **Auth Required**: Yes

### 18. Update Scan
- **Method**: PUT
- **Endpoint**: `/scans/{id}`
- **Auth Required**: Yes

### 19. Delete Scan
- **Method**: DELETE
- **Endpoint**: `/scans/{id}`
- **Auth Required**: Yes

---

## Image Endpoints

### 20. Get All Images
- **Method**: GET
- **Endpoint**: `/images`
- **Auth Required**: Yes

### 21. Create Image
- **Method**: POST
- **Endpoint**: `/images`
- **Auth Required**: Yes
- **Request Body**:
```json
{
  "scan_id": 1,
  "image_path": "/storage/images/image1.jpg",
  "file_size": 204800,
  "resolution": "1920x1080"
}
```

### 22. Get Image by ID
- **Method**: GET
- **Endpoint**: `/images/{id}`
- **Auth Required**: Yes

### 23. Update Image
- **Method**: PUT
- **Endpoint**: `/images/{id}`
- **Auth Required**: Yes

### 24. Delete Image
- **Method**: DELETE
- **Endpoint**: `/images/{id}`
- **Auth Required**: Yes

---

## Defect Category Endpoints

### 25. Get All Defect Categories
- **Method**: GET
- **Endpoint**: `/defect-categories`
- **Auth Required**: Yes

### 26. Create Defect Category
- **Method**: POST
- **Endpoint**: `/defect-categories`
- **Auth Required**: Yes
- **Request Body**:
```json
{
  "name": "Crack",
  "description": "Surface crack defect",
  "severity_level": "high"
}
```

### 27. Get Defect Category by ID
- **Method**: GET
- **Endpoint**: `/defect-categories/{id}`
- **Auth Required**: Yes

### 28. Update Defect Category
- **Method**: PUT
- **Endpoint**: `/defect-categories/{id}`
- **Auth Required**: Yes

### 29. Delete Defect Category
- **Method**: DELETE
- **Endpoint**: `/defect-categories/{id}`
- **Auth Required**: Yes

---

## Image Defect Endpoints

### 30. Get All Image Defects
- **Method**: GET
- **Endpoint**: `/image-defects`
- **Auth Required**: Yes

### 31. Create Image Defect
- **Method**: POST
- **Endpoint**: `/image-defects`
- **Auth Required**: Yes
- **Request Body**:
```json
{
  "image_id": 1,
  "defect_category_id": 1,
  "confidence": 95.5,
  "bounding_box": {
    "x": 100,
    "y": 200,
    "width": 50,
    "height": 50
  }
}
```

### 32. Get Image Defect by ID
- **Method**: GET
- **Endpoint**: `/image-defects/{id}`
- **Auth Required**: Yes

### 33. Update Image Defect
- **Method**: PUT
- **Endpoint**: `/image-defects/{id}`
- **Auth Required**: Yes

### 34. Delete Image Defect
- **Method**: DELETE
- **Endpoint**: `/image-defects/{id}`
- **Auth Required**: Yes

---

## Notification Endpoints

### 35. Get All Notifications
- **Method**: GET
- **Endpoint**: `/notifications`
- **Auth Required**: Yes

### 36. Create Notification
- **Method**: POST
- **Endpoint**: `/notifications`
- **Auth Required**: Yes
- **Request Body**:
```json
{
  "user_id": 1,
  "title": "Scan Complete",
  "message": "Your scan has been completed",
  "type": "success"
}
```

### 37. Get Notification by ID
- **Method**: GET
- **Endpoint**: `/notifications/{id}`
- **Auth Required**: Yes

### 38. Update Notification
- **Method**: PUT
- **Endpoint**: `/notifications/{id}`
- **Auth Required**: Yes

### 39. Mark Notification as Read
- **Method**: POST
- **Endpoint**: `/notifications/{id}/mark-as-read`
- **Auth Required**: Yes

### 40. Delete Notification
- **Method**: DELETE
- **Endpoint**: `/notifications/{id}`
- **Auth Required**: Yes

---

## Activity Endpoints

### 41. Get All Activities
- **Method**: GET
- **Endpoint**: `/activities`
- **Auth Required**: Yes

### 42. Create Activity
- **Method**: POST
- **Endpoint**: `/activities`
- **Auth Required**: Yes
- **Request Body**:
```json
{
  "user_id": 1,
  "scan_id": 1,
  "title": "Scan Started",
  "description": "Quality check scan initiated",
  "status": "pending"
}
```

### 43. Get Activity by ID
- **Method**: GET
- **Endpoint**: `/activities/{id}`
- **Auth Required**: Yes

### 44. Update Activity
- **Method**: PUT
- **Endpoint**: `/activities/{id}`
- **Auth Required**: Yes

### 45. Delete Activity
- **Method**: DELETE
- **Endpoint**: `/activities/{id}`
- **Auth Required**: Yes

---

## Scan Statistics Endpoints

### 46. Get All Scan Statistics
- **Method**: GET
- **Endpoint**: `/scan-statistics`
- **Auth Required**: Yes

### 47. Create Scan Statistics
- **Method**: POST
- **Endpoint**: `/scan-statistics`
- **Auth Required**: Yes
- **Request Body**:
```json
{
  "scan_id": 1,
  "total_defects": 5,
  "passed_count": 8,
  "defect_count": 2,
  "accuracy": 96.5,
  "processing_time": 120
}
```

### 48. Get Scan Statistics by ID
- **Method**: GET
- **Endpoint**: `/scan-statistics/{id}`
- **Auth Required**: Yes

### 49. Update Scan Statistics
- **Method**: PUT
- **Endpoint**: `/scan-statistics/{id}`
- **Auth Required**: Yes

### 50. Delete Scan Statistics
- **Method**: DELETE
- **Endpoint**: `/scan-statistics/{id}`
- **Auth Required**: Yes

---

## User Settings Endpoints

### 51. Get All User Settings
- **Method**: GET
- **Endpoint**: `/user-settings`
- **Auth Required**: Yes

### 52. Create User Settings
- **Method**: POST
- **Endpoint**: `/user-settings`
- **Auth Required**: Yes
- **Request Body**:
```json
{
  "user_id": 1,
  "language": "en",
  "theme": "dark",
  "push_notifications": true,
  "email_notifications": true
}
```

### 53. Get User Settings by ID
- **Method**: GET
- **Endpoint**: `/user-settings/{id}`
- **Auth Required**: Yes

### 54. Update User Settings
- **Method**: PUT
- **Endpoint**: `/user-settings/{id}`
- **Auth Required**: Yes

### 55. Delete User Settings
- **Method**: DELETE
- **Endpoint**: `/user-settings/{id}`
- **Auth Required**: Yes

---

## Error Responses

### Validation Error (422)
```json
{
  "errors": {
    "email": ["The email must be a valid email address."],
    "password": ["The password must be at least 8 characters."]
  }
}
```

### Unauthorized (401)
```json
{
  "message": "Invalid credentials"
}
```

### Not Found (404)
```json
{
  "message": "Resource not found"
}
```

### Server Error (500)
```json
{
  "message": "Server error"
}
```

---

## Running the Server

```bash
php artisan serve
```

The server will run at `http://localhost:8000`

## Running Migrations

```bash
php artisan migrate
```

## Resetting the Database

```bash
php artisan migrate:fresh --seed
```
