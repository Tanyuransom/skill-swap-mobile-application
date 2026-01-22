import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  print('🚀 Applying Migration 013: Notifications & Friend Requests...');
  
  try {
    await PostgresClient.initialize();
    
    print('🧹 Cleaning up old tables (if any)...');
    await PostgresClient.execute('DROP TABLE IF EXISTS notifications CASCADE');

    print('🚀 Creating notifications table...');
    await PostgresClient.execute('''
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
    ''');

    print('🚀 Updating friendships constraints...');
    await PostgresClient.execute('ALTER TABLE friendships DROP CONSTRAINT IF EXISTS friendships_status_check;');
    await PostgresClient.execute('''
      ALTER TABLE friendships ADD CONSTRAINT friendships_status_check 
          CHECK (status IN ('pending', 'accepted', 'rejected', 'blocked'));
    ''');

    print('🚀 Creating indexes...');
    await PostgresClient.execute('CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);');
    await PostgresClient.execute('CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read);');
    await PostgresClient.execute('CREATE INDEX idx_notifications_type ON notifications(notification_type);');

    print('✅ Migration 013 applied successfully!');
    print('📊 Created table: notifications');
    print('📊 Updated friendships constraints');
    print('📊 Created 3 indexes');
    
  } catch (e, stackTrace) {
    print('❌ Migration failed: $e');
    print(stackTrace);
  } finally {
    await PostgresClient.close();
    print('✅ Database connections closed');
  }
}
