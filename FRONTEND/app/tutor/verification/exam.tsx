/**
 * Verification Exam Screen
 * Take the skill verification test
 */

import { useState, useEffect, useRef } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    ScrollView,
    Alert,
    useColorScheme,
    BackHandler,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Clock, CheckCircle, XCircle } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { verificationService, type VerificationExam } from '@/services/verification.service';
import { Loading } from '@/components/Loading';

export default function ExamScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { requestId } = useLocalSearchParams<{ requestId: string }>();

    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);
    const [exam, setExam] = useState<VerificationExam | null>(null);
    const [answers, setAnswers] = useState<Record<string, number>>({});
    const [timeLeft, setTimeLeft] = useState(15 * 60); // 15 minutes in seconds

    // Prevent back button during exam
    useEffect(() => {
        const backHandler = BackHandler.addEventListener('hardwareBackPress', () => {
            Alert.alert(
                'Exit Exam?',
                'If you exit now, your progress will be lost and you will fail this attempt.',
                [
                    { text: 'Cancel', style: 'cancel' },
                    { text: 'Exit', style: 'destructive', onPress: () => router.back() },
                ]
            );
            return true;
        });

        return () => backHandler.remove();
    }, []);

    // Timer
    useEffect(() => {
        if (!exam || submitting) return;

        const timer = setInterval(() => {
            setTimeLeft((prev) => {
                if (prev <= 1) {
                    clearInterval(timer);
                    handleSubmit(true); // Auto-submit on timeout
                    return 0;
                }
                return prev - 1;
            });
        }, 1000);

        return () => clearInterval(timer);
    }, [exam, submitting]);

    useEffect(() => {
        if (requestId) {
            loadExam();
        }
    }, [requestId]);

    const loadExam = async () => {
        try {
            setLoading(true);
            const data = await verificationService.getExam(requestId!);
            setExam(data);
        } catch (error) {
            console.error('Failed to load exam:', error);
            Alert.alert('Error', 'Failed to load exam', [
                { text: 'Go Back', onPress: () => router.back() }
            ]);
        } finally {
            setLoading(false);
        }
    };

    const handleAnswer = (questionId: string, optionIndex: number) => {
        setAnswers(prev => ({
            ...prev,
            [questionId]: optionIndex
        }));
    };

    const handleSubmit = async (isAutoSubmit = false) => {
        if (!exam) return;

        // Check if all answered (unless auto-submit)
        if (!isAutoSubmit && Object.keys(answers).length < exam.questions.length) {
            Alert.alert(
                'Unanswered Questions',
                'Please answer all questions before submitting.'
            );
            return;
        }

        try {
            setSubmitting(true);
            await verificationService.submitExam(exam.id, answers);
            router.replace(`/tutor/verification/result?requestId=${requestId}` as any);
        } catch (error) {
            console.error('Failed to submit exam:', error);
            Alert.alert('Error', 'Failed to submit exam. Please try again.');
            setSubmitting(false);
        }
    };

    const formatTime = (seconds: number) => {
        const mins = Math.floor(seconds / 60);
        const secs = seconds % 60;
        return `${mins}:${secs < 10 ? '0' : ''}${secs}`;
    };

    if (loading || !exam) {
        return <Loading fullScreen />;
    }

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header / Timer */}
            <View style={[styles.header, { borderBottomColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}>
                <Text style={[typography.h4, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Skill Assessment
                </Text>
                <View style={[styles.timerBadge, {
                    backgroundColor: timeLeft < 60 ? '#FEF2F2' : (isDark ? AppColors.surfaceDark : AppColors.surface)
                }]}>
                    <Clock size={16} color={timeLeft < 60 ? '#EF4444' : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)} weight="bold" />
                    <Text style={[typography.bodyMedium, {
                        color: timeLeft < 60 ? '#EF4444' : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                        fontVariant: ['tabular-nums'],
                        marginLeft: 6,
                    }]}>
                        {formatTime(timeLeft)}
                    </Text>
                </View>
            </View>

            <ScrollView contentContainerStyle={styles.content}>
                <Text style={[typography.caption, styles.progress, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    Question {Object.keys(answers).length} of {exam.questions.length} answered
                </Text>

                {exam.questions.map((q, index) => (
                    <View key={q.id} style={styles.questionContainer}>
                        <Text style={[typography.h4, styles.questionText, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                        }]}>
                            {index + 1}. {q.question}
                        </Text>

                        <View style={styles.optionsContainer}>
                            {q.options.map((option, optIndex) => {
                                const isSelected = answers[q.id] === optIndex;
                                return (
                                    <TouchableOpacity
                                        key={optIndex}
                                        style={[
                                            styles.optionButton,
                                            {
                                                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                                                borderColor: isSelected
                                                    ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                                    : 'transparent',
                                                borderWidth: 2,
                                            }
                                        ]}
                                        onPress={() => handleAnswer(q.id, optIndex)}
                                    >
                                        <View style={[styles.radio, {
                                            borderColor: isSelected
                                                ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                                        }]}>
                                            {isSelected && (
                                                <View style={[styles.radioInner, {
                                                    backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                                                }]} />
                                            )}
                                        </View>
                                        <Text style={[typography.body, styles.optionText, {
                                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                                        }]}>
                                            {option}
                                        </Text>
                                    </TouchableOpacity>
                                );
                            })}
                        </View>
                    </View>
                ))}

                <TouchableOpacity
                    style={[styles.submitButton, {
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                        opacity: submitting ? 0.7 : 1
                    }]}
                    onPress={() => handleSubmit(false)}
                    disabled={submitting}
                >
                    <Text style={[typography.button, { color: '#fff' }]}>
                        {submitting ? 'Submitting...' : 'Submit Exam'}
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
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: spacing.md,
        paddingTop: spacing.xl,
        borderBottomWidth: 1,
    },
    timerBadge: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: spacing.md,
        paddingVertical: spacing.xs,
        borderRadius: radius.full,
    },
    content: {
        padding: spacing.md,
        paddingBottom: spacing.xl,
    },
    progress: {
        marginBottom: spacing.md,
        textAlign: 'center',
    },
    questionContainer: {
        marginBottom: spacing.xl,
    },
    questionText: {
        marginBottom: spacing.md,
        lineHeight: 24,
    },
    optionsContainer: {
        gap: spacing.sm,
    },
    optionButton: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: spacing.md,
        borderRadius: radius.lg,
    },
    radio: {
        width: 20,
        height: 20,
        borderRadius: 10,
        borderWidth: 2,
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: spacing.md,
    },
    radioInner: {
        width: 10,
        height: 10,
        borderRadius: 5,
    },
    optionText: {
        flex: 1,
    },
    submitButton: {
        padding: spacing.md,
        borderRadius: radius.lg,
        alignItems: 'center',
        marginTop: spacing.lg,
        marginBottom: spacing.xxl,
    },
});
