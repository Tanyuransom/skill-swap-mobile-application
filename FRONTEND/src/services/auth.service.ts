/**
 * Authentication Service
 * Handles all authentication-related API calls to backend
 */

import { apiService } from './api';
import { storageService } from './storage.service';
import { API_ENDPOINTS } from '@/config/api.config';
import {
    RegisterRequest,
    LoginRequest,
    OTPRequest,
    ResetPasswordRequest,
    AuthResponse,
    User,
    ApiResponse,
} from '@/types/auth.types';

class AuthService {
    /**
     * Register new user
     * POST /register
     */
    async register(data: RegisterRequest): Promise<ApiResponse<{ userId: string; email: string }>> {
        try {
            const response = await apiService.post(API_ENDPOINTS.REGISTER, data);
            return response;
        } catch (error: any) {
            throw error;
        }
    }

    /**
     * Verify OTP (for email verification after registration)
     * POST /verify-otp
     */
    async verifyOTP(data: OTPRequest): Promise<AuthResponse> {
        try {
            const response = await apiService.post<AuthResponse>(API_ENDPOINTS.VERIFY_OTP, data);

            if (response.success && response.data) {
                // Save tokens and user data
                await storageService.saveTokens(
                    response.data.accessToken,
                    response.data.refreshToken
                );
                await storageService.saveUser(response.data.user);

                return response.data;
            }

            throw new Error(response.message || 'OTP verification failed');
        } catch (error: any) {
            throw error;
        }
    }

    /**
     * Resend OTP
     * POST /resend-otp
     */
    async resendOTP(email: string): Promise<ApiResponse> {
        try {
            const response = await apiService.post(API_ENDPOINTS.RESEND_OTP, { email });
            return response;
        } catch (error: any) {
            throw error;
        }
    }

    /**
     * Login with email and password
     * POST /login
     */
    async login(data: LoginRequest): Promise<AuthResponse> {
        try {
            const response = await apiService.post<AuthResponse>(API_ENDPOINTS.LOGIN, data);

            if (response.success && response.data) {
                // Save tokens and user data
                await storageService.saveTokens(
                    response.data.accessToken,
                    response.data.refreshToken
                );
                await storageService.saveUser(response.data.user);

                return response.data;
            }

            throw new Error(response.message || 'Login failed');
        } catch (error: any) {
            throw error;
        }
    }

    /**
     * Logout
     * POST /logout
     */
    async logout(): Promise<void> {
        try {
            // Call backend logout endpoint
            await apiService.post(API_ENDPOINTS.LOGOUT);
        } catch (error) {
            // Continue with logout even if backend call fails
            console.error('Logout API error:', error);
        } finally {
            // Always clear local storage
            await storageService.clearAuth();
        }
    }

    /**
     * Refresh access token
     * POST /refresh-token
     * Note: This is handled automatically by API service interceptor
     */
    async refreshToken(refreshToken: string): Promise<AuthResponse> {
        try {
            const response = await apiService.post<AuthResponse>(
                API_ENDPOINTS.REFRESH_TOKEN,
                { refreshToken }
            );

            if (response.success && response.data) {
                return response.data;
            }

            throw new Error(response.message || 'Token refresh failed');
        } catch (error: any) {
            throw error;
        }
    }

    /**
     * Request password reset (sends OTP to email)
     * POST /forgot-password
     */
    async forgotPassword(email: string): Promise<ApiResponse> {
        try {
            const response = await apiService.post(API_ENDPOINTS.FORGOT_PASSWORD, { email });
            return response;
        } catch (error: any) {
            throw error;
        }
    }

    /**
     * Reset password with OTP
     * POST /reset-password
     */
    async resetPassword(data: ResetPasswordRequest): Promise<ApiResponse> {
        try {
            const response = await apiService.post(API_ENDPOINTS.RESET_PASSWORD, data);
            return response;
        } catch (error: any) {
            throw error;
        }
    }

    /**
     * Get current user
     * GET /me
     */
    async getCurrentUser(): Promise<User> {
        try {
            const response = await apiService.get<User>(API_ENDPOINTS.GET_CURRENT_USER);

            if (response.success && response.data) {
                // Update stored user data
                await storageService.saveUser(response.data);
                return response.data;
            }

            throw new Error(response.message || 'Failed to get user');
        } catch (error: any) {
            throw error;
        }
    }

    /**
     * Check if user is authenticated (has valid tokens)
     */
    async isAuthenticated(): Promise<boolean> {
        return await storageService.isLoggedIn();
    }

    /**
     * Get stored user data
     */
    async getStoredUser(): Promise<User | null> {
        return await storageService.getUser();
    }
}

export const authService = new AuthService();
