/**
 * Post Card Component
 * Displays a single post in the feed (Twitter-style)
 */

import { View, Text, StyleSheet, Image, TouchableOpacity, useColorScheme } from 'react-native';
import { Heart, ChatCircle, ShareNetwork, DotsThree, Trash } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import type { Post } from '@/services/social-feed.service';
import { useRouter } from 'expo-router';

interface PostCardProps {
    post: Post;
    onLike?: (postId: string) => void;
    onDelete?: (postId: string) => void;
    currentUserId?: string;
}

export function PostCard({ post, onLike, onDelete, currentUserId }: PostCardProps) {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const isOwner = currentUserId === post.userId;

    const handleProfilePress = () => {
        router.push(`/profile/${post.userId}` as any);
    };

    return (
        <View style={[styles.card, {
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderBottomColor: isDark ? AppColors.backgroundDark : AppColors.background,
        }]}>
            {/* Avatar Column */}
            <View style={styles.leftColumn}>
                <TouchableOpacity onPress={handleProfilePress}>
                    {post.userAvatar ? (
                        <Image source={{ uri: post.userAvatar }} style={styles.avatar} />
                    ) : (
                        <View style={[styles.avatarPlaceholder, {
                            backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                        }]} />
                    )}
                </TouchableOpacity>
            </View>

            {/* Content Column */}
            <View style={styles.rightColumn}>
                {/* Header */}
                <View style={styles.header}>
                    <View style={styles.userInfo}>
                        <Text style={[typography.bodyMedium, styles.name, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                        }]} numberOfLines={1}>
                            {post.userName || 'User'}
                        </Text>
                        <Text style={[typography.body, styles.handle, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]} numberOfLines={1}>
                            @{post.userHandle || 'username'}
                        </Text>
                        <Text style={[typography.body, styles.dot, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>•</Text>
                        <Text style={[typography.body, styles.time, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            {formatTime(post.createdAt)}
                        </Text>
                    </View>

                    {isOwner && onDelete && (
                        <TouchableOpacity onPress={() => onDelete(post.id)} style={styles.moreButton}>
                            <DotsThree size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} weight="bold" />
                        </TouchableOpacity>
                    )}
                </View>

                {/* Text Content */}
                {post.description && (
                    <Text style={[typography.body, styles.content, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        {post.description}
                    </Text>
                )}

                {/* Media Content */}
                {post.mediaUrl && (post.postType === 'image' || post.postType === 'video') && (
                    <View style={styles.mediaContainer}>
                        <Image
                            source={{ uri: post.mediaUrl }}
                            style={styles.media}
                            resizeMode="cover"
                        />
                    </View>
                )}

                {/* Actions */}
                <View style={styles.actions}>
                    <TouchableOpacity
                        style={styles.actionButton}
                        onPress={() => onLike && onLike(post.id)}
                    >
                        <Heart
                            size={20}
                            color={post.isLiked ? '#EF4444' : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)}
                            weight={post.isLiked ? 'fill' : 'regular'}
                        />
                        <Text style={[typography.caption, styles.actionText, {
                            color: post.isLiked ? '#EF4444' : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)
                        }]}>
                            {post.likeCount > 0 ? formatCount(post.likeCount) : ''}
                        </Text>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.actionButton}>
                        <ChatCircle
                            size={20}
                            color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                        />
                        <Text style={[typography.caption, styles.actionText, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            {post.commentCount > 0 ? formatCount(post.commentCount) : ''}
                        </Text>
                    </TouchableOpacity>

                    <TouchableOpacity style={styles.actionButton}>
                        <ShareNetwork
                            size={20}
                            color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                        />
                    </TouchableOpacity>
                </View>
            </View>
        </View>
    );
}

function formatTime(dateString: string): string {
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 1) return 'now';
    if (diffMins < 60) return `${diffMins}m`;
    if (diffHours < 24) return `${diffHours}h`;
    if (diffDays < 7) return `${diffDays}d`;
    return date.toLocaleDateString(undefined, { month: 'short', day: 'numeric' });
}

function formatCount(count: number): string {
    if (count >= 1000000) return `${(count / 1000000).toFixed(1)}M`;
    if (count >= 1000) return `${(count / 1000).toFixed(1)}K`;
    return count.toString();
}

const styles = StyleSheet.create({
    card: {
        flexDirection: 'row',
        padding: spacing.md,
        borderBottomWidth: 1,
    },
    leftColumn: {
        marginRight: spacing.md,
    },
    rightColumn: {
        flex: 1,
    },
    avatar: {
        width: 40,
        height: 40,
        borderRadius: 20,
    },
    avatarPlaceholder: {
        width: 40,
        height: 40,
        borderRadius: 20,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        marginBottom: 2,
    },
    userInfo: {
        flexDirection: 'row',
        alignItems: 'center',
        flex: 1,
        flexWrap: 'wrap',
    },
    name: {
        fontWeight: '700',
        marginRight: 4,
    },
    handle: {
        marginRight: 4,
    },
    dot: {
        marginRight: 4,
    },
    time: {},
    moreButton: {
        padding: 2,
    },
    content: {
        marginBottom: spacing.sm,
        lineHeight: 20,
    },
    mediaContainer: {
        marginTop: spacing.xs,
        marginBottom: spacing.sm,
        borderRadius: radius.lg,
        overflow: 'hidden',
    },
    media: {
        width: '100%',
        height: 200,
        borderRadius: radius.lg,
    },
    actions: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        maxWidth: 200, // Limit width so icons aren't too spread out
        marginTop: spacing.xs,
    },
    actionButton: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: 4,
    },
    actionText: {
        marginLeft: 4,
        minWidth: 20,
    },
});
