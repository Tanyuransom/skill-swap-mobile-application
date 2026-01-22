/**
 * AppCard Component
 * 
 * Professional card component following ANTI-GRAVITY UI Constitution
 * Translated from Flutter app_card.dart
 */

import React, { ReactNode } from 'react';
import { View, StyleSheet, ViewStyle, Pressable } from 'react-native';
import Animated, {
    useSharedValue,
    useAnimatedStyle,
    withTiming,
    Easing,
} from 'react-native-reanimated';
import { AppColors } from '@/theme/colors';
import { radius, shadows } from '@/theme/radius';
import { spacing } from '@/theme/spacing';

interface AppCardProps {
    children: ReactNode;
    onPress?: () => void;
    padding?: keyof typeof spacing;
    elevation?: 'small' | 'medium' | 'large';
    style?: ViewStyle;
    isDark?: boolean;
}

export function AppCard({
    children,
    onPress,
    padding = 'md',
    elevation = 'small',
    style,
    isDark = false,
}: AppCardProps) {
    const scale = useSharedValue(1);

    const animatedStyle = useAnimatedStyle(() => ({
        transform: [{ scale: scale.value }],
    }));

    const handlePressIn = () => {
        scale.value = withTiming(0.98, {
            duration: 150,
            easing: Easing.bezier(0.33, 1, 0.68, 1),
        });
    };

    const handlePressOut = () => {
        scale.value = withTiming(1, {
            duration: 150,
            easing: Easing.bezier(0.33, 1, 0.68, 1),
        });
    };

    const cardStyle = [
        styles.card,
        {
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderRadius: radius.large,
            padding: spacing[padding],
            ...shadows[elevation],
        },
        style,
    ];

    if (onPress) {
        return (
            <Animated.View style={animatedStyle}>
                <Pressable
                    onPress={onPress}
                    onPressIn={handlePressIn}
                    onPressOut={handlePressOut}
                    style={cardStyle}
                >
                    {children}
                </Pressable>
            </Animated.View>
        );
    }

    return <View style={cardStyle}>{children}</View>;
}

const styles = StyleSheet.create({
    card: {
        overflow: 'hidden',
    },
});
