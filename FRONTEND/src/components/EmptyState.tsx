/**
 * Empty State Component
 * Modern empty state with icon and message
 */

import { View, Text, StyleSheet, useColorScheme } from 'react-native';
import { MagnifyingGlass, BookOpen, ChatCircle, Bell } from 'phosphor-react-native';
import { AppColors } from '../theme/colors';
import { typography } from '../theme/typography';
import { spacing } from '../theme/spacing';

interface EmptyStateProps {
    icon?: 'search' | 'courses' | 'messages' | 'notifications';
    title: string;
    message: string;
}

export function EmptyState({ icon = 'search', title, message }: EmptyStateProps) {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';

    const iconColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    const IconComponent = {
        search: MagnifyingGlass,
        courses: BookOpen,
        messages: ChatCircle,
        notifications: Bell,
    }[icon];

    return (
        <View style={styles.container}>
            <IconComponent size={64} color={iconColor} weight="light" />
            <Text style={[
                typography.h3,
                styles.title,
                { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }
            ]}>
                {title}
            </Text>
            <Text style={[
                typography.body,
                styles.message,
                { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }
            ]}>
                {message}
            </Text>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        padding: spacing.xl,
    },
    title: {
        marginTop: spacing.md,
        textAlign: 'center',
    },
    message: {
        marginTop: spacing.xs,
        textAlign: 'center',
        maxWidth: 280,
    },
});
