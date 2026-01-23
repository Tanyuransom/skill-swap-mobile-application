/**
 * Add Review Screen
 * Form to create/edit course review
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TextInput,
    TouchableOpacity,
    useColorScheme,
    Alert,
    ScrollView,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { StarRating } from '@/components/StarRating';
import { reviewService } from '@/services/review.service';
import { Loading } from '@/components/Loading';

export default function AddReviewScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { courseId } = useLocalSearchParams<{ courseId: string }>();

    const [loading, setLoading] = useState(false);
    const [submitting, setSubmitting] = useState(false);
    const [rating, setRating] = useState(0);
    const [comment, setComment] = useState('');

    const handleSubmit = async () => {
        if (rating === 0) {
            Alert.alert('Error', 'Please select a rating');
            return;
        }

        try {
            setSubmitting(true);
            await reviewService.createReview({
                courseId: courseId!,
                rating,
                comment: comment.trim() || undefined,
            });

            Alert.alert('Success', 'Review submitted successfully!', [
                {
                    text: 'OK',
                    onPress: () => router.back(),
                },
            ]);
        } catch (error) {
            console.error('Failed to submit review:', error);
            Alert.alert('Error', 'Failed to submit review. Please try again.');
        } finally {
            setSubmitting(false);
        }
    };

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
                    Write a Review
                </Text>
                <View style={{ width: 24 }} />
            </View>

            <ScrollView contentContainerStyle={styles.content}>
                {/* Rating */}
                <View style={styles.section}>
                    <Text style={[typography.section, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        Your Rating
                    </Text>
                    <View style={styles.ratingContainer}>
                        <StarRating
                            rating={rating}
                            onRatingChange={setRating}
                            size={40}
                        />
                    </View>
                </View>

                {/* Comment */}
                <View style={styles.section}>
                    <Text style={[typography.section, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        Your Review (Optional)
                    </Text>
                    <TextInput
                        style={[styles.textArea, {
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        }]}
                        placeholder="Share your experience with this course..."
                        placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                        value={comment}
                        onChangeText={setComment}
                        multiline
                        numberOfLines={6}
                        maxLength={500}
                    />
                    <Text style={[typography.caption, styles.charCount, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        {comment.length}/500
                    </Text>
                </View>

                {/* Submit Button */}
                <TouchableOpacity
                    style={[styles.submitButton, {
                        backgroundColor: rating > 0
                            ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                            : (isDark ? AppColors.surfaceDark : AppColors.surface),
                        opacity: (rating > 0 && !submitting) ? 1 : 0.5
                    }]}
                    onPress={handleSubmit}
                    disabled={rating === 0 || submitting}
                >
                    <Text style={[typography.button, { color: '#fff' }]}>
                        {submitting ? 'Submitting...' : 'Submit Review'}
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
    section: {
        marginBottom: spacing.xl,
    },
    ratingContainer: {
        marginTop: spacing.md,
        alignItems: 'center',
        paddingVertical: spacing.lg,
    },
    textArea: {
        borderRadius: radius.lg,
        padding: spacing.md,
        marginTop: spacing.sm,
        textAlignVertical: 'top',
        fontSize: 16,
        minHeight: 150,
    },
    charCount: {
        textAlign: 'right',
        marginTop: spacing.xs,
    },
    submitButton: {
        borderRadius: radius.lg,
        padding: spacing.md,
        alignItems: 'center',
    },
});
