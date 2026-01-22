#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost:8080"
EMAIL="tutor@example.com"        # change to an existing, verified tutor
PASSWORD="Password123!"          # change to the correct password

echo "== Login =="
LOGIN_RES=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d @- <<EOF2
{
  "email": "$EMAIL",
  "password": "$PASSWORD"
}
EOF2
)

echo "Login response: $LOGIN_RES"
ACCESS_TOKEN=$(echo "$LOGIN_RES" | jq -r '.data.accessToken')
if [ "$ACCESS_TOKEN" = "null" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "Failed to get access token"; exit 1
fi

echo
echo "== Create course =="
CREATE_COURSE_RES=$(curl -s -X POST "$BASE_URL/api/courses/courses" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{
    "title": "Test Course",
    "description": "This is a test course description with more than 20 characters.",
    "price": 19.99,
    "difficultyLevel": "beginner",
    "durationHours": 5
  }')

echo "Create course response: $CREATE_COURSE_RES"
COURSE_ID=$(echo "$CREATE_COURSE_RES" | jq -r '.data.id')
if [ "$COURSE_ID" = "null" ] || [ -z "$COURSE_ID" ]; then
  echo "Failed to get course id"; exit 1
fi

echo
echo "== Add module =="
ADD_MODULE_RES=$(curl -s -X POST "$BASE_URL/api/courses/courses/$COURSE_ID/modules" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{
    "title": "Module 1",
    "description": "Intro module"
  }')

echo "Add module response: $ADD_MODULE_RES"
MODULE_ID=$(echo "$ADD_MODULE_RES" | jq -r '.data.id')
if [ "$MODULE_ID" = "null" ] || [ -z "$MODULE_ID" ]; then
  echo "Failed to get module id"; exit 1
fi

echo
echo "== Add lesson =="
ADD_LESSON_RES=$(curl -s -X POST "$BASE_URL/api/courses/modules/$MODULE_ID/lessons" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{
    "title": "Lesson 1",
    "content": "Some lesson content",
    "videoUrl": "https://example.com/video.mp4",
    "durationMinutes": 10,
    "isFree": true
  }')

echo "Add lesson response: $ADD_LESSON_RES"
LESSON_ID=$(echo "$ADD_LESSON_RES" | jq -r '.data.id')
if [ "$LESSON_ID" = "null" ] || [ -z "$LESSON_ID" ]; then
  echo "Failed to get lesson id"; exit 1
fi

echo
echo "== Get course with modules & lessons =="
COURSE_DETAIL=$(curl -s -X GET "$BASE_URL/api/courses/courses/$COURSE_ID")
echo "Course detail: $COURSE_DETAIL"

echo
echo "== Get my courses (authenticated tutor) =="
MY_COURSES=$(curl -s -X GET "$BASE_URL/api/courses/my-courses" \
  -H "Authorization: Bearer $ACCESS_TOKEN")
echo "My courses: $MY_COURSES"

echo
echo "== Search courses (published only) =="
SEARCH_RES=$(curl -s -X GET "$BASE_URL/api/courses/courses/search?q=Test")
echo "Search result: $SEARCH_RES"

echo
echo "== Delete lesson =="
curl -s -X DELETE "$BASE_URL/api/courses/lessons/$LESSON_ID" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -o /dev/null -w "Status: %{http_code}\n"

echo
echo "== Delete module =="
curl -s -X DELETE "$BASE_URL/api/courses/modules/$MODULE_ID" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -o /dev/null -w "Status: %{http_code}\n"

echo
echo "== Delete course =="
curl -s -X DELETE "$BASE_URL/api/courses/courses/$COURSE_ID" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -o /dev/null -w "Status: %{http_code}\n"

echo
echo "✅ Course flow test completed successfully"
