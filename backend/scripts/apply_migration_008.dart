import 'package:skillswapp_shared/skillswapp_shared.dart';

void main() async {
  print('🚀 Applying Migration 008: Payment Service Schema...');
  
  try {
    await PostgresClient.initialize();
    
    print('🧹 Cleaning up old tables (if any)...');
    // Drop in correct order (child tables first)
    await PostgresClient.execute('DROP TABLE IF EXISTS payouts CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS wallets CASCADE');
    await PostgresClient.execute('DROP TABLE IF EXISTS transactions CASCADE');

    print('🚀 Creating transactions table...');
    await PostgresClient.execute('''
      CREATE TABLE transactions (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          course_id UUID REFERENCES courses(id) ON DELETE SET NULL,
          amount DECIMAL(10, 2) NOT NULL,
          currency VARCHAR(3) DEFAULT 'XAF',
          status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
          payment_method VARCHAR(50) CHECK (payment_method IN ('orange_money', 'mtn_momo', 'wallet')),
          phone_number VARCHAR(20),
          transaction_ref VARCHAR(255),
          operator_transaction_id VARCHAR(255),
          description TEXT,
          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          completed_at TIMESTAMP WITH TIME ZONE
      );
    ''');

    print('🚀 Creating wallets table...');
    await PostgresClient.execute('''
      CREATE TABLE wallets (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          balance DECIMAL(10, 2) DEFAULT 0.00,
          pending_balance DECIMAL(10, 2) DEFAULT 0.00,
          total_earned DECIMAL(10, 2) DEFAULT 0.00,
          total_withdrawn DECIMAL(10, 2) DEFAULT 0.00,
          currency VARCHAR(3) DEFAULT 'XAF',
          updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          UNIQUE(user_id)
      );
    ''');

    print('🚀 Creating payouts table...');
    await PostgresClient.execute('''
      CREATE TABLE payouts (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          amount DECIMAL(10, 2) NOT NULL,
          status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
          payment_method VARCHAR(50) CHECK (payment_method IN ('orange_money', 'mtn_momo')),
          phone_number VARCHAR(20) NOT NULL,
          operator_transaction_id VARCHAR(255),
          requested_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
          completed_at TIMESTAMP WITH TIME ZONE,
          failure_reason TEXT
      );
    ''');

    print('🚀 Creating indexes...');
    await PostgresClient.execute('CREATE INDEX idx_transactions_user ON transactions(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_transactions_course ON transactions(course_id);');
    await PostgresClient.execute('CREATE INDEX idx_transactions_status ON transactions(status);');
    await PostgresClient.execute('CREATE INDEX idx_wallets_user ON wallets(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_payouts_user ON payouts(user_id);');
    await PostgresClient.execute('CREATE INDEX idx_payouts_status ON payouts(status);');

    print('✅ Migration 008 applied successfully!');
    print('📊 Created tables: transactions, wallets, payouts');
    print('📊 Created 6 indexes for query optimization');
    
  } catch (e, stackTrace) {
    print('❌ Migration failed: $e');
    print(stackTrace);
  } finally {
    await PostgresClient.close();
    print('✅ Database connections closed');
  }
}
