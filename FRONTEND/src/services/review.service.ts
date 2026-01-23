/**
 * Review Service
 * Handles course reviews and ratings
 */

import { apiService } from './api';

export interface Review {
    id: string;
    studentId: string;
    courseId: string;
    rating: number; // 1-5
    comment?: string;
    createdAt: string;
    updatedAt: string;
    // Populated fields
    studentName?: string;
    studentAvatar?: string;
}

export interface CreateReviewRequest {
    courseId: string;
    rating: number;
    comment?: string;
}

class ReviewService {
    /**
     * Get reviews for a course
     */
    async getCourseReviews(courseId: string): Promise<Review[]> {
        const response = await apiService.get<Review[]>(`/reviews/course/${courseId}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch reviews');
        }

        return response.data;
    }

    /**
     * Create a review
     */
    async createReview(data: CreateReviewRequest): Promise<Review> {
        const response = await apiService.post<Review>('/reviews', data);

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to create review');
        }

        return response.data;
    }

    /**
     * Update a review
     */
    async updateReview(reviewId: string, rating: number, comment?: string): Promise<Review> {
        const response = await apiService.put<Review>(`/reviews/${reviewId}`, {
            rating,
            comment,
        });

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to update review');
        }

        return response.data;
    }

    /**
     * Delete a review
     */
    async deleteReview(reviewId: string): Promise<void> {
        const response = await apiService.delete(`/reviews/${reviewId}`);

        if (!response.success) {
            throw new Error(response.message || 'Failed to delete review');
        }
    }

    /**
     * Get my review for a course
     */
    async getMyReview(courseId: string): Promise<Review | null> {
        try {
            const response = await apiService.get<Review>(`/reviews/my-review/${courseId}`);

            if (!response.success || !response.data) {
                return null;
            }

            return response.data;
        } catch (error) {
            return null;
        }
    }
}

export const reviewService = new ReviewService();
