-- Phase 6: Verification Service Schema

-- Verification Requests Table
CREATE TABLE verification_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    topic VARCHAR(255) NOT NULL, -- e.g. "Python", "Flutter"
    level VARCHAR(50) DEFAULT 'intermediate', -- "beginner", "intermediate", "advanced"
    status VARCHAR(50) DEFAULT 'pending', -- "pending", "generated", "submitted", "graded", "failed"
    score INTEGER DEFAULT 0,
    feedback TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Verification Exams Table (Stores the generated questions)
CREATE TABLE verification_exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL REFERENCES verification_requests(id) ON DELETE CASCADE,
    questions JSONB NOT NULL, -- The generated questions in JSON format
    answers JSONB, -- The user's submitted answers
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tutor Badges Table (Earned badges)
CREATE TABLE tutor_badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL, -- e.g. "Verified Python Tutor"
    topic VARCHAR(255) NOT NULL,
    issued_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB -- Optional: Score, Exam ID, etc.
);

-- Index for fast lookup
CREATE INDEX idx_verification_requests_user ON verification_requests(user_id);
CREATE INDEX idx_tutor_badges_user ON tutor_badges(user_id);
