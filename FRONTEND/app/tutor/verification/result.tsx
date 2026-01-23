/**
 * Verification Result Screen
 * Pass/Fail status and Badge display
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    Image,
    useColorScheme,
    ScrollView,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { CheckCircle, XCircle, House, ArrowRight } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { verificationService, type VerificationResult } from '@/services/verification.service';
import { Loading } from '@/components/Loading';

export default function ResultScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { requestId } = useLocalSearchParams<{ requestId: string }>();

    const [loading, setLoading] = useState(true);
    const [result, setResult] = useState<VerificationResult | null>(null);

    useEffect(() => {
        if (requestId) {
            loadResult();
        }
    }, [requestId]);

    const loadResult = async () => {
        try {
            setLoading(true);
            const data = await verificationService.getResult(requestId!);
            setResult(data);
        } catch (error) {
            console.error('Failed to load result:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleContinue = () => {
        router.replace('/tutor/dashboard' as any);
    };

    const handleRetry = () => {
        // In a real app, logic to allow retry after cooldown
        router.replace('/tutor/verification/start' as any);
    };

    if (loading || !result) {
        return <Loading fullScreen />;
    }

    return (
        <ScrollView contentContainerStyle={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            <View style={styles.content}>
                {/* Result Icon */}
                <View style={[styles.iconContainer, {
                    backgroundColor: result.passed ? '#DEF7EC' : '#FDE8E8'
                }]}>
                    {result.passed ? (
                        <CheckCircle size={64} color="#03543F" weight="fill" />
                    ) : (
                        <XCircle size={64} color="#9B1C1C" weight="fill" />
                    )}
                </View>

                {/* Title */}
                <Text style={[typography.h1, styles.title, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    {result.passed ? 'Certified!' : 'Not Passed'}
                </Text>

                {/* Description */}
                <Text style={[typography.body, styles.description, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    {result.passed
                        ? `Congratulations! You scored ${result.score}%. You have earned the ${result.badgeLevel} badge.`
                        : `You scored ${result.score}%. You need 70% to pass. Review the material and try again later.`
                    }
                </Text>

                {/* Badge Display (if passed) */}
                {result.passed && result.badgeLevel && (
                    <View style={[styles.badgeCard, {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                        borderColor: getBadgeColor(result.badgeLevel),
                    }]}>
                        <View style={[styles.badgeIcon, { backgroundColor: getBadgeColor(result.badgeLevel) }]}>
                            <Text style={styles.badgeInitial}>{result.badgeLevel[0].toUpperCase()}</Text>
                        </View>
                        <View>
                            <Text style={[typography.h3, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}>
                                {capitalize(result.badgeLevel)} Tutor
                            </Text>
                            <Text style={[typography.caption, {
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                            }]}>
                                Officially Verified
                            </Text>
                        </View>
                    </View>
                )}

                {/* Feedback */}
                {result.feedback && (
                    <View style={[styles.feedbackContainer, {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                    }]}>
                        <Text style={[typography.bodyMedium, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            marginBottom: spacing.xs,
                        }]}>
                            Feedback
                        </Text>
                        <Text style={[typography.body, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            {result.feedback}
                        </Text>
                    </View>
                )}
            </View>

            {/* Actions */}
            <View style={styles.footer}>
                <TouchableOpacity
                    style={[styles.primaryButton, {
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                    }]}
                    onPress={handleContinue}
                >
                    <Text style={[typography.button, { color: '#fff' }]}>
                        Go to Dashboard
                    </Text>
                    <ArrowRight size={20} color="#fff" weight="bold" style={{ marginLeft: spacing.sm }} />
                </TouchableOpacity>

                {!result.passed && (
                    <TouchableOpacity
                        style={styles.textButton}
                        onPress={handleRetry}
                    >
                        <Text style={[typography.button, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            Try Again
                        </Text>
                    </TouchableOpacity>
                )}
            </View>
        </ScrollView>
    );
}

function getBadgeColor(level: string): string {
    switch (level) {
        case 'bronze': return '#CD7F32';
        case 'silver': return '#C0C0C0';
        case 'gold': return '#FFD700';
        case 'platinum': return '#E5E4E2';
        default: return '#CD7F32';
    }
}

function capitalize(str: string): string {
    return str.charAt(0).toUpperCase() + str.slice(1);
}

const styles = StyleSheet.create({
    container: {
        flexGrow: 1,
        justifyContent: 'center',
        padding: spacing.xl,
    },
    content: {
        alignItems: 'center',
        flex: 1,
        justifyContent: 'center',
    },
    iconContainer: {
        width: 96,
        height: 96,
        borderRadius: 48,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: spacing.lg,
    },
    title: {
        marginBottom: spacing.sm,
        textAlign: 'center',
    },
    description: {
        textAlign: 'center',
        marginBottom: spacing.xl,
        lineHeight: 24,
    },
    badgeCard: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: spacing.md,
        borderRadius: radius.lg,
        borderWidth: 2,
        width: '100%',
        marginBottom: spacing.xl,
    },
    badgeIcon: {
        width: 48,
        height: 48,
        borderRadius: 24,
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: spacing.md,
    },
    badgeInitial: {
        color: '#fff',
        fontSize: 24,
        fontWeight: 'bold',
    },
    feedbackContainer: {
        width: '100%',
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.xl,
    },
    footer: {
        width: '100%',
        gap: spacing.md,
    },
    primaryButton: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        padding: spacing.md,
        borderRadius: radius.lg,
    },
    textButton: {
        padding: spacing.md,
        alignItems: 'center',
    },
});
