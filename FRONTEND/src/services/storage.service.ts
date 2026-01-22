/**
 * Secure Storage Service
 * Uses Expo SecureStore for sensitive data (tokens)
 * Uses AsyncStorage for non-sensitive data (user info)
 */

import * as SecureStore from 'expo-secure-store';
import { User, STORAGE_KEYS } from '@/types/auth.types';

class StorageService {
    /**
     * Save authentication tokens securely
     */
    async saveTokens(accessToken: string, refreshToken: string): Promise<void> {
        try {
            await SecureStore.setItemAsync(STORAGE_KEYS.ACCESS_TOKEN, accessToken);
            await SecureStore.setItemAsync(STORAGE_KEYS.REFRESH_TOKEN, refreshToken);
        } catch (error) {
            console.error('Error saving tokens:', error);
            throw new Error('Failed to save authentication tokens');
        }
    }

    /**
     * Get access token
     */
    async getAccessToken(): Promise<string | null> {
        try {
            return await SecureStore.getItemAsync(STORAGE_KEYS.ACCESS_TOKEN);
        } catch (error) {
            console.error('Error getting access token:', error);
            return null;
        }
    }

    /**
     * Get refresh token
     */
    async getRefreshToken(): Promise<string | null> {
        try {
            return await SecureStore.getItemAsync(STORAGE_KEYS.REFRESH_TOKEN);
        } catch (error) {
            console.error('Error getting refresh token:', error);
            return null;
        }
    }

    /**
     * Save user data
     */
    async saveUser(user: User): Promise<void> {
        try {
            await SecureStore.setItemAsync(STORAGE_KEYS.USER, JSON.stringify(user));
        } catch (error) {
            console.error('Error saving user:', error);
            throw new Error('Failed to save user data');
        }
    }

    /**
     * Get user data
     */
    async getUser(): Promise<User | null> {
        try {
            const userJson = await SecureStore.getItemAsync(STORAGE_KEYS.USER);
            return userJson ? JSON.parse(userJson) : null;
        } catch (error) {
            console.error('Error getting user:', error);
            return null;
        }
    }

    /**
     * Clear all authentication data
     */
    async clearAuth(): Promise<void> {
        try {
            await SecureStore.deleteItemAsync(STORAGE_KEYS.ACCESS_TOKEN);
            await SecureStore.deleteItemAsync(STORAGE_KEYS.REFRESH_TOKEN);
            await SecureStore.deleteItemAsync(STORAGE_KEYS.USER);
        } catch (error) {
            console.error('Error clearing auth data:', error);
            throw new Error('Failed to clear authentication data');
        }
    }

    /**
     * Check if user is logged in (has tokens)
     */
    async isLoggedIn(): Promise<boolean> {
        const accessToken = await this.getAccessToken();
        return accessToken !== null;
    }
}

export const storageService = new StorageService();
