/**
 * Analytics Dashboard (Tutor)
 * View course performance and earnings metrics
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    useColorScheme,
} from 'react-native';
import { TrendUp, Users, Eye, GraduationCap } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { Loading } from '@/components/Loading';

export default function AnalyticsScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';

    const [loading, setLoading] = useState(true);
    const [analytics, setAnalytics] = useState({
        totalViews: 12450,
        totalEnrollments: 342,
        completionRate: 68,
        totalRevenue: 125000,
        topCourses: [
            { id: '1', title: 'Web Development Bootcamp', enrollments: 156, revenue: 45000 },
            { id: '2', title: 'React Native Masterclass', enrollments: 98, revenue: 32000 },
            { id: '3', title: 'UI/UX Design Fundamentals', enrollments: 88, revenue: 28000 },
        ],
    });

    useEffect(() => {
        loadAnalytics();
    }, []);

    const loadAnalytics = async () => {
        try {
            setLoading(true);
            // TODO: Load from analytics service
            setTimeout(() => setLoading(false), 500);
        } catch (error) {
            console.error('Failed to load analytics:', error);
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
                    Analytics
                </Text>
                <Text style={[typography.body, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    Last 30 days
                </Text>
            </View>

            {/* Key Metrics */}
            <View style={styles.metricsGrid}>
                <View style={[styles.metricCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <Eye size={24} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                    <Text style={[typography.h2, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginTop: spacing.sm
                    }]}>
                        {analytics.totalViews.toLocaleString()}
                    </Text>
                    <Text style={[typography.caption, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        Total Views
                    </Text>
                </View>

                <View style={[styles.metricCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <Users size={24} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                    <Text style={[typography.h2, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginTop: spacing.sm
                    }]}>
                        {analytics.totalEnrollments}
                    </Text>
                    <Text style={[typography.caption, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        Enrollments
                    </Text>
                </View>

                <View style={[styles.metricCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <GraduationCap size={24} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                    <Text style={[typography.h2, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginTop: spacing.sm
                    }]}>
                        {analytics.completionRate}%
                    </Text>
                    <Text style={[typography.caption, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        Completion Rate
                    </Text>
                </View>

                <View style={[styles.metricCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <TrendUp size={24} color="#10B981" />
                    <Text style={[typography.h2, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginTop: spacing.sm
                    }]}>
                        {analytics.totalRevenue.toLocaleString()}
                    </Text>
                    <Text style={[typography.caption, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        Revenue (XAF)
                    </Text>
                </View>
            </View>

            {/* Top Courses */}
            <View style={styles.section}>
                <Text style={[typography.title, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    marginBottom: spacing.md
                }]}>
                    Top Performing Courses
                </Text>

                {analytics.topCourses.map((course, index) => (
                    <View
                        key={course.id}
                        style={[styles.courseCard, {
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                        }]}
                    >
                        <View style={styles.courseRank}>
                            <Text style={[typography.h3, {
                                color: isDark ? AppColors.primaryDarkMode : AppColors.primary
                            }]}>
                                #{index + 1}
                            </Text>
                        </View>
                        <View style={styles.courseInfo}>
                            <Text style={[typography.bodyMedium, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}>
                                {course.title}
                            </Text>
                            <View style={styles.courseStats}>
                                <Text style={[typography.caption, {
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                                }]}>
                                    {course.enrollments} students
                                </Text>
                                <Text style={[typography.caption, {
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                                }]}>
                                    •
                                </Text>
                                <Text style={[typography.caption, {
                                    color: '#10B981',
                                    fontWeight: '600'
                                }]}>
                                    {course.revenue.toLocaleString()} XAF
                                </Text>
                            </View>
                        </View>
                    </View>
                ))}
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
    metricsGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        padding: spacing.sm,
        gap: spacing.sm,
    },
    metricCard: {
        flex: 1,
        minWidth: '47%',
        padding: spacing.md,
        borderRadius: radius.lg,
        alignItems: 'center',
    },
    section: {
        padding: spacing.md,
    },
    courseCard: {
        flexDirection: 'row',
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.sm,
        alignItems: 'center',
    },
    courseRank: {
        marginRight: spacing.md,
    },
    courseInfo: {
        flex: 1,
    },
    courseStats: {
        flexDirection: 'row',
        gap: spacing.xs,
        marginTop: spacing.xs,
    },
});
