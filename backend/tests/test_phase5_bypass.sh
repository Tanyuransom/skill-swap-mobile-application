#!/bin/bash
# Test Script for Phase 5: Course Service (Bypassing Login)

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
YELLOW='\033[1;33m'

# Check if TOKEN argument is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: JWT Token must be provided as first argument${NC}"
    echo "Usage: ./test_phase5_bypass.sh <jwt_token>"
    exit 1
fi

TOKEN="$1"
API_URL="http://localhost:8080/api/courses" # Using Gateway
# API_URL="http://localhost:8083" # Direct to Service (use if Gateway fails)

echo -e "${YELLOW}🧪 Phase 5: Course Service Test (Bypass Login)${NC}"
echo "=============================="
echo "Using Token: ${TOKEN:0:10}..."

# 2. Create Course
echo -e "\n${YELLOW}Step 2: Create Course${NC}"
CREATE_RESPONSE=$(curl -s -X POST "$API_URL" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Flutter Advanced Masterclass",
    "description": "Master Flutter with advanced concepts and architecture.",
    "category": "Development",
    "price": 49.99,
    "level": "advanced"
  }')

echo "Response: $CREATE_RESPONSE"

COURSE_ID=$(echo $CREATE_RESPONSE | jq -r '.data.id')

if [ "$COURSE_ID" != "null" ] && [ -n "$COURSE_ID" ]; then
    echo -e "${GREEN}✅ Course created with ID: $COURSE_ID${NC}"
else
    echo -e "${RED}❌ Failed to create course${NC}"
    exit 1
fi

# 3. Get All Courses
echo -e "\n${YELLOW}Step 3: Get All Courses${NC}"
curl -s -X GET "$API_URL" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 4. Get Course Details
echo -e "\n${YELLOW}Step 4: Get Course Details${NC}"
curl -s -X GET "$API_URL/$COURSE_ID" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 5. Update Course
echo -e "\n${YELLOW}Step 5: Update Course${NC}"
curl -s -X PUT "$API_URL/$COURSE_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Flutter Advanced Masterclass (Updated)",
    "price": 59.99
  }' | jq .

# 6. Add Module
echo -e "\n${YELLOW}Step 6: Add Module${NC}"
MODULE_RESPONSE=$(curl -s -X POST "$API_URL/$COURSE_ID/modules" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Architecture Patterns",
    "orderIndex": 0
  }')

echo "Response: $MODULE_RESPONSE"
MODULE_ID=$(echo $MODULE_RESPONSE | jq -r '.data.id')

if [ "$MODULE_ID" != "null" ]; then
    echo -e "${GREEN}✅ Module created with ID: $MODULE_ID${NC}"
else
    echo -e "${RED}❌ Failed to create module${NC}"
    exit 1
fi

# 7. Add Lesson
echo -e "\n${YELLOW}Step 7: Add Lesson${NC}"
curl -s -X POST "$API_URL/modules/$MODULE_ID/lessons" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Clean Architecture",
    "content": "Video URL or text content here",
    "duration": 45,
    "orderIndex": 0
  }' | jq .

# 8. Search Courses
echo -e "\n${YELLOW}Step 8: Search Courses${NC}"
curl -s -X GET "$API_URL/search?query=Flutter" \
  -H "Authorization: Bearer $TOKEN" | jq .

# 9. Delete Course
echo -e "\n${YELLOW}Step 9: Delete Course${NC}"
curl -s -X DELETE "$API_URL/$COURSE_ID" \
  -H "Authorization: Bearer $TOKEN" | jq .

echo -e "\n${GREEN}🎉 Phase 5 Tests Completed!${NC}"
