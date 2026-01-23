/**
 * My Reels Screen (Tutor)
 * View and manage own reels
 */

import { useState, useCallback } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
    Image,
    useColorScheme,
} from 'react-native';
import { useRouter, useFocusEffect } from 'expo-router';
import { ArrowLeft, Plus, PlayCircle } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { reelsService, type Reel } from '@/services/reels.service';
import { Loading } from '@/components/Loading';
import { EmptyState } from '@/components/EmptyState';
import { useAuth } from '@/hooks/useAuth';

export default function MyReelsScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { user } = useAuth();

    const [loading, setLoading] = useState(true);
    const [reels, setReels] = useState<Reel[]>([]);

    useFocusEffect(
        useCallback(() => {
            if (user) {
                loadMyReels();
            }
        }, [user])
    );

    const loadMyReels = async () => {
        try {
            setLoading(true);
            const data = await reelsService.getUserReels(user!.id);
            setReels(data);
        } catch (error) {
            console.error('Failed to load reels:', error);
        } finally {
            setLoading(false);
        }
    };

    const renderReel = ({ item }: { item: Reel }) => (
        <TouchableOpacity
            style={styles.reelCard}
            onPress={() => router.push('/(tabs)/reels' as any)}
        >
            <Image source={{ uri: item.thumbnailUrl }} style={styles.thumbnail} />
            <View style={styles.overlay}>
                <PlayCircle size={32} color="#fff" weight="fill" />
            </View>
            <View style={styles.stats}>
                <Text style={styles.statText}>{formatCount(item.viewCount)} views</Text>
            </View>
        </TouchableOpacity>
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
                    My Reels
                </Text>
                <TouchableOpacity>
                    <Plus size={24} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} weight="bold" />
                </TouchableOpacity>
            </View>

            {reels.length === 0 ? (
                <EmptyState
                    icon="reel"
                    title="No reels yet"
                    message="Upload your first reel to engage students!"
                />
            ) : (
                <FlatList
                    data={reels}
                    renderItem={renderReel}
                    keyExtractor={(item) => item.id}
                    numColumns={3}
                    contentContainerStyle={styles.grid}
                    columnWrapperStyle={styles.row}
                />
            )}
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
    grid: {
        padding: 2,
    },
    row: {
        gap: 2,
    },
    reelCard: {
        flex: 1,
        aspectRatio: 9 / 16,
        position: 'relative',
        margin: 1,
    },
    thumbnail: {
        width: '100%',
        height: '100%',
        borderRadius: radius.sm,
    },
    overlay: {
        position: 'absolute',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'rgba(0,0,0,0.3)',
        borderRadius: radius.sm,
    },
    stats: {
        position: 'absolute',
        bottom: 8,
        left: 8,
    },
    statText: {
        color: '#fff',
        fontSize: 12,
        fontWeight: '600',
        textShadowColor: 'rgba(0, 0, 0, 0.75)',
        textShadowOffset: { width: 0, height: 1 },
        textShadowRadius: 3,
    },
});
