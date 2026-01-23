/**
 * User Service
 * Handles user profile and settings operations
 */

import { apiService } from './api';

export interface User {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    role: string;
    bio?: string;
    skills?: string[];
    avatar?: string;
    isVerified: boolean;
    createdAt: string;
}

export interface UpdateProfileRequest {
    firstName?: string;
    lastName?: string;
    bio?: string;
    skills?: string[];
    avatar?: string;
}

class UserService {
    /**
     * Get current user profile
     */
    async getMyProfile(): Promise<User> {
        const userId = await this.getCurrentUserId();
        const response = await apiService.get<User>(`/profile/${userId}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch profile');
        }

        return response.data;
    }

    /**
     * Get public profile of another user
     */
    async getPublicProfile(userId: string): Promise<User> {
        const response = await apiService.get<User>(`/profile/${userId}/public`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch public profile');
        }

        return response.data;
    }

    /**
     * Update current user profile
     */
    async updateProfile(data: UpdateProfileRequest): Promise<User> {
        const response = await apiService.put<User>('/profile', data);

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to update profile');
        }

        return response.data;
    }

    /**
     * Get current user ID from storage
     */
    private async getCurrentUserId(): Promise<string> {
        const { storageService } = await import('./storage.service');
        const user = await storageService.getUser();

        if (!user?.id) {
            throw new Error('User not authenticated');
        }

        return user.id;
    }
}

export const userService = new UserService();
