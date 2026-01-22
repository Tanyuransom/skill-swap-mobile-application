-- Subscription System Database Schema
-- Premium subscription: 2,500 XAF/month

-- Subscriptions: Track premium memberships
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled', 'pending')),
    start_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP WITH TIME ZONE,
    auto_renew BOOLEAN DEFAULT true,
    payment_method VARCHAR(50),
    last_payment_date TIMESTAMP WITH TIME ZONE,
    next_billing_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id)
);

-- Content Analytics: Track watch time and engagement
CREATE TABLE content_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    tutor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    watch_duration INTEGER NOT NULL, -- seconds
    completed BOOLEAN DEFAULT false,
    liked BOOLEAN DEFAULT false,
    shared BOOLEAN DEFAULT false,
    watched_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tutor Followers: Track subscriber counts
CREATE TABLE tutor_followers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tutor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    followed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tutor_id, follower_id)
);

-- Tutor Earnings: Monthly revenue calculations
CREATE TABLE tutor_earnings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tutor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    month DATE NOT NULL,
    watch_time_hours DECIMAL(10, 2) DEFAULT 0,
    total_views INTEGER DEFAULT 0,
    total_likes INTEGER DEFAULT 0,
    total_shares INTEGER DEFAULT 0,
    subscriber_count INTEGER DEFAULT 0,
    watch_time_score DECIMAL(10, 2) DEFAULT 0,
    engagement_score DECIMAL(10, 2) DEFAULT 0,
    subscriber_score DECIMAL(10, 2) DEFAULT 0,
    total_earnings DECIMAL(10, 2) DEFAULT 0,
    calculated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(tutor_id, month)
);

-- Indexes
CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_billing ON subscriptions(next_billing_date);
CREATE INDEX idx_analytics_lesson ON content_analytics(lesson_id);
CREATE INDEX idx_analytics_tutor ON content_analytics(tutor_id);
CREATE INDEX idx_analytics_user ON content_analytics(user_id);
CREATE INDEX idx_analytics_watched ON content_analytics(watched_at);
CREATE INDEX idx_followers_tutor ON tutor_followers(tutor_id);
CREATE INDEX idx_followers_follower ON tutor_followers(follower_id);
CREATE INDEX idx_earnings_tutor ON tutor_earnings(tutor_id);
CREATE INDEX idx_earnings_month ON tutor_earnings(month);
