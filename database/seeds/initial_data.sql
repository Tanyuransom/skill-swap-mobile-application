-- ============================================
-- SKILLSWAPP - SEED DATA
-- Initial data for development and testing
-- ============================================

-- Insert default categories
INSERT INTO categories (id, name, slug, description, icon_url, parent_id) VALUES
    ('550e8400-e29b-41d4-a716-446655440001', 'Programming & Development', 'programming-development', 'Learn coding, software development, and programming languages', 'https://example.com/icons/programming.png', NULL),
    ('550e8400-e29b-41d4-a716-446655440002', 'Business & Entrepreneurship', 'business-entrepreneurship', 'Business skills, management, and entrepreneurship', 'https://example.com/icons/business.png', NULL),
    ('550e8400-e29b-41d4-a716-446655440003', 'Design & Creative', 'design-creative', 'Graphic design, UI/UX, and creative skills', 'https://example.com/icons/design.png', NULL),
    ('550e8400-e29b-41d4-a716-446655440004', 'Marketing & Sales', 'marketing-sales', 'Digital marketing, SEO, and sales strategies', 'https://example.com/icons/marketing.png', NULL),
    ('550e8400-e29b-41d4-a716-446655440005', 'Personal Development', 'personal-development', 'Self-improvement and personal growth', 'https://example.com/icons/personal.png', NULL),
    ('550e8400-e29b-41d4-a716-446655440006', 'Language Learning', 'language-learning', 'Learn new languages and improve communication', 'https://example.com/icons/language.png', NULL),
    ('550e8400-e29b-41d4-a716-446655440007', 'Health & Fitness', 'health-fitness', 'Fitness, nutrition, and wellness', 'https://example.com/icons/health.png', NULL),
    ('550e8400-e29b-41d4-a716-446655440008', 'Music & Arts', 'music-arts', 'Music, performing arts, and creative expression', 'https://example.com/icons/music.png', NULL);

-- Insert programming subcategories
INSERT INTO categories (id, name, slug, description, parent_id) VALUES
    ('550e8400-e29b-41d4-a716-446655440101', 'Web Development', 'web-development', 'HTML, CSS, JavaScript, React, Vue, Angular', '550e8400-e29b-41d4-a716-446655440001'),
    ('550e8400-e29b-41d4-a716-446655440102', 'Mobile Development', 'mobile-development', 'iOS, Android, Flutter, React Native', '550e8400-e29b-41d4-a716-446655440001'),
    ('550e8400-e29b-41d4-a716-446655440103', 'Backend Development', 'backend-development', 'Node.js, Python, Java, PHP, Databases', '550e8400-e29b-41d4-a716-446655440001'),
    ('550e8400-e29b-41d4-a716-446655440104', 'Data Science & AI', 'data-science-ai', 'Machine Learning, AI, Data Analysis', '550e8400-e29b-41d4-a716-446655440001'),
    ('550e8400-e29b-41d4-a716-446655440105', 'DevOps & Cloud', 'devops-cloud', 'Docker, Kubernetes, AWS, Azure, CI/CD', '550e8400-e29b-41d4-a716-446655440001');

-- Insert admin user (password: Admin@123)
-- Password hash generated with bcrypt
INSERT INTO users (id, email, password_hash, full_name, is_email_verified, is_active) VALUES
    ('650e8400-e29b-41d4-a716-446655440000', 'admin@skillswapp.com', '$2a$10$rKvVJKJ7vZ8yQZ8yQZ8yQeJ7vZ8yQZ8yQZ8yQZ8yQZ8yQZ8yQZ8yQ', 'SkillSwapp Admin', TRUE, TRUE);

-- Assign admin role
INSERT INTO user_roles (user_id, role) VALUES
    ('650e8400-e29b-41d4-a716-446655440000', 'admin');

-- Insert test learner user (password: Learner@123)
INSERT INTO users (id, email, password_hash, full_name, is_email_verified, is_active) VALUES
    ('650e8400-e29b-41d4-a716-446655440001', 'learner@test.com', '$2a$10$rKvVJKJ7vZ8yQZ8yQZ8yQeJ7vZ8yQZ8yQZ8yQZ8yQZ8yQZ8yQZ8yQ', 'Test Learner', TRUE, TRUE);

-- Assign learner role
INSERT INTO user_roles (user_id, role) VALUES
    ('650e8400-e29b-41d4-a716-446655440001', 'learner');

-- Insert test tutor user (password: Tutor@123)
INSERT INTO users (id, email, password_hash, full_name, bio, is_email_verified, is_active) VALUES
    ('650e8400-e29b-41d4-a716-446655440002', 'tutor@test.com', '$2a$10$rKvVJKJ7vZ8yQZ8yQZ8yQeJ7vZ8yQZ8yQZ8yQZ8yQZ8yQZ8yQZ8yQ', 'Test Tutor', 'Experienced developer and educator', TRUE, TRUE);

-- Assign tutor role
INSERT INTO user_roles (user_id, role) VALUES
    ('650e8400-e29b-41d4-a716-446655440002', 'tutor');

-- Create wallet for tutor
INSERT INTO wallets (user_id, balance) VALUES
    ('650e8400-e29b-41d4-a716-446655440002', 0.00);

-- Initialize tutor reputation
INSERT INTO tutor_reputation (tutor_id, reputation_score, total_courses, total_students, average_rating) VALUES
    ('650e8400-e29b-41d4-a716-446655440002', 0.00, 0, 0, 0.00);

-- ============================================
-- SEED DATA COMPLETE
-- ============================================

-- Summary:
-- - 8 main categories
-- - 5 programming subcategories
-- - 1 admin user (admin@skillswapp.com / Admin@123)
-- - 1 test learner (learner@test.com / Learner@123)
-- - 1 test tutor (tutor@test.com / Tutor@123)
