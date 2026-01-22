-- Phase 8: Payment Service Database Schema
-- Currency: XAF (Central African Franc)
-- Payment Methods: Orange Money CM, MTN Mobile Money CM

-- Transactions: Track all payments
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE SET NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'XAF',
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    payment_method VARCHAR(50) CHECK (payment_method IN ('orange_money', 'mtn_momo', 'wallet')),
    phone_number VARCHAR(20), -- Customer phone for mobile money
    transaction_ref VARCHAR(255), -- Mobile money transaction reference
    operator_transaction_id VARCHAR(255), -- Orange/MTN transaction ID
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Wallet: Tutor earnings and balances (in XAF)
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

-- Payouts: Tutor withdrawal requests
CREATE TABLE payouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    payment_method VARCHAR(50) CHECK (payment_method IN ('orange_money', 'mtn_momo')),
    phone_number VARCHAR(20) NOT NULL, -- Tutor's mobile money number
    operator_transaction_id VARCHAR(255),
    requested_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    failure_reason TEXT
);

-- Indexes for performance
CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_transactions_course ON transactions(course_id);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_wallets_user ON wallets(user_id);
CREATE INDEX idx_payouts_user ON payouts(user_id);
CREATE INDEX idx_payouts_status ON payouts(status);
