import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  print('🚀 Applying Migration 009: Subscription & Analytics System...');
  
  try {
    await PostgresClient.initialize();
    
    print('🧹 Cleaning up old tables (if any)...');
    await PostgresClient.execute('DROP TABLE IF EXISTS tutor_earnings CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS tutor_followers CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS content_analytics CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS subscriptions CASCADE');

    print('🚀 Creating subscriptions table...');
    await PostgresClient.execute('''
      CREATE TABLE subscriptions (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled', 'pending')),
          start_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          end_date TIMESTAMP WITH TIME ZONE,
          auto_renew BOOLEAN DEFAULT true,
          payment_method VARCHAR(50),
          last_payment_date TIMESTAMP WITH TIME ZONE,
          next_billing_date TIMESTAMP WITH TIME ZONE,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(user_id)
      );
    ''');

    print('🚀 Creating content_analytics table...');
    await PostgresClient.execute('''
      CREATE TABLE content_analytics (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
          tutor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          watch_duration INTEGER NOT NULL,
          completed BOOLEAN DEFAULT false,
          liked BOOLEAN DEFAULT false,
          shared BOOLEAN DEFAULT false,
          watched_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    print('🚀 Creating tutor_followers table...');
    await PostgresClient.execute('''
      CREATE TABLE tutor_followers (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          tutor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          followed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(tutor_id, follower_id)
      );
    ''');

    print('🚀 Creating tutor_earnings table...');
    await PostgresClient.execute('''
      CREATE TABLE tutor_earnings (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          tutor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          month DATE NOT NULL,
          watch_time_hours DECIMAL(10, 2) DEFAULT 0,
          total_views INTEGER DEFAULT 0,
          total_likes INTEGER DEFAULT 0,
          total_shares INTEGER DEFAULT 0,
          subscriber_count INTEGER DEFAULT 0,
          watch_time_score DECIMAL(10, 2) DEFAULT 0,
          engagement_score DECIMAL(10, 2) DEFAULT 0,
          subscriber_score DECIMAL(10, 2) DEFAULT 0,
          total_earnings DECIMAL(10, 2) DEFAULT 0,
          calculated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(tutor_id, month)
      );
    ''');

    print('🚀 Creating indexes...');
    await PostgresClient.execute('CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_subscriptions_status ON subscriptions(status);');
    await PostgresClient.execute('CREATE INDEX idx_subscriptions_billing ON subscriptions(next_billing_date);');
    await PostgresClient.execute('CREATE INDEX idx_analytics_lesson ON content_analytics(lesson_id);');
    await PostgresClient.execute('CREATE INDEX idx_analytics_tutor ON content_analytics(tutor_id);');
    await PostgresClient.execute('CREATE INDEX idx_analytics_user ON content_analytics(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_analytics_watched ON content_analytics(watched_at);');
    await PostgresClient.execute('CREATE INDEX idx_followers_tutor ON tutor_followers(tutor_id);');
    await PostgresClient.execute('CREATE INDEX idx_followers_follower ON tutor_followers(follower_id);');
    await PostgresClient.execute('CREATE INDEX idx_earnings_tutor ON tutor_earnings(tutor_id);');
    await PostgresClient.execute('CREATE INDEX idx_earnings_month ON tutor_earnings(month);');

    print('🚀 Adding columns to lessons table...');
    await PostgresClient.execute('ALTER TABLE lessons ADD COLUMN IF NOT EXISTS is_premium BOOLEAN DEFAULT false;');
    await PostgresClient.execute('ALTER TABLE lessons ADD COLUMN IF NOT EXISTS is_free BOOLEAN DEFAULT true;');

    print('✅ Migration 009 applied successfully!');
    print('📊 Created tables: subscriptions, content_analytics, tutor_followers, tutor_earnings');
    print('📊 Created 11 indexes for query optimization');
    print('📊 Updated lessons table with premium/free flags');
    
  } catch (e, stackTrace) {
    print('❌ Migration failed: $e');
    print(stackTrace);
  } finally {
    await PostgresClient.close();
    print('✅ Database connections closed');
  }
}
