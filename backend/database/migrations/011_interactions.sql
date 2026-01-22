-- Phase 2: Social Platform - Interactions
-- Migration 011: Likes, Comments, Shares, Saves

-- Likes (on posts, reels, comments)
CREATE TABLE likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_type VARCHAR(20) CHECK (target_type IN ('post', 'reel', 'comment')),
    target_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, target_type, target_id)
);

-- Comments (on posts and reels)
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_type VARCHAR(20) CHECK (target_type IN ('post', 'reel')),
    target_id UUID NOT NULL,
    parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    like_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Shares (tracking content sharing)
CREATE TABLE shares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_type VARCHAR(20) CHECK (target_type IN ('post', 'reel')),
    target_id UUID NOT NULL,
    share_type VARCHAR(20) CHECK (share_type IN ('friend', 'external', 'group')),
    recipient_id UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Saves/Bookmarks
CREATE TABLE saves (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_type VARCHAR(20) CHECK (target_type IN ('post', 'reel')),
    target_id UUID NOT NULL,
    collection_name VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, target_type, target_id)
);

-- Indexes
CREATE INDEX idx_likes_user ON likes(user_id);
CREATE INDEX idx_likes_target ON likes(target_type, target_id);
CREATE INDEX idx_comments_target ON comments(target_type, target_id);
CREATE INDEX idx_comments_user ON comments(user_id);
CREATE INDEX idx_comments_parent ON comments(parent_comment_id);
CREATE INDEX idx_shares_user ON shares(user_id);
CREATE INDEX idx_shares_target ON shares(target_type, target_id);
CREATE INDEX idx_saves_user ON saves(user_id);
CREATE INDEX idx_saves_target ON saves(target_type, target_id);
