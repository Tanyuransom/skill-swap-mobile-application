/**
 * Messaging Service
 * Handles conversations and messages
 */

import { apiService } from './api';

export interface Message {
    id: string;
    conversationId: string;
    senderId: string;
    messageType: 'text' | 'image' | 'video' | 'file';
    content: string;
    mediaUrl?: string;
    isRead: boolean;
    createdAt: string;
}

export interface Conversation {
    id: string;
    participant1Id: string;
    participant2Id: string;
    lastMessageAt: string;
    createdAt: string;
    // Populated fields
    otherUserName?: string;
    otherUserAvatar?: string;
    lastMessage?: string;
    unreadCount?: number;
}

class MessagingService {
    /**
     * Get all conversations for current user
     */
    async getConversations(): Promise<Conversation[]> {
        const response = await apiService.get<{ conversations: Conversation[] }>('/conversations');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch conversations');
        }

        return response.data.conversations;
    }

    /**
     * Create or get existing conversation
     */
    async getOrCreateConversation(recipientId: string): Promise<string> {
        const response = await apiService.post<{ conversationId: string }>('/conversations', {
            recipientId,
        });

        if (!response.success || !response.data) {
            throw new Error('Failed to create conversation');
        }

        return response.data.conversationId;
    }

    /**
     * Get messages in a conversation
     */
    async getMessages(conversationId: string): Promise<Message[]> {
        const response = await apiService.get<{ messages: Message[] }>(
            `/conversations/${conversationId}/messages`
        );

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch messages');
        }

        return response.data.messages;
    }

    /**
     * Send a message
     */
    async sendMessage(
        conversationId: string,
        content: string,
        messageType: 'text' | 'image' | 'video' | 'file' = 'text',
        mediaUrl?: string
    ): Promise<string> {
        const response = await apiService.post<{ messageId: string }>('/messages', {
            conversationId,
            content,
            messageType,
            mediaUrl,
        });

        if (!response.success || !response.data) {
            throw new Error('Failed to send message');
        }

        return response.data.messageId;
    }

    /**
     * Mark conversation as read
     */
    async markAsRead(conversationId: string): Promise<void> {
        const response = await apiService.put(`/conversations/${conversationId}/read`, {});

        if (!response.success) {
            throw new Error('Failed to mark as read');
        }
    }
}

export const messagingService = new MessagingService();
