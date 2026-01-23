/**
 * Create Course Screen
 * Form to create a new course
 */

import { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TextInput,
    TouchableOpacity,
    useColorScheme,
    Switch,
    Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import { ArrowLeft, Upload } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { tutorCourseService } from '@/services/tutor-course.service';

const CATEGORIES = [
    'Development',
    'Business',
    'Design',
    'Marketing',
    'Lifestyle',
    'Photography',
    'Health & Fitness',
    'Music',
];

const DIFFICULTIES = ['beginner', 'intermediate', 'advanced'];

export default function CreateCourseScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [submitting, setSubmitting] = useState(false);
    const [formData, setFormData] = useState({
        title: '',
        description: '',
        price: '0',
        category: CATEGORIES[0],
        difficultyLevel: 'beginner' as 'beginner' | 'intermediate' | 'advanced',
    });

    const handleChange = (key: string, value: string) => {
        setFormData(prev => ({ ...prev, [key]: value }));
    };

    const handleSubmit = async () => {
        if (!formData.title || !formData.description) {
            Alert.alert('Error', 'Please fill in required fields');
            return;
        }

        try {
            setSubmitting(true);
            const course = await tutorCourseService.createCourse({
                ...formData,
                price: parseFloat(formData.price) || 0,
                currency: 'XAF',
                // TODO: Handle thumbnail upload
                thumbnailUrl: 'https://via.placeholder.com/300',
            });

            Alert.alert('Success', 'Course created!', [
                {
                    text: 'Manage Content',
                    onPress: () => router.replace(`/tutor/courses/${course.id}/manage` as any)
                }
            ]);
        } catch (error) {
            console.error('Failed to create course:', error);
            Alert.alert('Error', 'Failed to create course');
        } finally {
            setSubmitting(false);
        }
    };

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.header}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
                    <ArrowLeft size={24} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                </TouchableOpacity>
                <Text style={[typography.h2, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Create Course
                </Text>
                <View style={{ width: 24 }} />
            </View>

            <ScrollView contentContainerStyle={styles.content}>
                {/* Title */}
                <View style={styles.inputGroup}>
                    <Text style={[typography.label, { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }]}>
                        Course Title *
                    </Text>
                    <TextInput
                        style={[styles.input, {
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        }]}
                        placeholder="e.g. Master React Native in 30 Days"
                        placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                        value={formData.title}
                        onChangeText={(t) => handleChange('title', t)}
                    />
                </View>

                {/* Description */}
                <View style={styles.inputGroup}>
                    <Text style={[typography.label, { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }]}>
                        Description *
                    </Text>
                    <TextInput
                        style={[styles.input, styles.textArea, {
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        }]}
                        placeholder="What will students learn?"
                        placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                        multiline
                        numberOfLines={4}
                        textAlignVertical="top"
                        value={formData.description}
                        onChangeText={(t) => handleChange('description', t)}
                    />
                </View>

                {/* Price */}
                <View style={styles.inputGroup}>
                    <Text style={[typography.label, { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }]}>
                        Price (XAF) - 0 for Free
                    </Text>
                    <TextInput
                        style={[styles.input, {
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        }]}
                        keyboardType="numeric"
                        value={formData.price}
                        onChangeText={(t) => handleChange('price', t)}
                    />
                </View>

                {/* Category & Difficulty */}
                <View style={styles.row}>
                    <View style={[styles.inputGroup, { flex: 1, marginRight: spacing.sm }]}>
                        <Text style={[typography.label, { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }]}>
                            Category
                        </Text>
                        <View style={[styles.select, { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}>
                            <Text style={{ color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }}>
                                {formData.category}
                            </Text>
                            {/* In real app, use a picker modal */}
                        </View>
                    </View>

                    <View style={[styles.inputGroup, { flex: 1, marginLeft: spacing.sm }]}>
                        <Text style={[typography.label, { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }]}>
                            Level
                        </Text>
                        <View style={[styles.select, { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}>
                            <Text style={{ color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }}>
                                {formData.difficultyLevel}
                            </Text>
                        </View>
                    </View>
                </View>

                {/* Thumbnail Upload Placeholder */}
                <TouchableOpacity style={[styles.uploadBox, {
                    borderColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                }]}>
                    <Upload size={32} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                    <Text style={[typography.body, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        marginTop: spacing.sm
                    }]}>
                        Upload Course Thumbnail
                    </Text>
                </TouchableOpacity>

                {/* Submit Button */}
                <TouchableOpacity
                    style={[styles.submitButton, {
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                        opacity: submitting ? 0.7 : 1
                    }]}
                    onPress={handleSubmit}
                    disabled={submitting}
                >
                    <Text style={[typography.button, { color: '#fff' }]}>
                        {submitting ? 'Creating...' : 'Create Course'}
                    </Text>
                </TouchableOpacity>
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
    content: {
        padding: spacing.md,
        paddingBottom: spacing.xxl,
    },
    inputGroup: {
        marginBottom: spacing.lg,
    },
    input: {
        borderRadius: radius.lg,
        padding: spacing.md,
        fontSize: 16,
        marginTop: spacing.xs,
    },
    textArea: {
        minHeight: 120,
    },
    row: {
        flexDirection: 'row',
    },
    select: {
        borderRadius: radius.lg,
        padding: spacing.md,
        marginTop: spacing.xs,
    },
    uploadBox: {
        borderWidth: 2,
        borderStyle: 'dashed',
        borderRadius: radius.lg,
        height: 150,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: spacing.xl,
    },
    submitButton: {
        padding: spacing.md,
        borderRadius: radius.lg,
        alignItems: 'center',
    },
});
