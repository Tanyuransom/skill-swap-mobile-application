/**
 * Verification Service
 * Handles tutor skill verification and badges
 */

import { apiService } from './api';

export interface VerificationRequest {
    id: string;
    tutorId: string;
    skill: string;
    status: 'pending' | 'in_progress' | 'passed' | 'failed';
    createdAt: string;
    updatedAt: string;
}

export interface VerificationExam {
    id: string;
    requestId: string;
    questions: ExamQuestion[];
    submittedAt?: string;
}

export interface ExamQuestion {
    id: string;
    question: string;
    options: string[];
    correctAnswer?: number; // Only shown after submission
}

export interface VerificationResult {
    id: string;
    examId: string;
    score: number;
    passed: boolean;
    feedback?: string;
    badgeLevel?: 'bronze' | 'silver' | 'gold' | 'platinum';
}

export interface TutorBadge {
    id: string;
    tutorId: string;
    skill: string;
    badgeLevel: 'bronze' | 'silver' | 'gold' | 'platinum';
    issuedAt: string;
}

class VerificationService {
    /**
     * Request verification for a skill
     */
    async requestVerification(skill: string): Promise<VerificationRequest> {
        const response = await apiService.post<VerificationRequest>('/verification/request', {
            skill,
        });

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to request verification');
        }

        return response.data;
    }

    /**
     * Get verification exam
     */
    async getExam(requestId: string): Promise<VerificationExam> {
        const response = await apiService.get<VerificationExam>(`/verification/exam/${requestId}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch exam');
        }

        return response.data;
    }

    /**
     * Submit exam answers
     */
    async submitExam(examId: string, answers: Record<string, number>): Promise<VerificationResult> {
        const response = await apiService.post<VerificationResult>('/verification/submit', {
            examId,
            answers,
        });

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to submit exam');
        }

        return response.data;
    }

    /**
     * Get verification result
     */
    async getResult(requestId: string): Promise<VerificationResult> {
        const response = await apiService.get<VerificationResult>(`/verification/result/${requestId}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch result');
        }

        return response.data;
    }

    /**
     * Get tutor badges
     */
    async getTutorBadges(tutorId: string): Promise<TutorBadge[]> {
        const response = await apiService.get<TutorBadge[]>(`/verification/badges/${tutorId}`);

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch badges');
        }

        return response.data;
    }

    /**
     * Upload certificate for verification
     */
    async uploadCertificate(formData: FormData): Promise<void> {
        const response = await apiService.post('/verification/upload-certificate', formData);

        if (!response.success) {
            throw new Error(response.message || 'Failed to upload certificate');
        }
    }
}

export const verificationService = new VerificationService();
