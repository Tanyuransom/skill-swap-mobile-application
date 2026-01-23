/**
 * Reels Service
 * Handles short-form vertical videos (TikTok-style)
 */

import { apiService } from './api';

export interface Reel {
    id: string;
    userId: string;
    videoUrl: string;
    thumbnailUrl?: string;
    title?: string;
    description?: string;
    duration: number; // seconds (15-60)
    category?: string;
    viewCount: number;
    likeCount: number;
    commentCount: number;
    shareCount: number;
    completionRate: number;
    createdAt: string;
    // Populated fields
    userName?: string;
    userAvatar?: string;
    userHandle?: string;
    isLiked?: boolean;
    isFollowing?: boolean;
}

class ReelsService {
    /**
     * Get reels feed (infinite scroll)
     */
    async getReelsFeed(page: number = 0, limit: number = 10): Promise<Reel[]> {
        const response = await apiService.get<Reel[]>(`/reels/feed?page=${page}&limit=${limit}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch reels');
        }

        return response.data;
    }

    /**
     * Get user's reels
     */
    async getUserReels(userId: string): Promise<Reel[]> {
        const response = await apiService.get<Reel[]>(`/reels/user/${userId}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch user reels');
        }

        return response.data;
    }

    /**
     * Track view
     */
    async trackView(reelId: string): Promise<void> {
        try {
            await apiService.post(`/reels/${reelId}/view`, {});
        } catch (error) {
            console.error('Failed to track view:', error);
        }
    }

    /**
     * Like reel
     */
    async likeReel(reelId: string): Promise<void> {
        const response = await apiService.post(`/reels/${reelId}/like`, {});

        if (!response.success) {
            throw new Error('Failed to like reel');
        }
    }

    /**
     * Unlike reel
     */
    async unlikeReel(reelId: string): Promise<void> {
        const response = await apiService.delete(`/reels/${reelId}/like`);

        if (!response.success) {
            throw new Error('Failed to unlike reel');
        }
    }

    /**
     * Create new reel
     */
    async createReel(data: {
        videoUrl: string;
        thumbnailUrl: string;
        title: string;
        description?: string;
        duration: number;
    }): Promise<Reel> {
        const response = await apiService.post<Reel>('/reels', data);

        if (!response.success || !response.data) {
            throw new Error('Failed to create reel');
        }

        return response.data;
    }
}

export const reelsService = new ReelsService();
