/**
 * My Posts Screen (Tutor)
 * View and manage own posts
 */

import { useState, useCallback } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
    useColorScheme,
} from 'react-native';
import { useRouter, useFocusEffect } from 'expo-router';
import { ArrowLeft, Plus } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { socialFeedService, type Post } from '@/services/social-feed.service';
import { PostCard } from '@/components/PostCard';
import { Loading } from '@/components/Loading';
import { EmptyState } from '@/components/EmptyState';
import { useAuth } from '@/hooks/useAuth';

export default function MyPostsScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { user } = useAuth();

    const [loading, setLoading] = useState(true);
    const [posts, setPosts] = useState<Post[]>([]);

    useFocusEffect(
        useCallback(() => {
            if (user) {
                loadMyPosts();
            }
        }, [user])
    );

    const loadMyPosts = async () => {
        try {
            setLoading(true);
            const data = await socialFeedService.getUserPosts(user!.id);
            setPosts(data);
        } catch (error) {
            console.error('Failed to load posts:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleCreatePost = () => {
        router.push('/post/create' as any);
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
                    My Posts
                </Text>
                <TouchableOpacity onPress={handleCreatePost}>
                    <Plus size={24} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} weight="bold" />
                </TouchableOpacity>
            </View>

            {posts.length === 0 ? (
                <EmptyState
                    icon="post"
                    title="No posts yet"
                    message="Create your first post to share with students!"
                    actionLabel="Create Post"
                    onAction={handleCreatePost}
                />
            ) : (
                <FlatList
                    data={posts}
                    renderItem={({ item }) => (
                        <PostCard post={item} currentUserId={user?.id} />
                    )}
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
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    backButton: {
        padding: 4,
    },
    list: {
        paddingBottom: spacing.xl,
    },
});
