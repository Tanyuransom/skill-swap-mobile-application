/**
 * Splash Screen / Root Index
 * 
 * Auto-redirects based on auth status
 */

import { useEffect, useState } from 'react';
import { View, Image, ActivityIndicator, StyleSheet, useColorScheme, Animated } from 'react-native';
import { useRouter } from 'expo-router';
import { AppColors } from '@/theme/colors';
import { useAuth } from '@/hooks/useAuth';

export default function Index() {
    const router = useRouter();
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const { isAuthenticated, isLoading } = useAuth();

    const [fadeAnim] = useState(new Animated.Value(0));

    useEffect(() => {
        // Start fade in animation
        Animated.timing(fadeAnim, {
            toValue: 1,
            duration: 800,
            useNativeDriver: true,
        }).start();

        // Auto-redirect after auth check completes
        if (!isLoading) {
            const timer = setTimeout(() => {
                if (isAuthenticated) {
                    router.replace('/(tabs)/feed');
                } else {
                    router.replace('/auth/login');
                }
            }, 1500);

            return () => clearTimeout(timer);
        }
    }, [isLoading, isAuthenticated]);

    return (
        <View style={[
            styles.container,
            { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }
        ]}>
            <Animated.View style={{ opacity: fadeAnim }}>
                <Image
                    source={require('../assets/images/skillswap_logo.png')}
                    style={styles.logo}
                    resizeMode="contain"
                />
            </Animated.View>

            <Animated.View style={[styles.loader, { opacity: fadeAnim }]}>
                <ActivityIndicator
                    size="small"
                    color={isDark ? AppColors.primaryDarkMode : AppColors.primary}
                />
            </Animated.View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    logo: {
        width: 280,
        height: 280,
    },
    loader: {
        marginTop: 48,
    },
});
