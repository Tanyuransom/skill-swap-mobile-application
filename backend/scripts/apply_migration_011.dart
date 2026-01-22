import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  print('🚀 Applying Migration 011: Social Interactions...');
  
  try {
    await PostgresClient.initialize();
    
    print('🧹 Cleaning up old tables (if any)...');
    await PostgresClient.execute('DROP TABLE IF EXISTS saves CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS shares CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS comments CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS likes CASCADE');

    print('🚀 Creating likes table...');
    await PostgresClient.execute('''
      CREATE TABLE likes (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          target_type VARCHAR(20) CHECK (target_type IN ('post', 'reel', 'comment')),
          target_id UUID NOT NULL,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(user_id, target_type, target_id)
      );
    ''');

    print('🚀 Creating comments table...');
    await PostgresClient.execute('''
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
    ''');

    print('🚀 Creating shares table...');
    await PostgresClient.execute('''
      CREATE TABLE shares (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          target_type VARCHAR(20) CHECK (target_type IN ('post', 'reel')),
          target_id UUID NOT NULL,
          share_type VARCHAR(20) CHECK (share_type IN ('friend', 'external', 'group')),
          recipient_id UUID REFERENCES users(id),
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    print('🚀 Creating saves table...');
    await PostgresClient.execute('''
      CREATE TABLE saves (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          target_type VARCHAR(20) CHECK (target_type IN ('post', 'reel')),
          target_id UUID NOT NULL,
          collection_name VARCHAR(100),
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(user_id, target_type, target_id)
      );
    ''');

    print('🚀 Creating indexes...');
    await PostgresClient.execute('CREATE INDEX idx_likes_user ON likes(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_likes_target ON likes(target_type, target_id);');
    await PostgresClient.execute('CREATE INDEX idx_comments_target ON comments(target_type, target_id);');
    await PostgresClient.execute('CREATE INDEX idx_comments_user ON comments(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_comments_parent ON comments(parent_comment_id);');
    await PostgresClient.execute('CREATE INDEX idx_shares_user ON shares(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_shares_target ON shares(target_type, target_id);');
    await PostgresClient.execute('CREATE INDEX idx_saves_user ON saves(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_saves_target ON saves(target_type, target_id);');

    print('✅ Migration 011 applied successfully!');
    print('📊 Created tables: likes, comments, shares, saves');
    print('📊 Created 9 indexes for query optimization');
    
  } catch (e, stackTrace) {
    print('❌ Migration failed: $e');
    print(stackTrace);
  } finally {
    await PostgresClient.close();
    print('✅ Database connections closed');
  }
}
