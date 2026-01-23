/**
 * Payment Service
 * Handles subscription payments via mobile money
 */

import { apiService } from './api';

export interface Transaction {
    id: string;
    userId: string;
    amount: number;
    currency: string;
    paymentMethod: 'orange_money' | 'mtn_momo';
    status: 'pending' | 'completed' | 'failed';
    phoneNumber: string;
    createdAt: string;
}

export interface Wallet {
    id: string;
    userId: string;
    balance: number;
    currency: string;
}

export interface InitiatePaymentRequest {
    amount: number;
    paymentMethod: 'orange_money' | 'mtn_momo';
    phoneNumber: string;
}

class PaymentService {
    /**
     * Initiate payment
     */
    async initiatePayment(data: InitiatePaymentRequest): Promise<Transaction> {
        const response = await apiService.post<Transaction>('/payment/initiate', data);

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to initiate payment');
        }

        return response.data;
    }

    /**
     * Confirm payment
     */
    async confirmPayment(transactionId: string): Promise<Transaction> {
        const response = await apiService.post<Transaction>(`/payment/confirm/${transactionId}`, {});

        if (!response.success || !response.data) {
            throw new Error(response.message || 'Failed to confirm payment');
        }

        return response.data;
    }

    /**
     * Get payment history
     */
    async getPaymentHistory(): Promise<Transaction[]> {
        const response = await apiService.get<Transaction[]>('/payment/history');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch payment history');
        }

        return response.data;
    }

    /**
     * Get wallet
     */
    async getWallet(): Promise<Wallet> {
        const response = await apiService.get<Wallet>('/wallet');

        if (!response.success || !response.data) {
            throw new Error('Failed to fetch wallet');
        }

        return response.data;
    }
}

export const paymentService = new PaymentService();
