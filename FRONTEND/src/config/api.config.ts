/**
 * API Configuration
 * Base URL and settings for backend communication
 */

import Constants from 'expo-constants';

// Determine the API URL based on environment
const getBaseUrl = () => {
    // If we have a defined API URL in environment variables, use it
    if (process.env.EXPO_PUBLIC_API_URL) {
        console.log('📡 Using env API URL:', process.env.EXPO_PUBLIC_API_URL);
        return process.env.EXPO_PUBLIC_API_URL;
    }

    // In Expo Go development
    if (__DEV__) {
        // If running in Expo Go, use the host IP (your computer)
        const debuggerHost = Constants.expoConfig?.hostUri;
        const localhost = debuggerHost?.split(':')[0];

        console.log('📡 Expo hostUri:', debuggerHost);
        console.log('📡 Extracted localhost:', localhost);

        if (localhost) {
            const url = `http://${localhost}:8081`;
            console.log('📡 API BASE_URL:', url);
            return url;
        }

        // Fallback for web or simulators
        console.log('📡 Using fallback localhost:8081');
        return 'http://localhost:8081';
    }

    // Default production URL
    return 'https://api.skillswapp.com';
};

export const API_CONFIG = {
    BASE_URL: getBaseUrl(),
    TIMEOUT: 10000,
    HEADERS: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    },
} as const;

export const API_ENDPOINTS = {
    // Auth endpoints
    REGISTER: '/register',
    VERIFY_OTP: '/verify-otp',
    RESEND_OTP: '/resend-otp',
    LOGIN: '/login',
    LOGOUT: '/logout',
    REFRESH_TOKEN: '/refresh-token',
    FORGOT_PASSWORD: '/forgot-password',
    RESET_PASSWORD: '/reset-password',
    GET_CURRENT_USER: '/me',

    // OAuth endpoints
    GOOGLE_AUTH: '/google-auth',

    // Health check
    HEALTH: '/health',
} as const;
