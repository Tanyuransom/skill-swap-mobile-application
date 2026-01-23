/**
 * Start Verification Screen
 * Choose skill to verify
 */

import { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    useColorScheme,
    ScrollView,
    Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import { ArrowLeft, CheckCircle } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { verificationService } from '@/services/verification.service';

const AVAILABLE_SKILLS = [
    'Web Development',
    'Mobile Development',
    'Data Science',
    'Machine Learning',
    'UI/UX Design',
    'Digital Marketing',
    'Photography',
    'Video Editing',
    'Graphic Design',
    'Content Writing',
];

export default function StartVerificationScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [selectedSkill, setSelectedSkill] = useState<string | null>(null);
    const [submitting, setSubmitting] = useState(false);

    const handleStart = async () => {
        if (!selectedSkill) return;

        try {
            setSubmitting(true);
            const request = await verificationService.requestVerification(selectedSkill);
            router.push(`/tutor/verification/exam?requestId=${request.id}` as any);
        } catch (error) {
            console.error('Failed to start verification:', error);
            Alert.alert('Error', 'Failed to start verification');
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
                    Get Verified
                </Text>
                <View style={{ width: 24 }} />
            </View>

            <ScrollView contentContainerStyle={styles.content}>
                <Text style={[typography.body, styles.description, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    Choose a skill to verify. You'll take a short exam and receive a badge upon passing.
                </Text>

                <View style={styles.skillsGrid}>
                    {AVAILABLE_SKILLS.map((skill) => (
                        <TouchableOpacity
                            key={skill}
                            style={[
                                styles.skillCard,
                                {
                                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                                    borderWidth: 2,
                                    borderColor: selectedSkill === skill
                                        ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                        : 'transparent',
                                }
                            ]}
                            onPress={() => setSelectedSkill(skill)}
                        >
                            {selectedSkill === skill && (
                                <CheckCircle
                                    size={20}
                                    color={isDark ? AppColors.primaryDarkMode : AppColors.primary}
                                    weight="fill"
                                    style={styles.checkIcon}
                                />
                            )}
                            <Text style={[typography.bodyMedium, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}>
                                {skill}
                            </Text>
                        </TouchableOpacity>
                    ))}
                </View>

                <TouchableOpacity
                    style={[styles.startButton, {
                        backgroundColor: selectedSkill
                            ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                            : (isDark ? AppColors.surfaceDark : AppColors.surface),
                        opacity: (selectedSkill && !submitting) ? 1 : 0.5
                    }]}
                    onPress={handleStart}
                    disabled={!selectedSkill || submitting}
                >
                    <Text style={[typography.button, { color: '#fff' }]}>
                        {submitting ? 'Starting...' : 'Start Verification'}
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
    },
    description: {
        marginBottom: spacing.lg,
        lineHeight: 22,
    },
    skillsGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: spacing.sm,
    },
    skillCard: {
        padding: spacing.md,
        borderRadius: radius.lg,
        minWidth: '47%',
        position: 'relative',
    },
    checkIcon: {
        position: 'absolute',
        top: spacing.xs,
        right: spacing.xs,
    },
    startButton: {
        borderRadius: radius.lg,
        padding: spacing.md,
        alignItems: 'center',
        marginTop: spacing.xl,
    },
});
