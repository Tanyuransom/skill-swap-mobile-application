# Step 2: GitHub Actions Setup Guide

## What We've Done So Far (Step 1)
✅ EAS CLI installed and logged in
✅ Project configured for EAS Build (`eas.json` created)
✅ EAS Updates configured (runtime version added to `app.json`)
✅ GitHub Actions workflow created (`.github/workflows/eas-update.yml`)

---

## Step 2: Configure GitHub Secrets

### 1. Generate EXPO_TOKEN
**Option A: Via Expo Dashboard (Recommended)**
1. Go to https://expo.dev/accounts/[your-account]/settings/access-tokens
2. Click **Create Token**
3. Name it: "GitHub Actions"
4. Copy the token immediately (it won't be shown again)

**Option B: Via CLI** (if available)
```bash
cd FRONTEND
eas token:create
```

### 2. Add Token to GitHub Secrets
1. Go to your GitHub repository: https://github.com/YOUR_USERNAME/SkillSwapp
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `EXPO_TOKEN`
5. Value: Paste the token you copied
6. Click **Add secret**

### 3. Test the Workflow
Once the secret is added:
```bash
git add .
git commit -m "Add EAS configuration and GitHub Actions"
git push origin main
```

The GitHub Action will automatically run and publish an OTA update!

---

## How It Works

### Automatic OTA Updates
1. You make code changes in `FRONTEND/`
2. Commit and push to `main` branch
3. GitHub Actions automatically runs
4. EAS Update publishes to production channel
5. **Users get the update next time they open the app!**

### What Triggers Updates
- ✅ Any changes in `FRONTEND/` folder
- ❌ Changes to `android/` or `ios/` folders (native code)
- ❌ Changes outside `FRONTEND/` folder

---

## Next Steps (After Step 2)
- [ ] Generate EXPO_TOKEN
- [ ] Add to GitHub Secrets
- [ ] Push code to test workflow
- [ ] Build production APK/IPA (when ready)
- [ ] Move to Step 3: Backend VPS deployment
