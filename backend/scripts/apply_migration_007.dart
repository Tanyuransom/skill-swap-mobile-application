import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  print('🚀 Applying Migration 007: Learning Service Schema...');
  
  try {
    // Initialize database connection
    await PostgresClient.initialize();
    
    print('🧹 Cleaning up old tables (if any)...');
    // Drop in correct order (child tables first to avoid FK constraint violations)
    await PostgresClient.execute('DROP TABLE IF EXISTS completed_lessons CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS course_progress CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS enrollments CASCADE');

    print('🚀 Creating enrollments table...');
    await PostgresClient.execute('''
      CREATE TABLE enrollments (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
          status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'dropped')),
          enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          completed_at TIMESTAMP WITH TIME ZONE,
          last_accessed TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(user_id, course_id)
      );
    ''');

    print('🚀 Creating course_progress table...');
    await PostgresClient.execute('''
      CREATE TABLE course_progress (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          enrollment_id UUID NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
          total_lessons INTEGER NOT NULL DEFAULT 0,
          completed_lessons INTEGER NOT NULL DEFAULT 0,
          percentage INTEGER NOT NULL DEFAULT 0 CHECK (percentage >= 0 AND percentage <= 100),
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(enrollment_id)
      );
    ''');

    print('🚀 Creating completed_lessons table...');
    await PostgresClient.execute('''
      CREATE TABLE completed_lessons (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          enrollment_id UUID NOT NULL REFERENCES enrollments(id) ON DELETE CASCADE,
          lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
          completed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          watch_duration INTEGER,
          UNIQUE(enrollment_id, lesson_id)
      );
    ''');

    print('🚀 Creating indexes...');
    await PostgresClient.execute('CREATE INDEX idx_enrollments_user ON enrollments(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_enrollments_course ON enrollments(course_id);');
    await PostgresClient.execute('CREATE INDEX idx_enrollments_status ON enrollments(status);');
    await PostgresClient.execute('CREATE INDEX idx_progress_enrollment ON course_progress(enrollment_id);');
    await PostgresClient.execute('CREATE INDEX idx_completed_enrollment ON completed_lessons(enrollment_id);');
    await PostgresClient.execute('CREATE INDEX idx_completed_lesson ON completed_lessons(lesson_id);');

    print('✅ Migration 007 applied successfully!');
    print('📊 Created tables: enrollments, course_progress, completed_lessons');
    print('📊 Created 6 indexes for query optimization');
    
  } catch (e, stackTrace) {
    print('❌ Migration failed: $e');
    print(stackTrace);
  } finally {
    await PostgresClient.close();
    print('✅ Database connections closed');
  }
}
