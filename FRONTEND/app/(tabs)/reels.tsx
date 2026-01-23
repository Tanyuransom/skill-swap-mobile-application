/**
 * Reels Screen
 * TikTok-style vertical scrolling reels
 */

import { useState, useRef, useCallback } from 'react';
import {
    View,
    StyleSheet,
    FlatList,
    Dimensions,
    ViewToken,
    Alert,
} from 'react-native';
import { useFocusEffect, useRouter } from 'expo-router';
import { reelsService, type Reel } from '@/services/reels.service';
import { socialFeedService } from '@/services/social-feed.service';
import { ReelPlayer } from '@/components/ReelPlayer';
import { ReelSidebar } from '@/components/ReelSidebar';
import { ReelInfo } from '@/components/ReelInfo';
import { Loading } from '@/components/Loading';

const { height: SCREEN_HEIGHT } = Dimensions.get('window');

export default function ReelsScreen() {
    const router = useRouter();
    const [reels, setReels] = useState<Reel[]>([]);
    const [loading, setLoading] = useState(true);
    const [activeIndex, setActiveIndex] = useState(0);
    const flatListRef = useRef<FlatList>(null);

    useFocusEffect(
        useCallback(() => {
            loadReels();
        }, [])
    );

    const loadReels = async () => {
        try {
            const data = await reelsService.getReelsFeed();
            setReels(data);
        } catch (error) {
            console.error('Failed to load reels:', error);
        } finally {
            setLoading(false);
        }
    };

    const onViewableItemsChanged = useRef(({ viewableItems }: { viewableItems: ViewToken[] }) => {
        if (viewableItems.length > 0) {
            const index = viewableItems[0].index ?? 0;
            setActiveIndex(index);

            // Track view
            const reel = reels[index];
            if (reel) {
                reelsService.trackView(reel.id);
            }
        }
    }).current;

    const viewabilityConfig = useRef({
        itemVisiblePercentThreshold: 80,
    }).current;

    const handleLike = async (reelId: string) => {
        // Optimistic update
        setReels(prev => prev.map(r => {
            if (r.id === reelId) {
                const newIsLiked = !r.isLiked;
                return {
                    ...r,
                    isLiked: newIsLiked,
                    likeCount: newIsLiked ? r.likeCount + 1 : r.likeCount - 1
                };
            }
            return r;
        }));

        try {
            const reel = reels.find(r => r.id === reelId);
            if (reel?.isLiked) {
                await reelsService.unlikeReel(reelId);
            } else {
                await reelsService.likeReel(reelId);
            }
        } catch (error) {
            console.error('Failed to like reel:', error);
            // Revert on error
            setReels(prev => prev.map(r => {
                if (r.id === reelId) {
                    return {
                        ...r,
                        isLiked: !r.isLiked,
                        likeCount: r.isLiked ? r.likeCount - 1 : r.likeCount + 1
                    };
                }
                return r;
            }));
        }
    };

    const handleFollow = async (userId: string) => {
        try {
            await socialFeedService.followUser(userId);
            setReels(prev => prev.map(r => {
                if (r.userId === userId) {
                    return { ...r, isFollowing: true };
                }
                return r;
            }));
        } catch (error) {
            console.error('Failed to follow user:', error);
            Alert.alert('Error', 'Failed to follow user');
        }
    };

    const renderReel = ({ item, index }: { item: Reel; index: number }) => {
        const isActive = index === activeIndex;

        return (
            <View style={styles.reelContainer}>
                <ReelPlayer
                    reel={item}
                    isActive={isActive}
                    onDoubleTap={() => handleLike(item.id)}
                />

                <ReelSidebar
                    reel={item}
                    onProfilePress={() => router.push(`/profile/${item.userId}` as any)}
                    onLikePress={() => handleLike(item.id)}
                    onCommentPress={() => {/* TODO: Open comments */ }}
                    onSharePress={() => {/* TODO: Share */ }}
                />

                <ReelInfo
                    reel={item}
                    onProfilePress={() => router.push(`/profile/${item.userId}` as any)}
                />
            </View>
        );
    };

    if (loading) {
        return <Loading fullScreen />;
    }

    return (
        <View style={styles.container}>
            <FlatList
                ref={flatListRef}
                data={reels}
                renderItem={renderReel}
                keyExtractor={(item) => item.id}
                pagingEnabled
                showsVerticalScrollIndicator={false}
                snapToInterval={SCREEN_HEIGHT}
                snapToAlignment="start"
                decelerationRate="fast"
                onViewableItemsChanged={onViewableItemsChanged}
                viewabilityConfig={viewabilityConfig}
                getItemLayout={(data, index) => ({
                    length: SCREEN_HEIGHT,
                    offset: SCREEN_HEIGHT * index,
                    index,
                })}
            />
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#000',
    },
    reelContainer: {
        height: SCREEN_HEIGHT,
        position: 'relative',
    },
});
