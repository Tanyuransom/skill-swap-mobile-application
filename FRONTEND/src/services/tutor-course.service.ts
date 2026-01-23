/**
 * Tutor Course Service
 * Handles course creation and management for tutors
 */

import { apiService } from './api';
import type { Course } from './course.service';

export interface CreateCourseRequest {
    title: string;
    description: string;
    price: number;
    currency: string;
    category: string;
    difficultyLevel: 'beginner' | 'intermediate' | 'advanced';
    thumbnailUrl?: string; // Optional (upload separate)
}

export interface UpdateCourseRequest extends Partial<CreateCourseRequest> {
    isPublished?: boolean;
}

export interface CreateModuleRequest {
    title: string;
    description?: string;
    orderIndex: number;
}

export interface CreateLessonRequest {
    title: string;
    content?: string;
    videoUrl?: string;
    durationMinutes?: number;
    orderIndex: number;
    isFree?: boolean;
}

class TutorCourseService {
    /**
     * Get my courses
     */
    async getMyCourses(): Promise<Course[]> {
        const response = await apiService.get<Course[]>('/my-courses');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch your courses');
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
     * Update a course
     */
    async updateCourse(courseId: string, data: UpdateCourseRequest): Promise<Course> {
        const response = await apiService.put<Course>(`/courses/${courseId}`, data);

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to update course');
        }

        return response.data;
    }

    /**
     * Delete a course
     */
    async deleteCourse(courseId: string): Promise<void> {
        const response = await apiService.delete(`/courses/${courseId}`);

        if (!response.success) {
            throw new Error('Failed to delete course');
        }
    }

    /**
     * Add module to course
     */
    async addModule(courseId: string, data: CreateModuleRequest): Promise<void> {
        const response = await apiService.post(`/courses/${courseId}/modules`, data);

        if (!response.success) {
            throw new Error('Failed to add module');
        }
    }

    /**
     * Delete module
     */
    async deleteModule(moduleId: string): Promise<void> {
        const response = await apiService.delete(`/modules/${moduleId}`);

        if (!response.success) {
            throw new Error('Failed to delete module');
        }
    }

    /**
     * Add lesson to module
     */
    async addLesson(moduleId: string, data: CreateLessonRequest): Promise<void> {
        const response = await apiService.post(`/modules/${moduleId}/lessons`, data);

        if (!response.success) {
            throw new Error('Failed to add lesson');
        }
    }

    /**
     * Delete lesson
     */
    async deleteLesson(lessonId: string): Promise<void> {
        const response = await apiService.delete(`/lessons/${lessonId}`);

        if (!response.success) {
            throw new Error('Failed to delete lesson');
        }
    }
}

export const tutorCourseService = new TutorCourseService();
