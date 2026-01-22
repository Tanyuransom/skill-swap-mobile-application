import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  print('🚀 Applying Migration 010: Social Platform Core Features...');
  
  try {
    await PostgresClient.initialize();
    
    print('🧹 Cleaning up old tables (if any)...');
    await PostgresClient.execute('DROP TABLE IF EXISTS follows CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS friendships CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS reels CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS posts CASCADE');

    print('🚀 Creating posts table...');
    await PostgresClient.execute('''
      CREATE TABLE posts (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          post_type VARCHAR(20) DEFAULT 'video' CHECK (post_type IN ('video', 'reel', 'text', 'image')),
          title TEXT,
          description TEXT,
          media_url TEXT,
          thumbnail_url TEXT,
          duration INTEGER,
          category VARCHAR(50),
          is_premium BOOLEAN DEFAULT false,
          view_count INTEGER DEFAULT 0,
          like_count INTEGER DEFAULT 0,
          comment_count INTEGER DEFAULT 0,
          share_count INTEGER DEFAULT 0,
          save_count INTEGER DEFAULT 0,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    print('🚀 Creating reels table...');
    await PostgresClient.execute('''
      CREATE TABLE reels (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          video_url TEXT NOT NULL,
          thumbnail_url TEXT,
          title TEXT,
          description TEXT,
          duration INTEGER NOT NULL CHECK (duration BETWEEN 15 AND 60),
          category VARCHAR(50),
          view_count INTEGER DEFAULT 0,
          like_count INTEGER DEFAULT 0,
          comment_count INTEGER DEFAULT 0,
          share_count INTEGER DEFAULT 0,
          completion_rate DECIMAL(5,2) DEFAULT 0,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    print('🚀 Creating friendships table...');
    await PostgresClient.execute('''
      CREATE TABLE friendships (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          friend_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'blocked')),
          requested_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          accepted_at TIMESTAMP WITH TIME ZONE,
          UNIQUE(user_id, friend_id),
          CHECK (user_id != friend_id)
      );
    ''');

    print('🚀 Creating follows table...');
    await PostgresClient.execute('''
      CREATE TABLE follows (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          following_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          notify_on_post BOOLEAN DEFAULT true,
          followed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(follower_id, following_id),
          CHECK (follower_id != following_id)
      );
    ''');

    print('🚀 Creating indexes...');
    await PostgresClient.execute('CREATE INDEX idx_posts_user ON posts(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_posts_type ON posts(post_type);');
    await PostgresClient.execute('CREATE INDEX idx_posts_created ON posts(created_at DESC);');
    await PostgresClient.execute('CREATE INDEX idx_posts_category ON posts(category);');
    await PostgresClient.execute('CREATE INDEX idx_reels_user ON reels(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_reels_created ON reels(created_at DESC);');
    await PostgresClient.execute('CREATE INDEX idx_reels_category ON reels(category);');
    await PostgresClient.execute('CREATE INDEX idx_friendships_user ON friendships(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_friendships_friend ON friendships(friend_id);');
    await PostgresClient.execute('CREATE INDEX idx_friendships_status ON friendships(status);');
    await PostgresClient.execute('CREATE INDEX idx_follows_follower ON follows(follower_id);');
    await PostgresClient.execute('CREATE INDEX idx_follows_following ON follows(following_id);');

    print('✅ Migration 010 applied successfully!');
    print('📊 Created tables: posts, reels, friendships, follows');
    print('📊 Created 12 indexes for query optimization');
    print('🎉 Social platform core features ready!');
    
  } catch (e, stackTrace) {
    print('❌ Migration failed: $e');
    print(stackTrace);
  } finally {
    await PostgresClient.close();
    print('✅ Database connections closed');
  }
}
