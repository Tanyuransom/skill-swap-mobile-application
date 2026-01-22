#!/bin/bash

# Phase 5: Course Service Test
# Test user: pepe@gmail.com / Pepe1234!

echo "🧪 Phase 5: Course Service Test"
echo "=============================="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test credentials
TEST_EMAIL="pepe@gmail.com"
TEST_PASSWORD="Pepe1234!"

# Step 1: Login
echo -e "${YELLOW}Step 1: Login as Test User${NC}"
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8081/login \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$TEST_EMAIL\",
    \"password\": \"$TEST_PASSWORD\"
  }")

echo "$LOGIN_RESPONSE" | jq .
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data.accessToken')

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
    echo -e "${RED}❌ Login failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Login successful${NC}"
echo "Token: ${TOKEN:0:30}..."
echo ""

# Step 2: Create Course
echo -e "${YELLOW}Step 2: Create Course${NC}"
COURSE_RESPONSE=$(curl -s -X POST http://localhost:8083/courses \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Flutter Masterclass 2024",
    "description": "Complete guide to building scalable mobile apps with Flutter and Dart backend microservices.",
    "category": "Programming",
    "price": 49.99,
    "level": "intermediate"
  }')

echo "$COURSE_RESPONSE" | jq .
COURSE_ID=$(echo "$COURSE_RESPONSE" | jq -r '.data.id')

if [ "$COURSE_ID" == "null" ] || [ -z "$COURSE_ID" ]; then
    echo -e "${RED}❌ Failed to create course${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Course created: $COURSE_ID${NC}"
echo ""

# Step 3: List Courses (Public)
echo -e "${YELLOW}Step 3: List All Courses (Public)${NC}"
curl -s http://localhost:8083/courses | jq .
echo ""

# Step 4: Add Module
echo -e "${YELLOW}Step 4: Add Module to Course${NC}"
MODULE_RESPONSE=$(curl -s -X POST http://localhost:8083/courses/$COURSE_ID/modules \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Introduction to Clean Architecture",
    "description": "Understanding layers and separation of concerns in Flutter apps."
  }')

echo "$MODULE_RESPONSE" | jq .
MODULE_ID=$(echo "$MODULE_RESPONSE" | jq -r '.data.id')
echo -e "${GREEN}✅ Module added: $MODULE_ID${NC}"
echo ""

# Step 5: Add Lesson
echo -e "${YELLOW}Step 5: Add Lesson to Module${NC}"
LESSON_RESPONSE=$(curl -s -X POST http://localhost:8083/modules/$MODULE_ID/lessons \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Setup Project Structure",
    "content": "Learn how to organize your Flutter project with clean architecture principles.",
    "type": "video",
    "videoUrl": "https://example.com/video1.mp4",
    "duration": 15
  }')

echo "$LESSON_RESPONSE" | jq .
LESSON_ID=$(echo "$LESSON_RESPONSE" | jq -r '.data.id')
echo -e "${GREEN}✅ Lesson added: $LESSON_ID${NC}"
echo ""

# Step 6: Get Course Details
echo -e "${YELLOW}Step 6: Get Course Details with Modules & Lessons${NC}"
curl -s http://localhost:8083/courses/$COURSE_ID | jq .
echo ""

# Step 7: Update Course
echo -e "${YELLOW}Step 7: Update Course (Publish)${NC}"
curl -s -X PUT http://localhost:8083/courses/$COURSE_ID \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "price": 59.99,
    "status": "published"
  }' | jq .
echo ""

# Step 8: Search Courses
echo -e "${YELLOW}Step 8: Search Courses${NC}"
curl -s "http://localhost:8083/courses/search?q=Flutter" | jq .
echo ""

# Step 9: Get My Courses
echo -e "${YELLOW}Step 9: Get My Courses (Tutor)${NC}"
curl -s http://localhost:8083/my-courses \
  -H "Authorization: Bearer $TOKEN" | jq .
echo ""

echo "=============================="
echo -e "${GREEN}✅ Phase 5 Test Complete!${NC}"
echo ""
echo "Summary:"
echo "  - Created course with modules and lessons"
echo "  - Updated course status to published"
echo "  - Tested public endpoints (list, search, details)"
echo "  - Tested protected endpoints (create, update)"
