#!/bin/bash
# API Testing Script for Surface Defect Detection Application
# Tests all API endpoints and displays responses

# Configuration
BASE_URL="http://localhost:8000/api"  # Change to your Hostinger URL
TEST_EMAIL="test@example.com"
TEST_PASSWORD="password123"
TEST_PHONE="01234567890"
TEST_USER_FULLNAME="Test User"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print test header
print_test() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
    echo "Endpoint: $2"
}

# Function to print response
print_response() {
    echo "Response:"
    echo "$1" | jq '.' 2>/dev/null || echo "$1"
}

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     API Endpoint Testing - Surface Defect Detection     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo -e "Base URL: ${YELLOW}$BASE_URL${NC}\n"

# ============================================
# PUBLIC ENDPOINTS (No Authentication)
# ============================================

echo -e "\n${YELLOW}═══ PUBLIC ENDPOINTS ═══${NC}"

# Test 1: Register User
print_test "1. User Registration" "POST /auth/register"
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"full_name\": \"$TEST_USER_FULLNAME\",
    \"email\": \"$TEST_EMAIL\",
    \"phone\": \"$TEST_PHONE\",
    \"password\": \"$TEST_PASSWORD\"
  }")
print_response "$REGISTER_RESPONSE"

# Test 2: Login User
print_test "2. User Login" "POST /auth/login"
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$TEST_EMAIL\",
    \"password\": \"$TEST_PASSWORD\"
  }")
print_response "$LOGIN_RESPONSE"

# Extract token for authenticated requests
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data.token // .token // empty')
if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    echo -e "${RED}Warning: Could not extract token. Using dummy token for tests.${NC}"
    TOKEN="test_token_dummy"
fi
echo -e "${GREEN}Extracted Token: ${TOKEN:0:50}...${NC}"

# ============================================
# PROTECTED ENDPOINTS (Authentication Required)
# ============================================

echo -e "\n${YELLOW}═══ PROTECTED ENDPOINTS ═══${NC}"

# Test 3: Get User Profile
print_test "3. Get User Profile" "GET /profile"
PROFILE_RESPONSE=$(curl -s -X GET "$BASE_URL/profile" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$PROFILE_RESPONSE"

# Extract user ID from profile for later tests
USER_ID=$(echo "$PROFILE_RESPONSE" | jq -r '.data.id // .id // "29"')

# Test 4: Get Scans List (Lightweight - No Images/Stats)
print_test "4. Get Scans List (Lightweight)" "GET /scans"
SCANS_LIST=$(curl -s -X GET "$BASE_URL/scans" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$SCANS_LIST"

# Extract scan ID for detailed tests
SCAN_ID=$(echo "$SCANS_LIST" | jq -r '.data[0].id // "42"')

# Test 5: Get Specific Scan (Full Details with Images & Stats)
print_test "5. Get Scan Details (Full)" "GET /scans/{id}"
SCAN_DETAILS=$(curl -s -X GET "$BASE_URL/scans/$SCAN_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$SCAN_DETAILS"

# Test 6: Get Scan Images ONLY
print_test "6. Get Scan Images Only" "GET /scans/{id}/images"
SCAN_IMAGES=$(curl -s -X GET "$BASE_URL/scans/$SCAN_ID/images" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$SCAN_IMAGES"

# Test 7: Get Scan Statistics ONLY
print_test "7. Get Scan Statistics Only" "GET /scans/{id}/statistics"
SCAN_STATS=$(curl -s -X GET "$BASE_URL/scans/$SCAN_ID/statistics" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$SCAN_STATS"

# Test 8: Get All Images (with optional scan_id filter)
print_test "8. Get All Images" "GET /images"
ALL_IMAGES=$(curl -s -X GET "$BASE_URL/images" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$ALL_IMAGES"

# Test 9: Get Images Filtered by Scan ID
print_test "9. Get Images for Specific Scan" "GET /images?scan_id={id}"
FILTERED_IMAGES=$(curl -s -X GET "$BASE_URL/images?scan_id=$SCAN_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$FILTERED_IMAGES"

# Test 10: Get Defect Categories
print_test "10. Get Defect Categories" "GET /defect-categories"
CATEGORIES=$(curl -s -X GET "$BASE_URL/defect-categories" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$CATEGORIES"

# Test 11: Get Image Defects
print_test "11. Get Image Defects" "GET /image-defects"
DEFECTS=$(curl -s -X GET "$BASE_URL/image-defects" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$DEFECTS"

# Test 12: Get Scan Statistics List
print_test "12. Get Scan Statistics List" "GET /scan-statistics"
STATS_LIST=$(curl -s -X GET "$BASE_URL/scan-statistics" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$STATS_LIST"

# Test 13: Get Activities
print_test "13. Get Activities" "GET /activities"
ACTIVITIES=$(curl -s -X GET "$BASE_URL/activities" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$ACTIVITIES"

# Test 14: Get Notifications
print_test "14. Get Notifications" "GET /notifications"
NOTIFICATIONS=$(curl -s -X GET "$BASE_URL/notifications" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$NOTIFICATIONS"

# Test 15: Get User Statistics
print_test "15. Get User Analytics" "GET /user-statistics/analytics"
USER_ANALYTICS=$(curl -s -X GET "$BASE_URL/user-statistics/analytics" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$USER_ANALYTICS"

# Test 16: Get Dashboard
print_test "16. Get User Dashboard" "GET /user-statistics/dashboard"
DASHBOARD=$(curl -s -X GET "$BASE_URL/user-statistics/dashboard" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$DASHBOARD"

# Test 17: Get Analytics Summary
print_test "17. Get Analytics Summary" "GET /analytics/summary"
ANALYTICS=$(curl -s -X GET "$BASE_URL/analytics/summary" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$ANALYTICS"

# Test 18: Get Flutter Report
print_test "18. Get Scan Flutter Report" "GET /scans/{id}/flutter-report"
FLUTTER_REPORT=$(curl -s -X GET "$BASE_URL/scans/$SCAN_ID/flutter-report" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$FLUTTER_REPORT"

# Test 19: Logout
print_test "19. User Logout" "POST /auth/logout"
LOGOUT=$(curl -s -X POST "$BASE_URL/auth/logout" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")
print_response "$LOGOUT"

# Summary
echo -e "\n${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Testing Complete!                          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo -e "\n${YELLOW}Summary:${NC}"
echo "✓ All public endpoints tested (Register, Login)"
echo "✓ All protected endpoints tested (Profile, Scans, Images, Stats)"
echo "✓ Separate data endpoints tested (Images only, Stats only)"
echo "✓ Filter endpoints tested (Images by Scan ID)"
echo "✓ Analytics endpoints tested"
echo -e "\n${BLUE}Next Steps:${NC}"
echo "1. Check that /scans returns lightweight data (no nested images/stats)"
echo "2. Check that /scans/{id}/images returns only images"
echo "3. Check that /scans/{id}/statistics returns only statistics"
echo "4. Verify avatar URLs are properly formatted"
echo "5. Deploy to Hostinger when all tests pass"
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
