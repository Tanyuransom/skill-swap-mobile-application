# 🏗️ SKILLSWAPP - COMPLETE PROJECT STRUCTURE

> **Architecture**: Distributed Microservices (Dart Shelf) + Separate Flutter Apps (Student & Tutor)  
> **Backend**: Dart Shelf Microservices  
> **Frontend**: Two Flutter Apps (Student App & Tutor App)  
> **Database**: PostgreSQL  

---

## 📂 ROOT PROJECT STRUCTURE

```
SkillSwapp/
├── brain/                          # Project documentation & analysis
│   ├── guideline.md
│   ├── deep_analysis.md
│   ├── implementation_roadmap.md
│   └── project_structure.md
│
├── frontend/                       # Frontend applications
│   ├── student_app/               # Student Flutter app
│   └── tutor_app/                 # Tutor Flutter app
│
├── backend/                        # Backend microservices
│   ├── shared/                    # Shared utilities across services
│   ├── api_gateway/               # API Gateway service
│   ├── auth_service/              # Authentication service
│   ├── user_service/              # User management service
│   ├── course_service/            # Course management service
│   ├── verification_service/      # AI verification service
│   ├── learning_service/          # Learning & progress service
│   ├── payment_service/           # Payment processing service
│   ├── messaging_service/         # Messaging & notifications service
│   ├── review_service/            # Reviews & ratings service
│   ├── certificate_service/       # Certificate management service
│   └── admin_service/             # Admin operations service
│
├── database/                       # Database scripts
│   ├── migrations/
│   ├── seeds/
│   └── schema.sql
│
├── docs/                          # Additional documentation
│   ├── api/                       # API documentation
│   └── deployment/                # Deployment guides
│
├── scripts/                       # Utility scripts
│   ├── setup.sh
│   └── deploy.sh
│
├── docker-compose.yml             # Docker orchestration
└── README.md                      # Project overview
```

---

## 📱 FRONTEND STRUCTURE

---

## 1️⃣ STUDENT APP (`frontend/student_app/`)

```
student_app/
├── lib/
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── app.dart
│   │   ├── router.dart
│   │   └── theme/
│   │       ├── colors.dart
│   │       ├── text_styles.dart
│   │       └── theme.dart
│   │
│   ├── core/
│   │   ├── api/
│   │   │   ├── api_client.dart
│   │   │   ├── endpoints.dart
│   │   │   └── interceptors.dart
│   │   ├── storage/
│   │   │   ├── local_storage.dart
│   │   │   └── secure_storage.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   └── constants.dart
│   │   └── errors/
│   │       └── exceptions.dart
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── buttons/
│   │   │   ├── inputs/
│   │   │   ├── cards/
│   │   │   └── loaders/
│   │   └── models/
│   │       └── user_model.dart
│   │
│   └── features/
│       │
│       ├── auth/                          # Authentication
│       │   ├── data/
│       │   │   ├── models/
│       │   │   ├── datasources/
│       │   │   └── repositories/
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   ├── repositories/
│       │   │   └── usecases/
│       │   └── presentation/
│       │       ├── providers/
│       │       ├── screens/
│       │       │   ├── welcome_screen.dart
│       │       │   ├── signin_screen.dart
│       │       │   ├── signup_screen.dart
│       │       │   └── forgot_password_screen.dart
│       │       └── widgets/
│       │
│       ├── home/                          # Student Dashboard
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           └── student_home_screen.dart
│       │
│       ├── browse/                        # Browse & Search Courses
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── categories_screen.dart
│       │           ├── course_list_screen.dart
│       │           ├── course_detail_screen.dart
│       │           ├── search_screen.dart
│       │           └── filter_screen.dart
│       │
│       ├── learning/                      # Learning Experience
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── my_courses_screen.dart
│       │           ├── course_player_screen.dart
│       │           ├── quiz_screen.dart
│       │           └── final_exam_screen.dart
│       │
│       ├── certificates/                  # Student Certificates
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── certificates_screen.dart
│       │           └── certificate_detail_screen.dart
│       │
│       ├── profile/                       # Student Profile
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── profile_screen.dart
│       │           ├── edit_profile_screen.dart
│       │           └── settings_screen.dart
│       │
│       ├── payment/                       # Student Payments
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── payment_screen.dart
│       │           ├── payment_methods_screen.dart
│       │           └── transaction_history_screen.dart
│       │
│       ├── messaging/                     # Student Messaging
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── inbox_screen.dart
│       │           └── chat_screen.dart
│       │
│       ├── notifications/                 # Student Notifications
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           └── notifications_screen.dart
│       │
│       └── reviews/                       # Submit Reviews
│           ├── data/
│           ├── domain/
│           └── presentation/
│               └── screens/
│                   └── submit_review_screen.dart
│
├── assets/
│   ├── images/
│   ├── fonts/
│   └── animations/
│
├── test/
├── pubspec.yaml
└── README.md
```

---

## 2️⃣ TUTOR APP (`frontend/tutor_app/`)

```
tutor_app/
├── lib/
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── app.dart
│   │   ├── router.dart
│   │   └── theme/
│   │       ├── colors.dart
│   │       ├── text_styles.dart
│   │       └── theme.dart
│   │
│   ├── core/
│   │   ├── api/
│   │   ├── storage/
│   │   ├── utils/
│   │   └── errors/
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   └── models/
│   │
│   └── features/
│       │
│       ├── auth/                          # Tutor Authentication
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── signin_screen.dart
│       │           └── signup_screen.dart
│       │
│       ├── verification/                  # AI Tutor Verification
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── verification_request_screen.dart
│       │           ├── skill_selection_screen.dart
│       │           ├── verification_exam_screen.dart
│       │           └── verification_result_screen.dart
│       │
│       ├── dashboard/                     # Tutor Dashboard
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           └── tutor_dashboard_screen.dart
│       │
│       ├── courses/                       # Course Management
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── my_courses_screen.dart
│       │           ├── create_course_screen.dart
│       │           ├── edit_course_screen.dart
│       │           ├── add_module_screen.dart
│       │           ├── add_lesson_screen.dart
│       │           └── upload_content_screen.dart
│       │
│       ├── students/                      # Student Management
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── enrolled_students_screen.dart
│       │           └── student_progress_screen.dart
│       │
│       ├── earnings/                      # Earnings & Payouts
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── earnings_screen.dart
│       │           ├── payout_screen.dart
│       │           └── transaction_history_screen.dart
│       │
│       ├── analytics/                     # Course Analytics
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           └── course_analytics_screen.dart
│       │
│       ├── profile/                       # Tutor Profile
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── tutor_profile_screen.dart
│       │           ├── edit_profile_screen.dart
│       │           └── settings_screen.dart
│       │
│       ├── messaging/                     # Tutor Messaging
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           ├── inbox_screen.dart
│       │           └── chat_screen.dart
│       │
│       ├── notifications/                 # Tutor Notifications
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │       └── screens/
│       │           └── notifications_screen.dart
│       │
│       └── reviews/                       # View Reviews
│           ├── data/
│           ├── domain/
│           └── presentation/
│               └── screens/
│                   └── reviews_screen.dart
│
├── assets/
├── test/
├── pubspec.yaml
└── README.md
```

---

## 🔧 BACKEND STRUCTURE (Dart Shelf Microservices)

---

## SHARED UTILITIES (`backend/shared/`)

```
shared/
├── lib/
│   ├── config/
│   │   ├── database_config.dart
│   │   ├── redis_config.dart
│   │   └── env_config.dart
│   │
│   ├── database/
│   │   ├── postgres_client.dart
│   │   └── connection_pool.dart
│   │
│   ├── middleware/
│   │   ├── auth_middleware.dart
│   │   ├── cors_middleware.dart
│   │   ├── logging_middleware.dart
│   │   └── error_middleware.dart
│   │
│   ├── utils/
│   │   ├── jwt_utils.dart
│   │   ├── hash_utils.dart
│   │   ├── validators.dart
│   │   └── logger.dart
│   │
│   ├── models/
│   │   ├── api_response.dart
│   │   └── error_response.dart
│   │
│   └── exceptions/
│       ├── app_exception.dart
│       └── database_exception.dart
│
├── pubspec.yaml
└── README.md
```

---

## 1️⃣ API GATEWAY (`backend/api_gateway/`)

```
api_gateway/
├── bin/
│   └── server.dart                    # Main entry point
│
├── lib/
│   ├── routes/
│   │   ├── router.dart               # Main router
│   │   ├── auth_routes.dart
│   │   ├── user_routes.dart
│   │   ├── course_routes.dart
│   │   ├── verification_routes.dart
│   │   ├── learning_routes.dart
│   │   ├── payment_routes.dart
│   │   ├── messaging_routes.dart
│   │   ├── review_routes.dart
│   │   ├── certificate_routes.dart
│   │   └── admin_routes.dart
│   │
│   ├── middleware/
│   │   ├── rate_limiter.dart
│   │   ├── request_validator.dart
│   │   └── api_versioning.dart
│   │
│   ├── proxy/
│   │   └── service_proxy.dart        # Proxy to microservices
│   │
│   └── config/
│       └── gateway_config.dart
│
├── pubspec.yaml
└── README.md
```

---

## 2️⃣ AUTH SERVICE (`backend/auth_service/`)

```
auth_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   ├── auth_controller.dart
│   │   └── oauth_controller.dart
│   │
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── jwt_service.dart
│   │   ├── oauth_service.dart
│   │   └── email_service.dart
│   │
│   ├── repositories/
│   │   └── auth_repository.dart
│   │
│   ├── models/
│   │   ├── login_request.dart
│   │   ├── register_request.dart
│   │   ├── auth_response.dart
│   │   └── user_credentials.dart
│   │
│   ├── routes/
│   │   └── auth_routes.dart
│   │
│   └── utils/
│       ├── password_hasher.dart
│       └── token_generator.dart
│
├── pubspec.yaml
└── README.md
```

---

## 3️⃣ USER SERVICE (`backend/user_service/`)

```
user_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   ├── user_controller.dart
│   │   └── profile_controller.dart
│   │
│   ├── services/
│   │   ├── user_service.dart
│   │   ├── profile_service.dart
│   │   └── role_service.dart
│   │
│   ├── repositories/
│   │   └── user_repository.dart
│   │
│   ├── models/
│   │   ├── user.dart
│   │   ├── profile.dart
│   │   └── user_role.dart
│   │
│   └── routes/
│       └── user_routes.dart
│
├── pubspec.yaml
└── README.md
```

---

## 4️⃣ COURSE SERVICE (`backend/course_service/`)

```
course_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   ├── course_controller.dart
│   │   ├── module_controller.dart
│   │   ├── lesson_controller.dart
│   │   └── category_controller.dart
│   │
│   ├── services/
│   │   ├── course_service.dart
│   │   ├── module_service.dart
│   │   ├── lesson_service.dart
│   │   ├── search_service.dart
│   │   └── content_upload_service.dart
│   │
│   ├── repositories/
│   │   ├── course_repository.dart
│   │   ├── module_repository.dart
│   │   └── lesson_repository.dart
│   │
│   ├── models/
│   │   ├── course.dart
│   │   ├── module.dart
│   │   ├── lesson.dart
│   │   └── category.dart
│   │
│   └── routes/
│       └── course_routes.dart
│
├── pubspec.yaml
└── README.md
```

---

## 5️⃣ VERIFICATION SERVICE (`backend/verification_service/`)

```
verification_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   ├── verification_controller.dart
│   │   └── exam_controller.dart
│   │
│   ├── services/
│   │   ├── verification_service.dart
│   │   ├── ai_exam_generator.dart
│   │   ├── exam_grader.dart
│   │   └── badge_service.dart
│   │
│   ├── repositories/
│   │   ├── verification_repository.dart
│   │   └── exam_repository.dart
│   │
│   ├── models/
│   │   ├── verification_request.dart
│   │   ├── exam.dart
│   │   ├── question.dart
│   │   ├── answer.dart
│   │   └── verification_result.dart
│   │
│   ├── ai/
│   │   ├── openai_client.dart
│   │   ├── question_generator.dart
│   │   └── answer_evaluator.dart
│   │
│   └── routes/
│       └── verification_routes.dart
│
├── pubspec.yaml
└── README.md
```

---

## 6️⃣ LEARNING SERVICE (`backend/learning_service/`)

```
learning_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   ├── enrollment_controller.dart
│   │   ├── progress_controller.dart
│   │   └── quiz_controller.dart
│   │
│   ├── services/
│   │   ├── enrollment_service.dart
│   │   ├── progress_tracking_service.dart
│   │   ├── quiz_service.dart
│   │   └── completion_service.dart
│   │
│   ├── repositories/
│   │   ├── enrollment_repository.dart
│   │   ├── progress_repository.dart
│   │   └── quiz_repository.dart
│   │
│   ├── models/
│   │   ├── enrollment.dart
│   │   ├── progress.dart
│   │   ├── quiz.dart
│   │   └── quiz_submission.dart
│   │
│   └── routes/
│       └── learning_routes.dart
│
├── pubspec.yaml
└── README.md
```

---

## 7️⃣ PAYMENT SERVICE (`backend/payment_service/`)

```
payment_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   ├── payment_controller.dart
│   │   ├── wallet_controller.dart
│   │   └── payout_controller.dart
│   │
│   ├── services/
│   │   ├── payment_service.dart
│   │   ├── stripe_service.dart
│   │   ├── paypal_service.dart
│   │   ├── wallet_service.dart
│   │   └── payout_service.dart
│   │
│   ├── repositories/
│   │   ├── payment_repository.dart
│   │   ├── wallet_repository.dart
│   │   └── transaction_repository.dart
│   │
│   ├── models/
│   │   ├── payment.dart
│   │   ├── transaction.dart
│   │   ├── wallet.dart
│   │   └── payout.dart
│   │
│   └── routes/
│       └── payment_routes.dart
│
├── pubspec.yaml
└── README.md
```

---

## 8️⃣ MESSAGING SERVICE (`backend/messaging_service/`)

```
messaging_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   ├── message_controller.dart
│   │   └── notification_controller.dart
│   │
│   ├── services/
│   │   ├── messaging_service.dart
│   │   ├── notification_service.dart
│   │   ├── push_notification_service.dart
│   │   └── email_notification_service.dart
│   │
│   ├── repositories/
│   │   ├── message_repository.dart
│   │   └── notification_repository.dart
│   │
│   ├── models/
│   │   ├── message.dart
│   │   ├── conversation.dart
│   │   └── notification.dart
│   │
│   ├── websocket/
│   │   └── websocket_handler.dart
│   │
│   └── routes/
│       └── messaging_routes.dart
│
├── pubspec.yaml
└── README.md
```

---

## 9️⃣ REVIEW SERVICE (`backend/review_service/`)

```
review_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   ├── review_controller.dart
│   │   └── rating_controller.dart
│   │
│   ├── services/
│   │   ├── review_service.dart
│   │   ├── rating_service.dart
│   │   └── reputation_service.dart
│   │
│   ├── repositories/
│   │   └── review_repository.dart
│   │
│   ├── models/
│   │   ├── review.dart
│   │   ├── rating.dart
│   │   └── reputation.dart
│   │
│   └── routes/
│       └── review_routes.dart
│
├── pubspec.yaml
└── README.md
```

---

## 🔟 CERTIFICATE SERVICE (`backend/certificate_service/`)

```
certificate_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   └── certificate_controller.dart
│   │
│   ├── services/
│   │   ├── certificate_service.dart
│   │   ├── pdf_generator.dart
│   │   └── qr_generator.dart
│   │
│   ├── repositories/
│   │   └── certificate_repository.dart
│   │
│   ├── models/
│   │   └── certificate.dart
│   │
│   └── routes/
│       └── certificate_routes.dart
│
├── pubspec.yaml
└── README.md
```

---

## 1️⃣1️⃣ ADMIN SERVICE (`backend/admin_service/`)

```
admin_service/
├── bin/
│   └── server.dart
│
├── lib/
│   ├── controllers/
│   │   ├── user_management_controller.dart
│   │   ├── content_moderation_controller.dart
│   │   ├── complaint_controller.dart
│   │   └── analytics_controller.dart
│   │
│   ├── services/
│   │   ├── user_management_service.dart
│   │   ├── moderation_service.dart
│   │   ├── complaint_service.dart
│   │   └── analytics_service.dart
│   │
│   ├── repositories/
│   │   ├── admin_repository.dart
│   │   └── analytics_repository.dart
│   │
│   ├── models/
│   │   ├── admin_action.dart
│   │   ├── complaint.dart
│   │   └── analytics_data.dart
│   │
│   └── routes/
│       └── admin_routes.dart
│
├── pubspec.yaml
└── README.md
```

---

## 🗄️ DATABASE STRUCTURE (`database/`)

```
database/
├── migrations/
│   ├── 001_create_users_table.sql
│   ├── 002_create_courses_table.sql
│   ├── 003_create_enrollments_table.sql
│   ├── 004_create_payments_table.sql
│   ├── 005_create_messages_table.sql
│   ├── 006_create_reviews_table.sql
│   ├── 007_create_certificates_table.sql
│   ├── 008_create_verifications_table.sql
│   └── 009_create_notifications_table.sql
│
├── seeds/
│   ├── categories_seed.sql
│   ├── admin_user_seed.sql
│   └── test_data_seed.sql
│
└── schema.sql                        # Complete schema
```

---

## 🐳 DOCKER CONFIGURATION

### `docker-compose.yml` (Root)

```yaml
version: '3.8'

services:
  # Database
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: skillswapp
      POSTGRES_USER: skillswapp_user
      POSTGRES_PASSWORD: secure_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database:/docker-entrypoint-initdb.d

  # Redis Cache
  redis:
    image: redis:7
    ports:
      - "6379:6379"

  # API Gateway
  api_gateway:
    build: ./backend/api_gateway
    ports:
      - "8080:8080"
    depends_on:
      - postgres
      - redis

  # Auth Service
  auth_service:
    build: ./backend/auth_service
    ports:
      - "8081:8081"
    depends_on:
      - postgres
      - redis

  # User Service
  user_service:
    build: ./backend/user_service
    ports:
      - "8082:8082"
    depends_on:
      - postgres

  # Course Service
  course_service:
    build: ./backend/course_service
    ports:
      - "8083:8083"
    depends_on:
      - postgres

  # Verification Service
  verification_service:
    build: ./backend/verification_service
    ports:
      - "8084:8084"
    depends_on:
      - postgres

  # Learning Service
  learning_service:
    build: ./backend/learning_service
    ports:
      - "8085:8085"
    depends_on:
      - postgres

  # Payment Service
  payment_service:
    build: ./backend/payment_service
    ports:
      - "8086:8086"
    depends_on:
      - postgres

  # Messaging Service
  messaging_service:
    build: ./backend/messaging_service
    ports:
      - "8087:8087"
    depends_on:
      - postgres
      - redis

  # Review Service
  review_service:
    build: ./backend/review_service
    ports:
      - "8088:8088"
    depends_on:
      - postgres

  # Certificate Service
  certificate_service:
    build: ./backend/certificate_service
    ports:
      - "8089:8089"
    depends_on:
      - postgres

  # Admin Service
  admin_service:
    build: ./backend/admin_service
    ports:
      - "8090:8090"
    depends_on:
      - postgres

volumes:
  postgres_data:
```

---

## 📊 SERVICE COMMUNICATION FLOW

```
Student App / Tutor App
        ↓
    HTTPS (Port 8080)
        ↓
   API Gateway
        ↓
   ┌────┴────┬────────┬──────────┬─────────┐
   ↓         ↓        ↓          ↓         ↓
Auth      User    Course   Verification  Payment
Service   Service Service   Service      Service
(8081)    (8082)  (8083)    (8084)       (8086)
   ↓         ↓        ↓          ↓         ↓
   └─────────┴────────┴──────────┴─────────┘
                    ↓
              PostgreSQL
```

---

## 🎯 KEY FEATURES OF THIS STRUCTURE

### ✅ **Separation of Concerns**
- Student app and Tutor app are completely separate
- Each has its own features and UI flows
- Shared backend serves both apps

### ✅ **Microservices Architecture**
- 11 independent services
- Each service has single responsibility
- Easy to scale independently
- Easy to maintain and update

### ✅ **Clean Architecture**
- Controllers → Services → Repositories
- Clear data flow
- Testable components

### ✅ **Scalability**
- Horizontal scaling per service
- Load balancing via API Gateway
- Database connection pooling

### ✅ **Security**
- API Gateway as single entry point
- JWT authentication
- Service-to-service authentication
- Rate limiting

---

## 📝 NEXT STEPS

1. ✅ **Review this structure**
2. 🏗️ **Create folder structure**
3. 📦 **Set up dependencies**
4. 🔧 **Implement shared utilities**
5. 🚀 **Start with Auth Service + Student App Auth**

---

**Document Version**: 2.0  
**Created**: 2026-01-11  
**Status**: Proposed - Awaiting Approval
