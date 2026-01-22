#!/bin/bash
# Test Script for Phase 6: Verification Service

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
YELLOW='\033[1;33m'

TOKEN="$1"
if [ -z "$TOKEN" ]; then
    if [ -f "token.txt" ]; then
        TOKEN=$(cat token.txt)
    elif [ -f "../token.txt" ]; then
        TOKEN=$(cat ../token.txt)
    else
        echo -e "${RED}Error: JWT Token required (arg or token.txt)${NC}"
        exit 1
    fi
fi

API_URL="http://localhost:8080/api/verify"

echo -e "${YELLOW}🧪 Phase 6: Verification Service Test (Mistral AI)${NC}"
echo "=============================="

# 1. Request Verification
echo -e "\n${YELLOW}Step 1: Request Verification (Python)${NC}"
REQUEST_RSP=$(curl -s -X POST "$API_URL/request" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ "topic": "Python" }')

echo "Response: $REQUEST_RSP"
REQUEST_ID=$(echo $REQUEST_RSP | jq -r '.data.requestId')

if [ "$REQUEST_ID" == "null" ]; then
    echo -e "${RED}❌ Failed to create request${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Request Created: $REQUEST_ID${NC}"

# 2. Get Exam
echo -e "\n${YELLOW}Step 2: Get Exam Questions${NC}"
EXAM_RSP=$(curl -s -X GET "$API_URL/exam/$REQUEST_ID" \
  -H "Authorization: Bearer $TOKEN")

# echo "Response: $EXAM_RSP" # Silent to avoid spamming console with 10 questions
QUESTIONS_COUNT=$(echo $EXAM_RSP | jq '.data.questions | length')

if [ "$QUESTIONS_COUNT" -gt 0 ]; then
   echo -e "${GREEN}✅ Exam Retrieved: $QUESTIONS_COUNT questions${NC}"
else
   echo -e "${RED}❌ Failed to retrieve exam${NC}"
   exit 1
fi

# 3. Submit Exam (Simulate passing)
# We guess answers? Or since we are testing, we can simulate.
# Without knowing correctIndex (it's hidden), we might fail initially.
# But for test connectivity, sending *any* answers is enough.
echo -e "\n${YELLOW}Step 3: Submit Answers (Random Guessing)${NC}"

# Construct answers array
ANSWERS="[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]"

SUBMIT_RSP=$(curl -s -X POST "$API_URL/exam/$REQUEST_ID/submit" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{ \"answers\": $ANSWERS }")

echo "Response: $SUBMIT_RSP"

# 4. Check Badges
echo -e "\n${YELLOW}Step 4: Check Badges${NC}"
# Extract user ID from token helper or just use me
USER_ID="5bff3fec-79b4-4181-92e9-cce2f5afa6b7" # Hardcoded specific test user ID
curl -s -X GET "$API_URL/badges/$USER_ID" \
  -H "Authorization: Bearer $TOKEN" | jq .

echo -e "\n${GREEN}🎉 Phase 6 Tests Completed!${NC}"
