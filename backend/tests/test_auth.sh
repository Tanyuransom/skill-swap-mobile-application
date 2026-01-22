#!/bin/bash

# SkillSwapp Auth Service - Complete Test Suite

echo "🧪 SkillSwapp Auth Service Test Suite"
echo "======================================"
echo ""

BASE_URL="http://localhost:8081"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== 1. REGISTRATION FLOW ===${NC}"
echo "Testing user registration with OTP email..."
REGISTER_RESPONSE=$(curl -s -X POST $BASE_URL/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@skillswapp.com",
    "password": "Test123!@#",
    "role": "student",
    "firstName": "Test",
    "lastName": "User"
  }')

echo "$REGISTER_RESPONSE" | jq .
USER_ID=$(echo "$REGISTER_RESPONSE" | jq -r '.data.userId')
EMAIL=$(echo "$REGISTER_RESPONSE" | jq -r '.data.email')

if [ "$USER_ID" != "null" ]; then
    echo -e "${GREEN}✅ Registration successful!${NC}"
    echo "User ID: $USER_ID"
    echo "Email: $EMAIL"
    echo -e "${YELLOW}📧 Check your email for OTP code${NC}"
else
    echo -e "${RED}❌ Registration failed${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}=== 2. OTP VERIFICATION ===${NC}"
read -p "Enter the OTP code from your email: " OTP

VERIFY_RESPONSE=$(curl -s -X POST $BASE_URL/verify-otp \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$EMAIL\",
    \"otp\": \"$OTP\"
  }")

echo "$VERIFY_RESPONSE" | jq .
ACCESS_TOKEN=$(echo "$VERIFY_RESPONSE" | jq -r '.data.accessToken')
REFRESH_TOKEN=$(echo "$VERIFY_RESPONSE" | jq -r '.data.refreshToken')

if [ "$ACCESS_TOKEN" != "null" ]; then
    echo -e "${GREEN}✅ OTP verified! JWT tokens generated${NC}"
    echo "Access Token: ${ACCESS_TOKEN:0:50}..."
    echo "Refresh Token: ${REFRESH_TOKEN:0:50}..."
else
    echo -e "${RED}❌ OTP verification failed${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}=== 3. LOGIN FLOW ===${NC}"
echo "Testing login with email/password..."
LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/login \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$EMAIL\",
    \"password\": \"Test123!@#\"
  }")

echo "$LOGIN_RESPONSE" | jq .
NEW_ACCESS_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data.accessToken')

if [ "$NEW_ACCESS_TOKEN" != "null" ]; then
    echo -e "${GREEN}✅ Login successful! New JWT generated${NC}"
    ACCESS_TOKEN=$NEW_ACCESS_TOKEN
else
    echo -e "${RED}❌ Login failed${NC}"
fi

echo ""
echo -e "${YELLOW}=== 4. JWT VALIDATION (Get Current User) ===${NC}"
echo "Testing protected endpoint with JWT..."
ME_RESPONSE=$(curl -s -X GET $BASE_URL/me \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "$ME_RESPONSE" | jq .

if echo "$ME_RESPONSE" | jq -e '.success' > /dev/null; then
    echo -e "${GREEN}✅ JWT validation successful!${NC}"
else
    echo -e "${RED}❌ JWT validation failed${NC}"
fi

echo ""
echo -e "${YELLOW}=== 5. TOKEN REFRESH ===${NC}"
echo "Testing refresh token..."
REFRESH_RESPONSE=$(curl -s -X POST $BASE_URL/refresh-token \
  -H "Content-Type: application/json" \
  -d "{
    \"refreshToken\": \"$REFRESH_TOKEN\"
  }")

echo "$REFRESH_RESPONSE" | jq .

if echo "$REFRESH_RESPONSE" | jq -e '.data.accessToken' > /dev/null; then
    echo -e "${GREEN}✅ Token refresh successful!${NC}"
else
    echo -e "${RED}❌ Token refresh failed${NC}"
fi

echo ""
echo -e "${YELLOW}=== 6. PASSWORD RESET FLOW ===${NC}"
echo "Step 1: Request password reset..."
FORGOT_RESPONSE=$(curl -s -X POST $BASE_URL/forgot-password \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$EMAIL\"
  }")

echo "$FORGOT_RESPONSE" | jq .
echo -e "${YELLOW}📧 Check your email for password reset OTP${NC}"

read -p "Enter the password reset OTP: " RESET_OTP

echo "Step 2: Reset password with OTP..."
RESET_RESPONSE=$(curl -s -X POST $BASE_URL/reset-password \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$EMAIL\",
    \"otp\": \"$RESET_OTP\",
    \"newPassword\": \"NewPass123!@#\"
  }")

echo "$RESET_RESPONSE" | jq .

if echo "$RESET_RESPONSE" | jq -e '.success' > /dev/null; then
    echo -e "${GREEN}✅ Password reset successful!${NC}"
    
    echo "Step 3: Login with new password..."
    NEW_LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/login \
      -H "Content-Type: application/json" \
      -d "{
        \"email\": \"$EMAIL\",
        \"password\": \"NewPass123!@#\"
      }")
    
    echo "$NEW_LOGIN_RESPONSE" | jq .
    
    if echo "$NEW_LOGIN_RESPONSE" | jq -e '.data.accessToken' > /dev/null; then
        echo -e "${GREEN}✅ Login with new password successful!${NC}"
    else
        echo -e "${RED}❌ Login with new password failed${NC}"
    fi
else
    echo -e "${RED}❌ Password reset failed${NC}"
fi

echo ""
echo -e "${YELLOW}=== 7. LOGOUT ===${NC}"
LOGOUT_RESPONSE=$(curl -s -X POST $BASE_URL/logout \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "$LOGOUT_RESPONSE" | jq .

if echo "$LOGOUT_RESPONSE" | jq -e '.success' > /dev/null; then
    echo -e "${GREEN}✅ Logout successful!${NC}"
else
    echo -e "${RED}❌ Logout failed${NC}"
fi

echo ""
echo "======================================"
echo -e "${GREEN}🎉 All tests completed!${NC}"
echo ""
echo "Summary of implemented features:"
echo "✅ Registration with email validation"
echo "✅ OTP email sending (Gmail SMTP)"
echo "✅ OTP verification"
echo "✅ JWT generation (access + refresh tokens)"
echo "✅ Login with password hashing (bcrypt)"
echo "✅ JWT validation on protected routes"
echo "✅ Token refresh"
echo "✅ Password reset with OTP"
echo "✅ Logout with session invalidation"
echo ""
echo "⚠️  Google OAuth: Backend ready, needs Google API credentials"
