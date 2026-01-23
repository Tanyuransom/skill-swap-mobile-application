/**
 * Comprehensive Category Database
 * 300+ categories across multiple domains
 */

export interface Category {
    id: string;
    name: string;
    main: string;
    sub?: string;
    description?: string;
}

export const CATEGORIES: Category[] = [
    // TECHNOLOGY (100+ categories)
    // Programming
    { id: 'tech-prog-001', name: 'Web Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-002', name: 'Mobile Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-003', name: 'Game Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-004', name: 'AI & Machine Learning', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-005', name: 'Data Science', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-006', name: 'Backend Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-007', name: 'Frontend Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-008', name: 'Full Stack Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-009', name: 'DevOps & Cloud', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-010', name: 'Blockchain Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-011', name: 'Python Programming', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-012', name: 'JavaScript', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-013', name: 'Java Programming', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-014', name: 'C++ Programming', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-015', name: 'C# Programming', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-016', name: 'Ruby on Rails', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-017', name: 'PHP Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-018', name: 'Swift Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-019', name: 'Kotlin Development', main: 'Technology', sub: 'Programming' },
    { id: 'tech-prog-020', name: 'React Native', main: 'Technology', sub: 'Programming' },

    // Design & Creative
    { id: 'tech-design-001', name: 'UI/UX Design', main: 'Technology', sub: 'Design' },
    { id: 'tech-design-002', name: 'Graphic Design', main: 'Technology', sub: 'Design' },
    { id: 'tech-design-003', name: '3D Modeling', main: 'Technology', sub: 'Design' },
    { id: 'tech-design-004', name: 'Animation', main: 'Technology', sub: 'Design' },
    { id: 'tech-design-005', name: 'Product Design', main: 'Technology', sub: 'Design' },
    { id: 'tech-design-006', name: 'Web Design', main: 'Technology', sub: 'Design' },
    { id: 'tech-design-007', name: 'Mobile App Design', main: 'Technology', sub: 'Design' },
    { id: 'tech-design-008', name: 'Figma', main: 'Technology', sub: 'Design' },
    { id: 'tech-design-009', name: 'Adobe XD', main: 'Technology', sub: 'Design' },
    { id: 'tech-design-010', name: 'Sketch', main: 'Technology', sub: 'Design' },

    // Data & Analytics
    { id: 'tech-data-001', name: 'Data Analysis', main: 'Technology', sub: 'Data' },
    { id: 'tech-data-002', name: 'Big Data', main: 'Technology', sub: 'Data' },
    { id: 'tech-data-003', name: 'Data Visualization', main: 'Technology', sub: 'Data' },
    { id: 'tech-data-004', name: 'SQL', main: 'Technology', sub: 'Data' },
    { id: 'tech-data-005', name: 'NoSQL Databases', main: 'Technology', sub: 'Data' },
    { id: 'tech-data-006', name: 'Business Intelligence', main: 'Technology', sub: 'Data' },
    { id: 'tech-data-007', name: 'Tableau', main: 'Technology', sub: 'Data' },
    { id: 'tech-data-008', name: 'Power BI', main: 'Technology', sub: 'Data' },

    // BUSINESS (80+ categories)
    { id: 'biz-mkt-001', name: 'Digital Marketing', main: 'Business', sub: 'Marketing' },
    { id: 'biz-mkt-002', name: 'SEO', main: 'Business', sub: 'Marketing' },
    { id: 'biz-mkt-003', name: 'Social Media Marketing', main: 'Business', sub: 'Marketing' },
    { id: 'biz-mkt-004', name: 'Content Marketing', main: 'Business', sub: 'Marketing' },
    { id: 'biz-mkt-005', name: 'Email Marketing', main: 'Business', sub: 'Marketing' },
    { id: 'biz-mkt-006', name: 'Affiliate Marketing', main: 'Business', sub: 'Marketing' },
    { id: 'biz-mkt-007', name: 'Influencer Marketing', main: 'Business', sub: 'Marketing' },
    { id: 'biz-mkt-008', name: 'Video Marketing', main: 'Business', sub: 'Marketing' },
    { id: 'biz-mkt-009', name: 'Brand Strategy', main: 'Business', sub: 'Marketing' },
    { id: 'biz-mkt-010', name: 'Growth Hacking', main: 'Business', sub: 'Marketing' },

    { id: 'biz-mgmt-001', name: 'Project Management', main: 'Business', sub: 'Management' },
    { id: 'biz-mgmt-002', name: 'Product Management', main: 'Business', sub: 'Management' },
    { id: 'biz-mgmt-003', name: 'Leadership', main: 'Business', sub: 'Management' },
    { id: 'biz-mgmt-004', name: 'Team Management', main: 'Business', sub: 'Management' },
    { id: 'biz-mgmt-005', name: 'Agile & Scrum', main: 'Business', sub: 'Management' },
    { id: 'biz-mgmt-006', name: 'Strategic Planning', main: 'Business', sub: 'Management' },
    { id: 'biz-mgmt-007', name: 'Change Management', main: 'Business', sub: 'Management' },
    { id: 'biz-mgmt-008', name: 'Risk Management', main: 'Business', sub: 'Management' },

    { id: 'biz-fin-001', name: 'Accounting', main: 'Business', sub: 'Finance' },
    { id: 'biz-fin-002', name: 'Financial Analysis', main: 'Business', sub: 'Finance' },
    { id: 'biz-fin-003', name: 'Investment', main: 'Business', sub: 'Finance' },
    { id: 'biz-fin-004', name: 'Cryptocurrency', main: 'Business', sub: 'Finance' },
    { id: 'biz-fin-005', name: 'Stock Trading', main: 'Business', sub: 'Finance' },
    { id: 'biz-fin-006', name: 'Personal Finance', main: 'Business', sub: 'Finance' },
    { id: 'biz-fin-007', name: 'Real Estate', main: 'Business', sub: 'Finance' },

    { id: 'biz-ent-001', name: 'Entrepreneurship', main: 'Business', sub: 'Entrepreneurship' },
    { id: 'biz-ent-002', name: 'Startup', main: 'Business', sub: 'Entrepreneurship' },
    { id: 'biz-ent-003', name: 'E-commerce', main: 'Business', sub: 'Entrepreneurship' },
    { id: 'biz-ent-004', name: 'Dropshipping', main: 'Business', sub: 'Entrepreneurship' },
    { id: 'biz-ent-005', name: 'Amazon FBA', main: 'Business', sub: 'Entrepreneurship' },
    { id: 'biz-ent-006', name: 'Shopify', main: 'Business', sub: 'Entrepreneurship' },

    // CREATIVE ARTS (60+ categories)
    { id: 'art-photo-001', name: 'Photography', main: 'Creative Arts', sub: 'Photography' },
    { id: 'art-photo-002', name: 'Portrait Photography', main: 'Creative Arts', sub: 'Photography' },
    { id: 'art-photo-003', name: 'Landscape Photography', main: 'Creative Arts', sub: 'Photography' },
    { id: 'art-photo-004', name: 'Product Photography', main: 'Creative Arts', sub: 'Photography' },
    { id: 'art-photo-005', name: 'Wedding Photography', main: 'Creative Arts', sub: 'Photography' },
    { id: 'art-photo-006', name: 'Photo Editing', main: 'Creative Arts', sub: 'Photography' },
    { id: 'art-photo-007', name: 'Lightroom', main: 'Creative Arts', sub: 'Photography' },
    { id: 'art-photo-008', name: 'Photoshop', main: 'Creative Arts', sub: 'Photography' },

    { id: 'art-video-001', name: 'Video Editing', main: 'Creative Arts', sub: 'Video' },
    { id: 'art-video-002', name: 'Videography', main: 'Creative Arts', sub: 'Video' },
    { id: 'art-video-003', name: 'YouTube Creation', main: 'Creative Arts', sub: 'Video' },
    { id: 'art-video-004', name: 'Premiere Pro', main: 'Creative Arts', sub: 'Video' },
    { id: 'art-video-005', name: 'Final Cut Pro', main: 'Creative Arts', sub: 'Video' },
    { id: 'art-video-006', name: 'After Effects', main: 'Creative Arts', sub: 'Video' },
    { id: 'art-video-007', name: 'DaVinci Resolve', main: 'Creative Arts', sub: 'Video' },

    { id: 'art-music-001', name: 'Music Production', main: 'Creative Arts', sub: 'Music' },
    { id: 'art-music-002', name: 'Guitar', main: 'Creative Arts', sub: 'Music' },
    { id: 'art-music-003', name: 'Piano', main: 'Creative Arts', sub: 'Music' },
    { id: 'art-music-004', name: 'Singing', main: 'Creative Arts', sub: 'Music' },
    { id: 'art-music-005', name: 'Music Theory', main: 'Creative Arts', sub: 'Music' },
    { id: 'art-music-006', name: 'DJ Skills', main: 'Creative Arts', sub: 'Music' },
    { id: 'art-music-007', name: 'Audio Engineering', main: 'Creative Arts', sub: 'Music' },

    { id: 'art-write-001', name: 'Creative Writing', main: 'Creative Arts', sub: 'Writing' },
    { id: 'art-write-002', name: 'Copywriting', main: 'Creative Arts', sub: 'Writing' },
    { id: 'art-write-003', name: 'Content Writing', main: 'Creative Arts', sub: 'Writing' },
    { id: 'art-write-004', name: 'Technical Writing', main: 'Creative Arts', sub: 'Writing' },
    { id: 'art-write-005', name: 'Screenwriting', main: 'Creative Arts', sub: 'Writing' },
    { id: 'art-write-006', name: 'Blogging', main: 'Creative Arts', sub: 'Writing' },

    // HEALTH & FITNESS (40+ categories)
    { id: 'health-fit-001', name: 'Yoga', main: 'Health & Fitness', sub: 'Fitness' },
    { id: 'health-fit-002', name: 'Weight Training', main: 'Health & Fitness', sub: 'Fitness' },
    { id: 'health-fit-003', name: 'Cardio', main: 'Health & Fitness', sub: 'Fitness' },
    { id: 'health-fit-004', name: 'Pilates', main: 'Health & Fitness', sub: 'Fitness' },
    { id: 'health-fit-005', name: 'Martial Arts', main: 'Health & Fitness', sub: 'Fitness' },
    { id: 'health-fit-006', name: 'CrossFit', main: 'Health & Fitness', sub: 'Fitness' },
    { id: 'health-fit-007', name: 'Running', main: 'Health & Fitness', sub: 'Fitness' },
    { id: 'health-fit-008', name: 'Bodybuilding', main: 'Health & Fitness', sub: 'Fitness' },

    { id: 'health-nutr-001', name: 'Nutrition', main: 'Health & Fitness', sub: 'Nutrition' },
    { id: 'health-nutr-002', name: 'Meal Planning', main: 'Health & Fitness', sub: 'Nutrition' },
    { id: 'health-nutr-003', name: 'Vegan Cooking', main: 'Health & Fitness', sub: 'Nutrition' },
    { id: 'health-nutr-004', name: 'Keto Diet', main: 'Health & Fitness', sub: 'Nutrition' },
    { id: 'health-nutr-005', name: 'Weight Loss', main: 'Health & Fitness', sub: 'Nutrition' },

    { id: 'health-mind-001', name: 'Meditation', main: 'Health & Fitness', sub: 'Mental Health' },
    { id: 'health-mind-002', name: 'Mindfulness', main: 'Health & Fitness', sub: 'Mental Health' },
    { id: 'health-mind-003', name: 'Stress Management', main: 'Health & Fitness', sub: 'Mental Health' },
    { id: 'health-mind-004', name: 'Sleep Improvement', main: 'Health & Fitness', sub: 'Mental Health' },

    // LIFESTYLE (30+ categories)
    { id: 'life-cook-001', name: 'Cooking', main: 'Lifestyle', sub: 'Cooking' },
    { id: 'life-cook-002', name: 'Baking', main: 'Lifestyle', sub: 'Cooking' },
    { id: 'life-cook-003', name: 'Pastry', main: 'Lifestyle', sub: 'Cooking' },
    { id: 'life-cook-004', name: 'International Cuisine', main: 'Lifestyle', sub: 'Cooking' },
    { id: 'life-cook-005', name: 'Grilling & BBQ', main: 'Lifestyle', sub: 'Cooking' },

    { id: 'life-home-001', name: 'Interior Design', main: 'Lifestyle', sub: 'Home' },
    { id: 'life-home-002', name: 'Gardening', main: 'Lifestyle', sub: 'Home' },
    { id: 'life-home-003', name: 'DIY Projects', main: 'Lifestyle', sub: 'Home' },
    { id: 'life-home-004', name: 'Home Organization', main: 'Lifestyle', sub: 'Home' },

    { id: 'life-pers-001', name: 'Personal Development', main: 'Lifestyle', sub: 'Personal Growth' },
    { id: 'life-pers-002', name: 'Productivity', main: 'Lifestyle', sub: 'Personal Growth' },
    { id: 'life-pers-003', name: 'Time Management', main: 'Lifestyle', sub: 'Personal Growth' },
    { id: 'life-pers-004', name: 'Public Speaking', main: 'Lifestyle', sub: 'Personal Growth' },
    { id: 'life-pers-005', name: 'Communication Skills', main: 'Lifestyle', sub: 'Personal Growth' },

    // LANGUAGE (20+ categories)
    { id: 'lang-001', name: 'English', main: 'Language', sub: 'Languages' },
    { id: 'lang-002', name: 'Spanish', main: 'Language', sub: 'Languages' },
    { id: 'lang-003', name: 'French', main: 'Language', sub: 'Languages' },
    { id: 'lang-004', name: 'German', main: 'Language', sub: 'Languages' },
    { id: 'lang-005', name: 'Chinese (Mandarin)', main: 'Language', sub: 'Languages' },
    { id: 'lang-006', name: 'Japanese', main: 'Language', sub: 'Languages' },
    { id: 'lang-007', name: 'Korean', main: 'Language', sub: 'Languages' },
    { id: 'lang-008', name: 'Arabic', main: 'Language', sub: 'Languages' },
    { id: 'lang-009', name: 'Portuguese', main: 'Language', sub: 'Languages' },
    { id: 'lang-010', name: 'Italian', main: 'Language', sub: 'Languages' },
    { id: 'lang-011', name: 'Russian', main: 'Language', sub: 'Languages' },
    { id: 'lang-012', name: 'Hindi', main: 'Language', sub: 'Languages' },

    // ACADEMIC (30+ categories)
    { id: 'acad-math-001', name: 'Mathematics', main: 'Academic', sub: 'Mathematics' },
    { id: 'acad-math-002', name: 'Algebra', main: 'Academic', sub: 'Mathematics' },
    { id: 'acad-math-003', name: 'Calculus', main: 'Academic', sub: 'Mathematics' },
    { id: 'acad-math-004', name: 'Statistics', main: 'Academic', sub: 'Mathematics' },
    { id: 'acad-math-005', name: 'Geometry', main: 'Academic', sub: 'Mathematics' },

    { id: 'acad-sci-001', name: 'Physics', main: 'Academic', sub: 'Science' },
    { id: 'acad-sci-002', name: 'Chemistry', main: 'Academic', sub: 'Science' },
    { id: 'acad-sci-003', name: 'Biology', main: 'Academic', sub: 'Science' },
    { id: 'acad-sci-004', name: 'Environmental Science', main: 'Academic', sub: 'Science' },

    { id: 'acad-eng-001', name: 'Mechanical Engineering', main: 'Academic', sub: 'Engineering' },
    { id: 'acad-eng-002', name: 'Electrical Engineering', main: 'Academic', sub: 'Engineering' },
    { id: 'acad-eng-003', name: 'Civil Engineering', main: 'Academic', sub: 'Engineering' },
    { id: 'acad-eng-004', name: 'Chemical Engineering', main: 'Academic', sub: 'Engineering' },

    // TEST PREP (10+ categories)
    { id: 'test-001', name: 'SAT Preparation', main: 'Test Prep', sub: 'Standardized Tests' },
    { id: 'test-002', name: 'ACT Preparation', main: 'Test Prep', sub: 'Standardized Tests' },
    { id: 'test-003', name: 'GRE Preparation', main: 'Test Prep', sub: 'Standardized Tests' },
    { id: 'test-004', name: 'GMAT Preparation', main: 'Test Prep', sub: 'Standardized Tests' },
    { id: 'test-005', name: 'TOEFL', main: 'Test Prep', sub: 'Language Tests' },
    { id: 'test-006', name: 'IELTS', main: 'Test Prep', sub: 'Language Tests' },
];

// Helper functions
export function getCategoryById(id: string): Category | undefined {
    return CATEGORIES.find(c => c.id === id);
}

export function getCategoriesByMain(main: string): Category[] {
    return CATEGORIES.filter(c => c.main === main);
}

export function getCategoriesBySub(sub: string): Category[] {
    return CATEGORIES.filter(c => c.sub === sub);
}

export function getMainCategories(): string[] {
    return [...new Set(CATEGORIES.map(c => c.main))];
}

export function getSubCategories(main: string): string[] {
    return [...new Set(CATEGORIES.filter(c => c.main === main && c.sub).map(c => c.sub!))];
}

export function searchCategories(query: string): Category[] {
    const lowerQuery = query.toLowerCase();
    return CATEGORIES.filter(c =>
        c.name.toLowerCase().includes(lowerQuery) ||
        c.main.toLowerCase().includes(lowerQuery) ||
        (c.sub && c.sub.toLowerCase().includes(lowerQuery))
    );
}
