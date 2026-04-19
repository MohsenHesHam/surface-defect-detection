# Surface Defect Detection API Quick Docs

Base URL: `http://127.0.0.1:8000`

## Auth

- `POST /api/auth/register`
  Registers a new account.
  Example body:
  ```json
  {
    "full_name": "Mohsen Hesham",
    "email": "mohsen@example.com",
    "phone": "01012345678",
    "password": "Password123",
    "password_confirmation": "Password123"
  }
  ```

- `POST /api/auth/login`
  Logs in and returns a token.
  Example body:
  ```json
  {
    "email": "mohsen@example.com",
    "password": "Password123"
  }
  ```

- `POST /api/auth/logout`
  Logs out the current user. Requires `Bearer Token`.

- `GET /api/auth/me`
  Returns the authenticated user. Requires `Bearer Token`.

- `POST /api/auth/send-email-verification`
- `POST /api/auth/verify-email`
- `POST /api/auth/send-phone-verification`
- `POST /api/auth/verify-phone`
- `POST /api/auth/resend-code`
- `POST /api/auth/send-password-reset`
- `POST /api/auth/verify-password-reset`
- `POST /api/auth/reset-password`

## Profile

- `GET /api/profile`
  Returns the current user profile.

- `PUT /api/profile`
  Updates the current user profile.

- `PUT /api/profile/settings`
  Updates the current user settings.

## Main AI Pipeline

- `POST /api/scans/detect-defect`
  This is the endpoint Flutter or React should call to trigger the full image pipeline.

  Request:
  - Content-Type: `multipart/form-data`
  - Fields:
    - `image`: required file
    - `scan_id`: optional existing scan id

  Example Postman setup:
  - URL: `http://127.0.0.1:8000/api/scans/detect-defect`
  - Method: `POST`
  - Headers:
    - `Authorization: Bearer YOUR_TOKEN`
    - `Accept: application/json`
  - Body:
    - `form-data`
    - `scan_id` = `1`
    - `image` = file

  Current response shape:
  ```json
  {
    "status": true,
    "success": true,
    "message": "Defect detection completed successfully",
    "data": {
      "prediction": {
        "class": "cr",
        "confidence": 96.62,
        "defect_percentage": 43.8,
        "bbox": [0, 0, 186, 156],
        "annotated_image": "BASE64_STRING"
      },
      "saved_records": {
        "scan": {
          "id": 1,
          "status": "completed"
        },
        "image": {
          "id": 10,
          "scan_id": 1,
          "image_path": "/storage/images/abc.jpg",
          "processed_image_path": "/storage/images/xyz_annotated.jpg"
        },
        "image_defect": {
          "id": 3,
          "confidence": 96.62,
          "bounding_box": {
            "x": 0,
            "y": 0,
            "width": 186,
            "height": 156
          }
        },
        "statistics": {
          "scan_id": 1,
          "total_defects": 1,
          "defect_count": 1,
          "accuracy": 0
        }
      }
    }
  }
  ```

  Flutter should read:
  - `data.prediction.class`
  - `data.prediction.confidence`
  - `data.prediction.defect_percentage`
  - `data.prediction.bbox`
  - `data.prediction.annotated_image`

## CRUD Groups

- Users:
  - `GET /api/users`
  - `POST /api/users`
  - `GET /api/users/{user}`
  - `PUT /api/users/{user}`
  - `DELETE /api/users/{user}`
  - `POST /api/users/{user}/promote-to-admin`
  - `POST /api/users/{user}/demote-to-user`

- Activities:
  - `GET /api/activities`
  - `POST /api/activities`
  - `GET /api/activities/{activity}`
  - `PUT /api/activities/{activity}`
  - `DELETE /api/activities/{activity}`

- Defect Categories:
  - `GET /api/defect-categories`
  - `POST /api/defect-categories`
  - `GET /api/defect-categories/{defectCategory}`
  - `PUT /api/defect-categories/{defectCategory}`
  - `DELETE /api/defect-categories/{defectCategory}`

- Scans:
  - `GET /api/scans`
  - `POST /api/scans`
  - `GET /api/scans/{scan}`
  - `PUT /api/scans/{scan}`
  - `DELETE /api/scans/{scan}`

- Images:
  - `GET /api/images`
  - `POST /api/images`
  - `GET /api/images/{image}`
  - `PUT /api/images/{image}`
  - `DELETE /api/images/{image}`

- Image Defects:
  - `GET /api/image-defects`
  - `POST /api/image-defects`
  - `GET /api/image-defects/{imageDefect}`
  - `PUT /api/image-defects/{imageDefect}`
  - `DELETE /api/image-defects/{imageDefect}`

- Notifications:
  - `GET /api/notifications`
  - `POST /api/notifications`
  - `GET /api/notifications/{notification}`
  - `PUT /api/notifications/{notification}`
  - `DELETE /api/notifications/{notification}`
  - `POST /api/notifications/{notification}/mark-as-read`

- Scan Statistics:
  - `GET /api/scan-statistics`
  - `POST /api/scan-statistics`
  - `GET /api/scan-statistics/{scanStatistic}`
  - `PUT /api/scan-statistics/{scanStatistic}`
  - `DELETE /api/scan-statistics/{scanStatistic}`

- User Settings:
  - `GET /api/user-settings`
  - `POST /api/user-settings`
  - `GET /api/user-settings/{userSetting}`
  - `PUT /api/user-settings/{userSetting}`
  - `DELETE /api/user-settings/{userSetting}`

## Analytics

- `GET /api/analytics/summary`
- `GET /api/analytics/report/{scanId}`
- `GET /api/analytics/history`

## Notes

- All protected routes require:
  ```text
  Authorization: Bearer YOUR_TOKEN
  ```
- AI service endpoint behind Laravel:
  ```text
  POST /predict
  ```
- Laravel receives `image`, then forwards it to AI as `file`.
