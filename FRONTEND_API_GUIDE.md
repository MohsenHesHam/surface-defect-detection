# Surface Defect Detection — Frontend Integration Guide

Base URL

- Local: `http://localhost:8000/api`

Auth

- Uses Laravel Sanctum bearer tokens.
- After login the response contains `token` (e.g. `1|abc...`).
- Include in protected requests header:

  Authorization: Bearer {token}

Common headers (JSON requests)

- `Content-Type: application/json`
- `Accept: application/json`

Useful endpoints & examples

1) Register (public)

- Route: `POST /auth/register`
- Body (JSON):
```
{
  "full_name": "Ahmed",
  "email": "ahmed@example.com",
  "phone": "01001234567",
  "password": "Password123",
  "password_confirmation": "Password123"
}
```
- Response (201): user object (role defaults to `user`).

2) Login (public)

- Route: `POST /auth/login`
- Body:
```
{
  "email": "ahmed@example.com",
  "password": "Password123"
}
```
- Response (200):
```
{
  "message": "Login successful",
  "user": { ... },
  "token": "1|abc123...",
  "requires_email_verification": false
}
```
- Save `token` for subsequent requests.

3) Get current user

- Route: `GET /auth/me`
- Headers: `Authorization: Bearer {token}`
- Response (200): current user JSON (includes `role` and `account_status`).

4) Users (admin protected)

- List users: `GET /users` (admin only)
- Create user: `POST /users` (admin only)
- View user: `GET /users/{id}` (admin or owner)
- Promote to admin: `POST /users/{id}/promote-to-admin` (admin only)

5) Scans

- List scans: `GET /scans`
  - Admin sees all; regular users see their own scans.
- Create scan: `POST /scans`
  - Body (JSON):
```
{
  "user_id": 1,         // must be your own id unless admin
  "scan_type": "visual",
  "total_images": 0
}
```
- Upload images while creating a scan: multipart `POST /scans` with `images[]` files (use `multipart/form-data`).
  - For multipart requests set header `Content-Type: multipart/form-data` (let browser/axios set boundary automatically).

- View scan: `GET /scans/{id}` (admin or owner)
- Update scan: `PUT /scans/{id}` (admin or owner)
- Delete scan: `DELETE /scans/{id}` (admin or owner)

6) Images

- List images: `GET /images` (admin sees all; users see images from their scans)
- Upload single image: `POST /images` (multipart)
  - Fields: `scan_id`, and file under `file` OR `image_path` if providing a URL
  - Example multipart fields:
    - `scan_id`: 12
    - `file`: (binary image)
- View/update/delete image: `GET/PUT/DELETE /images/{id}` (admin or owner of the scan)

7) Defect categories

- Public: `GET /defect-categories` and `GET /defect-categories/{id}`
- Admin only: `POST /defect-categories`, `PUT /defect-categories/{id}`, `DELETE /defect-categories/{id}`

8) Image defects & statistics

- `GET /image-defects` and `GET /scan-statistics` return admin/all or user-limited data depending on role.
- Creation of defects and statistics is normally automatic during scan processing; admin can create manually via endpoints if needed.

Error handling (common responses)

- 401 Unauthorized — invalid/missing token
- 403 Forbidden — insufficient permissions (e.g., user trying an admin-only action)
- 422 Validation errors — check `errors` object in response

Quick Postman / Axios tips

- Postman: add `Authorization` header with `Bearer {{token}}` in environment.
- Axios example (login + get me):

```js
// login
const res = await axios.post('/api/auth/login', { email, password });
const token = res.data.token;
axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;

// get current user
const me = await axios.get('/api/auth/me');
```

File locations & notes for backend devs

- Migrations: `database/migrations/2026_03_04_000000_add_role_to_users_table.php` (adds `role`)
- Controllers adjusted for authorization: `app/Http/Controllers/*Controller.php` (users, scans, images, etc.)

Testing checklist for frontend dev

1. Register a user and confirm `role` is `user` via `GET /auth/me`.
2. Login, save token, call `GET /scans` — should return only your scans.
3. Try to call an admin-only endpoint (e.g., `POST /defect-categories`) — expect 403.
4. If given an admin token (from backend/dev), test admin flows: list users, promote a user.
