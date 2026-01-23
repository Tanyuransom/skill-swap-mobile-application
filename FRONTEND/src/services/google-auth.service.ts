/**
 * Google OAuth Service
 * Handles Google Sign-In with Expo AuthSession
 */

import * as Google from 'expo-auth-session/providers/google';
import * as WebBrowser from 'expo-web-browser';
import { makeRedirectUri } from 'expo-auth-session';
import { apiService } from './api';
import { storageService } from './storage.service';
import { API_ENDPOINTS } from '@/config/api.config';
import { AuthResponse } from '@/types/auth.types';

// Complete the auth session
WebBrowser.maybeCompleteAuthSession();

// Google OAuth Configuration
// TODO: Replace with your actual Google Client IDs from Google Cloud Console
const GOOGLE_CLIENT_ID_WEB = '529526504833-nkunvqn2mto9qrr4rmbq5h75c7etav9b.apps.googleusercontent.com';
const GOOGLE_CLIENT_ID_IOS = '';
const GOOGLE_CLIENT_ID_ANDROID = '829756738508-526a5hh3lsj1709tc2kjq2d5jkvh7o3u.apps.googleusercontent.com';

/**
 * Custom Hook for Google Sign-In
 */
export function useGoogleAuth() {
    const [request, response, promptAsync] = Google.useAuthRequest({
        clientId: GOOGLE_CLIENT_ID_WEB,
        iosClientId: GOOGLE_CLIENT_ID_IOS,
        androidClientId: GOOGLE_CLIENT_ID_ANDROID,
        // FORCE the proxy URL that you registered in Google Cloud
        redirectUri: 'https://auth.expo.io/@periclesngon/skillswapp',
        scopes: ['profile', 'email'],
    });

    return { request, response, promptAsync };
}

class GoogleAuthService {
    /**
     * Handle Google OAuth response and authenticate with backend
     */
    async handleGoogleResponse(response: any): Promise<AuthResponse | null> {
        // Log to help debug
        console.log('Google Auth Response:', JSON.stringify(response, null, 2));

        if (response?.type === 'success') {
            const { authentication } = response;

            if (authentication?.accessToken) {
                try {
                    // Send Google access token to backend
                    const result = await apiService.post<AuthResponse>(
                        API_ENDPOINTS.GOOGLE_AUTH,
                        {
                            accessToken: authentication.accessToken,
                            idToken: authentication.idToken,
                        }
                    );

                    if (result.success && result.data) {
                        // Save tokens and user data
                        await storageService.saveTokens(
                            result.data.accessToken,
                            result.data.refreshToken
                        );
                        await storageService.saveUser(result.data.user);

                        return result.data;
                    }
                } catch (error: any) {
                    console.error('Google auth backend error:', error);
                    throw new Error(error.message || 'Google authentication failed');
                }
            }
        }

        return null;
    }
}

export const googleAuthService = new GoogleAuthService();

