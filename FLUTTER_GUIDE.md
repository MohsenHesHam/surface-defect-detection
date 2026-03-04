# Flutter Integration Guide

This guide shows how to consume the Surface Defect Detection API from a Flutter app.

## Response Format

All API responses follow this structure:

### Success Response (200, 201)

```json
{
  "success": true,
  "message": "Operation successful",
  "data": {
    "id": 1,
    "full_name": "Ahmed",
    "email": "ahmed@example.com",
    "role": "user"
  }
}
```

### List Response (200)

```json
{
  "success": true,
  "message": "Items retrieved successfully",
  "data": [
    { "id": 1, "name": "Item 1" },
    { "id": 2, "name": "Item 2" }
  ]
}
```

### Paginated Response (200)

```json
{
  "success": true,
  "message": "Items retrieved successfully",
  "data": [ ... ],
  "pagination": {
    "total": 100,
    "per_page": 10,
    "current_page": 1,
    "last_page": 10,
    "from": 1,
    "to": 10
  }
}
```

### Error Response (400, 401, 403, 422, 500)

```json
{
  "success": false,
  "message": "Invalid credentials",
  "errors": null
}
```

### Validation Error (422)

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "email": ["The email field is required"],
    "password": ["The password must be at least 8 characters"]
  }
}
```

---

## Dart/Flutter Code Examples

### 1. Install HTTP Package

```bash
flutter pub add http
```

### 2. Create API Service Class

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  static String? token;

  // Set token after login
  static void setToken(String t) {
    token = t;
  }

  // Helper: Add auth header if token exists
  static Map<String, String> getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Register
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: getHeaders(),
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
      }),
    );
    return jsonDecode(response.body);
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      setToken(data['data']['token']);
    }
    return data;
  }

  // Get current user
  static Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: getHeaders(),
    );
    return jsonDecode(response.body);
  }

  // Get all scans
  static Future<Map<String, dynamic>> getScans() async {
    final response = await http.get(
      Uri.parse('$baseUrl/scans'),
      headers: getHeaders(),
    );
    return jsonDecode(response.body);
  }

  // Create scan
  static Future<Map<String, dynamic>> createScan({
    required int userId,
    required String scanType,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scans'),
      headers: getHeaders(),
      body: jsonEncode({
        'user_id': userId,
        'scan_type': scanType,
      }),
    );
    return jsonDecode(response.body);
  }

  // Upload image to scan
  static Future<Map<String, dynamic>> uploadImageToScan({
    required int scanId,
    required String imagePath,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/images'),
    );
    
    request.headers.addAll(getHeaders());
    request.fields['scan_id'] = scanId.toString();
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    
    var response = await request.send();
    final responseData = await response.stream.bytesToString();
    return jsonDecode(responseData);
  }

  // Get defect categories
  static Future<Map<String, dynamic>> getDefectCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/defect-categories'),
      headers: getHeaders(),
    );
    return jsonDecode(response.body);
  }

  // Logout
  static Future<Map<String, dynamic>> logout() async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: getHeaders(),
    );
    setToken(null);
    return jsonDecode(response.body);
  }
}
```

### 3. Handle Responses in UI

```dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() => isLoading = true);

    try {
      final response = await ApiService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response['success'] == true) {
        // Login successful
        print('Token: ${response['data']['token']}');
        print('User: ${response['data']['user']}');
        
        // Navigate to home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 4. Models (Optional but Recommended)

```dart
class User {
  final int id;
  final String fullName;
  final String email;
  final String role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataParser,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataParser != null && json['data'] != null
          ? dataParser(json['data'])
          : null,
      errors: json['errors'],
    );
  }
}
```

### 5. Provider Pattern (Recommended for State Management)

```dart
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  User? currentUser;
  String? token;
  bool isLoading = false;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.login(
        email: email,
        password: password,
      );

      if (response['success'] == true) {
        token = response['data']['token'];
        currentUser = User.fromJson(response['data']['user']);
        ApiService.setToken(token!);
        isLoading = false;
        notifyListeners();
        return true;
      }
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.logout();
    currentUser = null;
    token = null;
    notifyListeners();
  }
}
```

---

## Error Handling Best Practices

```dart
Future<void> safeApiCall(Future Function() apiCall) async {
  try {
    await apiCall();
  } on SocketException {
    print('Network error');
  } on TimeoutException {
    print('Request timeout');
  } catch (e) {
    print('Unknown error: $e');
  }
}
```

---

## Testing with Postman First

Before implementing in Flutter:
1. Test all endpoints with Postman
2. Save token from login
3. Add Bearer token to Authorization header
4. Check response format matches

---

## Common Issues

| Issue | Solution |
|-------|----------|
| CORS error | Backend needs CORS headers (check if configured) |
| SSL error on Android | Add cleartext traffic config for localhost |
| Token expires | Implement refresh token flow |
| Image upload fails | Check Content-Type is multipart/form-data |

---

## Quick Setup Checklist

- [ ] Add `http` package to pubspec.yaml
- [ ] Copy ApiService class
- [ ] Test login endpoint first
- [ ] Save token locally (use `shared_preferences`)
- [ ] Implement logout
- [ ] Add error handling
- [ ] Use Provider for state management
