/**
 * Messages Screen
 * Conversation list with last messages
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
    useColorScheme,
} from 'react-native';
import { useRouter } from 'expo-router';
import { ChatCircle, User } from 'phosphor-react-native';
import { AppColors } from '../../src/theme/colors';
import { typography } from '../../src/theme/typography';
import { spacing } from '../../src/theme/spacing';
import { radius } from '../../src/theme/radius';
import { messagingService, type Conversation } from '../../src/services/messaging.service';
import { Loading } from '../../src/components/Loading';
import { EmptyState } from '../../src/components/EmptyState';

export default function MessagesScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [loading, setLoading] = useState(true);
    const [conversations, setConversations] = useState<Conversation[]>([]);

    useEffect(() => {
        loadConversations();
    }, []);

    const loadConversations = async () => {
        try {
            setLoading(true);
            const data = await messagingService.getConversations();
            setConversations(data);
        } catch (error) {
            console.error('Failed to load conversations:', error);
        } finally {
            setLoading(false);
        }
    };

    const renderConversation = ({ item }: { item: Conversation }) => (
        <TouchableOpacity
            style={[styles.conversationCard, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}
            onPress={() => router.push(`/messages/${item.id}` as any)}
        >
            {/* Avatar */}
            <View style={[styles.avatar, {
                backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
            }]}>
                <User size={24} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
            </View>

            {/* Content */}
            <View style={styles.conversationContent}>
                <View style={styles.header}>
                    <Text style={[typography.title, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]} numberOfLines={1}>
                        {item.otherUserName || 'User'}
                    </Text>
                    <Text style={[typography.caption, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        {formatTime(item.lastMessageAt)}
                    </Text>
                </View>

                <Text style={[typography.body, styles.lastMessage, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]} numberOfLines={1}>
                    {item.lastMessage || 'No messages yet'}
                </Text>

                {/* Unread Badge */}
                {item.unreadCount && item.unreadCount > 0 && (
                    <View style={[styles.unreadBadge, {
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                    }]}>
                        <Text style={[typography.caption, styles.unreadText]}>
                            {item.unreadCount}
                        </Text>
                    </View>
                )}
            </View>
        </TouchableOpacity>
    );

    if (loading) {
        return <Loading fullScreen />;
    }

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.headerContainer}>
                <Text style={[typography.hero, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                    Messages
                </Text>
            </View>

            {/* Conversations List */}
            {conversations.length === 0 ? (
                <EmptyState
                    icon="messages"
                    title="No messages yet"
                    message="Start a conversation with an instructor or student"
                />
            ) : (
                <FlatList
                    data={conversations}
                    renderItem={renderConversation}
                    keyExtractor={(item) => item.id}
                    contentContainerStyle={styles.list}
                    showsVerticalScrollIndicator={false}
                />
            )}
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
    return date.toLocaleDateString();
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    headerContainer: {
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    list: {
        padding: spacing.md,
    },
    conversationCard: {
        flexDirection: 'row',
        padding: spacing.md,
        borderRadius: radius.large,
        marginBottom: spacing.sm,
        elevation: 1,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.05,
        shadowRadius: 4,
    },
    avatar: {
        width: 56,
        height: 56,
        borderRadius: 28,
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: spacing.md,
    },
    conversationContent: {
        flex: 1,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: 4,
    },
    lastMessage: {
        fontSize: 14,
    },
    unreadBadge: {
        position: 'absolute',
        right: 0,
        bottom: 0,
        minWidth: 20,
        height: 20,
        borderRadius: 10,
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: 6,
    },
    unreadText: {
        color: '#fff',
        fontSize: 11,
        fontWeight: '600',
    },
});
