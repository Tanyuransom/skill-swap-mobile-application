/**
 * Review List Component
 * Displays course reviews
 */

import { View, Text, StyleSheet, FlatList, useColorScheme } from 'react-native';
import { User } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { StarRating } from './StarRating';
import type { Review } from '@/services/review.service';

interface ReviewListProps {
    reviews: Review[];
}

export function ReviewList({ reviews }: ReviewListProps) {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';

    const renderReview = ({ item }: { item: Review }) => (
        <View style={[styles.reviewCard, {
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
        }]}>
            <View style={styles.header}>
                <View style={[styles.avatar, {
                    backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                }]}>
                    <User size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                </View>
                <View style={styles.headerInfo}>
                    <Text style={[typography.bodyMedium, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        {item.studentName || 'Student'}
                    </Text>
                    <StarRating rating={item.rating} size={16} readonly />
                </View>
            </View>

            {item.comment && (
                <Text style={[typography.body, styles.comment, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    {item.comment}
                </Text>
            )}

            <Text style={[typography.caption, {
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
            }]}>
                {formatDate(item.createdAt)}
            </Text>
        </View>
    );

    if (reviews.length === 0) {
        return (
            <View style={styles.emptyContainer}>
                <Text style={[typography.body, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    No reviews yet. Be the first to review!
                </Text>
            </View>
        );
    }

    return (
        <FlatList
            data={reviews}
            renderItem={renderReview}
            keyExtractor={(item) => item.id}
            contentContainerStyle={styles.list}
            scrollEnabled={false}
        />
    );
}

function formatDate(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleDateString();
}

const styles = StyleSheet.create({
    list: {
        gap: spacing.md,
    },
    reviewCard: {
        borderRadius: radius.lg,
        padding: spacing.md,
    },
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: spacing.sm,
    },
    avatar: {
        width: 40,
        height: 40,
        borderRadius: 20,
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: spacing.sm,
    },
    headerInfo: {
        flex: 1,
        gap: 4,
    },
    comment: {
        marginBottom: spacing.sm,
        lineHeight: 20,
    },
    emptyContainer: {
        padding: spacing.xl,
        alignItems: 'center',
    },
});
