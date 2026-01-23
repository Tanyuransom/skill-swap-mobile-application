/**
 * Pending Approval Screen
 * Waiting for admin to review certificate
 */

import { View, Text, StyleSheet, useColorScheme } from 'react-native';
import { useRouter } from 'expo-router';
import { Clock, CheckCircle } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';

export default function PendingApprovalScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            <View style={styles.content}>
                {/* Icon */}
                <View style={[styles.iconContainer, { backgroundColor: '#FEF3C7' }]}>
                    <Clock size={64} color="#F59E0B" weight="fill" />
                </View>

                {/* Title */}
                <Text style={[typography.h1, styles.title, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Under Review
                </Text>

                {/* Description */}
                <Text style={[typography.body, styles.description, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    Your certificate has been submitted and is currently being reviewed by our admin team.
                </Text>

                {/* Info Card */}
                <View style={[styles.infoCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <View style={styles.infoRow}>
                        <CheckCircle size={20} color="#10B981" weight="fill" />
                        <Text style={[typography.body, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            marginLeft: spacing.sm
                        }]}>
                            Certificate uploaded successfully
                        </Text>
                    </View>
                    <View style={styles.infoRow}>
                        <Clock size={20} color="#F59E0B" weight="fill" />
                        <Text style={[typography.body, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            marginLeft: spacing.sm
                        }]}>
                            Review time: 24-48 hours
                        </Text>
                    </View>
                </View>

                {/* Next Steps */}
                <View style={[styles.stepsCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <Text style={[typography.bodyMedium, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginBottom: spacing.md
                    }]}>
                        What happens next?
                    </Text>
                    <Text style={[typography.body, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        lineHeight: 24
                    }]}>
                        1. Admin reviews your certificate{'\n'}
                        2. If approved, you'll take an AI-generated quiz{'\n'}
                        3. Pass the quiz (≥70%) to get verified{'\n'}
                        4. Receive your verification badge
                    </Text>
                </View>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    content: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        padding: spacing.xl,
    },
    iconContainer: {
        width: 120,
        height: 120,
        borderRadius: 60,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: spacing.xl,
    },
    title: {
        marginBottom: spacing.md,
        textAlign: 'center',
    },
    description: {
        textAlign: 'center',
        marginBottom: spacing.xl,
        lineHeight: 24,
        maxWidth: 300,
    },
    infoCard: {
        width: '100%',
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.lg,
        gap: spacing.md,
    },
    infoRow: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    stepsCard: {
        width: '100%',
        padding: spacing.md,
        borderRadius: radius.lg,
    },
});
