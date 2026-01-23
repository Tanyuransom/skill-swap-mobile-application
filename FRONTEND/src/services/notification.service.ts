/**
 * Notification Service
 * Handles user notifications
 */

import { apiService } from './api';

export interface Notification {
    id: string;
    userId: string;
    type: 'course_update' | 'new_message' | 'enrollment' | 'review' | 'system';
    title: string;
    message: string;
    isRead: boolean;
    relatedId?: string; // course_id, message_id, etc.
    createdAt: string;
}

class NotificationService {
    /**
     * Get all notifications for current user
     */
    async getNotifications(): Promise<Notification[]> {
        const response = await apiService.get<Notification[]>('/notifications');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch notifications');
        }

        return response.data;
    }

    /**
     * Get unread count
     */
    async getUnreadCount(): Promise<number> {
        const response = await apiService.get<{ count: number }>('/notifications/unread/count');

        if (!response.success || !response.data) {
            return 0;
        }

        return response.data.count;
    }

    /**
     * Mark notification as read
     */
    async markAsRead(notificationId: string): Promise<void> {
        const response = await apiService.put(`/notifications/${notificationId}/read`, {});

        if (!response.success) {
            throw new Error('Failed to mark notification as read');
        }
    }

    /**
     * Mark all notifications as read
     */
    async markAllAsRead(): Promise<void> {
        const response = await apiService.put('/notifications/read-all', {});

        if (!response.success) {
            throw new Error('Failed to mark all as read');
        }
    }

    /**
     * Delete notification
     */
    async deleteNotification(notificationId: string): Promise<void> {
        const response = await apiService.delete(`/notifications/${notificationId}`);

        if (!response.success) {
            throw new Error('Failed to delete notification');
        }
    }
}

export const notificationService = new NotificationService();
