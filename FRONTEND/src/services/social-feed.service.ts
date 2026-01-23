/**
 * Social Feed Service
 * Handles posts, feed, and social interactions
 */

import { apiService } from './api';

export interface Post {
    id: string;
    userId: string;
    postType: 'video' | 'reel' | 'text' | 'image';
    title?: string;
    description?: string;
    mediaUrl?: string;
    thumbnailUrl?: string;
    category?: string;
    viewCount: number;
    likeCount: number;
    commentCount: number;
    shareCount: number;
    createdAt: string;
    // Populated fields
    userName?: string;
    userAvatar?: string;
    userHandle?: string; // @username
    isLiked?: boolean;
    isSaved?: boolean;
}

export interface CreatePostRequest {
    postType: 'text' | 'image' | 'video';
    description: string;
    mediaUrl?: string;
    title?: string; // Optional for text posts
}

class SocialFeedService {
    /**
     * Get "For You" feed
     */
    async getForYouFeed(): Promise<Post[]> {
        const response = await apiService.get<Post[]>('/feed/for-you');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch feed');
        }

        return response.data;
    }

    /**
     * Get "Following" feed
     */
    async getFollowingFeed(): Promise<Post[]> {
        const response = await apiService.get<Post[]>('/feed/following');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch following feed');
        }

        return response.data;
    }

    /**
     * Create a new post
     */
    async createPost(data: CreatePostRequest): Promise<Post> {
        const response = await apiService.post<Post>('/posts', data);

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to create post');
        }

        return response.data;
    }

    /**
     * Delete a post
     */
    async deletePost(postId: string): Promise<void> {
        const response = await apiService.delete(`/posts/${postId}`);

        if (!response.success) {
            throw new Error('Failed to delete post');
        }
    }

    /**
     * Get user's posts
     */
    async getUserPosts(userId: string): Promise<Post[]> {
        const response = await apiService.get<Post[]>(`/posts/user/${userId}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch user posts');
        }

        return response.data;
    }

    /**
     * Follow a user
     */
    async followUser(userId: string): Promise<void> {
        const response = await apiService.post(`/follow/${userId}`, {});

        if (!response.success) {
            throw new Error('Failed to follow user');
        }
    }

    /**
     * Unfollow a user
     */
    async unfollowUser(userId: string): Promise<void> {
        const response = await apiService.delete(`/unfollow/${userId}`);

        if (!response.success) {
            throw new Error('Failed to unfollow user');
        }
    }
}

export const socialFeedService = new SocialFeedService();
