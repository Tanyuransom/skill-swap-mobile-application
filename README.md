# SkillSwapp - AI-Verified Peer-to-Peer Learning Platform

> An enterprise-grade, distributed microservices platform enabling students to learn from AI-verified tutors.

## 🎯 Project Overview

SkillSwapp is a peer-to-peer learning marketplace where:
- Students can learn from verified tutors
- Anyone can become a tutor after passing an **AI-powered verification exam**
- Learners receive **verifiable certificates** upon course completion
- Trust is built through ratings, reviews, and reputation scores

## 🏗️ Architecture

### Frontend (Flutter)
- **Student App** - Browse courses, learn, earn certificates
- **Tutor App** - Create courses, manage students, track earnings

### Backend (Dart Shelf Microservices)
- **API Gateway** - Single entry point (Port 8080)
- **Auth Service** - Authentication & OAuth (Port 8081)
- **User Service** - Profile management (Port 8082)
- **Course Service** - Course CRUD (Port 8083)
- **Verification Service** - AI exam generation & grading (Port 8084)
- **Learning Service** - Progress tracking (Port 8085)
- **Payment Service** - Stripe, PayPal, wallet (Port 8086)
- **Messaging Service** - Chat & notifications (Port 8087)
- **Review Service** - Ratings & reviews (Port 8088)
- **Certificate Service** - PDF generation (Port 8089)
- **Admin Service** - User & content management (Port 8090)

### Database
- **PostgreSQL** - Primary data store
- **Redis** - Caching layer

## 📂 Project Structure

```
SkillSwapp/
├── frontend/
│   ├── student_app/      # Student Flutter app (10 features)
│   └── tutor_app/        # Tutor Flutter app (11 features)
├── backend/
│   ├── shared/           # Shared utilities
│   ├── api_gateway/      # API Gateway
│   └── [11 microservices]
├── database/
│   ├── migrations/
│   └── seeds/
├── brain/                # Project documentation
└── docs/                 # API & deployment docs
```

## 🚀 Key Features

### For Students
- Browse & search courses by category
- Enroll in courses
- Track learning progress
- Take quizzes & final exams
- Earn verifiable certificates
- Rate & review courses
- Message tutors

### For Tutors
- **AI Verification Exam** - Prove your expertise
- Create & publish courses
- Upload video lessons
- Manage enrolled students
- Track earnings & analytics
- Receive payments via Stripe/PayPal
- Build reputation through ratings

### For Platform
- AI-powered tutor verification
- Secure payment processing
- Certificate generation with QR codes
- Real-time messaging
- Admin dashboard
- Content moderation
- Analytics & reporting

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.10+**
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Dio** - HTTP client
- **Hive** - Local storage

### Backend
- **Dart Shelf** - Microservices framework
- **PostgreSQL 15+** - Database
- **Redis** - Cache
- **Docker** - Containerization
- **OpenAI API** - AI verification

### DevOps
- **Docker Compose** - Orchestration
- **GitHub Actions** - CI/CD
- **AWS/GCP** - Cloud hosting

## 📚 Documentation

Comprehensive documentation is available in the `brain/` folder:

- **guideline.md** - Master system prompt & architecture principles
- **deep_analysis.md** - Complete functionality & business logic analysis
- **implementation_roadmap.md** - 8-phase development roadmap
- **project_structure.md** - Detailed project structure specification
- **structure_created_summary.md** - Verification of created structure

## 🔐 Security

- **Zero-trust architecture** - WAF → API Gateway → Services → Database
- **JWT authentication** - Secure token-based auth
- **OAuth 2.0** - Google & Facebook login
- **Encrypted storage** - Sensitive data encryption
- **Rate limiting** - DDoS protection
- **Input validation** - SQL injection prevention

## 🎨 Design

UI/UX designs are available in the `frontendfig/` folder (27 mockups):
- Welcome & onboarding screens
- Authentication flows
- Course browsing & discovery
- Learning experience
- Profile & settings
- Messaging & notifications
- Payment flows

## 🧪 Testing

- **Unit Tests** - Business logic testing
- **Widget Tests** - UI component testing
- **Integration Tests** - End-to-end flows
- **API Tests** - Backend endpoint testing

## 📦 Installation

### Prerequisites
- Flutter SDK 3.10+
- Dart SDK 3.10+
- PostgreSQL 15+
- Redis 7+
- Docker Desktop

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Tanyuransom/skill-swap-mobile-application.git
   cd skill-swap-mobile-application
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Start backend services**
   ```bash
   docker-compose up -d
   ```

4. **Run database migrations**
   ```bash
   cd database
   psql -U skillswapp_user -d skillswapp -f schema.sql
   ```

5. **Run Student App**
   ```bash
   cd frontend/student_app
   flutter pub get
   flutter run
   ```

6. **Run Tutor App**
   ```bash
   cd frontend/tutor_app
   flutter pub get
   flutter run
   ```

## 🗺️ Roadmap

- [x] Phase 1: Foundation & Setup
- [x] Phase 2: Project Structure Creation
- [ ] Phase 3: Backend Core Services
- [ ] Phase 4: AI Verification System
- [ ] Phase 5: Frontend Development
- [ ] Phase 6: Integration & Testing
- [ ] Phase 7: Admin Panel & Analytics
- [ ] Phase 8: Deployment & Launch

See `brain/implementation_roadmap.md` for detailed task breakdown.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

- **Developer** - Full-stack development
- **AI Assistant** - Architecture & implementation support

## 📞 Contact

For questions or support, please open an issue on GitHub.

---

**Built with ❤️ using Flutter & Dart Shelf**
