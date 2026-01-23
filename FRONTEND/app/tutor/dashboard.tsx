/**
 * Tutor Dashboard
 * Main hub for tutors
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    useColorScheme,
} from 'react-native';
import { useRouter } from 'expo-router';
import {
    GraduationCap,
    Users,
    CurrencyDollar,
    Plus,
    CheckCircle,
    TrendUp,
} from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { useAuth } from '@/hooks/useAuth';
import { Loading } from '@/components/Loading';

export default function TutorDashboardScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { user } = useAuth();

    const [loading, setLoading] = useState(true);
    const [stats, setStats] = useState({
        totalCourses: 0,
        totalStudents: 0,
        totalEarnings: 0,
        pendingVerifications: 0,
    });

    useEffect(() => {
        // Redirect if not tutor
        if (user && user.role !== 'tutor') {
            router.replace('/(tabs)/feed' as any);
            return;
        }

        loadDashboard();
    }, [user]);

    const loadDashboard = async () => {
        try {
            setLoading(true);
            // TODO: Load actual stats from API
            setStats({
                totalCourses: 5,
                totalStudents: 127,
                totalEarnings: 45000,
                pendingVerifications: 1,
            });
        } catch (error) {
            console.error('Failed to load dashboard:', error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) {
        return <Loading fullScreen />;
    }

    return (
        <ScrollView style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.header}>
                <Text style={[typography.hero, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Dashboard
                </Text>
                <Text style={[typography.body, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    Welcome back, {user?.firstName}!
                </Text>
            </View>

            {/* Stats Grid */}
            <View style={styles.statsGrid}>
                <View style={[styles.statCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <GraduationCap size={32} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                    <Text style={[typography.h2, styles.statValue, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        {stats.totalCourses}
                    </Text>
                    <Text style={[typography.body, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        Courses
                    </Text>
                </View>

                <View style={[styles.statCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <Users size={32} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                    <Text style={[typography.h2, styles.statValue, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        {stats.totalStudents}
                    </Text>
                    <Text style={[typography.body, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        Students
                    </Text>
                </View>

                <View style={[styles.statCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <CurrencyDollar size={32} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                    <Text style={[typography.h2, styles.statValue, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        {stats.totalEarnings.toLocaleString()}
                    </Text>
                    <Text style={[typography.body, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        XAF Earned
                    </Text>
                </View>
            </View>

            {/* Quick Actions */}
            <View style={styles.section}>
                <Text style={[typography.title, styles.sectionTitle, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Quick Actions
                </Text>

                <TouchableOpacity
                    style={[styles.actionCard, {
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                    }]}
                    onPress={() => router.push('/tutor/courses/create' as any)}
                >
                    <Plus size={24} color="#fff" weight="bold" />
                    <Text style={[typography.bodyMedium, { color: '#fff', marginLeft: spacing.sm }]}>
                        Create New Course
                    </Text>
                </TouchableOpacity>

                {stats.pendingVerifications > 0 && (
                    <TouchableOpacity
                        style={[styles.actionCard, {
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                            borderWidth: 2,
                            borderColor: '#F59E0B',
                        }]}
                        onPress={() => router.push('/tutor/verification/start' as any)}
                    >
                        <CheckCircle size={24} color="#F59E0B" weight="bold" />
                        <Text style={[typography.bodyMedium, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            marginLeft: spacing.sm
                        }]}>
                            Complete Verification
                        </Text>
                    </TouchableOpacity>
                )}

                <TouchableOpacity
                    style={[styles.actionCard, {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                    }]}
                    onPress={() => router.push('/tutor/analytics' as any)}
                >
                    <TrendUp size={24} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                    <Text style={[typography.bodyMedium, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginLeft: spacing.sm
                    }]}>
                        View Analytics
                    </Text>
                </TouchableOpacity>
            </View>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    statsGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        padding: spacing.sm,
        gap: spacing.sm,
    },
    statCard: {
        flex: 1,
        minWidth: '30%',
        padding: spacing.md,
        borderRadius: radius.lg,
        alignItems: 'center',
        gap: spacing.xs,
    },
    statValue: {
        marginTop: spacing.xs,
    },
    section: {
        padding: spacing.md,
    },
    sectionTitle: {
        marginBottom: spacing.md,
    },
    actionCard: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.sm,
    },
});
