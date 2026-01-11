# 🧠 SKILLSWAPP - DEEP ANALYSIS & SYSTEM ARCHITECTURE

> **Purpose**: This document serves as the complete brain/memory for the SkillSwapp project. It contains deep analysis of all functionalities, business logic, technical architecture, and implementation requirements.

---

## 📋 TABLE OF CONTENTS

1. [Executive Summary](#executive-summary)
2. [Core Business Model](#core-business-model)
3. [Domain Analysis](#domain-analysis)
4. [User Roles & Permissions](#user-roles--permissions)
5. [Core Functionalities Deep Dive](#core-functionalities-deep-dive)
6. [AI Verification System](#ai-verification-system)
7. [Learning & Certification Flow](#learning--certification-flow)
8. [Trust & Reputation System](#trust--reputation-system)
9. [Payment & Monetization](#payment--monetization)
10. [Communication & Community](#communication--community)
11. [Admin System](#admin-system)
12. [Technical Architecture](#technical-architecture)
13. [Database Schema Design](#database-schema-design)
14. [API Design](#api-design)
15. [Security Architecture](#security-architecture)
16. [Frontend Architecture](#frontend-architecture)
17. [Integration Points](#integration-points)
18. [Scalability & Performance](#scalability--performance)

---

## 1. EXECUTIVE SUMMARY

**SkillSwapp** is an enterprise-grade, AI-verified peer-to-peer learning marketplace that enables students to learn from verified tutors. The platform's unique value proposition is its **AI-powered verification system** that ensures only qualified individuals can teach.

### Key Differentiators:
- **AI Verification**: No one can teach without passing an AI-generated competency exam
- **Dual-Role Users**: Users can be both learners and teachers (after verification)
- **Certificate Issuance**: Learners receive verifiable certificates upon course completion
- **Trust-Based Marketplace**: Ratings, reviews, and reputation scores drive quality
- **Enterprise Security**: WAF → API Gateway → Microservices → PostgreSQL

### Platform Scale:
- Target: Millions of concurrent users
- Response Time: <2 seconds for all API calls
- Availability: 99.9% uptime
- Security: Zero-trust architecture

---

## 2. CORE BUSINESS MODEL

### 2.1 Value Proposition

**For Learners:**
- Access to verified, quality tutors
- Affordable peer-to-peer learning
- Verifiable certificates
- Community-driven learning
- Transparent tutor ratings

**For Tutors:**
- Monetize their skills
- Flexible teaching schedule
- Build reputation
- Access to global student base
- AI-verified credibility badge

**For Platform:**
- Commission on course sales
- Premium features (future)
- Certification fees (optional)
- Advertisement (future)

### 2.2 Revenue Streams

1. **Transaction Fees**: 15-20% commission on course sales
2. **Verification Fees**: Optional fee for tutor verification exam retakes
3. **Premium Subscriptions**: Enhanced features for tutors/learners
4. **Certificate Verification**: Fee for third-party certificate verification

### 2.3 Quality Control Mechanism

```
User wants to teach
        ↓
AI Verification Exam
        ↓
    Pass? → Yes → Verified Tutor Badge → Can create courses
        ↓
    No → Feedback + Retake option
```

---

## 3. DOMAIN ANALYSIS

### 3.1 Core Domains

#### **User Domain**
- User registration & authentication
- Profile management
- Role switching (Learner ↔ Tutor)
- Account settings
- Notification preferences

#### **Verification Domain**
- AI exam generation
- Exam taking & grading
- Skill assessment
- Verification badge issuance
- Re-verification (periodic or on-demand)

#### **Course Domain**
- Course creation (by verified tutors)
- Course catalog
- Course enrollment
- Course content delivery
- Course completion tracking

#### **Learning Domain**
- Learning progress tracking
- Quiz/assignment submission
- Final exam taking
- Certificate generation
- Learning history

#### **Payment Domain**
- Payment processing
- Wallet management
- Transaction history
- Refund processing
- Payout to tutors

#### **Communication Domain**
- Direct messaging (Learner ↔ Tutor)
- Course Q&A
- Community forums
- Notifications (push, email, in-app)

#### **Review & Rating Domain**
- Course ratings
- Tutor ratings
- Review submission
- Reputation calculation
- Fraud detection

#### **Certificate Domain**
- Certificate generation
- Certificate storage
- Certificate verification
- Certificate sharing
- Certificate revocation (admin)

#### **Admin Domain**
- User management
- Content moderation
- Complaint resolution
- Analytics & reporting
- System configuration

---

## 4. USER ROLES & PERMISSIONS

### 4.1 Role Hierarchy

```
┌─────────────────────────────────────┐
│           SUPER ADMIN               │
│  - Full system access               │
│  - User management                  │
│  - Certificate issuance/revocation  │
└─────────────────────────────────────┘
                 │
    ┌────────────┴────────────┐
    │                         │
┌───▼────────┐        ┌──────▼──────┐
│   ADMIN    │        │  MODERATOR  │
│ - Moderate │        │ - Review    │
│ - Reports  │        │ - Flag      │
└────────────┘        └─────────────┘
                 │
    ┌────────────┴────────────┐
    │                         │
┌───▼──────────────┐  ┌──────▼──────────────┐
│ VERIFIED TUTOR   │  │     LEARNER         │
│ - Create courses │  │ - Enroll in courses │
│ - Teach          │  │ - Take exams        │
│ - Earn money     │  │ - Get certificates  │
└──────────────────┘  └─────────────────────┘
```

### 4.2 Permission Matrix

| Action | Learner | Tutor | Moderator | Admin | Super Admin |
|--------|---------|-------|-----------|-------|-------------|
| Browse courses | ✅ | ✅ | ✅ | ✅ | ✅ |
| Enroll in course | ✅ | ✅ | ❌ | ❌ | ❌ |
| Take verification exam | ✅ | ✅ | ❌ | ❌ | ❌ |
| Create course | ❌ | ✅ | ❌ | ❌ | ❌ |
| Receive payments | ❌ | ✅ | ❌ | ❌ | ❌ |
| Issue certificate | ❌ | ❌ | ❌ | ✅ | ✅ |
| Revoke certificate | ❌ | ❌ | ❌ | ✅ | ✅ |
| Ban users | ❌ | ❌ | ❌ | ✅ | ✅ |
| Moderate content | ❌ | ❌ | ✅ | ✅ | ✅ |
| System configuration | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## 5. CORE FUNCTIONALITIES DEEP DIVE

### 5.1 User Registration & Authentication

**Flow:**
```
1. User opens app
2. Chooses registration method:
   - Email/Password
   - Google OAuth
   - Facebook OAuth
3. Enters required information:
   - Full name
   - Email
   - Password (if email/password)
   - Phone number (optional)
4. Email verification sent
5. User verifies email
6. Account created
7. User selects initial role: Learner or Tutor
8. If Tutor → Redirect to verification exam
9. If Learner → Redirect to home screen
```

**Business Rules:**
- Email must be unique
- Password: min 8 chars, 1 uppercase, 1 number, 1 special char
- Phone number must be valid (if provided)
- Social login: auto-verify email
- Users can switch roles later

**Data Captured:**
```json
{
  "user_id": "uuid",
  "full_name": "string",
  "email": "string",
  "phone": "string",
  "password_hash": "string",
  "auth_provider": "email|google|facebook",
  "email_verified": "boolean",
  "created_at": "timestamp",
  "updated_at": "timestamp",
  "status": "active|suspended|banned"
}
```

### 5.2 Profile Management

**Learner Profile:**
- Personal information
- Learning interests
- Enrolled courses
- Completed courses
- Certificates earned
- Learning streak
- Total learning hours

**Tutor Profile:**
- Personal information
- Verified skills (badges)
- Courses created
- Total students taught
- Average rating
- Total earnings
- Tutor bio
- Teaching experience
- Education background

**Editable Fields:**
- Profile picture
- Full name
- Bio
- Phone number
- Teaching/learning interests
- Social links

### 5.3 Course Browsing & Discovery

**Discovery Methods:**
1. **Category Browse**: Programming, Design, Business, Math, etc.
2. **Search**: Keyword search with filters
3. **Recommendations**: AI-powered based on learning history
4. **Trending**: Popular courses
5. **Top Rated**: Highest-rated courses
6. **New Arrivals**: Recently published courses

**Filters:**
- Category
- Price range
- Duration
- Difficulty level (Beginner, Intermediate, Advanced)
- Rating (4+ stars, 3+ stars, etc.)
- Language
- Tutor verification status

**Course Card Display:**
- Course title
- Course thumbnail
- Tutor name + verified badge
- Rating (stars + count)
- Price
- Duration
- Enrollment count
- Difficulty level

### 5.4 Course Enrollment

**Flow:**
```
1. User clicks "Enroll" on course
2. System checks if already enrolled → Skip to step 7
3. Display course price
4. User selects payment method
5. Payment processed
6. Enrollment created
7. User redirected to course content
8. Notification sent to tutor
9. Transaction recorded
```

**Business Rules:**
- Cannot enroll in own course
- Cannot enroll twice in same course
- Payment required for paid courses
- Free courses: instant enrollment
- Refund available within 7 days (if <10% progress)

### 5.5 Course Content Delivery

**Content Types:**
- Video lessons
- Text articles
- Quizzes
- Assignments
- Downloadable resources
- Live sessions (future)

**Progress Tracking:**
- Lessons completed
- Quiz scores
- Assignment submissions
- Overall progress percentage
- Time spent

**Learning Flow:**
```
Course Overview
    ↓
Module 1
    ↓
  Lesson 1.1 (Video)
    ↓
  Lesson 1.2 (Article)
    ↓
  Quiz 1
    ↓
Module 2
    ↓
  ...
    ↓
Final Exam
    ↓
Certificate
```

---

## 6. AI VERIFICATION SYSTEM

### 6.1 Purpose

The AI Verification System is the **core differentiator** of SkillSwapp. It ensures that only competent individuals can teach, thereby maintaining platform quality and trust.

### 6.2 Verification Flow

```
User requests to become tutor
        ↓
Select skill domain (e.g., "Python Programming")
        ↓
Select skill level (Beginner, Intermediate, Advanced)
        ↓
AI generates custom exam (20-30 questions)
        ↓
User takes exam (time-limited: 60-90 minutes)
        ↓
AI evaluates answers
        ↓
    Pass (≥70%)? 
        ↓                    ↓
       YES                  NO
        ↓                    ↓
Verified Badge          Feedback Report
Can create courses      Can retake after 7 days
```

### 6.3 AI Exam Generation Logic

**Exam Composition:**
- **Multiple Choice**: 40% (knowledge recall)
- **Code/Practical**: 30% (hands-on skills)
- **Scenario-Based**: 20% (problem-solving)
- **Theory**: 10% (conceptual understanding)

**Difficulty Distribution:**
- Easy: 30%
- Medium: 50%
- Hard: 20%

**AI Model Requirements:**
- Generate questions based on skill domain
- Ensure no duplicate questions
- Validate answer correctness
- Provide detailed feedback
- Detect cheating patterns (time analysis, answer patterns)

**Example Question Types:**

**Python Programming - Beginner:**
```
Q: What is the output of: print(type([]))
A) <class 'list'>
B) <class 'array'>
C) <class 'tuple'>
D) <class 'dict'>

Correct: A
```

**Python Programming - Intermediate (Code):**
```
Q: Write a function that returns the second largest number in a list.
Expected: Code submission
Evaluation: AI checks logic, edge cases, efficiency
```

### 6.4 Grading System

**Scoring:**
- Each question has a weight
- Total score: 100 points
- Pass threshold: 70 points
- Partial credit for code questions

**Evaluation Criteria (Code Questions):**
- Correctness: 50%
- Edge case handling: 20%
- Code quality: 15%
- Efficiency: 15%

**Anti-Cheating Measures:**
- Time per question tracking
- Tab switching detection
- Copy-paste detection
- Answer pattern analysis
- Webcam monitoring (optional, future)

### 6.5 Verification Badge

**Badge Levels:**
- ⭐ **Verified Beginner Tutor**
- ⭐⭐ **Verified Intermediate Tutor**
- ⭐⭐⭐ **Verified Advanced Tutor**
- 🏆 **Expert Tutor** (after 100+ students + 4.5+ rating)

**Badge Display:**
- On tutor profile
- On course cards
- In search results
- In messaging

**Re-verification:**
- Optional: Every 12 months
- Mandatory: If rating drops below 3.5
- Mandatory: After 3+ complaints

---

## 7. LEARNING & CERTIFICATION FLOW

### 7.1 Course Completion Requirements

**To complete a course:**
1. Watch all video lessons (≥80% completion)
2. Complete all quizzes (≥60% score)
3. Submit all assignments (if any)
4. Pass final exam (≥70% score)

### 7.2 Final Exam

**Exam Structure:**
- Generated by course creator
- 15-25 questions
- Time limit: 30-60 minutes
- Multiple attempts allowed (max 3)
- Must pass to get certificate

**Exam Types:**
- Multiple choice
- True/False
- Code submission
- Essay (manual grading by tutor)

### 7.3 Certificate Generation

**Certificate Contains:**
- Student name
- Course title
- Tutor name
- Completion date
- Certificate ID (unique, verifiable)
- QR code (for verification)
- SkillSwapp signature

**Certificate Format:**
- PDF download
- Shareable link
- LinkedIn integration (future)

**Certificate Verification:**
```
Anyone can verify certificate by:
1. Scanning QR code
2. Entering certificate ID on website
3. System returns:
   - Student name
   - Course title
   - Completion date
   - Validity status
```

### 7.4 Learning Analytics

**For Learners:**
- Courses in progress
- Courses completed
- Total learning hours
- Certificates earned
- Learning streak
- Skill progress

**For Tutors:**
- Student enrollment trends
- Course completion rates
- Average exam scores
- Student engagement metrics

---

## 8. TRUST & REPUTATION SYSTEM

### 8.1 Rating System

**Course Ratings:**
- 1-5 stars
- Written review (optional)
- Can rate after completing ≥20% of course
- Cannot rate own course

**Tutor Ratings:**
- Aggregate of all course ratings
- Weighted by recency (recent ratings have more weight)
- Displayed as average (e.g., 4.7/5.0)

**Rating Breakdown:**
- Content quality
- Teaching style
- Responsiveness
- Value for money

### 8.2 Review System

**Review Components:**
- Star rating (required)
- Written feedback (optional, max 500 chars)
- Pros/Cons (optional)
- Timestamp
- Verified purchase badge

**Review Moderation:**
- AI scans for inappropriate language
- Flagged reviews go to moderators
- Tutors can respond to reviews
- Reviews can be reported

### 8.3 Reputation Score

**Tutor Reputation Calculation:**
```
Reputation Score = (
  Average Rating × 40% +
  Course Completion Rate × 25% +
  Student Count (normalized) × 20% +
  Response Time (normalized) × 10% +
  Verification Status × 5%
)
```

**Reputation Tiers:**
- 🥉 Bronze: 0-50 points
- 🥈 Silver: 51-70 points
- 🥇 Gold: 71-85 points
- 💎 Platinum: 86-95 points
- 👑 Elite: 96-100 points

**Benefits by Tier:**
- Higher tiers → Better visibility in search
- Higher tiers → Lower platform commission
- Higher tiers → Priority support
- Elite → Featured tutor badge

### 8.4 Complaint & Report System

**Reportable Issues:**
- Inappropriate content
- Plagiarism
- Fake credentials
- Poor quality
- Harassment
- Spam

**Report Flow:**
```
User reports issue
        ↓
Auto-flagged for review
        ↓
Moderator investigates
        ↓
Decision:
  - Dismiss (no action)
  - Warning to tutor
  - Content removal
  - Temporary suspension
  - Permanent ban
        ↓
Notification to reporter & tutor
```

---

## 9. PAYMENT & MONETIZATION

### 9.1 Payment Flow

**Course Purchase:**
```
1. User selects course
2. Clicks "Enroll"
3. Chooses payment method:
   - Credit/Debit card
   - PayPal
   - Wallet balance
   - Bank transfer (future)
4. Payment gateway processes payment
5. On success:
   - Enrollment created
   - Receipt sent
   - Tutor notified
   - Platform commission deducted
   - Tutor balance updated
6. On failure:
   - Error message
   - Retry option
```

### 9.2 Pricing Model

**Course Pricing:**
- Free courses allowed
- Paid courses: $5 - $500
- Tutor sets price
- Platform suggests optimal price (AI-based)

**Platform Commission:**
- Standard: 20%
- Silver tutors: 18%
- Gold tutors: 15%
- Platinum tutors: 12%
- Elite tutors: 10%

### 9.3 Tutor Payouts

**Payout Schedule:**
- Minimum payout: $50
- Payout frequency: Weekly or Monthly
- Payout methods:
  - Bank transfer
  - PayPal
  - Stripe

**Payout Calculation:**
```
Tutor Earnings = Course Price × (1 - Platform Commission) × Enrollment Count
```

**Refund Policy:**
- 7-day money-back guarantee
- Conditions:
  - <10% course progress
  - Valid reason
  - No certificate issued
- Refund amount: 100% (platform absorbs commission loss)

### 9.4 Wallet System

**Features:**
- Store balance
- Transaction history
- Add funds
- Withdraw funds
- Use for course purchases

**Wallet Transactions:**
- Course purchase
- Refund received
- Tutor earnings
- Withdrawal
- Bonus/Promotion

---

## 10. COMMUNICATION & COMMUNITY

### 10.1 Messaging System

**Message Types:**
1. **Direct Messages**: Learner ↔ Tutor
2. **Course Q&A**: Public questions on course page
3. **Announcements**: Tutor → All enrolled students

**Direct Messaging Features:**
- Real-time chat
- File sharing (images, PDFs, code)
- Message history
- Read receipts
- Typing indicators
- Notification on new message

**Business Rules:**
- Can only message tutors of enrolled courses
- Tutors can message any enrolled student
- Message retention: 1 year
- File size limit: 10MB per file

### 10.2 Notifications

**Notification Types:**
- Course enrollment
- New message
- Course update
- Certificate issued
- Payment received
- Review received
- Verification exam result
- Complaint resolution

**Notification Channels:**
- In-app notifications
- Push notifications
- Email notifications
- SMS (optional, future)

**Notification Settings:**
- User can enable/disable per type
- Quiet hours
- Frequency (instant, daily digest, weekly digest)

### 10.3 Community Features (Future)

- Discussion forums
- Study groups
- Live Q&A sessions
- Webinars
- Student success stories
- Tutor spotlight

---

## 11. ADMIN SYSTEM

### 11.1 Admin Dashboard

**Key Metrics:**
- Total users (Learners, Tutors, Admins)
- Total courses
- Total enrollments
- Total revenue
- Active users (daily, weekly, monthly)
- Verification pass rate
- Certificate issuance count
- Pending complaints
- System health

### 11.2 User Management

**Admin Actions:**
- View all users
- Search/filter users
- View user details
- Suspend user
- Ban user
- Delete user (soft delete)
- Reset password
- Verify email manually
- Grant/revoke tutor status

### 11.3 Content Moderation

**Moderator Actions:**
- Review flagged courses
- Review flagged reviews
- Approve/reject course submissions
- Edit course content (if necessary)
- Remove inappropriate content

### 11.4 Complaint Resolution

**Complaint Dashboard:**
- List of all complaints
- Filter by status (pending, in-progress, resolved)
- Filter by type
- Assign to moderator
- View complaint details
- View evidence (screenshots, messages)
- Take action
- Close complaint

### 11.5 Certificate Management

**Admin Actions:**
- View all certificates
- Search by certificate ID
- Verify certificate authenticity
- Revoke certificate (with reason)
- Re-issue certificate
- Export certificate data

### 11.6 Analytics & Reporting

**Reports:**
- User growth report
- Revenue report
- Course performance report
- Tutor performance report
- Verification exam statistics
- Certificate issuance report
- Complaint resolution report

**Export Formats:**
- PDF
- Excel
- CSV

---

## 12. TECHNICAL ARCHITECTURE

### 12.1 System Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                   Flutter Mobile App                    │
│              (iOS, Android, Web - Future)               │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ HTTPS
                     ▼
┌─────────────────────────────────────────────────────────┐
│          Web Application Firewall (WAF)                 │
│     - DDoS Protection                                   │
│     - SQL Injection Prevention                          │
│     - Rate Limiting                                     │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                   API Gateway                           │
│     - Request Routing                                   │
│     - Authentication (JWT Validation)                   │
│     - Request/Response Transformation                   │
│     - API Versioning                                    │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
┌───────────────┐         ┌───────────────┐
│ Microservices │         │  AI Service   │
└───────┬───────┘         └───────┬───────┘
        │                         │
        └────────────┬────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │   PostgreSQL Database  │
        │   - Primary Data Store │
        │   - ACID Transactions  │
        └────────────────────────┘
```

### 12.2 Microservices Architecture

**Service Breakdown:**

1. **Authentication Service**
   - User registration
   - Login/Logout
   - OAuth integration
   - JWT token generation/validation
   - Password reset

2. **User Service**
   - Profile management
   - Role management
   - User preferences
   - User search

3. **Verification Service**
   - AI exam generation
   - Exam taking
   - Exam grading
   - Badge issuance
   - Re-verification

4. **Course Service**
   - Course CRUD
   - Course catalog
   - Course search
   - Course enrollment
   - Content delivery

5. **Learning Service**
   - Progress tracking
   - Quiz/assignment management
   - Final exam
   - Certificate generation

6. **Payment Service**
   - Payment processing
   - Wallet management
   - Transaction history
   - Payout processing
   - Refund handling

7. **Messaging Service**
   - Direct messaging
   - Course Q&A
   - Notifications
   - Real-time chat

8. **Review & Rating Service**
   - Rating submission
   - Review management
   - Reputation calculation
   - Fraud detection

9. **Certificate Service**
   - Certificate generation
   - Certificate storage
   - Certificate verification
   - Certificate revocation

10. **Admin Service**
    - User management
    - Content moderation
    - Complaint resolution
    - Analytics
    - System configuration

11. **AI Service**
    - Exam question generation
    - Answer evaluation
    - Recommendation engine
    - Fraud detection
    - Content moderation

### 12.3 Technology Stack

**Backend:**
- **Language**: Node.js (TypeScript) or Python (FastAPI)
- **Framework**: NestJS (Node.js) or FastAPI (Python)
- **API**: RESTful + GraphQL (for complex queries)
- **Authentication**: JWT + OAuth 2.0
- **Database**: PostgreSQL 15+
- **Caching**: Redis
- **Message Queue**: RabbitMQ or Apache Kafka
- **File Storage**: AWS S3 or Google Cloud Storage
- **AI/ML**: OpenAI API, TensorFlow, or PyTorch

**Frontend (Mobile):**
- **Framework**: Flutter 3.10+
- **State Management**: Riverpod or Bloc
- **Local Storage**: Hive or SQLite
- **HTTP Client**: Dio
- **Real-time**: WebSockets or Firebase

**DevOps:**
- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **CI/CD**: GitHub Actions or GitLab CI
- **Monitoring**: Prometheus + Grafana
- **Logging**: ELK Stack (Elasticsearch, Logstash, Kibana)
- **Cloud**: AWS, Google Cloud, or Azure

---

## 13. DATABASE SCHEMA DESIGN

### 13.1 Core Tables

#### **users**
```sql
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    profile_picture_url TEXT,
    bio TEXT,
    auth_provider VARCHAR(50) DEFAULT 'email',
    email_verified BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **user_roles**
```sql
CREATE TABLE user_roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    role_type VARCHAR(50) NOT NULL, -- 'learner', 'tutor', 'admin', 'moderator'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **tutor_verifications**
```sql
CREATE TABLE tutor_verifications (
    verification_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    skill_domain VARCHAR(100) NOT NULL,
    skill_level VARCHAR(50) NOT NULL, -- 'beginner', 'intermediate', 'advanced'
    exam_id UUID,
    score DECIMAL(5,2),
    pass_status BOOLEAN,
    verified_at TIMESTAMP,
    expires_at TIMESTAMP,
    badge_level VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **courses**
```sql
CREATE TABLE courses (
    course_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tutor_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    thumbnail_url TEXT,
    category VARCHAR(100),
    difficulty_level VARCHAR(50),
    price DECIMAL(10,2) DEFAULT 0,
    duration_hours DECIMAL(5,2),
    language VARCHAR(50) DEFAULT 'English',
    status VARCHAR(50) DEFAULT 'draft', -- 'draft', 'published', 'archived'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **course_modules**
```sql
CREATE TABLE course_modules (
    module_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID REFERENCES courses(course_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    order_index INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **lessons**
```sql
CREATE TABLE lessons (
    lesson_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID REFERENCES course_modules(module_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content_type VARCHAR(50), -- 'video', 'article', 'quiz', 'assignment'
    content_url TEXT,
    content_text TEXT,
    duration_minutes INTEGER,
    order_index INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **enrollments**
```sql
CREATE TABLE enrollments (
    enrollment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(course_id) ON DELETE CASCADE,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'active', -- 'active', 'completed', 'refunded'
    completed_at TIMESTAMP,
    UNIQUE(user_id, course_id)
);
```

#### **certificates**
```sql
CREATE TABLE certificates (
    certificate_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(course_id) ON DELETE CASCADE,
    certificate_number VARCHAR(100) UNIQUE NOT NULL,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pdf_url TEXT,
    qr_code_url TEXT,
    status VARCHAR(50) DEFAULT 'valid', -- 'valid', 'revoked'
    revoked_at TIMESTAMP,
    revoke_reason TEXT
);
```

#### **payments**
```sql
CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(course_id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    payment_method VARCHAR(50),
    payment_gateway VARCHAR(50),
    transaction_id VARCHAR(255),
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'completed', 'failed', 'refunded'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **reviews**
```sql
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(course_id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, course_id)
);
```

#### **messages**
```sql
CREATE TABLE messages (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    receiver_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    message_text TEXT NOT NULL,
    attachment_url TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### **notifications**
```sql
CREATE TABLE notifications (
    notification_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 13.2 Indexes

```sql
-- Performance optimization indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_courses_tutor ON courses(tutor_id);
CREATE INDEX idx_courses_category ON courses(category);
CREATE INDEX idx_enrollments_user ON enrollments(user_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_receiver ON messages(receiver_id);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_reviews_course ON reviews(course_id);
```

---

## 14. API DESIGN

### 14.1 API Versioning

All APIs will be versioned: `/api/v1/...`

### 14.2 Authentication APIs

**POST** `/api/v1/auth/register`
```json
Request:
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "full_name": "John Doe",
  "role": "learner"
}

Response:
{
  "success": true,
  "message": "Registration successful. Please verify your email.",
  "user_id": "uuid"
}
```

**POST** `/api/v1/auth/login`
```json
Request:
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}

Response:
{
  "success": true,
  "access_token": "jwt_token",
  "refresh_token": "refresh_token",
  "user": {
    "user_id": "uuid",
    "email": "user@example.com",
    "full_name": "John Doe",
    "roles": ["learner"]
  }
}
```

### 14.3 Course APIs

**GET** `/api/v1/courses`
```
Query params:
- category: string
- search: string
- min_price: number
- max_price: number
- difficulty: string
- page: number
- limit: number

Response:
{
  "success": true,
  "data": [
    {
      "course_id": "uuid",
      "title": "Python for Beginners",
      "description": "...",
      "price": 49.99,
      "rating": 4.7,
      "enrollment_count": 1234,
      "tutor": {
        "name": "Jane Smith",
        "verified": true
      }
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150
  }
}
```

**POST** `/api/v1/courses` (Tutor only)
```json
Request:
{
  "title": "Advanced Python",
  "description": "...",
  "category": "Programming",
  "price": 99.99,
  "difficulty_level": "advanced"
}

Response:
{
  "success": true,
  "course_id": "uuid",
  "message": "Course created successfully"
}
```

### 14.4 Enrollment APIs

**POST** `/api/v1/enrollments`
```json
Request:
{
  "course_id": "uuid",
  "payment_method": "card"
}

Response:
{
  "success": true,
  "enrollment_id": "uuid",
  "payment_url": "https://payment-gateway.com/..."
}
```

### 14.5 Verification APIs

**POST** `/api/v1/verification/request`
```json
Request:
{
  "skill_domain": "Python Programming",
  "skill_level": "intermediate"
}

Response:
{
  "success": true,
  "exam_id": "uuid",
  "message": "Exam generated. You can start now."
}
```

**POST** `/api/v1/verification/submit`
```json
Request:
{
  "exam_id": "uuid",
  "answers": [
    {"question_id": "uuid", "answer": "A"},
    {"question_id": "uuid", "answer": "code here"}
  ]
}

Response:
{
  "success": true,
  "score": 85,
  "pass_status": true,
  "badge_level": "intermediate",
  "message": "Congratulations! You are now a verified tutor."
}
```

---

## 15. SECURITY ARCHITECTURE

### 15.1 Security Layers

```
Layer 1: WAF (Web Application Firewall)
  - DDoS protection
  - SQL injection prevention
  - XSS prevention
  - Rate limiting

Layer 2: API Gateway
  - JWT validation
  - Request sanitization
  - API key validation (for third-party)

Layer 3: Microservices
  - Service-to-service authentication
  - Input validation
  - Business logic security

Layer 4: Database
  - Encrypted connections (SSL/TLS)
  - Encrypted sensitive fields
  - Row-level security
  - Audit logging
```

### 15.2 Authentication & Authorization

**JWT Token Structure:**
```json
{
  "user_id": "uuid",
  "email": "user@example.com",
  "roles": ["learner", "tutor"],
  "iat": 1234567890,
  "exp": 1234567890
}
```

**Token Expiry:**
- Access token: 15 minutes
- Refresh token: 7 days

**OAuth 2.0 Flow:**
```
1. User clicks "Login with Google"
2. Redirect to Google OAuth
3. User authorizes
4. Google redirects back with code
5. Backend exchanges code for token
6. Backend creates/updates user
7. Backend issues JWT
8. User logged in
```

### 15.3 Data Encryption

**At Rest:**
- Database encryption (AES-256)
- Sensitive fields (passwords, payment info) hashed/encrypted

**In Transit:**
- HTTPS/TLS 1.3
- Certificate pinning (mobile app)

**Sensitive Data:**
- Passwords: bcrypt (cost factor 12)
- Payment info: Tokenized (never stored)
- Personal info: Encrypted

### 15.4 Rate Limiting

**API Rate Limits:**
- Unauthenticated: 100 requests/hour
- Authenticated: 1000 requests/hour
- Admin: 5000 requests/hour

**Action-Specific Limits:**
- Login attempts: 5/15 minutes
- Password reset: 3/hour
- Course creation: 10/day
- Message sending: 100/hour

---

## 16. FRONTEND ARCHITECTURE

### 16.1 Flutter App Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   ├── utils/
│   ├── services/
│   └── models/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── courses/
│   ├── learning/
│   ├── verification/
│   ├── profile/
│   ├── messaging/
│   └── admin/
└── shared/
    ├── widgets/
    └── providers/
```

### 16.2 State Management (Riverpod)

**Example: Course State**
```dart
@riverpod
class CourseNotifier extends _$CourseNotifier {
  @override
  Future<List<Course>> build() async {
    return await ref.read(courseRepositoryProvider).getCourses();
  }

  Future<void> enrollInCourse(String courseId) async {
    // Enrollment logic
  }
}
```

### 16.3 Screens (Based on Frontend Designs)

**Authentication Flow:**
1. Welcome Screen (3 variations)
2. Sign In
3. Create Account
4. Account Type Selection
5. Forgot Password
6. Verification Code

**Main App:**
1. Student Home Screen
2. Category Browse
3. Course Selection
4. Learning Screen
5. Search
6. Filter
7. Profile
8. Edit Profile
9. Menu
10. Inbox
11. Personal Inbox
12. Notifications
13. Payment Settings
14. Payment Method
15. Blog Discovery
16. No Data (Empty State)

### 16.4 Design System

**Colors:**
- Primary: #6C63FF (Purple)
- Secondary: #FF6584 (Pink)
- Success: #00D4AA
- Warning: #FFB800
- Error: #FF4757
- Background: #F8F9FA
- Text: #2C3E50

**Typography:**
- Font Family: Inter
- Heading 1: 32px, Bold
- Heading 2: 24px, SemiBold
- Body: 16px, Regular
- Caption: 14px, Regular

**Components:**
- Buttons
- Cards
- Input Fields
- Dropdowns
- Modals
- Bottom Sheets
- Snackbars
- Loading Indicators

---

## 17. INTEGRATION POINTS

### 17.1 Third-Party Integrations

**Payment Gateways:**
- Stripe
- PayPal
- Razorpay (for India)

**Cloud Storage:**
- AWS S3 (videos, images, PDFs)
- Cloudflare CDN (content delivery)

**Email Service:**
- SendGrid or AWS SES

**Push Notifications:**
- Firebase Cloud Messaging (FCM)

**Analytics:**
- Google Analytics
- Mixpanel

**AI/ML:**
- OpenAI API (exam generation, grading)
- Custom ML models (recommendation, fraud detection)

**Video Hosting:**
- Vimeo or AWS CloudFront

### 17.2 Webhooks

**Payment Webhooks:**
- Payment success
- Payment failure
- Refund processed

**Email Webhooks:**
- Email delivered
- Email opened
- Email bounced

---

## 18. SCALABILITY & PERFORMANCE

### 18.1 Scalability Strategy

**Horizontal Scaling:**
- Microservices can scale independently
- Load balancer distributes traffic
- Auto-scaling based on CPU/memory

**Database Scaling:**
- Read replicas for read-heavy operations
- Sharding for large datasets
- Connection pooling

**Caching Strategy:**
- Redis for frequently accessed data
- CDN for static assets
- API response caching

### 18.2 Performance Targets

- **API Response Time**: <500ms (95th percentile)
- **Page Load Time**: <2 seconds
- **Video Streaming**: <3 seconds to start
- **Search Results**: <1 second
- **Database Queries**: <100ms

### 18.3 Monitoring & Alerts

**Metrics to Monitor:**
- API response times
- Error rates
- Database query performance
- Server CPU/memory usage
- Active users
- Payment success rate

**Alerts:**
- Error rate >1%
- Response time >2 seconds
- Database connection pool exhausted
- Payment gateway down

---

## 🎯 CONCLUSION

This deep analysis document serves as the **complete brain** for the SkillSwapp project. It covers:

✅ Business model & value proposition  
✅ All core functionalities in detail  
✅ AI verification system logic  
✅ Learning & certification flow  
✅ Trust & reputation mechanisms  
✅ Payment & monetization  
✅ Communication & community  
✅ Admin system capabilities  
✅ Complete technical architecture  
✅ Database schema design  
✅ API specifications  
✅ Security architecture  
✅ Frontend architecture  
✅ Integration points  
✅ Scalability & performance  

**Next Steps:**
1. Review this document thoroughly
2. Create implementation roadmap
3. Begin development phase by phase

---

**Document Version**: 1.0  
**Last Updated**: 2026-01-11  
**Status**: Complete
