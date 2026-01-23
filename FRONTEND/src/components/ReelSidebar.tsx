/**
 * Reel Sidebar Component
 * TikTok-style right sidebar with actions
 */

import { View, Text, StyleSheet, TouchableOpacity, Image } from 'react-native';
import { Heart, ChatCircle, ShareNetwork, DotsThree, User } from 'phosphor-react-native';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import type { Reel } from '@/services/reels.service';

interface ReelSidebarProps {
    reel: Reel;
    onProfilePress: () => void;
    onLikePress: () => void;
    onCommentPress: () => void;
    onSharePress: () => void;
}

export function ReelSidebar({
    reel,
    onProfilePress,
    onLikePress,
    onCommentPress,
    onSharePress,
}: ReelSidebarProps) {
    return (
        <View style={styles.container}>
            {/* Profile Avatar */}
            <TouchableOpacity style={styles.actionButton} onPress={onProfilePress}>
                {reel.userAvatar ? (
                    <View>
                        <Image source={{ uri: reel.userAvatar }} style={styles.avatar} />
                        {!reel.isFollowing && (
                            <View style={styles.followBadge}>
                                <View style={styles.plusIcon} />
                            </View>
                        )}
                    </View>
                ) : (
                    <View style={styles.avatarPlaceholder}>
                        <User size={24} color="#fff" />
                    </View>
                )}
            </TouchableOpacity>

            {/* Like */}
            <TouchableOpacity style={styles.actionButton} onPress={onLikePress}>
                <Heart
                    size={32}
                    color={reel.isLiked ? '#FF2D55' : '#fff'}
                    weight={reel.isLiked ? 'fill' : 'regular'}
                />
                <Text style={styles.actionText}>
                    {formatCount(reel.likeCount)}
                </Text>
            </TouchableOpacity>

            {/* Comment */}
            <TouchableOpacity style={styles.actionButton} onPress={onCommentPress}>
                <ChatCircle size={32} color="#fff" weight="fill" />
                <Text style={styles.actionText}>
                    {formatCount(reel.commentCount)}
                </Text>
            </TouchableOpacity>

            {/* Share */}
            <TouchableOpacity style={styles.actionButton} onPress={onSharePress}>
                <ShareNetwork size={32} color="#fff" weight="fill" />
                <Text style={styles.actionText}>
                    {formatCount(reel.shareCount)}
                </Text>
            </TouchableOpacity>

            {/* More */}
            <TouchableOpacity style={styles.actionButton}>
                <DotsThree size={32} color="#fff" weight="bold" />
            </TouchableOpacity>
        </View>
    );
}

function formatCount(count: number): string {
    if (count >= 1000000) return `${(count / 1000000).toFixed(1)}M`;
    if (count >= 1000) return `${(count / 1000).toFixed(1)}K`;
    return count.toString();
}

const styles = StyleSheet.create({
    container: {
        position: 'absolute',
        right: spacing.sm,
        bottom: 100,
        alignItems: 'center',
        gap: spacing.lg,
    },
    actionButton: {
        alignItems: 'center',
        gap: 4,
    },
    avatar: {
        width: 48,
        height: 48,
        borderRadius: 24,
        borderWidth: 2,
        borderColor: '#fff',
    },
    avatarPlaceholder: {
        width: 48,
        height: 48,
        borderRadius: 24,
        backgroundColor: 'rgba(255,255,255,0.3)',
        justifyContent: 'center',
        alignItems: 'center',
    },
    followBadge: {
        position: 'absolute',
        bottom: -6,
        left: '50%',
        marginLeft: -10,
        width: 20,
        height: 20,
        borderRadius: 10,
        backgroundColor: '#FF2D55',
        justifyContent: 'center',
        alignItems: 'center',
    },
    plusIcon: {
        width: 10,
        height: 2,
        backgroundColor: '#fff',
    },
    actionText: {
        ...typography.caption,
        color: '#fff',
        fontWeight: '600',
        textShadowColor: 'rgba(0, 0, 0, 0.75)',
        textShadowOffset: { width: 0, height: 1 },
        textShadowRadius: 3,
    },
});
