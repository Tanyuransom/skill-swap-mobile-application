# 🔧 SkillSwapp Backend - Dart Shelf Microservices Structure

## 📊 Overview

**Architecture**: Distributed Microservices  
**Framework**: Dart Shelf  
**Database**: PostgreSQL  
**Total Services**: 12 + 1 Shared Library  
**Total Directories**: 106

---

## 🏗️ Complete Backend Structure

```
backend/
├── shared/                          # Shared utilities library
│   ├── lib/
│   │   ├── config/                 # Configuration
│   │   ├── database/               # Database utilities
│   │   ├── middleware/             # Shared middleware
│   │   ├── utils/                  # Utility functions
│   │   ├── models/                 # Shared models
│   │   └── exceptions/             # Exception classes
│   ├── pubspec.yaml
│   └── README.md
│
├── api_gateway/                     # Port 8080 - API Gateway
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   └── routes/
│   ├── pubspec.yaml
│   └── README.md
│
├── auth_service/                    # Port 8081 - Authentication
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   └── routes/
│   ├── pubspec.yaml
│   └── README.md
│
├── user_service/                    # Port 8082 - User Management
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   └── routes/
│   ├── pubspec.yaml
│   └── README.md
│
├── course_service/                  # Port 8083 - Course Management
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   └── routes/
│   ├── pubspec.yaml
│   └── README.md
│
├── verification_service/            # Port 8084 - AI Verification
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   ├── routes/
│   │   └── ai/                     # AI-specific logic
│   ├── pubspec.yaml
│   └── README.md
│
├── learning_service/                # Port 8085 - Learning & Progress
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   └── routes/
│   ├── pubspec.yaml
│   └── README.md
│
├── payment_service/                 # Port 8086 - Payments
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   └── routes/
│   ├── pubspec.yaml
│   └── README.md
│
├── messaging_service/               # Port 8087 - Messaging & Chat
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   ├── routes/
│   │   └── websocket/              # WebSocket handlers
│   ├── pubspec.yaml
│   └── README.md
│
├── review_service/                  # Port 8088 - Reviews & Ratings
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   └── routes/
│   ├── pubspec.yaml
│   └── README.md
│
├── certificate_service/             # Port 8089 - Certificates
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   └── routes/
│   ├── pubspec.yaml
│   └── README.md
│
├── admin_service/                   # Port 8090 - Admin Operations
│   ├── bin/
│   │   └── server.dart
│   ├── lib/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   └── routes/
│   ├── pubspec.yaml
│   └── README.md
│
├── database/                        # Database scripts
│   ├── migrations/
│   ├── seeds/
│   └── schema.sql
│
├── docs/                            # Documentation
│   ├── api/
│   └── deployment/
│
├── scripts/                         # Utility scripts
│   ├── setup.sh
│   └── deploy.sh
│
├── docker-compose.yml               # Docker orchestration
├── .env.example                     # Environment variables template
└── README.md                        # Backend documentation
```

---

## 📋 Service Details

| Service | Port | Purpose | Special Features |
|---------|------|---------|------------------|
| **API Gateway** | 8080 | Single entry point, routing | Rate limiting, auth |
| **Auth Service** | 8081 | Authentication, OAuth | JWT, Google, Facebook |
| **User Service** | 8082 | User profiles, roles | Student/Tutor management |
| **Course Service** | 8083 | Course CRUD, content | Modules, lessons |
| **Verification Service** | 8084 | AI tutor verification | AI exam generation |
| **Learning Service** | 8085 | Progress tracking | Enrollment, completion |
| **Payment Service** | 8086 | Payments, wallet | Stripe, PayPal |
| **Messaging Service** | 8087 | Chat, notifications | WebSocket, real-time |
| **Review Service** | 8088 | Ratings, reviews | Reputation calculation |
| **Certificate Service** | 8089 | Certificate generation | PDF, QR codes |
| **Admin Service** | 8090 | Admin operations | User management, moderation |

---

## 🔧 Technology Stack

### Core
- **Dart SDK**: 3.0+
- **Shelf**: HTTP server framework
- **Shelf Router**: Routing
- **Shelf CORS**: CORS middleware

### Database
- **PostgreSQL**: 15+
- **postgres**: Dart PostgreSQL driver

### Authentication
- **dart_jsonwebtoken**: JWT tokens
- **crypto**: Password hashing

### Utilities
- **dotenv**: Environment variables
- **logger**: Logging
- **uuid**: UUID generation

### External Services
- **http**: HTTP client
- **dio**: Advanced HTTP client (optional)

---

## 📦 Shared Library Dependencies

The `shared/` package provides common utilities used by all services:

### Config
- Database configuration
- Redis configuration
- Environment configuration

### Database
- PostgreSQL client
- Connection pooling
- Query builders

### Middleware
- Authentication middleware
- CORS middleware
- Logging middleware
- Error middleware

### Utils
- JWT utilities
- Hash utilities
- Validators
- Logger

### Models
- API response models
- Error response models

### Exceptions
- Application exceptions
- Database exceptions

---

## 🚀 Service Communication

### Synchronous (REST)
```
Client → API Gateway → Service → Database
```

### Asynchronous (Events)
```
Service A → Message Queue → Service B
```

### Database Access
```
Service → Shared DB Client → PostgreSQL
```

---

## 🔐 Security Architecture

```
Client Request
    ↓
API Gateway (Port 8080)
    ↓
Authentication Check
    ↓
Route to Service
    ↓
Service Logic
    ↓
Database Query
    ↓
Response
```

---

## 📝 Next Steps

### 1. Create pubspec.yaml for Each Service
- Add Shelf dependencies
- Add PostgreSQL driver
- Add shared package reference

### 2. Implement Shared Library
- Database connection
- Middleware
- Utilities

### 3. Implement API Gateway
- Routing configuration
- Authentication middleware
- Service proxy

### 4. Implement Auth Service
- User registration
- Login
- JWT generation
- OAuth integration

### 5. Implement Other Services
Follow the same pattern for each service

### 6. Database Setup
- Create schema
- Run migrations
- Seed data

### 7. Docker Setup
- Create Dockerfiles
- Configure docker-compose
- Set up networking

---

## ✅ Structure Status

- ✅ 106 directories created
- ✅ Folder structure complete
- ⏭️ pubspec.yaml files (next)
- ⏭️ Server entry points (next)
- ⏭️ Implementation (after setup)

---

**Ready for implementation!**
