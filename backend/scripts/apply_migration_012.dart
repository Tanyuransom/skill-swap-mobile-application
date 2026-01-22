import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  print('🚀 Applying Migration 012: Messaging System...');
  
  try {
    await PostgresClient.initialize();
    
    print('🧹 Cleaning up old tables (if any)...');
    await PostgresClient.execute('DROP TABLE IF EXISTS messages CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS conversation_participants CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS conversations CASCADE');

    print('🚀 Creating conversations table...');
    await PostgresClient.execute('''
      CREATE TABLE conversations (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          conversation_type VARCHAR(20) DEFAULT 'direct' CHECK (conversation_type IN ('direct', 'group')),
          name VARCHAR(100),
          created_by UUID REFERENCES users(id),
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    print('🚀 Creating conversation_participants table...');
    await PostgresClient.execute('''
      CREATE TABLE conversation_participants (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          role VARCHAR(20) DEFAULT 'member' CHECK (role IN ('admin', 'member')),
          joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(conversation_id, user_id)
      );
    ''');

    print('🚀 Creating messages table...');
    await PostgresClient.execute('''
      CREATE TABLE messages (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
          sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          message_type VARCHAR(20) DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'video', 'reel_share', 'post_share')),
          content TEXT,
          media_url TEXT,
          shared_content_id UUID,
          is_read BOOLEAN DEFAULT false,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    print('🚀 Creating indexes...');
    await PostgresClient.execute('CREATE INDEX idx_conversations_updated ON conversations(updated_at DESC);');
    await PostgresClient.execute('CREATE INDEX idx_participants_user ON conversation_participants(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_participants_conversation ON conversation_participants(conversation_id);');
    await PostgresClient.execute('CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at DESC);');
    await PostgresClient.execute('CREATE INDEX idx_messages_sender ON messages(sender_id);');
    await PostgresClient.execute('CREATE INDEX idx_messages_unread ON messages(is_read);');

    print('✅ Migration 012 applied successfully!');
    print('📊 Created tables: conversations, conversation_participants, messages');
    print('📊 Created 6 indexes for query optimization');
    
  } catch (e, stackTrace) {
    print('❌ Migration failed: $e');
    print(stackTrace);
  } finally {
    await PostgresClient.close();
    print('✅ Database connections closed');
  }
}
