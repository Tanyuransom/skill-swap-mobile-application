/**
 * Profile Tab Screen
 * 
 * Translated from Flutter profile_screen.dart
 */

import { View, Text, StyleSheet, useColorScheme } from 'react-native';
import { AppColors } from '../src/theme/colors';
import { typography } from '../src/theme/typography';
import { spacing } from '../src/theme/spacing';

export default function ProfileScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';

    return (
        <View style={[
            styles.container,
            { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }
        ]}>
            <Text style={[
                typography.title,
                { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }
            ]}>
                Profile
            </Text>
            <Text style={[
                typography.body,
                { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, marginTop: spacing.sm }
            ]}>
                User profile & settings - To be implemented
            </Text>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
});
