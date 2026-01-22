#!/bin/bash

# SkillSwapp Backend - Complete System Test (Phases 1-4)
# Tests all services and features

echo "🧪 SkillSwapp Backend - Complete System Test"
echo "=============================================="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
FAILED=0

test_endpoint() {
    local name=$1
    local method=$2
    local url=$3
    local headers=$4
    local data=$5
    local expected_status=$6
    
    echo -e "${BLUE}Testing: $name${NC}"
    
    if [ "$method" == "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" $headers "$url")
    else
        response=$(curl -s -w "\n%{http_code}" -X $method $headers -d "$data" "$url")
    fi
    
    status=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$status" == "$expected_status" ]; then
        echo -e "${GREEN}✅ PASSED${NC} (Status: $status)"
        ((PASSED++))
    else
        echo -e "${RED}❌ FAILED${NC} (Expected: $expected_status, Got: $status)"
        ((FAILED++))
    fi
    
    echo "$body" | jq . 2>/dev/null || echo "$body"
    echo ""
}

echo -e "${YELLOW}=== PHASE 1 & 2: AUTH SERVICE ===${NC}"
echo ""

# Test 1: Health Check
test_endpoint "Auth Service Health" "GET" "http://localhost:8081/health" "" "" "200"

# Test 2: Registration
test_endpoint "User Registration" "POST" "http://localhost:8081/register" \
    "-H 'Content-Type: application/json'" \
    '{"email":"systemtest@skillswapp.com","password":"Test123!@#","role":"student","firstName":"System","lastName":"Test"}' \
    "200"

# Test 3: Login
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8081/login \
    -H "Content-Type: application/json" \
    -d '{"email":"periclesngon01@gmail.com","password":"Test123!@#"}')

TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data.accessToken' 2>/dev/null)
USER_ID=$(echo "$LOGIN_RESPONSE" | jq -r '.data.user.id' 2>/dev/null)

if [ "$TOKEN" != "null" ] && [ -n "$TOKEN" ]; then
    echo -e "${GREEN}✅ Login successful${NC}"
    echo "Token: ${TOKEN:0:50}..."
    echo "User ID: $USER_ID"
    ((PASSED++))
else
    echo -e "${RED}❌ Login failed${NC}"
    ((FAILED++))
fi
echo ""

echo -e "${YELLOW}=== PHASE 3: API GATEWAY ===${NC}"
echo ""

# Test 4: Gateway Health
test_endpoint "API Gateway Health" "GET" "http://localhost:8080/health" "" "" "200"

# Test 5: Gateway Routing to Auth
test_endpoint "Gateway → Auth Service" "GET" "http://localhost:8080/api/auth/health" "" "" "200"

echo -e "${YELLOW}=== PHASE 4: USER SERVICE ===${NC}"
echo ""

# Test 6: User Service Health
test_endpoint "User Service Health" "GET" "http://localhost:8082/health" "" "" "200"

if [ "$TOKEN" != "null" ] && [ -n "$TOKEN" ]; then
    # Test 7: Get Profile (Protected)
    test_endpoint "Get User Profile (JWT Protected)" "GET" \
        "http://localhost:8080/api/users/profile/$USER_ID" \
        "-H 'Authorization: Bearer $TOKEN'" \
        "" "200"
    
    # Test 8: Update Profile (Protected)
    test_endpoint "Update Profile (JWT Protected)" "PUT" \
        "http://localhost:8080/api/users/profile" \
        "-H 'Authorization: Bearer $TOKEN' -H 'Content-Type: application/json'" \
        '{"bio":"Automated test user","location":"Cameroon"}' \
        "200"
    
    # Test 9: Get Settings (Protected)
    test_endpoint "Get User Settings (JWT Protected)" "GET" \
        "http://localhost:8080/api/users/settings" \
        "-H 'Authorization: Bearer $TOKEN'" \
        "" "200"
    
    # Test 10: Public Profile (No JWT)
    test_endpoint "Get Public Profile (No JWT)" "GET" \
        "http://localhost:8080/api/users/profile/$USER_ID/public" \
        "" "" "200"
else
    echo -e "${YELLOW}⚠️  Skipping protected endpoint tests (no valid token)${NC}"
    echo ""
fi

echo "=============================================="
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
echo -e "${RED}❌ Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Some tests failed${NC}"
    exit 1
fi
