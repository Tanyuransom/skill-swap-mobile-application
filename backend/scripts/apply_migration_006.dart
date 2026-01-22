import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  // Load environment variables strictly from .env file
  var env = DotEnv(includePlatformEnvironment: true)..load(['.env']);
  
  if (env['DATABASE_HOST'] == null) {
      // Fallback or error
      print('⚠️ DATABASE_HOST not found in .env, trying default load...');
      env = DotEnv(includePlatformEnvironment: true)..load();
  }
  
  print('🔌 Connecting to DB to apply migration 006...');
  
  await PostgresClient.initialize();
  
  try {
     print('🧹 Cleaning up old tables (if any)...');
     // Drop in correct order (child first)
     await PostgresClient.execute('DROP TABLE IF EXISTS verification_exams CASCADE');
     await PostgresClient.execute('DROP TABLE IF EXISTS tutor_badges CASCADE');
     await PostgresClient.execute('DROP TABLE IF EXISTS verification_requests CASCADE');

     print('🚀 Executing SQL Statement 1: verification_requests...');
     await PostgresClient.execute('''
        CREATE TABLE verification_requests (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
            topic VARCHAR(255) NOT NULL,
            level VARCHAR(50) DEFAULT 'intermediate',
            status VARCHAR(50) DEFAULT 'pending',
            score INTEGER DEFAULT 0,
            feedback TEXT,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
     ''');

     print('🚀 Executing SQL Statement 2: verification_exams...');
     await PostgresClient.execute('''
        CREATE TABLE verification_exams (
            id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            request_id UUID NOT NULL REFERENCES verification_requests(id) ON DELETE CASCADE,
            questions JSONB NOT NULL,
            answers JSONB,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
     ''');

     print('🚀 Executing SQL Statement 3: tutor_badges...');
     await PostgresClient.execute('''
        CREATE TABLE tutor_badges (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          title VARCHAR(255) NOT NULL,
          topic VARCHAR(255) NOT NULL,
          issued_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          metadata JSONB
        );
     ''');
     
     print('🚀 Executing SQL Statement 4: Indexes...');
     await PostgresClient.execute('CREATE INDEX idx_verification_requests_user ON verification_requests(user_id);');
     await PostgresClient.execute('CREATE INDEX idx_tutor_badges_user ON tutor_badges(user_id);');

     print('✅ Migration applied successfully.');
  } catch (e) {
     print('❌ Migration failed: $e');
  } finally {
     await PostgresClient.close();
  }
}
