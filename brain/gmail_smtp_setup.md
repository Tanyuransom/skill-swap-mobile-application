# 📧 Gmail SMTP Configuration Guide

## ✅ Database Schema Applied!

All 25+ tables have been successfully created in Neon PostgreSQL.

---

## 🔧 Gmail SMTP Setup Required

To enable OTP email verification, you need to configure Gmail SMTP.

### Step 1: Get Gmail App Password

1. Go to: https://myaccount.google.com/apppasswords
2. Sign in to your Gmail account
3. Create a new app password:
   - App name: "SkillSwapp Backend"
   - Click "Create"
4. Copy the 16-character password (format: `xxxx xxxx xxxx xxxx`)

### Step 2: Provide Credentials

**I need:**
- Your Gmail email address
- The app password you just created

### Step 3: I'll Update .env

Once you provide the credentials, I'll update the `.env` file with:
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
FROM_EMAIL=your_email@gmail.com
FROM_NAME=SkillSwapp
```

---

## 🧪 After Configuration

I'll test the Auth Service by:
1. Starting the server on port 8081
2. Testing the `/health` endpoint
3. Testing user registration (with OTP email)
4. Verifying all endpoints work

---

**Ready when you are!** Just provide your Gmail credentials.
