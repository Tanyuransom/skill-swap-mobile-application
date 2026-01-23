/**
 * CamPay Payment Integration
 * Real payment processing with CamPay SDK
 */

import { apiService } from './api';

export interface CamPayConfig {
    appUsername: string;
    appPassword: string;
    environment: 'PROD' | 'DEV';
}

export interface CamPayPaymentRequest {
    amount: string;
    currency: string;
    from: string; // Phone number in format 237xxxxxxxxx
    description: string;
    externalReference: string;
}

export interface CamPayResponse {
    reference: string;
    ussdCode: string;
    operator: string;
    status: string;
}

class CamPayService {
    private config: CamPayConfig = {
        appUsername: process.env.EXPO_PUBLIC_CAMPAY_USERNAME || '',
        appPassword: process.env.EXPO_PUBLIC_CAMPAY_PASSWORD || '',
        environment: 'PROD',
    };

    private readonly baseUrl = 'https://demo.campay.net/api';

    /**
     * Get CamPay access token
     */
    private async getToken(): Promise<string> {
        try {
            const response = await fetch(`${this.baseUrl}/token/`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    username: this.config.appUsername,
                    password: this.config.appPassword,
                }),
            });

            const data = await response.json();
            return data.token;
        } catch (error) {
            console.error('Failed to get CamPay token:', error);
            throw new Error('Failed to authenticate with CamPay');
        }
    }

    /**
     * Initiate payment with CamPay
     */
    async initiatePayment(
        amount: number,
        phoneNumber: string,
        description: string = 'SkillSwapp Subscription'
    ): Promise<CamPayResponse> {
        try {
            const token = await this.getToken();

            // Format phone number (must be 237xxxxxxxxx for Cameroon)
            const formattedPhone = phoneNumber.startsWith('237')
                ? phoneNumber
                : `237${phoneNumber.replace(/^0+/, '')}`;

            const paymentData: CamPayPaymentRequest = {
                amount: amount.toString(),
                currency: 'XAF',
                from: formattedPhone,
                description,
                externalReference: `SKILLSWAPP_${Date.now()}`,
            };

            const response = await fetch(`${this.baseUrl}/collect/`, {
                method: 'POST',
                headers: {
                    'Authorization': `Token ${token}`,
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(paymentData),
            });

            if (!response.ok) {
                throw new Error('Payment initiation failed');
            }

            const data = await response.json();
            return data;
        } catch (error) {
            console.error('CamPay payment failed:', error);
            throw error;
        }
    }

    /**
     * Check payment status
     */
    async checkPaymentStatus(reference: string): Promise<any> {
        try {
            const token = await this.getToken();

            const response = await fetch(`${this.baseUrl}/transaction/${reference}/`, {
                method: 'GET',
                headers: {
                    'Authorization': `Token ${token}`,
                    'Content-Type': 'application/json',
                },
            });

            if (!response.ok) {
                throw new Error('Failed to check payment status');
            }

            return await response.json();
        } catch (error) {
            console.error('Failed to check payment status:', error);
            throw error;
        }
    }
}

export const camPayService = new CamPayService();
