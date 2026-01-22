# SkillSwapp Monetization System

## Overview

SkillSwapp uses a **content consumption-based revenue model** similar to TikTok/YouTube, where tutors earn based on how much their content is watched and engaged with.

---

## Premium Subscription

**Price**: 2,500 XAF/month  
**Payment**: Orange Money CM or MTN Mobile Money CM  
**Access**: All premium content from all tutors

### For Students
- Subscribe once, access everything
- No per-course fees
- Cancel anytime

### For Tutors
- Choose free or premium per lesson
- Earn from content consumption
- Passive income model

---

## Revenue Distribution

**Platform Commission**: 20%  
**Tutor Pool**: 80% of all subscription revenue

### Earnings Formula

```
Tutor Monthly Earnings = 
  (Watch Time Score × 40%) +
  (Engagement Score × 30%) +
  (Subscriber Score × 30%)
```

### Metrics Tracked

1. **Watch Time** (40% weight)
   - Total hours watched
   - Completion rate

2. **Engagement** (30% weight)
   - Likes
   - Shares

3. **Subscribers** (30% weight)
   - Follower count
   - Growth rate

---

## Example Calculation

### Platform Stats
- Total subscribers: 1,000 students
- Monthly revenue: 1,000 × 2,500 = **2,500,000 XAF**
- Tutor pool (80%): **2,000,000 XAF**
- Platform fee (20%): **500,000 XAF**

### Tutor Performance
**Tutor A**:
- Watch time: 500 hours (10% of total)
- Engagement: 5,000 actions (8% of total)
- Subscribers: 150 (15% of total)

**Earnings**:
```
Watch Time:    2,000,000 × 0.40 × 0.10 = 80,000 XAF
Engagement:    2,000,000 × 0.30 × 0.08 = 48,000 XAF
Subscribers:   2,000,000 × 0.30 × 0.15 = 90,000 XAF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total:         218,000 XAF/month
```

---

## Services

### Subscription Service (Port 8087)
- `POST /subscribe` - Subscribe to premium
- `GET /subscription/status` - Check status
- `POST /subscription/cancel` - Cancel subscription
- `GET /content/:lessonId/access` - Check content access

### Analytics Service (Port 8088)
- `POST /analytics/track` - Track content view
- `GET /analytics/tutor/dashboard` - Tutor metrics
- `POST /tutors/:tutorId/follow` - Follow tutor
- `DELETE /tutors/:tutorId/follow` - Unfollow tutor

### Payment Service (Port 8086)
- Handles subscription payments
- Mobile money integration
- Wallet management

---

## Monthly Earnings Calculation

### Automated Process

Run at end of each month:
```bash
dart scripts/calculate_monthly_earnings.dart
```

Or specify month:
```bash
dart scripts/calculate_monthly_earnings.dart 2026-01
```

### Cron Setup

Add to crontab (runs 1st of each month at midnight):
```cron
0 0 1 * * cd /path/to/backend && dart scripts/calculate_monthly_earnings.dart
```

### What It Does

1. Calculate total subscription revenue
2. Determine tutor pool (80%)
3. For each tutor:
   - Sum watch time, engagement, subscribers
   - Calculate scores
   - Compute earnings
4. Save to `tutor_earnings` table
5. Credit tutor wallets

---

## Content Creation

### Tutor Workflow

When creating a lesson:
```dart
{
  "title": "Python Basics",
  "videoUrl": "https://...",
  "isFree": false,      // Premium content
  "isPremium": true     // Requires subscription
}
```

**Options**:
- `isFree: true` - Anyone can watch
- `isPremium: true` - Requires active subscription

---

## Database Schema

### Key Tables

- `subscriptions` - Premium memberships
- `content_analytics` - Watch time, likes, shares
- `tutor_followers` - Subscriber counts
- `tutor_earnings` - Monthly revenue calculations
- `wallets` - Tutor balances

---

## API Integration

### Track Content View

```javascript
POST /analytics/track
{
  "lessonId": "uuid",
  "watchDuration": 450,  // seconds
  "completed": true,
  "liked": false,
  "shared": false
}
```

### Check Content Access

```javascript
GET /content/:lessonId/access

Response:
{
  "canAccess": true,
  "reason": "active_subscription"
}
```

### Subscribe to Premium

```javascript
POST /subscribe
{
  "paymentMethod": "orange_money",
  "phoneNumber": "237670000000"
}
```

---

## Benefits

### For Platform
✅ Recurring revenue (predictable)  
✅ Higher lifetime value  
✅ Viral growth incentive  
✅ Better retention

### For Tutors
✅ Passive income from content  
✅ Earnings grow with quality  
✅ No pricing decisions  
✅ Incentive to create more

### For Students
✅ Access all content for 2,500 XAF  
✅ No per-course fees  
✅ Unlimited learning  
✅ Cancel anytime

---

**Questions?** Check the implementation plan in `monetization_redesign.md`
