/**
 * Universal Loading Component
 * Modern loading animation used across the app
 */

import { View, ActivityIndicator, StyleSheet, useColorScheme } from 'react-native';
import { AppColors } from '../theme/colors';

interface LoadingProps {
    size?: 'small' | 'large';
    fullScreen?: boolean;
}

export function Loading({ size = 'large', fullScreen = false }: LoadingProps) {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';

    const backgroundColor = isDark ? AppColors.backgroundDark : AppColors.background;
    const color = isDark ? AppColors.primaryDarkMode : AppColors.primary;

    if (fullScreen) {
        return (
            <View style={[styles.fullScreen, { backgroundColor }]}>
                <ActivityIndicator size={size} color={color} />
            </View>
        );
    }

    return <ActivityIndicator size={size} color={color} />;
}

const styles = StyleSheet.create({
    fullScreen: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
});
