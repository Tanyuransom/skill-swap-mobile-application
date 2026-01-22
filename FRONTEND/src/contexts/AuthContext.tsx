/**
 * Authentication Context
 * Global state management for authentication
 */

import React, { createContext, useState, useEffect, useCallback } from 'react';
import { authService } from '@/services/auth.service';
import { storageService } from '@/services/storage.service';
import {
    User,
    AuthState,
    RegisterRequest,
    LoginRequest,
    OTPRequest,
    ResetPasswordRequest,
} from '@/types/auth.types';

interface AuthContextType extends AuthState {
    // Actions
    register: (data: RegisterRequest) => Promise<{ userId: string; email: string }>;
    verifyOTP: (data: OTPRequest) => Promise<void>;
    resendOTP: (email: string) => Promise<void>;
    login: (data: LoginRequest) => Promise<void>;
    logout: () => Promise<void>;
    forgotPassword: (email: string) => Promise<void>;
    resetPassword: (data: ResetPasswordRequest) => Promise<void>;
    refreshUser: () => Promise<void>;
}

export const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [state, setState] = useState<AuthState>({
        user: null,
        accessToken: null,
        refreshToken: null,
        isAuthenticated: false,
        isLoading: true,
    });

    /**
     * Initialize auth state on app start
     */
    useEffect(() => {
        initializeAuth();
    }, []);

    const initializeAuth = async () => {
        try {
            const [user, accessToken, refreshToken] = await Promise.all([
                storageService.getUser(),
                storageService.getAccessToken(),
                storageService.getRefreshToken(),
            ]);

            if (user && accessToken && refreshToken) {
                setState({
                    user,
                    accessToken,
                    refreshToken,
                    isAuthenticated: true,
                    isLoading: false,
                });
            } else {
                setState({
                    user: null,
                    accessToken: null,
                    refreshToken: null,
                    isAuthenticated: false,
                    isLoading: false,
                });
            }
        } catch (error) {
            console.error('Error initializing auth:', error);
            setState({
                user: null,
                accessToken: null,
                refreshToken: null,
                isAuthenticated: false,
                isLoading: false,
            });
        }
    };

    /**
     * Register new user
     */
    const register = useCallback(async (data: RegisterRequest) => {
        try {
            const response = await authService.register(data);
            return response.data!;
        } catch (error: any) {
            throw error;
        }
    }, []);

    /**
     * Verify OTP
     */
    const verifyOTP = useCallback(async (data: OTPRequest) => {
        try {
            const authResponse = await authService.verifyOTP(data);

            setState({
                user: authResponse.user,
                accessToken: authResponse.accessToken,
                refreshToken: authResponse.refreshToken,
                isAuthenticated: true,
                isLoading: false,
            });
        } catch (error: any) {
            throw error;
        }
    }, []);

    /**
     * Resend OTP
     */
    const resendOTP = useCallback(async (email: string) => {
        try {
            await authService.resendOTP(email);
        } catch (error: any) {
            throw error;
        }
    }, []);

    /**
     * Login
     */
    const login = useCallback(async (data: LoginRequest) => {
        try {
            const authResponse = await authService.login(data);

            setState({
                user: authResponse.user,
                accessToken: authResponse.accessToken,
                refreshToken: authResponse.refreshToken,
                isAuthenticated: true,
                isLoading: false,
            });
        } catch (error: any) {
            throw error;
        }
    }, []);

    /**
     * Logout
     */
    const logout = useCallback(async () => {
        try {
            await authService.logout();

            setState({
                user: null,
                accessToken: null,
                refreshToken: null,
                isAuthenticated: false,
                isLoading: false,
            });
        } catch (error: any) {
            console.error('Logout error:', error);
            // Still clear state even if API call fails
            setState({
                user: null,
                accessToken: null,
                refreshToken: null,
                isAuthenticated: false,
                isLoading: false,
            });
        }
    }, []);

    /**
     * Forgot password
     */
    const forgotPassword = useCallback(async (email: string) => {
        try {
            await authService.forgotPassword(email);
        } catch (error: any) {
            throw error;
        }
    }, []);

    /**
     * Reset password
     */
    const resetPassword = useCallback(async (data: ResetPasswordRequest) => {
        try {
            await authService.resetPassword(data);
        } catch (error: any) {
            throw error;
        }
    }, []);

    /**
     * Refresh user data
     */
    const refreshUser = useCallback(async () => {
        try {
            const user = await authService.getCurrentUser();
            setState((prev) => ({
                ...prev,
                user,
            }));
        } catch (error: any) {
            console.error('Error refreshing user:', error);
            throw error;
        }
    }, []);

    const value: AuthContextType = {
        ...state,
        register,
        verifyOTP,
        resendOTP,
        login,
        logout,
        forgotPassword,
        resetPassword,
        refreshUser,
    };

    return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
