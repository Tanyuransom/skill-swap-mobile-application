/**
 * Learning Service
 * Handles enrollment and progress tracking
 */

import { apiService } from './api';
import type { Course } from './course.service';

export interface Enrollment {
    id: string;
    userId: string;
    courseId: string;
    status: 'active' | 'completed' | 'dropped';
    enrolledAt: string;
    completedAt?: string;
    lastAccessed: string;
    course?: Course; // Populated from join
}

export interface Progress {
    totalLessons: number;
    completedLessons: number;
    percentage: number;
}

export interface EnrollmentWithProgress extends Enrollment {
    progress?: Progress;
}

class LearningService {
    /**
     * Enroll in a course
     */
    async enrollInCourse(courseId: string): Promise<Enrollment> {
        const response = await apiService.post<Enrollment>(`/enroll/${courseId}`, {});

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to enroll in course');
        }

        return response.data;
    }

    /**
     * Get all enrollments for current user
     */
    async getEnrollments(): Promise<Enrollment[]> {
        const response = await apiService.get<Enrollment[]>('/enrollments');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch enrollments');
        }

        return response.data;
    }

    /**
     * Get progress for a specific course
     */
    async getCourseProgress(courseId: string): Promise<Progress> {
        const response = await apiService.get<Progress>(`/progress/${courseId}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch progress');
        }

        return response.data;
    }

    /**
     * Update progress (last accessed time)
     */
    async updateProgress(courseId: string): Promise<void> {
        const response = await apiService.post('/progress', { courseId });

        if (!response.success) {
            throw new Error('Failed to update progress');
        }
    }

    /**
     * Mark lesson as complete
     */
    async markLessonComplete(lessonId: string): Promise<void> {
        const response = await apiService.post(`/complete/${lessonId}`, {});

        if (!response.success) {
            throw new Error('Failed to mark lesson as complete');
        }
    }

    /**
     * Drop enrollment
     */
    async dropEnrollment(enrollmentId: string): Promise<void> {
        const response = await apiService.delete(`/enroll/${enrollmentId}`);

        if (!response.success) {
            throw new Error('Failed to drop enrollment');
        }
    }
}

export const learningService = new LearningService();
