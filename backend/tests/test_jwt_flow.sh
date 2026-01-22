#!/bin/bash

# Complete JWT Authentication Flow Test
# This demonstrates how JWT protection works in SkillSwapp

echo "🔐 JWT Authentication Flow Test"
echo "================================"
echo ""

BASE_URL="http://localhost:8080"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== STEP 1: Login to get JWT token ===${NC}"
echo "Logging in with existing user..."
LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "periclesngon01@gmail.com",
    "password": "Test123!@#"
  }')

echo "$LOGIN_RESPONSE" | jq .

# Extract access token
ACCESS_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data.accessToken')
USER_ID=$(echo "$LOGIN_RESPONSE" | jq -r '.data.user.id')

if [ "$ACCESS_TOKEN" == "null" ] || [ -z "$ACCESS_TOKEN" ]; then
    echo -e "${YELLOW}⚠️  Login failed. Using test registration...${NC}"
    
    # Register new user
    REG_RESPONSE=$(curl -s -X POST $BASE_URL/api/auth/register \
      -H "Content-Type: application/json" \
      -d '{
        "email": "jwttest@skillswapp.com",
        "password": "Test123!@#",
        "role": "student",
        "firstName": "JWT",
        "lastName": "Test"
      }')
    
    echo "$REG_RESPONSE" | jq .
    echo ""
    echo -e "${YELLOW}📧 Check email for OTP and verify, then run this script again${NC}"
    exit 0
fi

echo -e "${GREEN}✅ Login successful!${NC}"
echo "Access Token: ${ACCESS_TOKEN:0:50}..."
echo "User ID: $USER_ID"
echo ""

echo -e "${BLUE}=== STEP 2: Access PUBLIC endpoint (No JWT needed) ===${NC}"
echo "GET /api/users/profile/$USER_ID/public"
PUBLIC_RESPONSE=$(curl -s http://localhost:8080/api/users/profile/$USER_ID/public)
echo "$PUBLIC_RESPONSE" | jq .
echo ""

echo -e "${BLUE}=== STEP 3: Try PROTECTED endpoint WITHOUT JWT (Should FAIL) ===${NC}"
echo "GET /api/users/profile/$USER_ID (without Authorization header)"
NO_AUTH_RESPONSE=$(curl -s http://localhost:8080/api/users/profile/$USER_ID)
echo "$NO_AUTH_RESPONSE" | jq .
echo ""

echo -e "${BLUE}=== STEP 4: Access PROTECTED endpoint WITH JWT (Should SUCCEED) ===${NC}"
echo "GET /api/users/profile/$USER_ID (with Authorization: Bearer TOKEN)"
PROFILE_RESPONSE=$(curl -s http://localhost:8080/api/users/profile/$USER_ID \
  -H "Authorization: Bearer $ACCESS_TOKEN")
echo "$PROFILE_RESPONSE" | jq .
echo ""

echo -e "${BLUE}=== STEP 5: Update Profile (Protected) ===${NC}"
echo "PUT /api/users/profile"
UPDATE_RESPONSE=$(curl -s -X PUT http://localhost:8080/api/users/profile \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "bio": "Testing JWT authentication flow",
    "location": "Cameroon",
    "website": "https://skillswapp.com"
  }')
echo "$UPDATE_RESPONSE" | jq .
echo ""

echo -e "${BLUE}=== STEP 6: Get User Settings (Protected) ===${NC}"
echo "GET /api/users/settings"
SETTINGS_RESPONSE=$(curl -s http://localhost:8080/api/users/settings \
  -H "Authorization: Bearer $ACCESS_TOKEN")
echo "$SETTINGS_RESPONSE" | jq .
echo ""

echo -e "${BLUE}=== STEP 7: Update Settings (Protected) ===${NC}"
echo "PUT /api/users/settings"
UPDATE_SETTINGS=$(curl -s -X PUT http://localhost:8080/api/users/settings \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "emailNotifications": true,
    "profilePublic": true,
    "language": "en"
  }')
echo "$UPDATE_SETTINGS" | jq .
echo ""

echo "================================"
echo -e "${GREEN}🎉 JWT Authentication Flow Complete!${NC}"
echo ""
echo -e "${YELLOW}📚 How JWT Protection Works:${NC}"
echo ""
echo "1. **Login** → Server generates JWT token"
echo "2. **Client stores token** (localStorage/secure storage)"
echo "3. **Protected requests** → Include 'Authorization: Bearer TOKEN' header"
echo "4. **Server validates** → Checks JWT signature & expiry"
echo "5. **Extract user info** → Gets userId from token payload"
echo "6. **Process request** → Uses userId for database queries"
echo ""
echo -e "${YELLOW}🔒 Security Features:${NC}"
echo "✅ JWT signed with secret key (HS256)"
echo "✅ Access token expires in 1 hour"
echo "✅ Refresh token for getting new access tokens"
echo "✅ User ID embedded in token (no database lookup needed)"
echo "✅ Middleware validates token on every protected route"
echo ""
