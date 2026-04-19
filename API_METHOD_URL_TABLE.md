# Surface Defect Detection API Table

Base URL: `http://127.0.0.1:8000`

| Method | URL | Purpose |
| --- | --- | --- |
| POST | `http://127.0.0.1:8000/api/auth/register` | Register a new account |
| POST | `http://127.0.0.1:8000/api/auth/login` | Login |
| POST | `http://127.0.0.1:8000/api/auth/logout` | Logout |
| GET | `http://127.0.0.1:8000/api/auth/me` | Get current authenticated user |
| POST | `http://127.0.0.1:8000/api/auth/send-email-verification` | Send email verification code |
| POST | `http://127.0.0.1:8000/api/auth/verify-email` | Verify email with code |
| POST | `http://127.0.0.1:8000/api/auth/send-phone-verification` | Send phone verification code |
| POST | `http://127.0.0.1:8000/api/auth/verify-phone` | Verify phone with code |
| POST | `http://127.0.0.1:8000/api/auth/resend-code` | Resend verification code |
| POST | `http://127.0.0.1:8000/api/auth/send-password-reset` | Send password reset code |
| POST | `http://127.0.0.1:8000/api/auth/verify-password-reset` | Verify password reset code |
| POST | `http://127.0.0.1:8000/api/auth/reset-password` | Reset password |
| GET | `http://127.0.0.1:8000/api/profile` | Get current profile |
| PUT | `http://127.0.0.1:8000/api/profile` | Update current profile |
| PUT | `http://127.0.0.1:8000/api/profile/settings` | Update current profile settings |
| GET | `http://127.0.0.1:8000/api/users` | List users |
| POST | `http://127.0.0.1:8000/api/users` | Create user |
| GET | `http://127.0.0.1:8000/api/users/{user}` | Get user by id |
| PUT | `http://127.0.0.1:8000/api/users/{user}` | Update user |
| DELETE | `http://127.0.0.1:8000/api/users/{user}` | Delete user |
| POST | `http://127.0.0.1:8000/api/users/{user}/promote-to-admin` | Promote user to admin |
| POST | `http://127.0.0.1:8000/api/users/{user}/demote-to-user` | Demote admin to user |
| GET | `http://127.0.0.1:8000/api/activities` | List activities |
| POST | `http://127.0.0.1:8000/api/activities` | Create activity |
| GET | `http://127.0.0.1:8000/api/activities/{activity}` | Get activity |
| PUT | `http://127.0.0.1:8000/api/activities/{activity}` | Update activity |
| DELETE | `http://127.0.0.1:8000/api/activities/{activity}` | Delete activity |
| GET | `http://127.0.0.1:8000/api/defect-categories` | List defect categories |
| POST | `http://127.0.0.1:8000/api/defect-categories` | Create defect category |
| GET | `http://127.0.0.1:8000/api/defect-categories/{defectCategory}` | Get defect category |
| PUT | `http://127.0.0.1:8000/api/defect-categories/{defectCategory}` | Update defect category |
| DELETE | `http://127.0.0.1:8000/api/defect-categories/{defectCategory}` | Delete defect category |
| GET | `http://127.0.0.1:8000/api/scans` | List scans |
| POST | `http://127.0.0.1:8000/api/scans` | Create scan |
| GET | `http://127.0.0.1:8000/api/scans/{scan}` | Get scan |
| PUT | `http://127.0.0.1:8000/api/scans/{scan}` | Update scan |
| DELETE | `http://127.0.0.1:8000/api/scans/{scan}` | Delete scan |
| POST | `http://127.0.0.1:8000/api/scans/detect-defect` | Send image to Laravel, then AI, save result in DB |
| GET | `http://127.0.0.1:8000/api/images` | List images |
| POST | `http://127.0.0.1:8000/api/images` | Create image |
| GET | `http://127.0.0.1:8000/api/images/{image}` | Get image |
| PUT | `http://127.0.0.1:8000/api/images/{image}` | Update image |
| DELETE | `http://127.0.0.1:8000/api/images/{image}` | Delete image |
| GET | `http://127.0.0.1:8000/api/image-defects` | List image defects |
| POST | `http://127.0.0.1:8000/api/image-defects` | Create image defect |
| GET | `http://127.0.0.1:8000/api/image-defects/{imageDefect}` | Get image defect |
| PUT | `http://127.0.0.1:8000/api/image-defects/{imageDefect}` | Update image defect |
| DELETE | `http://127.0.0.1:8000/api/image-defects/{imageDefect}` | Delete image defect |
| GET | `http://127.0.0.1:8000/api/notifications` | List notifications |
| POST | `http://127.0.0.1:8000/api/notifications` | Create notification |
| GET | `http://127.0.0.1:8000/api/notifications/{notification}` | Get notification |
| PUT | `http://127.0.0.1:8000/api/notifications/{notification}` | Update notification |
| DELETE | `http://127.0.0.1:8000/api/notifications/{notification}` | Delete notification |
| POST | `http://127.0.0.1:8000/api/notifications/{notification}/mark-as-read` | Mark notification as read |
| GET | `http://127.0.0.1:8000/api/scan-statistics` | List scan statistics |
| POST | `http://127.0.0.1:8000/api/scan-statistics` | Create scan statistic |
| GET | `http://127.0.0.1:8000/api/scan-statistics/{scanStatistic}` | Get scan statistic |
| PUT | `http://127.0.0.1:8000/api/scan-statistics/{scanStatistic}` | Update scan statistic |
| DELETE | `http://127.0.0.1:8000/api/scan-statistics/{scanStatistic}` | Delete scan statistic |
| GET | `http://127.0.0.1:8000/api/user-settings` | List user settings |
| POST | `http://127.0.0.1:8000/api/user-settings` | Create user setting |
| GET | `http://127.0.0.1:8000/api/user-settings/{userSetting}` | Get user setting |
| PUT | `http://127.0.0.1:8000/api/user-settings/{userSetting}` | Update user setting |
| DELETE | `http://127.0.0.1:8000/api/user-settings/{userSetting}` | Delete user setting |
| GET | `http://127.0.0.1:8000/api/analytics/summary` | Get dashboard summary |
| GET | `http://127.0.0.1:8000/api/analytics/report/{scanId}` | Get report for one scan |
| GET | `http://127.0.0.1:8000/api/analytics/history` | Get analytics history |
| GET | `http://127.0.0.1:8000/api/user` | Shortcut to current user |
