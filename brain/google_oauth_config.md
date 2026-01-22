# 🔐 Google OAuth Configuration for SkillSwapp

## For Google Cloud Console OAuth Client ID Setup

### **Application Type**
- **Android** (for mobile app)

### **Package Name**
```
com.skillswapp.app
```

### **SHA-1 Certificate Fingerprint**
For development/debug:
```bash
# Run this command to get your debug SHA-1:
keytool -keystore ~/.android/debug.keystore -list -v
# Password: android
```

For production, you'll need your release keystore SHA-1.

---

## Backend OAuth Configuration

### **Redirect URIs** (for web/backend testing)
```
http://localhost:8081/auth/google-callback
http://localhost:8080/auth/google-callback
```

### **Authorized JavaScript Origins**
```
http://localhost:8080
http://localhost:8081
```

---

## After Creating OAuth Client

### **Add to Backend .env**
```env
# Google OAuth
GOOGLE_CLIENT_ID=your_client_id_here.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your_client_secret_here
GOOGLE_REDIRECT_URI=http://localhost:8081/auth/google-callback
```

### **For Flutter Mobile App**
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.gms.auth.api.signin.ClientId"
    android:value="YOUR_CLIENT_ID_HERE" />
```

---

## OAuth Scopes Needed
- `email`
- `profile`
- `openid`

---

## Current Status
✅ Backend OAuth endpoint ready at: `/auth/google-auth`
✅ Database table `oauth_providers` created
✅ OAuth service logic implemented
⏳ Needs Google Client ID and Secret
