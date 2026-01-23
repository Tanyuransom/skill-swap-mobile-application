/**
 * Course Detail Screen
 * Modern course details with enrollment
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    useColorScheme,
    Image,
    Alert,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, Clock, TrendUp, User, Play } from 'phosphor-react-native';
import { AppColors } from '../../src/theme/colors';
import { typography } from '../../src/theme/typography';
import { spacing } from '../../src/theme/spacing';
import { radius } from '../../src/theme/radius';
import { courseService, type Course } from '../../src/services/course.service';
import { learningService } from '../../src/services/learning.service';
import { Loading } from '../../src/components/Loading';

export default function CourseDetailScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { id } = useLocalSearchParams<{ id: string }>();

    const [loading, setLoading] = useState(true);
    const [enrolling, setEnrolling] = useState(false);
    const [course, setCourse] = useState<Course | null>(null);

    useEffect(() => {
        if (id) {
            loadCourse();
        }
    }, [id]);

    const loadCourse = async () => {
        try {
            setLoading(true);
            const data = await courseService.getCourse(id!);
            setCourse(data);
        } catch (error) {
            console.error('Failed to load course:', error);
            Alert.alert('Error', 'Failed to load course details');
        } finally {
            setLoading(false);
        }
    };

    const handleEnroll = async () => {
        try {
            setEnrolling(true);
            await learningService.enrollInCourse(id!);
            Alert.alert('Success', 'Enrolled in course successfully!');
            router.push('/(tabs)/learning');
        } catch (error) {
            console.error('Enrollment failed:', error);
            Alert.alert('Error', 'Failed to enroll in course');
        } finally {
            setEnrolling(false);
        }
    };

    if (loading) {
        return <Loading fullScreen />;
    }

    if (!course) {
        return (
            <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
                <Text style={[typography.body, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                    Course not found
                </Text>
            </View>
        );
    }

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            <ScrollView showsVerticalScrollIndicator={false}>
                {/* Header Image */}
                {course.thumbnailUrl ? (
                    <Image source={{ uri: course.thumbnailUrl }} style={styles.headerImage} />
                ) : (
                    <View style={[styles.headerImage, styles.placeholderImage, {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                    }]}>
                        <Play size={64} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                    </View>
                )}

                {/* Back Button */}
                <TouchableOpacity
                    style={[styles.backButton, { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}
                    onPress={() => router.back()}
                >
                    <ArrowLeft size={24} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                </TouchableOpacity>

                {/* Content */}
                <View style={styles.content}>
                    {/* Title */}
                    <Text style={[typography.h2, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                        {course.title}
                    </Text>

                    {/* Meta Info */}
                    <View style={styles.metaContainer}>
                        {course.difficultyLevel && (
                            <View style={[styles.metaBadge, {
                                backgroundColor: getDifficultyColor(course.difficultyLevel, isDark)
                            }]}>
                                <TrendUp size={14} color="#fff" weight="bold" />
                                <Text style={[typography.caption, styles.metaText]}>
                                    {course.difficultyLevel}
                                </Text>
                            </View>
                        )}

                        {course.durationHours && (
                            <View style={[styles.metaBadge, {
                                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                            }]}>
                                <Clock size={14} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                                <Text style={[typography.caption, {
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                    marginLeft: 4,
                                }]}>
                                    {course.durationHours} hours
                                </Text>
                            </View>
                        )}
                    </View>

                    {/* Description */}
                    <View style={styles.section}>
                        <Text style={[typography.h3, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                            About this course
                        </Text>
                        <Text style={[typography.body, styles.description, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            {course.description}
                        </Text>
                    </View>

                    {/* Instructor */}
                    <View style={[styles.instructorCard, {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                    }]}>
                        <View style={styles.instructorAvatar}>
                            <User size={24} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                        </View>
                        <View style={styles.instructorInfo}>
                            <Text style={[typography.caption, {
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                            }]}>
                                Instructor
                            </Text>
                            <Text style={[typography.h4, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}>
                                Course Instructor
                            </Text>
                        </View>
                    </View>
                </View>
            </ScrollView>

            {/* Enroll Button */}
            <View style={[styles.footer, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}>
                <TouchableOpacity
                    style={[styles.enrollButton, {
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                    }]}
                    onPress={handleEnroll}
                    disabled={enrolling}
                >
                    <Text style={[typography.button, { color: '#fff' }]}>
                        {enrolling ? 'Enrolling...' : 'Start Learning'}
                    </Text>
                </TouchableOpacity>
            </View>
        </View>
    );
}

function getDifficultyColor(level: string, isDark: boolean): string {
    const colors = {
        beginner: '#10B981',
        intermediate: '#F59E0B',
        advanced: '#EF4444',
    };
    return colors[level as keyof typeof colors] || colors.beginner;
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    headerImage: {
        width: '100%',
        height: 280,
    },
    placeholderImage: {
        justifyContent: 'center',
        alignItems: 'center',
    },
    backButton: {
        position: 'absolute',
        top: 48,
        left: spacing.md,
        width: 40,
        height: 40,
        borderRadius: 20,
        justifyContent: 'center',
        alignItems: 'center',
        elevation: 4,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.2,
        shadowRadius: 8,
    },
    content: {
        padding: spacing.md,
    },
    metaContainer: {
        flexDirection: 'row',
        gap: spacing.sm,
        marginTop: spacing.sm,
    },
    metaBadge: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: spacing.sm,
        paddingVertical: 6,
        borderRadius: radius.md,
        gap: 4,
    },
    metaText: {
        color: '#fff',
        fontSize: 12,
        fontWeight: '600',
        textTransform: 'capitalize',
    },
    price: {
        marginTop: spacing.md,
    },
    section: {
        marginTop: spacing.lg,
    },
    description: {
        marginTop: spacing.sm,
        lineHeight: 24,
    },
    instructorCard: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: spacing.md,
        borderRadius: radius.lg,
        marginTop: spacing.lg,
    },
    instructorAvatar: {
        width: 48,
        height: 48,
        borderRadius: 24,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'rgba(0,0,0,0.1)',
    },
    instructorInfo: {
        marginLeft: spacing.sm,
        flex: 1,
    },
    footer: {
        padding: spacing.md,
        borderTopWidth: 1,
        borderTopColor: 'rgba(0,0,0,0.05)',
    },
    enrollButton: {
        borderRadius: radius.lg,
        padding: spacing.md,
        alignItems: 'center',
    },
});
