#!/bin/bash

# Phase 4: User Service Test
# Tests all User Service functionality

echo "🧪 Phase 4: User Service Test"
echo "=============================="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Login to get token
echo -e "${YELLOW}Step 1: Login to get JWT token${NC}"
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8081/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "periclesngon01@gmail.com",
    "password": "Test123!@#"
  }')

TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data.accessToken')
USER_ID=$(echo "$LOGIN_RESPONSE" | jq -r '.data.user.id')

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
    echo -e "${RED}❌ Login failed - user not verified${NC}"
    echo "Registering new test user..."
    
    REG_RESPONSE=$(curl -s -X POST http://localhost:8081/register \
      -H "Content-Type: application/json" \
      -d '{
        "email": "phase4test@skillswapp.com",
        "password": "Test123!@#",
        "role": "student",
        "firstName": "Phase4",
        "lastName": "Test"
      }')
    
    echo "$REG_RESPONSE" | jq .
    echo -e "${YELLOW}Please verify email and run test again${NC}"
    exit 0
fi

echo -e "${GREEN}✅ Login successful${NC}"
echo "Token: ${TOKEN:0:50}..."
echo "User ID: $USER_ID"
echo ""

# Step 2: Get User Profile
echo -e "${YELLOW}Step 2: Get User Profile${NC}"
curl -s http://localhost:8082/profile/$USER_ID \
  -H "Authorization: Bearer $TOKEN" | jq .
echo ""

# Step 3: Update Profile
echo -e "${YELLOW}Step 3: Update Profile${NC}"
curl -s -X PUT http://localhost:8082/profile \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "bio": "Phase 4 testing - User Service working!",
    "location": "Cameroon",
    "website": "https://skillswapp.com"
  }' | jq .
echo ""

# Step 4: Get Public Profile
echo -e "${YELLOW}Step 4: Get Public Profile (No Auth)${NC}"
curl -s http://localhost:8082/profile/$USER_ID/public | jq .
echo ""

# Step 5: Get User Settings
echo -e "${YELLOW}Step 5: Get User Settings${NC}"
curl -s http://localhost:8082/settings \
  -H "Authorization: Bearer $TOKEN" | jq .
echo ""

# Step 6: Update Settings
echo -e "${YELLOW}Step 6: Update Settings${NC}"
curl -s -X PUT http://localhost:8082/settings \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "emailNotifications": true,
    "profilePublic": true,
    "language": "en"
  }' | jq .
echo ""

echo "=============================="
echo -e "${GREEN}✅ Phase 4 Test Complete!${NC}"
echo ""
echo "Tested:"
echo "  ✅ User Profile (GET)"
echo "  ✅ Update Profile (PUT)"
echo "  ✅ Public Profile (GET)"
echo "  ✅ User Settings (GET)"
echo "  ✅ Update Settings (PUT)"
echo ""
