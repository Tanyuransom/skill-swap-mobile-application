/**
 * Root Layout
 * 
 * Sets up navigation, theme, and authentication
 */

import { useEffect } from 'react';
import { Stack } from 'expo-router';
import { useColorScheme } from 'react-native';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { useThemeStore } from '@/store/themeStore';
import { AppColors } from '@/theme/colors';
import { AuthProvider } from '@/contexts/AuthContext';

export default function RootLayout() {
    const colorScheme = useColorScheme();
    const { loadTheme, themeMode } = useThemeStore();

    useEffect(() => {
        loadTheme();
    }, []);

    const isDark = themeMode === 'system'
        ? colorScheme === 'dark'
        : themeMode === 'dark';

    return (
        <AuthProvider>
            <GestureHandlerRootView style={{ flex: 1 }}>
                <Stack
                    screenOptions={{
                        headerShown: false,
                        contentStyle: {
                            backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
                        },
                        animation: 'fade',
                    }}
                >
                    <Stack.Screen name="index" />
                    <Stack.Screen name="auth/login" />
                    <Stack.Screen name="auth/register" />
                    <Stack.Screen name="auth/forgot-password" />
                    <Stack.Screen name="auth/verification" />
                    <Stack.Screen name="auth/reset-password" />
                    <Stack.Screen name="(tabs)" />
                </Stack>
            </GestureHandlerRootView>
        </AuthProvider>
    );
}
