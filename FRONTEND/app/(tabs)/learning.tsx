/**
 * Learning Dashboard
 * Shows enrolled courses with progress tracking
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
    useColorScheme,
    Image,
} from 'react-native';
import { useRouter } from 'expo-router';
import { GraduationCap, Clock, CheckCircle } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { learningService, type Enrollment } from '@/services/learning.service';
import { courseService } from '@/services/course.service';
import { Loading } from '@/components/Loading';
import { EmptyState } from '@/components/EmptyState';

interface EnrollmentWithCourse extends Enrollment {
    courseTitle?: string;
    courseThumbnail?: string;
    progress?: {
        totalLessons: number;
        completedLessons: number;
        percentage: number;
    };
}

export default function LearningScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [loading, setLoading] = useState(true);
    const [enrollments, setEnrollments] = useState<EnrollmentWithCourse[]>([]);

    useEffect(() => {
        loadEnrollments();
    }, []);

    const loadEnrollments = async () => {
        try {
            setLoading(true);
            const data = await learningService.getEnrollments();

            // Fetch course details and progress for each enrollment
            const enriched = await Promise.all(
                data.map(async (enrollment) => {
                    try {
                        const [course, progress] = await Promise.all([
                            courseService.getCourse(enrollment.courseId),
                            learningService.getCourseProgress(enrollment.courseId),
                        ]);

                        return {
                            ...enrollment,
                            courseTitle: course.title,
                            courseThumbnail: course.thumbnailUrl,
                            progress,
                        };
                    } catch (error) {
                        console.error('Failed to enrich enrollment:', error);
                        return enrollment;
                    }
                })
            );

            setEnrollments(enriched);
        } catch (error) {
            console.error('Failed to load enrollments:', error);
        } finally {
            setLoading(false);
        }
    };

    const renderEnrollment = ({ item }: { item: EnrollmentWithCourse }) => {
        const progressPercentage = item.progress?.percentage || 0;
        const isCompleted = item.status === 'completed';

        return (
            <TouchableOpacity
                style={[styles.card, { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}
                onPress={() => router.push(`/courses/${item.courseId}` as any)}
            >
                {/* Thumbnail */}
                {item.courseThumbnail ? (
                    <Image source={{ uri: item.courseThumbnail }} style={styles.thumbnail} />
                ) : (
                    <View style={[styles.thumbnail, styles.placeholderThumbnail, {
                        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                    }]}>
                        <GraduationCap size={32} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                    </View>
                )}

                {/* Content */}
                <View style={styles.content}>
                    <Text style={[typography.title, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]} numberOfLines={2}>
                        {item.courseTitle || 'Course'}
                    </Text>

                    {/* Progress Bar */}
                    {item.progress && (
                        <View style={styles.progressSection}>
                            <View style={[styles.progressBar, {
                                backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                            }]}>
                                <View style={[styles.progressFill, {
                                    width: `${progressPercentage}%`,
                                    backgroundColor: isCompleted
                                        ? '#10B981'
                                        : (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                }]} />
                            </View>

                            <View style={styles.progressInfo}>
                                <Text style={[typography.caption, {
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                                }]}>
                                    {item.progress.completedLessons} / {item.progress.totalLessons} lessons
                                </Text>
                                <Text style={[typography.caption, styles.percentage, {
                                    color: isCompleted
                                        ? '#10B981'
                                        : (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                }]}>
                                    {progressPercentage}%
                                </Text>
                            </View>
                        </View>
                    )}

                    {/* Status Badge */}
                    {isCompleted && (
                        <View style={styles.completedBadge}>
                            <CheckCircle size={16} color="#10B981" weight="fill" />
                            <Text style={[typography.caption, styles.completedText]}>
                                Completed
                            </Text>
                        </View>
                    )}

                    {/* Last Accessed */}
                    <View style={styles.meta}>
                        <Clock size={14} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                        <Text style={[typography.caption, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            marginLeft: 4,
                        }]}>
                            Last accessed {formatDate(item.lastAccessed)}
                        </Text>
                    </View>
                </View>
            </TouchableOpacity>
        );
    };

    if (loading) {
        return <Loading fullScreen />;
    }

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.header}>
                <Text style={[typography.hero, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                    My Learning
                </Text>
                <Text style={[typography.body, styles.subtitle, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    {enrollments.length} {enrollments.length === 1 ? 'course' : 'courses'} enrolled
                </Text>
            </View>

            {/* Enrollments List */}
            {enrollments.length === 0 ? (
                <EmptyState
                    icon="courses"
                    title="No courses yet"
                    message="Browse courses and start learning"
                />
            ) : (
                <FlatList
                    data={enrollments}
                    renderItem={renderEnrollment}
                    keyExtractor={(item) => item.id}
                    contentContainerStyle={styles.list}
                    showsVerticalScrollIndicator={false}
                />
            )}
        </View>
    );
}

function formatDate(dateString: string): string {
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

    if (diffDays === 0) return 'today';
    if (diffDays === 1) return 'yesterday';
    if (diffDays < 7) return `${diffDays} days ago`;
    if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`;
    return date.toLocaleDateString();
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        padding: spacing.large,
        paddingTop: spacing.xlarge,
    },
    subtitle: {
        marginTop: spacing.small,
    },
    list: {
        padding: spacing.large,
    },
    card: {
        borderRadius: radius.large,
        marginBottom: spacing.large,
        overflow: 'hidden',
        elevation: 2,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 8,
    },
    thumbnail: {
        width: '100%',
        height: 160,
    },
    placeholderThumbnail: {
        justifyContent: 'center',
        alignItems: 'center',
    },
    content: {
        padding: spacing.large,
    },
    progressSection: {
        marginTop: spacing.medium,
    },
    progressBar: {
        height: 8,
        borderRadius: radius.full,
        overflow: 'hidden',
    },
    progressFill: {
        height: '100%',
        borderRadius: radius.full,
    },
    progressInfo: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginTop: spacing.small,
    },
    percentage: {
        fontWeight: '600',
    },
    completedBadge: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: spacing.small,
        gap: 4,
    },
    completedText: {
        color: '#10B981',
        fontWeight: '600',
    },
    meta: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: spacing.small,
    },
});
