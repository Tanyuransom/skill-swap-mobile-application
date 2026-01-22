-- Phase 4: Social Platform - Notifications & Friend Requests
-- Migration 013: Notifications and Friend Request System

-- Notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notification_type VARCHAR(50) CHECK (notification_type IN (
        'new_follower', 'friend_request', 'friend_accepted',
        'post_like', 'post_comment', 'post_share',
        'reel_like', 'reel_comment',
        'message', 'mention', 'achievement'
    )),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    action_url TEXT,
    actor_id UUID REFERENCES users(id),
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Update friendships table to add more statuses
ALTER TABLE friendships DROP CONSTRAINT IF EXISTS friendships_status_check;
ALTER TABLE friendships ADD CONSTRAINT friendships_status_check 
    CHECK (status IN ('pending', 'accepted', 'rejected', 'blocked'));

-- Indexes
CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_type ON notifications(notification_type);
