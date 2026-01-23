/**
 * Feed Tab Screen
 * 
 * Translated from Flutter feed_screen.dart
 */

import { View, Text, StyleSheet, useColorScheme } from 'react-native';
import { AppColors } from '../src/theme/colors';
import { typography } from '../src/theme/typography';
import { spacing } from '../src/theme/spacing';

export default function FeedScreen() {
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
                Feed
            </Text>
            <Text style={[
                typography.body,
                { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, marginTop: spacing.sm }
            ]}>
                Social learning feed - To be implemented
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
