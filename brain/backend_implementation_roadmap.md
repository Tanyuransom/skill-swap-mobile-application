# 🗺️ SkillSwapp Backend Implementation Roadmap

## 📋 Project Configuration

### Technology Stack
- **Backend Framework**: Dart Shelf (Microservices)
- **Database**: Neon PostgreSQL (Serverless)
- **Containerization**: Docker + Docker Compose
- **Authentication**: JWT + Google OAuth
- **Email**: Gmail SMTP with OTP verification

### Security Configuration
- **Password Policy**: Min 8 chars, 1 uppercase, 1 lowercase, 1 number, 1 special char
- **JWT Access Token**: 1 hour expiry
- **JWT Refresh Token**: 7 days expiry
- **OTP**: 6-digit code, 10 minutes expiry

---

## 🎯 Implementation Phases

### Phase 1: Foundation (Week 1) ⚙️
**Goal**: Set up infrastructure and shared utilities

**Deliverables**:
- ✅ Neon PostgreSQL database setup
- ✅ Database schema (users, sessions, profiles, OTP)
- ✅ Shared library (JWT, hashing, email, DB connection)
- ✅ Docker configuration updated

**Key Files**:
- `database/schema.sql`
- `shared/lib/config/database_config.dart`
- `shared/lib/utils/jwt_utils.dart`
- `shared/lib/utils/hash_utils.dart`
- `shared/lib/utils/otp_utils.dart`
- `shared/lib/utils/email_service.dart`

**Success Criteria**:
- Database accessible from Docker
- JWT generation/validation working
- OTP emails sending via Gmail SMTP
- Password hashing functional

---

### Phase 2: Authentication Service (Week 1-2) 🔐
**Goal**: Complete user authentication system

**Deliverables**:
- ✅ Auth Service running on port 8081
- ✅ User registration with OTP verification
- ✅ Email/password login
- ✅ Google OAuth integration
- ✅ Password reset with OTP
- ✅ JWT token management

**Endpoints**:
```
POST /register          # Register new user
POST /verify-otp        # Verify email with OTP
POST /resend-otp        # Resend OTP
POST /login             # Login with email/password
POST /google-auth       # Login with Google
POST /logout            # Logout
POST /refresh-token     # Refresh JWT
POST /forgot-password   # Request password reset
POST /reset-password    # Reset password with OTP
GET  /me                # Get current user
```

**Success Criteria**:
- Users can register and receive OTP
- Email verification works
- Login returns valid JWT
- Google OAuth functional
- Password reset flow complete

---

### Phase 3: API Gateway (Week 2) 🌐
**Goal**: Single entry point for all services

**Deliverables**:
- ✅ API Gateway running on port 8080
- ✅ Request routing to all services
- ✅ CORS middleware
- ✅ Rate limiting
- ✅ Request logging

**Routes**:
```
/auth/*          → Auth Service (8081)
/users/*         → User Service (8082)
/courses/*       → Course Service (8083)
/verification/*  → Verification Service (8084)
/learning/*      → Learning Service (8085)
/payments/*      → Payment Service (8086)
/messages/*      → Messaging Service (8087)
/reviews/*       → Review Service (8088)
/certificates/*  → Certificate Service (8089)
/admin/*         → Admin Service (8090)
```

**Success Criteria**:
- All requests route correctly
- CORS headers present
- Rate limiting works
- Logs captured

---

### Phase 4: User Service (Week 2-3) 👤
**Goal**: User profile management

**Deliverables**:
- ✅ User Service running on port 8082
- ✅ Profile CRUD operations
- ✅ Avatar upload
- ✅ User settings
- ✅ User statistics

**Database Tables**:
- `profiles` (bio, avatar, phone, country)
- `user_settings` (notifications, privacy)

**Endpoints**:
```
GET  /profile/:id       # Get profile
PUT  /profile           # Update profile
POST /profile/avatar    # Upload avatar
GET  /profile/stats     # Get statistics
PUT  /settings          # Update settings
```

**Success Criteria**:
- Profile creation/update works
- Avatar upload functional
- Settings persist

---

### Phase 5: Course Service (Week 3-4) 📚
**Goal**: Course management system

**Deliverables**:
- ✅ Course Service running on port 8083
- ✅ Course CRUD (tutors only)
- ✅ Module and lesson management
- ✅ Course search and filtering
- ✅ Category management

**Database Tables**:
- `courses` (title, description, price, tutor_id)
- `modules` (course_id, title, order)
- `lessons` (module_id, title, content, video_url)
- `categories` (name, description)

**Endpoints**:
```
POST   /courses              # Create course
GET    /courses              # List courses
GET    /courses/:id          # Get course
PUT    /courses/:id          # Update course
DELETE /courses/:id          # Delete course
POST   /courses/:id/modules  # Add module
POST   /modules/:id/lessons  # Add lesson
GET    /courses/search       # Search courses
```

**Success Criteria**:
- Tutors can create courses
- Students can browse courses
- Search works with filters
- Modules/lessons organized

---

### Phase 6: Verification Service (Week 4-5) 🤖
**Goal**: AI-powered tutor verification

**Deliverables**:
- ✅ Verification Service running on port 8084
- ✅ AI exam generation
- ✅ Exam submission and grading
- ✅ Badge system
- ✅ Verification status tracking

**Database Tables**:
- `verification_requests` (tutor_id, skill, status)
- `verification_exams` (request_id, questions, answers)
- `verification_results` (exam_id, score, passed)
- `tutor_badges` (tutor_id, skill, badge_level)

**Endpoints**:
```
POST /verify/request      # Request verification
GET  /verify/exam/:id     # Get exam
POST /verify/submit       # Submit answers
GET  /verify/result/:id   # Get result
GET  /verify/badge/:id    # Get badge
```

**Success Criteria**:
- AI generates relevant exams
- Grading is accurate
- Badges awarded correctly

---

### Phase 7: Learning Service (Week 5) 📖
**Goal**: Student learning progress tracking

**Deliverables**:
- ✅ Learning Service running on port 8085
- ✅ Course enrollment
- ✅ Progress tracking
- ✅ Lesson completion
- ✅ Course completion certificates

**Database Tables**:
- `enrollments` (student_id, course_id, enrolled_at)
- `progress` (enrollment_id, lesson_id, completed, time_spent)
- `completed_courses` (enrollment_id, completed_at)

**Endpoints**:
```
POST /enroll/:courseId       # Enroll in course
GET  /enrollments            # Get enrollments
POST /progress               # Update progress
GET  /progress/:courseId     # Get progress
POST /complete/:lessonId     # Complete lesson
```

**Success Criteria**:
- Students can enroll
- Progress tracked accurately
- Completion triggers certificate

---

### Phase 8: Payment Service (Week 6) 💳
**Goal**: Payment processing and wallet

**Deliverables**:
- ✅ Payment Service running on port 8086
- ✅ Stripe integration
- ✅ PayPal integration
- ✅ Wallet system
- ✅ Payout system (tutors)

**Database Tables**:
- `transactions` (user_id, amount, type, status)
- `payment_methods` (user_id, type, details)
- `wallets` (user_id, balance)

**Endpoints**:
```
POST /payment/create    # Create payment
POST /payment/confirm   # Confirm payment
GET  /payment/history   # Payment history
GET  /wallet            # Get balance
POST /payout            # Request payout
```

**Success Criteria**:
- Payments process successfully
- Wallet balances accurate
- Payouts work for tutors

---

### Phase 9: Messaging Service (Week 6-7) 💬
**Goal**: Real-time chat system

**Deliverables**:
- ✅ Messaging Service running on port 8087
- ✅ WebSocket support
- ✅ Conversations management
- ✅ Message history
- ✅ Real-time notifications

**Database Tables**:
- `conversations` (participants, last_message_at)
- `messages` (conversation_id, sender_id, content, sent_at)

**Endpoints**:
```
GET  /conversations           # Get conversations
POST /conversations           # Create conversation
GET  /messages/:convId        # Get messages
POST /messages                # Send message
WS   /ws                      # WebSocket connection
```

**Success Criteria**:
- Messages send/receive in real-time
- Message history loads
- WebSocket stable

---

### Phase 10: Review Service (Week 7) ⭐
**Goal**: Course and tutor reviews

**Deliverables**:
- ✅ Review Service running on port 8088
- ✅ Course reviews
- ✅ Tutor ratings
- ✅ Review moderation

**Database Tables**:
- `reviews` (user_id, course_id, rating, comment)
- `tutor_ratings` (tutor_id, avg_rating, total_reviews)

**Endpoints**:
```
POST   /reviews                  # Create review
GET    /reviews/:courseId        # Get course reviews
GET    /reviews/tutor/:tutorId   # Get tutor reviews
PUT    /reviews/:id              # Update review
DELETE /reviews/:id              # Delete review
```

**Success Criteria**:
- Reviews submitted successfully
- Ratings calculated correctly
- Moderation works

---

### Phase 11: Certificate Service (Week 8) 📜
**Goal**: Certificate generation and verification

**Deliverables**:
- ✅ Certificate Service running on port 8089
- ✅ PDF certificate generation
- ✅ QR code verification
- ✅ Certificate download

**Database Tables**:
- `certificates` (user_id, course_id, issued_at, verification_code)

**Endpoints**:
```
POST /certificates/generate       # Generate certificate
GET  /certificates/:id            # Get certificate
GET  /certificates/verify/:code   # Verify certificate
GET  /certificates/download/:id   # Download PDF
```

**Success Criteria**:
- Certificates generate correctly
- QR codes work
- PDFs downloadable

---

### Phase 12: Admin Service (Week 8) 👨‍💼
**Goal**: Platform administration

**Deliverables**:
- ✅ Admin Service running on port 8090
- ✅ User management
- ✅ Course moderation
- ✅ Platform statistics
- ✅ Report handling

**Endpoints**:
```
GET    /admin/users              # List users
PUT    /admin/users/:id/status   # Ban/unban user
GET    /admin/courses            # List courses
DELETE /admin/courses/:id        # Delete course
GET    /admin/stats              # Platform stats
GET    /admin/reports            # Get reports
```

**Success Criteria**:
- Admins can manage users
- Course moderation works
- Statistics accurate

---

### Phase 13: Testing & Deployment (Week 9) 🐳
**Goal**: Production-ready deployment

**Tasks**:
- [ ] Integration testing
- [ ] Load testing
- [ ] Security audit
- [ ] Docker optimization
- [ ] Environment configuration
- [ ] Documentation

**Success Criteria**:
- All services pass tests
- System handles load
- Security vulnerabilities addressed
- Docker deployment smooth

---

### Phase 14: Frontend Integration (Week 10+) 🎨
**Goal**: Connect Flutter app to backend

**Tasks**:
- [ ] Implement 27 Figma screens
- [ ] Connect auth flows
- [ ] Integrate all features
- [ ] End-to-end testing

---

## 📊 Timeline Summary

| Phase | Duration | Services | Status |
|-------|----------|----------|--------|
| 1. Foundation | Week 1 | Shared, DB | ⏭️ Next |
| 2. Auth | Week 1-2 | Auth Service | ⏭️ |
| 3. Gateway | Week 2 | API Gateway | ⏭️ |
| 4. User | Week 2-3 | User Service | ⏭️ |
| 5. Course | Week 3-4 | Course Service | ⏭️ |
| 6. Verification | Week 4-5 | Verification | ⏭️ |
| 7. Learning | Week 5 | Learning | ⏭️ |
| 8. Payment | Week 6 | Payment | ⏭️ |
| 9. Messaging | Week 6-7 | Messaging | ⏭️ |
| 10. Review | Week 7 | Review | ⏭️ |
| 11. Certificate | Week 8 | Certificate | ⏭️ |
| 12. Admin | Week 8 | Admin | ⏭️ |
| 13. Testing | Week 9 | All | ⏭️ |
| 14. Frontend | Week 10+ | Flutter | ⏭️ |

**Total Backend Development**: ~9 weeks  
**Frontend Development**: ~3-4 weeks  
**Total Project**: ~12-13 weeks

---

## 🚀 Next Steps

1. **Get Neon PostgreSQL connection string**
2. **Start Phase 1: Foundation**
   - Set up database
   - Implement shared library
   - Test with Docker

**Ready to begin implementation!** 🎯
