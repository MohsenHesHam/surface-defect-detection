#!/bin/bash
# API Testing Script for Graduation Project

# Base URL
BASE_URL="http://localhost:8000/api"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Graduation Project Backend API Testing ===${NC}\n"

# Test 1: Register User
echo -e "${BLUE}1. Testing User Registration${NC}"
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "full_name": "Test User",
    "email": "test@example.com",
    "phone": "+1234567890",
    "password": "password123",
    "password_confirmation": "password123"
  }')
echo "$REGISTER_RESPONSE" | jq .
echo ""

# Test 2: Login User
echo -e "${BLUE}2. Testing User Login${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }')
echo "$LOGIN_RESPONSE" | jq .

# Extract token from login response
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.token')
echo -e "${GREEN}Token: $TOKEN${NC}\n"

# Test 3: Get Current User
echo -e "${BLUE}3. Testing Get Current User${NC}"
curl -s -X GET "$BASE_URL/auth/me" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" | jq .
echo ""

# Test 4: Send Email Verification
echo -e "${BLUE}4. Testing Send Email Verification Code${NC}"
curl -s -X POST "$BASE_URL/auth/send-email-verification" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com"
  }' | jq .
echo ""

# Test 5: Verify Email (using code from response)
echo -e "${BLUE}5. Testing Email Verification${NC}"
curl -s -X POST "$BASE_URL/auth/verify-email" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "code": "123456"
  }' | jq .
echo ""

# Test 6: Send Phone Verification
echo -e "${BLUE}6. Testing Send Phone Verification Code${NC}"
curl -s -X POST "$BASE_URL/auth/send-phone-verification" \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "+1234567890"
  }' | jq .
echo ""

# Test 7: Verify Phone
echo -e "${BLUE}7. Testing Phone Verification${NC}"
curl -s -X POST "$BASE_URL/auth/verify-phone" \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "+1234567890",
    "code": "654321"
  }' | jq .
echo ""

# Test 8: Create Activity (Protected)
echo -e "${BLUE}8. Testing Create Activity (Protected)${NC}"
curl -s -X POST "$BASE_URL/activities" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "scan_id": 1,
    "title": "Test Activity",
    "description": "This is a test activity",
    "status": "pending"
  }' | jq .
echo ""

# Test 9: Create Defect Category
echo -e "${BLUE}9. Testing Create Defect Category${NC}"
curl -s -X POST "$BASE_URL/defect-categories" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Surface Crack",
    "description": "A crack on the product surface",
    "severity_level": "high"
  }' | jq .
echo ""

# Test 10: Get All Users (Protected)
echo -e "${BLUE}10. Testing Get All Users${NC}"
curl -s -X GET "$BASE_URL/users" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" | jq .
echo ""

# Test 11: Logout
echo -e "${BLUE}11. Testing Logout${NC}"
curl -s -X POST "$BASE_URL/auth/logout" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" | jq .
echo ""

echo -e "${GREEN}=== All tests completed ===${NC}"
