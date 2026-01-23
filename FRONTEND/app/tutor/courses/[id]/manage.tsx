/**
 * Manage Course Screen
 * Add/edit modules and lessons
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    TextInput,
    useColorScheme,
    Alert,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { ArrowLeft, Plus, Trash, PlayCircle } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { courseService, type Course } from '@/services/course.service';
import { tutorCourseService } from '@/services/tutor-course.service';
import { Loading } from '@/components/Loading';

export default function ManageCourseScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { id } = useLocalSearchParams<{ id: string }>();

    const [loading, setLoading] = useState(true);
    const [course, setCourse] = useState<Course | null>(null);
    const [showModuleForm, setShowModuleForm] = useState(false);
    const [newModuleTitle, setNewModuleTitle] = useState('');

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
        } finally {
            setLoading(false);
        }
    };

    const handleAddModule = async () => {
        if (!newModuleTitle.trim()) return;

        try {
            await tutorCourseService.addModule(id!, {
                title: newModuleTitle,
                orderIndex: (course?.modules?.length || 0) + 1,
            });
            setNewModuleTitle('');
            setShowModuleForm(false);
            loadCourse(); // Reload to get updated modules
        } catch (error) {
            console.error('Failed to add module:', error);
            Alert.alert('Error', 'Failed to add module');
        }
    };

    const handlePublish = async () => {
        try {
            await tutorCourseService.updateCourse(id!, { isPublished: true });
            Alert.alert('Success', 'Course published!');
            loadCourse();
        } catch (error) {
            Alert.alert('Error', 'Failed to publish course');
        }
    };

    if (loading || !course) {
        return <Loading fullScreen />;
    }

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.header}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
                    <ArrowLeft size={24} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                </TouchableOpacity>
                <Text style={[typography.h3, styles.headerTitle, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]} numberOfLines={1}>
                    {course.title}
                </Text>
                <View style={{ width: 24 }} />
            </View>

            <ScrollView contentContainerStyle={styles.content}>
                {/* Course Info Card */}
                <View style={[styles.infoCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <View style={styles.infoRow}>
                        <Text style={[typography.body, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            Status
                        </Text>
                        <View style={[styles.statusBadge, {
                            backgroundColor: course.isPublished ? '#DEF7EC' : '#F3F4F6'
                        }]}>
                            <Text style={[typography.caption, {
                                color: course.isPublished ? '#03543F' : '#6B7280',
                                fontWeight: '600'
                            }]}>
                                {course.isPublished ? 'Published' : 'Draft'}
                            </Text>
                        </View>
                    </View>
                    <View style={styles.infoRow}>
                        <Text style={[typography.body, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            Modules
                        </Text>
                        <Text style={[typography.bodyMedium, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                        }]}>
                            {course.modules?.length || 0}
                        </Text>
                    </View>
                </View>

                {/* Modules Section */}
                <View style={styles.section}>
                    <View style={styles.sectionHeader}>
                        <Text style={[typography.title, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                        }]}>
                            Course Content
                        </Text>
                        <TouchableOpacity
                            style={[styles.addButton, {
                                backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                            }]}
                            onPress={() => setShowModuleForm(true)}
                        >
                            <Plus size={16} color="#fff" weight="bold" />
                            <Text style={[typography.caption, { color: '#fff', marginLeft: 4, fontWeight: '600' }]}>
                                Module
                            </Text>
                        </TouchableOpacity>
                    </View>

                    {/* Add Module Form */}
                    {showModuleForm && (
                        <View style={[styles.moduleForm, {
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                        }]}>
                            <TextInput
                                style={[styles.input, {
                                    backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                }]}
                                placeholder="Module title (e.g., Introduction to React)"
                                placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                                value={newModuleTitle}
                                onChangeText={setNewModuleTitle}
                                autoFocus
                            />
                            <View style={styles.formActions}>
                                <TouchableOpacity
                                    style={styles.textButton}
                                    onPress={() => {
                                        setShowModuleForm(false);
                                        setNewModuleTitle('');
                                    }}
                                >
                                    <Text style={[typography.button, {
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                                    }]}>
                                        Cancel
                                    </Text>
                                </TouchableOpacity>
                                <TouchableOpacity
                                    style={[styles.primaryButton, {
                                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                                    }]}
                                    onPress={handleAddModule}
                                >
                                    <Text style={[typography.button, { color: '#fff' }]}>
                                        Add Module
                                    </Text>
                                </TouchableOpacity>
                            </View>
                        </View>
                    )}

                    {/* Modules List */}
                    {course.modules && course.modules.length > 0 ? (
                        course.modules.map((module: any, index: number) => (
                            <View key={module.id} style={[styles.moduleCard, {
                                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                            }]}>
                                <View style={styles.moduleHeader}>
                                    <Text style={[typography.h4, {
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                                    }]}>
                                        {index + 1}. {module.title}
                                    </Text>
                                    <TouchableOpacity>
                                        <Trash size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                                    </TouchableOpacity>
                                </View>
                                <Text style={[typography.caption, {
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                    marginTop: spacing.xs
                                }]}>
                                    {module.lessons?.length || 0} lessons
                                </Text>
                                <TouchableOpacity style={styles.addLessonButton}>
                                    <PlayCircle size={16} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                                    <Text style={[typography.caption, {
                                        color: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                                        marginLeft: 4,
                                        fontWeight: '600'
                                    }]}>
                                        Add Lesson
                                    </Text>
                                </TouchableOpacity>
                            </View>
                        ))
                    ) : (
                        <Text style={[typography.body, styles.emptyText, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            No modules yet. Add your first module to get started.
                        </Text>
                    )}
                </View>

                {/* Publish Button */}
                {!course.isPublished && (
                    <TouchableOpacity
                        style={[styles.publishButton, {
                            backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                        }]}
                        onPress={handlePublish}
                    >
                        <Text style={[typography.button, { color: '#fff' }]}>
                            Publish Course
                        </Text>
                    </TouchableOpacity>
                )}
            </ScrollView>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    backButton: {
        padding: 4,
    },
    headerTitle: {
        flex: 1,
        marginHorizontal: spacing.md,
    },
    content: {
        padding: spacing.md,
        paddingBottom: spacing.xxl,
    },
    infoCard: {
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.lg,
        gap: spacing.sm,
    },
    infoRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    statusBadge: {
        paddingHorizontal: 8,
        paddingVertical: 2,
        borderRadius: radius.sm,
    },
    section: {
        marginBottom: spacing.xl,
    },
    sectionHeader: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: spacing.md,
    },
    addButton: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: spacing.md,
        paddingVertical: spacing.xs,
        borderRadius: radius.full,
    },
    moduleForm: {
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.md,
    },
    input: {
        borderRadius: radius.lg,
        padding: spacing.md,
        fontSize: 16,
        marginBottom: spacing.md,
    },
    formActions: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        gap: spacing.sm,
    },
    textButton: {
        padding: spacing.sm,
    },
    primaryButton: {
        paddingHorizontal: spacing.md,
        paddingVertical: spacing.sm,
        borderRadius: radius.lg,
    },
    moduleCard: {
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.sm,
    },
    moduleHeader: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
    },
    addLessonButton: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: spacing.md,
    },
    emptyText: {
        textAlign: 'center',
        padding: spacing.xl,
    },
    publishButton: {
        padding: spacing.md,
        borderRadius: radius.lg,
        alignItems: 'center',
        marginTop: spacing.lg,
    },
});
