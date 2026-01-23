/**
 * Course Service
 * Handles course-related operations
 */

import { apiService } from './api';

export interface Course {
    id: string;
    tutorId: string;
    categoryId?: string;
    title: string;
    description: string;
    price: number;
    currency: string;
    thumbnailUrl?: string;
    difficultyLevel?: 'beginner' | 'intermediate' | 'advanced';
    durationHours?: number;
    isPublished: boolean;
    createdAt: string;
    updatedAt: string;
}

export interface CreateCourseRequest {
    title: string;
    description: string;
    categoryId?: string;
    price: number;
    difficultyLevel?: string;
    durationHours?: number;
}

class CourseService {
    /**
     * Get all published courses
     */
    async getAllCourses(): Promise<Course[]> {
        const response = await apiService.get<Course[]>('/courses');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch courses');
        }

        return response.data;
    }

    /**
     * Get course by ID
     */
    async getCourse(courseId: string): Promise<Course> {
        const response = await apiService.get<Course>(`/courses/${courseId}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch course');
        }

        return response.data;
    }

    /**
     * Search courses
     */
    async searchCourses(query: string): Promise<Course[]> {
        const response = await apiService.get<Course[]>(`/courses/search?q=${encodeURIComponent(query)}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to search courses');
        }

        return response.data;
    }

    /**
     * Get my courses (created by me)
     */
    async getMyCourses(): Promise<Course[]> {
        const response = await apiService.get<Course[]>('/my-courses');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch my courses');
        }

        return response.data;
    }

    /**
     * Create a new course
     */
    async createCourse(data: CreateCourseRequest): Promise<Course> {
        const response = await apiService.post<Course>('/courses', data);

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to create course');
        }

        return response.data;
    }

    /**
     * Update course
     */
    async updateCourse(courseId: string, data: Partial<CreateCourseRequest>): Promise<Course> {
        const response = await apiService.put<Course>(`/courses/${courseId}`, data);

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to update course');
        }

        return response.data;
    }

    /**
     * Delete course
     */
    async deleteCourse(courseId: string): Promise<void> {
        const response = await apiService.delete(`/courses/${courseId}`);

        if (!response.success) {
            throw new Error(response.message || 'Failed to delete course');
        }
    }
}

export const courseService = new CourseService();
