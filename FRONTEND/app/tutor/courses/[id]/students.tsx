/**
 * Course Students Screen
 * View enrolled students for a specific course
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
    Image,
    useColorScheme,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { ArrowLeft, User } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { Loading } from '@/components/Loading';
import { EmptyState } from '@/components/EmptyState';

interface Student {
    id: string;
    name: string;
    avatar?: string;
    enrolledAt: string;
    progress: number;
}

export default function CourseStudentsScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { id } = useLocalSearchParams<{ id: string }>();

    const [loading, setLoading] = useState(true);
    const [students, setStudents] = useState<Student[]>([]);

    useEffect(() => {
        loadStudents();
    }, []);

    const loadStudents = async () => {
        try {
            setLoading(true);
            // TODO: Load from API
            setStudents([
                { id: '1', name: 'John Doe', progress: 75, enrolledAt: '2024-01-15' },
                { id: '2', name: 'Jane Smith', progress: 45, enrolledAt: '2024-01-20' },
                { id: '3', name: 'Bob Johnson', progress: 90, enrolledAt: '2024-01-10' },
            ]);
        } catch (error) {
            console.error('Failed to load students:', error);
        } finally {
            setLoading(false);
        }
    };

    const renderStudent = ({ item }: { item: Student }) => (
        <View style={[styles.studentCard, {
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
        }]}>
            {item.avatar ? (
                <Image source={{ uri: item.avatar }} style={styles.avatar} />
            ) : (
                <View style={[styles.avatarPlaceholder, {
                    backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                }]}>
                    <User size={24} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                </View>
            )}
            <View style={styles.studentInfo}>
                <Text style={[typography.bodyMedium, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    {item.name}
                </Text>
                <Text style={[typography.caption, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    Enrolled {new Date(item.enrolledAt).toLocaleDateString()}
                </Text>
            </View>
            <View style={styles.progressContainer}>
                <Text style={[typography.caption, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    marginBottom: 4
                }]}>
                    Progress
                </Text>
                <View style={[styles.progressBar, {
                    backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                }]}>
                    <View style={[styles.progressFill, {
                        width: `${item.progress}%`,
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                    }]} />
                </View>
                <Text style={[typography.caption, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    marginTop: 4,
                    fontWeight: '600'
                }]}>
                    {item.progress}%
                </Text>
            </View>
        </View>
    );

    if (loading) {
        return <Loading fullScreen />;
    }

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
                    Enrolled Students
                </Text>
                <View style={{ width: 24 }} />
            </View>

            {students.length === 0 ? (
                <EmptyState
                    icon="courses"
                    title="No students yet"
                    message="Students will appear here once they enroll in your course"
                />
            ) : (
                <FlatList
                    data={students}
                    renderItem={renderStudent}
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
    list: {
        padding: spacing.md,
    },
    studentCard: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.sm,
    },
    avatar: {
        width: 48,
        height: 48,
        borderRadius: 24,
        marginRight: spacing.md,
    },
    avatarPlaceholder: {
        width: 48,
        height: 48,
        borderRadius: 24,
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: spacing.md,
    },
    studentInfo: {
        flex: 1,
    },
    progressContainer: {
        alignItems: 'flex-end',
    },
    progressBar: {
        width: 80,
        height: 6,
        borderRadius: 3,
        overflow: 'hidden',
    },
    progressFill: {
        height: '100%',
        borderRadius: 3,
    },
});
