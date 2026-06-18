# Surface Defect Detection API Table

Base URL: `https://lightgreen-crane-116703.hostingersite.com`

| Method | URL | Purpose |
| --- | --- | --- |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/register` | Register a new account |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/login` | Login |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/logout` | Logout |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/auth/me` | Get current authenticated user |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/send-email-verification` | Send email verification code |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/verify-email` | Verify email with code |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/send-phone-verification` | Send phone verification code |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/verify-phone` | Verify phone with code |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/resend-code` | Resend verification code |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/send-password-reset` | Send password reset code |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/verify-password-reset` | Verify password reset code |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/auth/reset-password` | Reset password |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/profile` | Get current profile |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/profile` | Update current profile |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/profile/settings` | Update current profile settings |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/users` | List users |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/users` | Create user |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/users/{user}` | Get user by id |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/users/{user}` | Update user |
| DELETE | `https://lightgreen-crane-116703.hostingersite.com/api/users/{user}` | Delete user |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/users/{user}/promote-to-admin` | Promote user to admin |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/users/{user}/demote-to-user` | Demote admin to user |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/activities` | List activities |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/activities` | Create activity |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/activities/{activity}` | Get activity |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/activities/{activity}` | Update activity |
| DELETE | `https://lightgreen-crane-116703.hostingersite.com/api/activities/{activity}` | Delete activity |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/defect-categories` | List defect categories |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/defect-categories` | Create defect category |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/defect-categories/{defectCategory}` | Get defect category |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/defect-categories/{defectCategory}` | Update defect category |
| DELETE | `https://lightgreen-crane-116703.hostingersite.com/api/defect-categories/{defectCategory}` | Delete defect category |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/scans` | List scans |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/scans` | Create scan |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/scans/{scan}` | Get scan |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/scans/{scan}` | Update scan |
| DELETE | `https://lightgreen-crane-116703.hostingersite.com/api/scans/{scan}` | Delete scan |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/scans/detect-defect` | Send image to Laravel, then AI, save result in DB |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/images` | List images |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/images` | Create image |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/images/{image}` | Get image |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/images/{image}` | Update image |
| DELETE | `https://lightgreen-crane-116703.hostingersite.com/api/images/{image}` | Delete image |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/image-defects` | List image defects |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/image-defects` | Create image defect |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/image-defects/{imageDefect}` | Get image defect |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/image-defects/{imageDefect}` | Update image defect |
| DELETE | `https://lightgreen-crane-116703.hostingersite.com/api/image-defects/{imageDefect}` | Delete image defect |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/notifications` | List notifications |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/notifications` | Create notification |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/notifications/{notification}` | Get notification |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/notifications/{notification}` | Update notification |
| DELETE | `https://lightgreen-crane-116703.hostingersite.com/api/notifications/{notification}` | Delete notification |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/notifications/{notification}/mark-as-read` | Mark notification as read |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/scan-statistics` | List scan statistics |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/scan-statistics` | Create scan statistic |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/scan-statistics/{scanStatistic}` | Get scan statistic |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/scan-statistics/{scanStatistic}` | Update scan statistic |
| DELETE | `https://lightgreen-crane-116703.hostingersite.com/api/scan-statistics/{scanStatistic}` | Delete scan statistic |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/user-settings` | List user settings |
| POST | `https://lightgreen-crane-116703.hostingersite.com/api/user-settings` | Create user setting |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/user-settings/{userSetting}` | Get user setting |
| PUT | `https://lightgreen-crane-116703.hostingersite.com/api/user-settings/{userSetting}` | Update user setting |
| DELETE | `https://lightgreen-crane-116703.hostingersite.com/api/user-settings/{userSetting}` | Delete user setting |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/analytics/summary` | Get dashboard summary |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/analytics/report/{scanId}` | Get report for one scan |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/analytics/history` | Get analytics history |
| GET | `https://lightgreen-crane-116703.hostingersite.com/api/user` | Shortcut to current user |
