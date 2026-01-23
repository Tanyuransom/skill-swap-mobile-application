/**
 * Courses Screen
 * Modern course catalog with search
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
    TextInput,
    useColorScheme,
    Image,
} from 'react-native';
import { useRouter } from 'expo-router';
import { MagnifyingGlass, Clock, TrendUp } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { courseService, type Course } from '@/services/course.service';
import { Loading } from '@/components/Loading';
import { EmptyState } from '@/components/EmptyState';

export default function CoursesScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [loading, setLoading] = useState(true);
    const [courses, setCourses] = useState<Course[]>([]);
    const [searchQuery, setSearchQuery] = useState('');
    const [searching, setSearching] = useState(false);

    useEffect(() => {
        loadCourses();
    }, []);

    const loadCourses = async () => {
        try {
            setLoading(true);
            const data = await courseService.getAllCourses();
            setCourses(data);
        } catch (error) {
            console.error('Failed to load courses:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleSearch = async (query: string) => {
        setSearchQuery(query);

        if (!query.trim()) {
            loadCourses();
            return;
        }

        try {
            setSearching(true);
            const results = await courseService.searchCourses(query);
            setCourses(results);
        } catch (error) {
            console.error('Search failed:', error);
        } finally {
            setSearching(false);
        }
    };

    const renderCourse = ({ item }: { item: Course }) => (
        <TouchableOpacity
            style={[styles.courseCard, { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}
            onPress={() => router.push(`/courses/${item.id}` as any)}
        >
            {item.thumbnailUrl ? (
                <Image source={{ uri: item.thumbnailUrl }} style={styles.thumbnail} />
            ) : (
                <View style={[styles.thumbnail, styles.placeholderThumbnail, {
                    backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                }]} />
            )}

            <View style={styles.courseInfo}>
                <Text style={[typography.h4, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]} numberOfLines={2}>
                    {item.title}
                </Text>

                <Text style={[typography.body, styles.description, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]} numberOfLines={2}>
                    {item.description}
                </Text>

                <View style={styles.meta}>
                    {item.difficultyLevel && (
                        <View style={[styles.badge, {
                            backgroundColor: getDifficultyColor(item.difficultyLevel, isDark)
                        }]}>
                            <TrendUp size={12} color="#fff" weight="bold" />
                            <Text style={[typography.caption, styles.badgeText]}>
                                {item.difficultyLevel}
                            </Text>
                        </View>
                    )}

                    {item.durationHours && (
                        <View style={styles.duration}>
                            <Clock size={14} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                            <Text style={[typography.caption, {
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                marginLeft: 4,
                            }]}>
                                {item.durationHours}h
                            </Text>
                        </View>
                    )}
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
            <View style={styles.header}>
                <Text style={[typography.h1, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                    Courses
                </Text>
            </View>

            {/* Search */}
            <View style={[styles.searchContainer, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}>
                <MagnifyingGlass size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                <TextInput
                    style={[styles.searchInput, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}
                    placeholder="Search courses..."
                    placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                    value={searchQuery}
                    onChangeText={handleSearch}
                />
            </View>

            {/* Course List */}
            {courses.length === 0 ? (
                <EmptyState
                    icon="courses"
                    title="No courses found"
                    message={searchQuery ? "Try a different search term" : "No courses available yet"}
                />
            ) : (
                <FlatList
                    data={courses}
                    renderItem={renderCourse}
                    keyExtractor={(item) => item.id}
                    contentContainerStyle={styles.list}
                    showsVerticalScrollIndicator={false}
                />
            )}
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
    header: {
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        marginHorizontal: spacing.md,
        marginBottom: spacing.md,
        paddingHorizontal: spacing.md,
        borderRadius: radius.lg,
        height: 48,
    },
    searchInput: {
        flex: 1,
        marginLeft: spacing.sm,
        fontSize: 16,
    },
    list: {
        padding: spacing.md,
    },
    courseCard: {
        borderRadius: radius.lg,
        marginBottom: spacing.md,
        overflow: 'hidden',
        elevation: 2,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 8,
    },
    thumbnail: {
        width: '100%',
        height: 180,
    },
    placeholderThumbnail: {
        justifyContent: 'center',
        alignItems: 'center',
    },
    courseInfo: {
        padding: spacing.md,
    },
    description: {
        marginTop: spacing.xs,
    },
    meta: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: spacing.sm,
        gap: spacing.sm,
    },
    badge: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: spacing.sm,
        paddingVertical: 4,
        borderRadius: radius.sm,
        gap: 4,
    },
    badgeText: {
        color: '#fff',
        fontSize: 11,
        fontWeight: '600',
        textTransform: 'capitalize',
    },
    duration: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    price: {
        marginTop: spacing.sm,
    },
});
