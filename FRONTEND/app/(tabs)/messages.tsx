/**
 * Messages Tab Screen
 * 
 * Translated from Flutter messages_screen.dart
 */

import { View, Text, StyleSheet, useColorScheme } from 'react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';

export default function MessagesScreen() {
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
                Messages
            </Text>
            <Text style={[
                typography.body,
                { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, marginTop: spacing.sm }
            ]}>
                Real-time messaging - To be implemented
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
