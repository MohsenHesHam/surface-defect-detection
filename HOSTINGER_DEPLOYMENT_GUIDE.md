# Hostinger Deployment Checklist

## ✅ Pre-Deployment Verification

Before uploading to Hostinger, verify these items locally:

### 1. Database Integrity
- [ ] Database backup exists: `u608200362_php_database.sql`
- [ ] All tables have correct structure
- [ ] Test user exists with known credentials

### 2. Code Quality
- [ ] No PHP syntax errors
- [ ] All modified files compile without errors
- [ ] Routes file is valid
- [ ] All controllers can be instantiated

### 3. API Functionality (Run Tests)

#### Test on Local Server:
```bash
# Start local PHP server (if needed)
php artisan serve

# Run the test script
bash test_api.sh
```

Then verify:
- [ ] `GET /scans` returns lightweight data (no images/statistics nested)
- [ ] `GET /scans/{id}` returns full scan with images and statistics
- [ ] `GET /scans/{id}/images` returns only images array
- [ ] `GET /scans/{id}/statistics` returns only statistics object
- [ ] `GET /images?scan_id=X` returns filtered images
- [ ] `GET /profile` returns complete user data with avatar URL
- [ ] Avatar URLs are properly formatted (full URLs)
- [ ] All authentication endpoints work
- [ ] Error responses are properly formatted

---

## 📋 Files to Upload to Hostinger

### Modified Files (CRITICAL - Must Upload):
```
✓ app/Http/Controllers/ScanController.php
✓ app/Http/Controllers/ImageController.php
✓ app/Http/Resources/UserResource.php
✓ routes/api.php
```

### Documentation Files (Recommended - For Reference):
```
✓ API_ENDPOINTS_COMPLETE.md          (Complete API docs)
✓ OPTIMIZATION_SUMMARY.md             (What was fixed)
✓ test_api.sh                         (Testing script)
✓ u608200362_php_database.sql        (Backup of database)
```

---

## 🚀 Deployment Steps

### Step 1: Connect to Hostinger via FTP/SSH

**Using FTP:**
1. Open FTP client (FileZilla, WinSCP, etc.)
2. Connect with credentials provided by Hostinger
3. Navigate to `public_html` folder

**Using SSH:**
```bash
ssh username@hostname
cd ~/public_html
```

### Step 2: Upload Modified Files

**Via FTP:** Drag and drop these files:
- `app/Http/Controllers/ScanController.php`
- `app/Http/Controllers/ImageController.php`
- `app/Http/Resources/UserResource.php`
- `routes/api.php`

**Via SSH:**
```bash
# If you have the files locally, use SCP
scp -r local/path/to/files username@hostname:~/public_html/
```

### Step 3: Update Environment Variables

**Connect to Hostinger via SSH/Terminal:**
```bash
ssh username@hostname
cd ~/public_html
```

**Edit .env file:**
```bash
# Make sure these are set correctly:
APP_NAME="Surface Defect Detection"
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-hostinger-domain.com

# Database (should already be configured)
DB_CONNECTION=mysql
DB_HOST=your-db-host
DB_PORT=3306
DB_DATABASE=u608200362_php_database
DB_USERNAME=your-username
DB_PASSWORD=your-password
```

### Step 4: Clear Laravel Cache

```bash
# Via SSH on Hostinger:
php artisan cache:clear
php artisan config:cache
php artisan route:cache

# Or via Laravel Tinker (if available)
php artisan tinker
> cache('clear')
> exit
```

### Step 5: Verify Deployment

**Test API Endpoints:**

Using cURL or Postman:
```bash
# Test login
curl -X POST https://your-hostinger-domain.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Should return a token

# Test get scans (with token)
curl -X GET https://your-hostinger-domain.com/api/scans \
  -H "Authorization: Bearer YOUR_TOKEN"

# Verify response is lightweight (no images/stats nested)
```

### Step 6: Test All Critical Endpoints

Using Postman or the test script:

1. **Profile Endpoint:**
   ```
   GET /api/profile
   ✓ Check avatar URL format
   ✓ Check all fields returned
   ```

2. **Scans Endpoint:**
   ```
   GET /api/scans
   ✓ Check response is lightweight
   ✓ No nested images/statistics
   ```

3. **Scan Details Endpoint:**
   ```
   GET /api/scans/{id}
   ✓ Check full data is returned
   ✓ Images and statistics included
   ```

4. **Scan Images Endpoint:**
   ```
   GET /api/scans/{id}/images
   ✓ Check only images returned
   ```

5. **Scan Statistics Endpoint:**
   ```
   GET /api/scans/{id}/statistics
   ✓ Check only statistics returned
   ```

6. **Images Filter Endpoint:**
   ```
   GET /api/images?scan_id={id}
   ✓ Check filtered results
   ```

---

## ⚠️ Common Issues & Solutions

### Issue 1: "Method Not Allowed" Error
**Symptom:** `405 Method Not Allowed`
**Solution:** Verify routes file is correct. Clear route cache:
```bash
php artisan route:clear
php artisan route:cache
```

### Issue 2: "Class Not Found" Error
**Symptom:** `Class 'App\Http\Controllers\ScanController' not found`
**Solution:** Verify files are uploaded to correct paths. Use:
```bash
php artisan tinker
> class_exists('App\Http\Controllers\ScanController')
```

### Issue 3: Avatar URLs Not Working
**Symptom:** Avatar shows as `null` or broken image
**Solution:** 
- Verify `/storage/avatars` directory exists
- Check APP_URL is correct in .env
- Verify avatar files exist in storage

### Issue 4: Large Response Freezing App
**Symptom:** App still freezes when loading scans
**Solution:** Verify these routes are correct:
```bash
# This should return ONLY basic scan data:
GET /api/scans

# Check response size is < 10KB
curl -I https://domain.com/api/scans
```

### Issue 5: CORS Issues
**Symptom:** Frontend shows CORS errors
**Solution:** Check `config/cors.php` allows your frontend domain:
```php
'allowed_origins' => ['your-frontend-domain.com'],
```

---

## 📊 Performance Verification

After deployment, verify performance:

### Check Response Sizes:
```bash
# Should be small (~5KB)
curl -X GET https://domain.com/api/scans \
  -H "Authorization: Bearer TOKEN" | wc -c

# Should be medium (~50KB) 
curl -X GET https://domain.com/api/scans/1 \
  -H "Authorization: Bearer TOKEN" | wc -c
```

### Check Response Times:
Use Postman or browser DevTools to check:
- `/scans` should load in < 100ms
- `/scans/{id}` should load in < 500ms
- `/scans/{id}/images` should load in < 200ms
- `/scans/{id}/statistics` should load in < 100ms

---

## 🔒 Security Checklist

Before going live:

- [ ] APP_DEBUG is set to `false` (not `true`)
- [ ] Database password is strong
- [ ] CORS is configured correctly
- [ ] HTTPS is enabled
- [ ] All sensitive data is in `.env` (not in code)
- [ ] API rate limiting is configured
- [ ] Authentication tokens expire properly

---

## 📞 Post-Deployment Support

### If Something Goes Wrong:

1. **Check Logs:**
   ```bash
   # View recent errors
   tail -n 100 storage/logs/laravel.log
   ```

2. **Revert Changes:**
   ```bash
   # Restore backup files if needed
   # Use git or re-upload from backup
   ```

3. **Clear Everything:**
   ```bash
   php artisan cache:clear
   php artisan config:clear
   php artisan route:clear
   php artisan view:clear
   ```

4. **Contact Hostinger Support:**
   - Provide error logs
   - Mention PHP version
   - Ask about file permissions

---

## ✅ Final Checklist

Before Announcing to Frontend Team:

- [ ] All endpoints tested on Hostinger
- [ ] Response times are acceptable
- [ ] No app freezing issues
- [ ] Avatar URLs work
- [ ] Error messages are clear
- [ ] Database is backed up
- [ ] Team has updated documentation
- [ ] Frontend is ready to use new endpoints

---

## 📝 Notes for Frontend Developer

**Important Changes to Implement in Flutter App:**

1. **Use separate endpoints:**
   ```dart
   // Get scans list first (lightweight)
   GET /api/scans
   
   // Load details when user selects a scan
   GET /api/scans/{id}/images
   GET /api/scans/{id}/statistics
   ```

2. **Handle avatar URLs:**
   ```dart
   // Avatar is now a full URL, use directly
   Image.network(userProfile.avatar)
   ```

3. **Updated profile data:**
   ```dart
   userProfile.todayScans      // Number of scans today
   userProfile.totalScans      // Total scans
   userProfile.isEmailVerified // Boolean
   userProfile.accountStatus   // 'active', 'inactive', 'suspended'
   ```

---

## 📞 Support Contacts

- **Hostinger Support:** [https://www.hostinger.com/](https://www.hostinger.com/)
- **Laravel Docs:** [https://laravel.com/docs/](https://laravel.com/docs/)
- **API Documentation:** See `API_ENDPOINTS_COMPLETE.md`

---

**Deployment Date:** [Enter date]
**Deployed By:** [Enter name]
**Status:** [Ready/In Progress/Complete]

---

## Sign-Off

Once all tests pass on Hostinger and the frontend team confirms the app works without freezing:

**✓ Ready for Production**

The API is optimized and ready to serve the Surface Defect Detection application!
