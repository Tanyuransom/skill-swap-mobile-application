# Add EXPO_TOKEN to GitHub - Quick Guide

## Your EXPO_TOKEN
```
Yo8M8Xr0QGNV7Zv7SxC3SMSwxF8c7Dc9wkjrleeY
```

## Steps to Add to GitHub

### 1. Go to Repository Settings
Visit: https://github.com/Tanyuransom/skill-swap-mobile-application/settings/secrets/actions

### 2. Click "New repository secret"
Look for the green button that says "New repository secret"

### 3. Fill in the Form
- **Name:** `EXPO_TOKEN` (exactly as shown, all caps)
- **Secret:** `Yo8M8Xr0QGNV7Zv7SxC3SMSwxF8c7Dc9wkjrleeY`

### 4. Click "Add secret"

## That's It!

Once added, your CI/CD pipeline is fully operational. Every time you push code to the `main` branch:
1. GitHub Actions will run automatically
2. EAS Update will publish to production channel
3. Users will get the update next time they open the app

## Test It
```bash
cd /home/gotti/Desktop/SkillSwapp
# Make a small change
echo "# Test" >> FRONTEND/README.md
git add .
git commit -m "test: Trigger CI/CD pipeline"
git push origin main
```

Then check: https://github.com/Tanyuransom/skill-swap-mobile-application/actions
