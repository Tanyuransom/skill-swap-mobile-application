/**
 * TypeScript Types for Authentication
 * Matches backend Dart models
 */

// User roles
export type UserRole = 'student' | 'tutor';

// User interface
export interface User {
    id: string;
    email: string;
    role: UserRole;
    firstName: string;
    lastName: string;
    isVerified: boolean;
    isActive: boolean;
    createdAt?: string;
    updatedAt?: string;
}

// Register request (matches backend RegisterRequest)
export interface RegisterRequest {
    email: string;
    password: string;
    role: UserRole;
    firstName: string;
    lastName: string;
}

// Login request (matches backend LoginRequest)
export interface LoginRequest {
    email: string;
    password: string;
}

// OTP request (matches backend OTPRequest)
export interface OTPRequest {
    email: string;
    otp: string;
}

// Auth response (matches backend AuthResponse)
export interface AuthResponse {
    accessToken: string;
    refreshToken: string;
    user: User;
}

// Reset password request
export interface ResetPasswordRequest {
    email: string;
    otp: string;
    newPassword: string;
}

// API Response wrapper (matches backend ApiResponse)
export interface ApiResponse<T = any> {
    success: boolean;
    message: string;
    data?: T;
    errors?: Record<string, any>;
}

// Verification context
export type VerificationContext = 'signup' | 'password-reset';

// Auth state
export interface AuthState {
    user: User | null;
    accessToken: string | null;
    refreshToken: string | null;
    isAuthenticated: boolean;
    isLoading: boolean;
}

// Storage keys
export const STORAGE_KEYS = {
    ACCESS_TOKEN: 'access_token',
    REFRESH_TOKEN: 'refresh_token',
    USER: 'user',
} as const;
