#!/bin/bash

# SkillSwapp Backend - Startup Script
# Starts all microservices in the correct order

# Ensure Dart/Flutter is in PATH
export PATH="$PATH:/home/gotti/Videos/flutter_linux_3.38.7-stable/flutter/bin"

echo "🚀 Starting SkillSwapp Backend Services"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Kill any existing Dart processes
echo -e "${YELLOW}Cleaning up existing processes...${NC}"
pkill -9 -f "dart run" 2>/dev/null
sleep 2

# Start Auth Service (Port 8081)
echo -e "${YELLOW}Starting Auth Service (Port 8081)...${NC}"
cd /home/gotti/Desktop/SkillSwapp/backend
nohup dart run auth_service/bin/server.dart > logs/auth.log 2>&1 &
AUTH_PID=$!
sleep 8

# Check if Auth Service started
if curl -s http://localhost:8081/health > /dev/null; then
    echo -e "${GREEN}✅ Auth Service started (PID: $AUTH_PID)${NC}"
else
    echo -e "${RED}❌ Auth Service failed to start${NC}"
    exit 1
fi

# Start User Service (Port 8082)
echo -e "${YELLOW}Starting User Service (Port 8082)...${NC}"
nohup dart run user_service/bin/server.dart > logs/user.log 2>&1 &
USER_PID=$!
sleep 8

# Check if User Service started
if curl -s http://localhost:8082/health > /dev/null; then
    echo -e "${GREEN}✅ User Service started (PID: $USER_PID)${NC}"
else
    echo -e "${RED}❌ User Service failed to start${NC}"
    exit 1
fi

# Start API Gateway (Port 8080)
echo -e "${YELLOW}Starting API Gateway (Port 8080)...${NC}"
nohup dart run api_gateway/bin/server.dart > logs/gateway.log 2>&1 &
GATEWAY_PID=$!
sleep 8

# Check if API Gateway started
if curl -s http://localhost:8080/health > /dev/null; then
    echo -e "${GREEN}✅ API Gateway started (PID: $GATEWAY_PID)${NC}"
else
    echo -e "${RED}❌ API Gateway failed to start${NC}"
    exit 1
fi

# Start Course Service (Port 8083)
echo -e "${YELLOW}Starting Course Service (Port 8083)...${NC}"
nohup dart run course_service/bin/server.dart > logs/course.log 2>&1 &
COURSE_PID=$!
sleep 5

# Start Verification Service (Port 8084)
echo -e "${YELLOW}Starting Verification Service (Port 8084)...${NC}"
nohup dart run verification_service/bin/server.dart > logs/verification.log 2>&1 &
VERIFICATION_PID=$!
sleep 5

# Check if Course Service started
if curl -s http://localhost:8083/health > /dev/null; then
    echo -e "${GREEN}✅ Course Service started (PID: $COURSE_PID)${NC}"
else
    echo -e "${RED}❌ Course Service failed to start${NC}"
    exit 1
fi

# Start Learning Service (Port 8085)
echo -e "${YELLOW}Starting Learning Service (Port 8085)...${NC}"
nohup dart run learning_service/bin/server.dart > logs/learning.log 2>&1 &
LEARNING_PID=$!
sleep 2

# Start Payment Service (Port 8086)
echo -e "${YELLOW}Starting Payment Service (Port 8086)...${NC}"
nohup dart run payment_service/bin/server.dart > logs/payment.log 2>&1 &
PAYMENT_PID=$!
sleep 2

# Start Messaging Service (Port 8087)
echo -e "${YELLOW}Starting Messaging Service (Port 8087)...${NC}"
nohup dart run messaging_service/bin/server.dart > logs/messaging.log 2>&1 &
MESSAGING_PID=$!
sleep 2

# Start Review Service (Port 8088)
echo -e "${YELLOW}Starting Review Service (Port 8088)...${NC}"
nohup dart run review_service/bin/server.dart > logs/review.log 2>&1 &
REVIEW_PID=$!
sleep 2

# Start Certificate Service (Port 8089)
echo -e "${YELLOW}Starting Certificate Service (Port 8089)...${NC}"
nohup dart run certificate_service/bin/server.dart > logs/certificate.log 2>&1 &
CERTIFICATE_PID=$!
sleep 2

# Start Admin Service (Port 8090)
echo -e "${YELLOW}Starting Admin Service (Port 8090)...${NC}"
nohup dart run admin_service/bin/server.dart > logs/admin.log 2>&1 &
ADMIN_PID=$!
sleep 2

# Start Analytics Service (Port 8091)
echo -e "${YELLOW}Starting Analytics Service (Port 8091)...${NC}"
nohup dart run analytics_service/bin/server.dart > logs/analytics.log 2>&1 &
ANALYTICS_PID=$!
sleep 2

# Start Notification Service (Port 8092)
echo -e "${YELLOW}Starting Notification Service (Port 8092)...${NC}"
nohup dart run notification_service/bin/server.dart > logs/notification.log 2>&1 &
NOTIFICATION_PID=$!
sleep 2

echo ""
echo "========================================"
echo -e "${GREEN}🎉 All services started successfully!${NC}"
echo ""
echo "Services:"
echo "  - Gateway:      http://localhost:8080"
echo "  - Auth:         http://localhost:8081"
echo "  - User:         http://localhost:8082"
echo "  - Course:       http://localhost:8083"
echo "  - Verification: http://localhost:8084"
echo "  - Learning:     http://localhost:8085"
echo "  - Payment:      http://localhost:8086"
echo "  - Messaging:    http://localhost:8087"
echo "  - Review:       http://localhost:8088"
echo "  - Certificate:  http://localhost:8089"
echo "  - Admin:        http://localhost:8090"
echo "  - Analytics:    http://localhost:8091"
echo "  - Notification: http://localhost:8092"
echo ""
echo "logs are available in backend/logs/"
echo "To stop: pkill -9 -f 'dart run'"
echo "========================================"
