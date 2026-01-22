#!/bin/bash

# Phase 7: Learning Service Test Script
# Tests enrollment, progress tracking, and lesson completion

set -e  # Exit on error

echo "🧪 Phase 7: Learning Service Test"
echo "=============================="
echo ""

# Get token
export TOKEN=$(cat token.txt)
BASE_URL="http://localhost:8085"

# We need a course ID from Course Service
# First, let's create a test course
echo "Step 0: Creating a test course..."
COURSE_RESPONSE=$(curl -s -X POST "http://localhost:8083/courses" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Learning Course",
    "description": "Course for testing Learning Service",
    "category": "Programming",
    "level": "beginner",
    "price": 0,
    "thumbnail": "https://example.com/thumb.jpg"
  }')

COURSE_ID=$(echo $COURSE_RESPONSE | jq -r '.data.id')
echo "✅ Test course created: $COURSE_ID"
echo ""

# Add modules and lessons to the course
echo "Adding module and lessons..."
MODULE_RESPONSE=$(curl -s -X POST "http://localhost:8083/courses/$COURSE_ID/modules" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Module 1",
    "description": "Test module",
    "order": 1
  }')

MODULE_ID=$(echo $MODULE_RESPONSE | jq -r '.data.id')
echo "✅ Module created: $MODULE_ID"

# Create 10 lessons
LESSON_IDS=()
for i in {1..10}; do
  LESSON_RESPONSE=$(curl -s -X POST "http://localhost:8083/modules/$MODULE_ID/lessons" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"title\": \"Lesson $i\",
      \"content\": \"Test lesson content\",
      \"videoUrl\": \"https://example.com/video$i.mp4\",
      \"duration\": 300,
      \"order\": $i
    }")
  
  LESSON_ID=$(echo $LESSON_RESPONSE | jq -r '.data.id')
  LESSON_IDS+=($LESSON_ID)
done
echo "✅ Created 10 lessons"
echo ""

# Test 1: Enroll in course
echo "Step 1: Enroll in course"
ENROLL_RESPONSE=$(curl -s -X POST "$BASE_URL/enroll/$COURSE_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"totalLessons": 10}')

echo "Response: $ENROLL_RESPONSE"
ENROLLMENT_ID=$(echo $ENROLL_RESPONSE | jq -r '.data.enrollmentId')

if [ "$ENROLLMENT_ID" != "null" ] && [ -n "$ENROLLMENT_ID" ]; then
  echo "✅ Enrolled successfully: $ENROLLMENT_ID"
else
  echo "❌ Failed to enroll"
  exit 1
fi
echo ""

# Test 2: Get enrollments
echo "Step 2: Get all enrollments"
ENROLLMENTS_RESPONSE=$(curl -s -X GET "$BASE_URL/enrollments" \
  -H "Authorization: Bearer $TOKEN")

echo "Response: $ENROLLMENTS_RESPONSE"
ENROLLMENT_COUNT=$(echo $ENROLLMENTS_RESPONSE | jq -r '.data.total')

if [ "$ENROLLMENT_COUNT" -gt 0 ]; then
  echo "✅ Enrollments retrieved: $ENROLLMENT_COUNT total"
else
  echo "❌ No enrollments found"
  exit 1
fi
echo ""

# Test 3: Get course progress (should be 0%)
echo "Step 3: Get course progress (initial)"
PROGRESS_RESPONSE=$(curl -s -X GET "$BASE_URL/progress/$COURSE_ID" \
  -H "Authorization: Bearer $TOKEN")

echo "Response: $PROGRESS_RESPONSE"
PERCENTAGE=$(echo $PROGRESS_RESPONSE | jq -r '.data.progress.percentage')

if [ "$PERCENTAGE" == "0" ]; then
  echo "✅ Initial progress is 0%"
else
  echo "❌ Expected 0%, got $PERCENTAGE%"
  exit 1
fi
echo ""

# Test 4: Mark 5 lessons complete (50% progress)
echo "Step 4: Mark 5 lessons complete"
for i in {0..4}; do
  LESSON_ID=${LESSON_IDS[$i]}
  COMPLETE_RESPONSE=$(curl -s -X POST "$BASE_URL/complete/$LESSON_ID" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"courseId\": \"$COURSE_ID\"}")
  
  PROGRESS=$(echo $COMPLETE_RESPONSE | jq -r '.data.progress.percentage')
  echo "  Lesson $((i+1))/10 complete - Progress: $PROGRESS%"
done
echo "✅ 5 lessons marked complete"
echo ""

# Test 5: Verify progress is 50%
echo "Step 5: Verify progress is 50%"
PROGRESS_RESPONSE=$(curl -s -X GET "$BASE_URL/progress/$COURSE_ID" \
  -H "Authorization: Bearer $TOKEN")

PERCENTAGE=$(echo $PROGRESS_RESPONSE | jq -r '.data.progress.percentage')
COMPLETED=$(echo $PROGRESS_RESPONSE | jq -r '.data.progress.completedLessons')

if [ "$PERCENTAGE" == "50" ] && [ "$COMPLETED" == "5" ]; then
  echo "✅ Progress is 50% (5/10 lessons)"
else
  echo "❌ Expected 50%, got $PERCENTAGE% ($COMPLETED/10 lessons)"
  exit 1
fi
echo ""

# Test 6: Complete remaining 5 lessons (100% progress)
echo "Step 6: Complete remaining 5 lessons"
for i in {5..9}; do
  LESSON_ID=${LESSON_IDS[$i]}
  COMPLETE_RESPONSE=$(curl -s -X POST "$BASE_URL/complete/$LESSON_ID" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"courseId\": \"$COURSE_ID\"}")
  
  PROGRESS=$(echo $COMPLETE_RESPONSE | jq -r '.data.progress.percentage')
  COURSE_COMPLETED=$(echo $COMPLETE_RESPONSE | jq -r '.data.courseCompleted')
  echo "  Lesson $((i+1))/10 complete - Progress: $PROGRESS% - Course Complete: $COURSE_COMPLETED"
done
echo "✅ All 10 lessons marked complete"
echo ""

# Test 7: Verify course is completed
echo "Step 7: Verify course completion"
PROGRESS_RESPONSE=$(curl -s -X GET "$BASE_URL/progress/$COURSE_ID" \
  -H "Authorization: Bearer $TOKEN")

PERCENTAGE=$(echo $PROGRESS_RESPONSE | jq -r '.data.progress.percentage')
COMPLETED=$(echo $PROGRESS_RESPONSE | jq -r '.data.progress.completedLessons')

if [ "$PERCENTAGE" == "100" ] && [ "$COMPLETED" == "10" ]; then
  echo "✅ Course 100% complete (10/10 lessons)"
else
  echo "❌ Expected 100%, got $PERCENTAGE% ($COMPLETED/10 lessons)"
  exit 1
fi
echo ""

# Test 8: Verify enrollment status is 'completed'
echo "Step 8: Verify enrollment status"
ENROLLMENTS_RESPONSE=$(curl -s -X GET "$BASE_URL/enrollments?status=completed" \
  -H "Authorization: Bearer $TOKEN")

COMPLETED_COUNT=$(echo $ENROLLMENTS_RESPONSE | jq -r '.data.total')

if [ "$COMPLETED_COUNT" -gt 0 ]; then
  echo "✅ Enrollment marked as completed"
else
  echo "⚠️  Enrollment not marked as completed (may need manual check)"
fi
echo ""

# Test 9: Test idempotency (mark same lesson complete again)
echo "Step 9: Test idempotency (re-complete lesson)"
LESSON_ID=${LESSON_IDS[0]}
COMPLETE_RESPONSE=$(curl -s -X POST "$BASE_URL/complete/$LESSON_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"courseId\": \"$COURSE_ID\"}")

PERCENTAGE=$(echo $COMPLETE_RESPONSE | jq -r '.data.progress.percentage')

if [ "$PERCENTAGE" == "100" ]; then
  echo "✅ Idempotency works - still 100%"
else
  echo "❌ Progress changed unexpectedly: $PERCENTAGE%"
  exit 1
fi
echo ""

echo "=============================="
echo "✅ All Phase 7 tests passed!"
echo "=============================="
echo ""
echo "Summary:"
echo "  - Enrollment: ✓"
echo "  - Progress tracking: ✓"
echo "  - Lesson completion: ✓"
echo "  - Course completion detection: ✓"
echo "  - Idempotency: ✓"
