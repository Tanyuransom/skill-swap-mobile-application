# 🚀 DATABASE SETUP GUIDE

## 📋 Overview

This guide will help you set up the SkillSwapp database using Docker.

---

## 🐳 Prerequisites

1. **Docker Desktop** installed and running
   - Download from: https://www.docker.com/products/docker-desktop
   - Make sure Docker is running (check system tray/menu bar)

2. **Git Bash or PowerShell** (Windows)

---

## 🏗️ What's Included

### Docker Services
- **PostgreSQL 15** - Main database (Port 5432)
- **Redis 7** - Caching layer (Port 6379)
- **pgAdmin** - Database management UI (Port 5050)

### Database Files
- `database/schema.sql` - Complete database schema (25+ tables)
- `database/seeds/initial_data.sql` - Seed data (categories, test users)

---

## 🚀 Quick Start

### Step 1: Start Docker Containers

Open terminal in the project root and run:

```bash
docker-compose up -d
```

This will:
- ✅ Download PostgreSQL, Redis, and pgAdmin images
- ✅ Create and start all containers
- ✅ Automatically run schema.sql to create all tables
- ✅ Automatically run seed data to populate initial data

### Step 2: Verify Containers are Running

```bash
docker ps
```

You should see 3 containers running:
- `skillswapp_postgres`
- `skillswapp_redis`
- `skillswapp_pgadmin`

### Step 3: Access pgAdmin (Optional)

Open browser and go to: http://localhost:5050

**Login Credentials:**
- Email: `admin@skillswapp.com`
- Password: `admin123`

**Connect to PostgreSQL:**
1. Click "Add New Server"
2. General Tab:
   - Name: `SkillSwapp Local`
3. Connection Tab:
   - Host: `postgres` (container name)
   - Port: `5432`
   - Database: `skillswapp`
   - Username: `skillswapp_user`
   - Password: `skillswapp_dev_password_2024`
4. Click "Save"

---

## 📊 Database Details

### Connection Info
- **Host**: `localhost`
- **Port**: `5432`
- **Database**: `skillswapp`
- **Username**: `skillswapp_user`
- **Password**: `skillswapp_dev_password_2024`

### Redis Connection Info
- **Host**: `localhost`
- **Port**: `6379`
- **Password**: `skillswapp_redis_password_2024`

---

## 👥 Test Users

After setup, you'll have these test users:

### Admin User
- **Email**: `admin@skillswapp.com`
- **Password**: `Admin@123`
- **Role**: Admin

### Test Learner
- **Email**: `learner@test.com`
- **Password**: `Learner@123`
- **Role**: Learner

### Test Tutor
- **Email**: `tutor@test.com`
- **Password**: `Tutor@123`
- **Role**: Tutor

---

## 📂 Database Tables Created

### Users & Authentication (4 tables)
- `users` - User accounts
- `user_roles` - User roles (learner, tutor, admin)
- `refresh_tokens` - JWT refresh tokens
- `audit_logs` - Audit trail

### Courses (4 tables)
- `categories` - Course categories
- `courses` - Course information
- `course_modules` - Course modules
- `course_lessons` - Individual lessons

### Learning (3 tables)
- `enrollments` - Student enrollments
- `learning_progress` - Progress tracking
- `quiz_submissions` - Quiz results

### Verification (2 tables)
- `verifications` - Tutor verifications
- `verification_exams` - Verification exams

### Payments (4 tables)
- `payments` - Payment records
- `wallets` - User wallets
- `wallet_transactions` - Wallet transactions
- `payouts` - Tutor payouts

### Reviews (2 tables)
- `reviews` - Course reviews
- `tutor_reputation` - Tutor reputation scores

### Communication (2 tables)
- `messages` - Direct messages
- `notifications` - User notifications

### Certificates (1 table)
- `certificates` - Course completion certificates

### Moderation (1 table)
- `complaints` - User complaints

**Total: 25 tables**

---

## 🔧 Useful Commands

### Start all containers
```bash
docker-compose up -d
```

### Stop all containers
```bash
docker-compose down
```

### View logs
```bash
docker-compose logs -f
```

### View PostgreSQL logs only
```bash
docker-compose logs -f postgres
```

### Access PostgreSQL CLI
```bash
docker exec -it skillswapp_postgres psql -U skillswapp_user -d skillswapp
```

### Run SQL file manually
```bash
docker exec -i skillswapp_postgres psql -U skillswapp_user -d skillswapp < database/schema.sql
```

### Restart containers
```bash
docker-compose restart
```

### Remove all containers and volumes (CAUTION: Deletes all data!)
```bash
docker-compose down -v
```

---

## 🐛 Troubleshooting

### Port Already in Use
If you get "port already in use" error:

**Option 1: Stop existing service**
```bash
# Windows
net stop postgresql-x64-15

# Or find and kill process using port 5432
netstat -ano | findstr :5432
taskkill /PID <process_id> /F
```

**Option 2: Change port in docker-compose.yml**
```yaml
ports:
  - "5433:5432"  # Use 5433 instead of 5432
```

### Container Won't Start
```bash
# Check logs
docker-compose logs postgres

# Remove and recreate
docker-compose down -v
docker-compose up -d
```

### Can't Connect to Database
1. Make sure containers are running: `docker ps`
2. Check if PostgreSQL is healthy: `docker-compose ps`
3. Verify connection details in pgAdmin
4. Check firewall settings

---

## 📝 Next Steps

After database setup:

1. ✅ **Verify database is running**
2. ✅ **Check tables were created** (use pgAdmin)
3. ✅ **Verify seed data** (check categories and users)
4. 🔜 **Create backend shared utilities**
5. 🔜 **Build authentication service**
6. 🔜 **Build API gateway**

---

## 🎯 Database Schema Highlights

### Key Features
- ✅ UUID primary keys for all tables
- ✅ Automatic `updated_at` triggers
- ✅ Proper foreign key relationships
- ✅ Indexes for performance
- ✅ Check constraints for data validation
- ✅ JSONB fields for flexible data
- ✅ Audit logging capability

### Security
- ✅ Password hashing (bcrypt)
- ✅ Email verification tokens
- ✅ Password reset tokens
- ✅ Refresh token rotation
- ✅ Soft deletes where appropriate

---

## 📞 Need Help?

If you encounter issues:
1. Check Docker Desktop is running
2. Check the troubleshooting section above
3. View container logs: `docker-compose logs`
4. Restart containers: `docker-compose restart`

---

**Database Setup Complete!** ✅

You're ready to start building the backend services! 🚀
