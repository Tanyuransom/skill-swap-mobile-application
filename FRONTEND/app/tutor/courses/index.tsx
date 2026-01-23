/**
 * My Courses Screen (Tutor)
 * List of courses created by the tutor
 */

import { useState, useCallback } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
    useColorScheme,
    Image,
    Alert,
} from 'react-native';
import { useRouter, useFocusEffect } from 'expo-router';
import { Plus, DotsThree, Users } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { tutorCourseService } from '@/services/tutor-course.service';
import type { Course } from '@/services/course.service';
import { Loading } from '@/components/Loading';
import { EmptyState } from '@/components/EmptyState';

export default function MyCoursesScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [courses, setCourses] = useState<Course[]>([]);
    const [loading, setLoading] = useState(true);

    useFocusEffect(
        useCallback(() => {
            loadCourses();
        }, [])
    );

    const loadCourses = async () => {
        try {
            setLoading(true);
            const data = await tutorCourseService.getMyCourses();
            setCourses(data);
        } catch (error) {
            console.error('Failed to load courses:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleCreateCourse = () => {
        router.push('/tutor/courses/create' as any);
    };

    const handleEditCourse = (courseId: string) => {
        router.push(`/tutor/courses/${courseId}/manage` as any);
    };

    const handleDeleteCourse = (course: Course) => {
        Alert.alert(
            'Delete Course',
            `Are you sure you want to delete "${course.title}"? This cannot be undone.`,
            [
                { text: 'Cancel', style: 'cancel' },
                {
                    text: 'Delete',
                    style: 'destructive',
                    onPress: async () => {
                        try {
                            await tutorCourseService.deleteCourse(course.id);
                            setCourses(prev => prev.filter(c => c.id !== course.id));
                        } catch (error) {
                            Alert.alert('Error', 'Failed to delete course');
                        }
                    }
                }
            ]
        );
    };

    const renderCourse = ({ item }: { item: Course }) => (
        <TouchableOpacity
            style={[styles.courseCard, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}
            onPress={() => handleEditCourse(item.id)}
        >
            <Image
                source={{ uri: item.thumbnailUrl || 'https://via.placeholder.com/150' }}
                style={styles.thumbnail}
            />
            <View style={styles.content}>
                <View style={styles.header}>
                    <Text style={[typography.h4, styles.title, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]} numberOfLines={1}>
                        {item.title}
                    </Text>
                    <View style={[styles.statusBadge, {
                        backgroundColor: item.isPublished ? '#DEF7EC' : '#F3F4F6'
                    }]}>
                        <Text style={[typography.caption, {
                            color: item.isPublished ? '#03543F' : '#6B7280',
                            fontWeight: '600'
                        }]}>
                            {item.isPublished ? 'Published' : 'Draft'}
                        </Text>
                    </View>
                </View>

                <Text style={[typography.body, styles.price, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    {item.price === 0 ? 'Free' : `${item.price} ${item.currency}`}
                </Text>

                <View style={styles.footer}>
                    <View style={styles.stat}>
                        <Users size={16} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                        <Text style={[typography.caption, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            0 Students
                        </Text>
                    </View>
                    <TouchableOpacity onPress={() => handleDeleteCourse(item)}>
                        <DotsThree size={24} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                    </TouchableOpacity>
                </View>
            </View>
        </TouchableOpacity>
    );

    if (loading) {
        return <Loading fullScreen />;
    }

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.headerBar}>
                <Text style={[typography.h2, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    My Courses
                </Text>
                <TouchableOpacity
                    style={[styles.createButton, {
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                    }]}
                    onPress={handleCreateCourse}
                >
                    <Plus size={20} color="#fff" weight="bold" />
                    <Text style={[typography.button, { color: '#fff', marginLeft: 4 }]}>
                        Create
                    </Text>
                </TouchableOpacity>
            </View>

            {courses.length === 0 ? (
                <EmptyState
                    icon="course"
                    title="No courses yet"
                    message="Create your first course to start teaching!"
                    actionLabel="Create Course"
                    onAction={handleCreateCourse}
                />
            ) : (
                <FlatList
                    data={courses}
                    renderItem={renderCourse}
                    keyExtractor={(item) => item.id}
                    contentContainerStyle={styles.list}
                />
            )}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    headerBar: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    createButton: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: spacing.md,
        paddingVertical: spacing.sm,
        borderRadius: radius.full,
    },
    list: {
        padding: spacing.md,
        gap: spacing.md,
    },
    courseCard: {
        flexDirection: 'row',
        borderRadius: radius.lg,
        overflow: 'hidden',
        height: 120,
    },
    thumbnail: {
        width: 120,
        height: '100%',
    },
    content: {
        flex: 1,
        padding: spacing.md,
        justifyContent: 'space-between',
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
    },
    title: {
        flex: 1,
        marginRight: spacing.sm,
    },
    price: {
        fontWeight: '700',
    },
    statusBadge: {
        paddingHorizontal: 8,
        paddingVertical: 2,
        borderRadius: radius.sm,
    },
    footer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    stat: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 4,
    },
});
