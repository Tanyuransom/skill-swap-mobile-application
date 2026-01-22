/**
 * API Service
 * Axios instance with interceptors for authentication
 */

import axios, { AxiosInstance, AxiosError, InternalAxiosRequestConfig } from 'axios';
import { API_CONFIG } from '@/config/api.config';
import { storageService } from './storage.service';
import { ApiResponse } from '@/types/auth.types';

class ApiService {
    private axiosInstance: AxiosInstance;
    private isRefreshing = false;
    private failedQueue: Array<{
        resolve: (value?: any) => void;
        reject: (reason?: any) => void;
    }> = [];

    constructor() {
        this.axiosInstance = axios.create({
            baseURL: API_CONFIG.BASE_URL,
            timeout: API_CONFIG.TIMEOUT,
            headers: API_CONFIG.HEADERS,
        });

        this.setupInterceptors();
    }

    private setupInterceptors() {
        // Request interceptor - add auth token
        this.axiosInstance.interceptors.request.use(
            async (config: InternalAxiosRequestConfig) => {
                const token = await storageService.getAccessToken();
                if (token && config.headers) {
                    config.headers.Authorization = `Bearer ${token}`;
                }
                return config;
            },
            (error) => {
                return Promise.reject(error);
            }
        );

        // Response interceptor - handle token refresh
        this.axiosInstance.interceptors.response.use(
            (response) => response,
            async (error: AxiosError) => {
                const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean };

                // If error is 401 and we haven't retried yet
                if (error.response?.status === 401 && !originalRequest._retry) {
                    if (this.isRefreshing) {
                        // Wait for token refresh to complete
                        return new Promise((resolve, reject) => {
                            this.failedQueue.push({ resolve, reject });
                        })
                            .then((token) => {
                                if (originalRequest.headers) {
                                    originalRequest.headers.Authorization = `Bearer ${token}`;
                                }
                                return this.axiosInstance(originalRequest);
                            })
                            .catch((err) => Promise.reject(err));
                    }

                    originalRequest._retry = true;
                    this.isRefreshing = true;

                    try {
                        const refreshToken = await storageService.getRefreshToken();
                        if (!refreshToken) {
                            throw new Error('No refresh token');
                        }

                        // Call refresh token endpoint
                        const response = await axios.post(
                            `${API_CONFIG.BASE_URL}/refresh-token`,
                            { refreshToken },
                            { headers: API_CONFIG.HEADERS }
                        );

                        const { accessToken, refreshToken: newRefreshToken } = response.data.data;

                        // Save new tokens
                        await storageService.saveTokens(accessToken, newRefreshToken);

                        // Retry all failed requests
                        this.failedQueue.forEach((prom) => prom.resolve(accessToken));
                        this.failedQueue = [];

                        // Retry original request
                        if (originalRequest.headers) {
                            originalRequest.headers.Authorization = `Bearer ${accessToken}`;
                        }
                        return this.axiosInstance(originalRequest);
                    } catch (refreshError) {
                        // Refresh failed - clear auth and redirect to login
                        this.failedQueue.forEach((prom) => prom.reject(refreshError));
                        this.failedQueue = [];
                        await storageService.clearAuth();
                        // TODO: Navigate to login screen
                        return Promise.reject(refreshError);
                    } finally {
                        this.isRefreshing = false;
                    }
                }

                return Promise.reject(error);
            }
        );
    }

    /**
     * GET request
     */
    async get<T = any>(url: string, config?: any): Promise<ApiResponse<T>> {
        try {
            const response = await this.axiosInstance.get(url, config);
            return response.data;
        } catch (error) {
            throw this.handleError(error);
        }
    }

    /**
     * POST request
     */
    async post<T = any>(url: string, data?: any, config?: any): Promise<ApiResponse<T>> {
        try {
            const response = await this.axiosInstance.post(url, data, config);
            return response.data;
        } catch (error) {
            throw this.handleError(error);
        }
    }

    /**
     * PUT request
     */
    async put<T = any>(url: string, data?: any, config?: any): Promise<ApiResponse<T>> {
        try {
            const response = await this.axiosInstance.put(url, data, config);
            return response.data;
        } catch (error) {
            throw this.handleError(error);
        }
    }

    /**
     * DELETE request
     */
    async delete<T = any>(url: string, config?: any): Promise<ApiResponse<T>> {
        try {
            const response = await this.axiosInstance.delete(url, config);
            return response.data;
        } catch (error) {
            throw this.handleError(error);
        }
    }

    /**
     * Handle API errors
     */
    private handleError(error: any): Error {
        if (axios.isAxiosError(error)) {
            const axiosError = error as AxiosError<ApiResponse>;

            if (axiosError.response) {
                // Server responded with error
                const message = axiosError.response.data?.message || 'An error occurred';
                const apiError = new Error(message);
                (apiError as any).response = axiosError.response.data;
                (apiError as any).status = axiosError.response.status;
                return apiError;
            } else if (axiosError.request) {
                // Request made but no response
                return new Error('No response from server. Please check your internet connection.');
            }
        }

        return new Error('An unexpected error occurred');
    }
}

export const apiService = new ApiService();
