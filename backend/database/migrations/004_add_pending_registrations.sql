-- Migration: Add pending_registrations table
-- Purpose: Store temporary registration data until OTP verification
-- Date: 2026-01-22

-- Create pending_registrations table
CREATE TABLE IF NOT EXISTS pending_registrations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('student', 'tutor')),
  otp_code VARCHAR(10) NOT NULL,
  otp_expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  expires_at TIMESTAMP DEFAULT NOW() + INTERVAL '24 hours'
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_pending_email ON pending_registrations(email);
CREATE INDEX IF NOT EXISTS idx_pending_expires ON pending_registrations(expires_at);
CREATE INDEX IF NOT EXISTS idx_pending_otp_expires ON pending_registrations(otp_expires_at);

-- Add comment
COMMENT ON TABLE pending_registrations IS 'Temporary storage for user registrations pending OTP verification';
