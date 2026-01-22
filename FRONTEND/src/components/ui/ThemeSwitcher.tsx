/**
 * ThemeSwitcher Component
 * 
 * Animated theme toggle button
 * Translated from Flutter theme_switcher.dart
 */

import React from 'react';
import { Pressable, StyleSheet, useColorScheme } from 'react-native';
import Animated, {
    useSharedValue,
    useAnimatedStyle,
    withTiming,
    withSequence,
    Easing,
} from 'react-native-reanimated';
import { Moon, Sun } from 'phosphor-react-native';
import { useThemeStore } from '@/store/themeStore';
import { AppColors } from '@/theme/colors';

export function ThemeSwitcher() {
    const colorScheme = useColorScheme();
    const { themeMode, toggleTheme } = useThemeStore();

    const isDark = themeMode === 'system'
        ? colorScheme === 'dark'
        : themeMode === 'dark';

    // Animation values
    const rotation = useSharedValue(0);
    const scale = useSharedValue(1);
    const iconOpacity = useSharedValue(1);

    const animatedStyle = useAnimatedStyle(() => ({
        transform: [
            { rotate: `${rotation.value}deg` },
            { scale: scale.value },
        ],
    }));

    const iconAnimatedStyle = useAnimatedStyle(() => ({
        opacity: iconOpacity.value,
    }));

    const handlePress = async () => {
        // Icon fade out
        iconOpacity.value = withTiming(0, { duration: 150 });

        // Rotation and scale animation
        rotation.value = withSequence(
            withTiming(180, {
                duration: 300,
                easing: Easing.bezier(0.33, 1, 0.68, 1),
            }),
            withTiming(0, { duration: 0 })
        );

        scale.value = withSequence(
            withTiming(0.8, { duration: 150 }),
            withTiming(1, { duration: 150 })
        );

        // Toggle theme
        await toggleTheme();

        // Icon fade in
        setTimeout(() => {
            iconOpacity.value = withTiming(1, { duration: 150 });
        }, 150);
    };

    const iconColor = isDark ? AppColors.primaryDarkMode : AppColors.primary;

    return (
        <Pressable onPress={handlePress} style={styles.container}>
            <Animated.View style={[animatedStyle, styles.iconContainer]}>
                <Animated.View style={iconAnimatedStyle}>
                    {isDark ? (
                        <Moon size={24} color={iconColor} weight="fill" />
                    ) : (
                        <Sun size={24} color={iconColor} weight="fill" />
                    )}
                </Animated.View>
            </Animated.View>
        </Pressable>
    );
}

const styles = StyleSheet.create({
    container: {
        width: 48,
        height: 48,
        justifyContent: 'center',
        alignItems: 'center',
    },
    iconContainer: {
        justifyContent: 'center',
        alignItems: 'center',
    },
});
