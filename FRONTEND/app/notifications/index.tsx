/**
 * Notifications Screen
 * Display and manage user notifications
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
    useColorScheme,
    Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import {
    Bell,
    BookOpen,
    ChatCircle,
    GraduationCap,
    Star,
    Info,
    Trash,
} from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { notificationService, type Notification } from '@/services/notification.service';
import { Loading } from '@/components/Loading';
import { EmptyState } from '@/components/EmptyState';

export default function NotificationsScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [loading, setLoading] = useState(true);
    const [notifications, setNotifications] = useState<Notification[]>([]);

    useEffect(() => {
        loadNotifications();
    }, []);

    const loadNotifications = async () => {
        try {
            setLoading(true);
            const data = await notificationService.getNotifications();
            setNotifications(data);
        } catch (error) {
            console.error('Failed to load notifications:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleNotificationPress = async (notification: Notification) => {
        // Mark as read
        if (!notification.isRead) {
            try {
                await notificationService.markAsRead(notification.id);
                setNotifications(prev =>
                    prev.map(n => n.id === notification.id ? { ...n, isRead: true } : n)
                );
            } catch (error) {
                console.error('Failed to mark as read:', error);
            }
        }

        // Navigate based on type
        if (notification.type === 'course_update' && notification.relatedId) {
            router.push(`/courses/${notification.relatedId}` as any);
        } else if (notification.type === 'new_message') {
            router.push('/(tabs)/messages' as any);
        } else if (notification.type === 'enrollment' && notification.relatedId) {
            router.push('/(tabs)/learning' as any);
        }
    };

    const handleDelete = async (notificationId: string) => {
        try {
            await notificationService.deleteNotification(notificationId);
            setNotifications(prev => prev.filter(n => n.id !== notificationId));
        } catch (error) {
            console.error('Failed to delete notification:', error);
            Alert.alert('Error', 'Failed to delete notification');
        }
    };

    const handleMarkAllRead = async () => {
        try {
            await notificationService.markAllAsRead();
            setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
        } catch (error) {
            console.error('Failed to mark all as read:', error);
            Alert.alert('Error', 'Failed to mark all as read');
        }
    };

    const getNotificationIcon = (type: string) => {
        switch (type) {
            case 'course_update':
                return BookOpen;
            case 'new_message':
                return ChatCircle;
            case 'enrollment':
                return GraduationCap;
            case 'review':
                return Star;
            default:
                return Info;
        }
    };

    const renderNotification = ({ item }: { item: Notification }) => {
        const Icon = getNotificationIcon(item.type);

        return (
            <TouchableOpacity
                style={[
                    styles.notificationCard,
                    {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                        borderLeftWidth: 3,
                        borderLeftColor: item.isRead
                            ? 'transparent'
                            : (isDark ? AppColors.primaryDarkMode : AppColors.primary),
                    }
                ]}
                onPress={() => handleNotificationPress(item)}
            >
                <View style={[styles.iconContainer, {
                    backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                }]}>
                    <Icon
                        size={24}
                        color={isDark ? AppColors.primaryDarkMode : AppColors.primary}
                        weight={item.isRead ? 'regular' : 'fill'}
                    />
                </View>

                <View style={styles.content}>
                    <Text style={[
                        typography.bodyMedium,
                        {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            fontWeight: item.isRead ? '400' : '600',
                        }
                    ]}>
                        {item.title}
                    </Text>
                    <Text style={[typography.body, styles.message, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]} numberOfLines={2}>
                        {item.message}
                    </Text>
                    <Text style={[typography.caption, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        {formatTime(item.createdAt)}
                    </Text>
                </View>

                <TouchableOpacity
                    style={styles.deleteButton}
                    onPress={() => handleDelete(item.id)}
                >
                    <Trash size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                </TouchableOpacity>
            </TouchableOpacity>
        );
    };

    if (loading) {
        return <Loading fullScreen />;
    }

    const unreadCount = notifications.filter(n => !n.isRead).length;

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.header}>
                <View>
                    <Text style={[typography.hero, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        Notifications
                    </Text>
                    {unreadCount > 0 && (
                        <Text style={[typography.body, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            {unreadCount} unread
                        </Text>
                    )}
                </View>
                {unreadCount > 0 && (
                    <TouchableOpacity
                        style={[styles.markAllButton, {
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                        }]}
                        onPress={handleMarkAllRead}
                    >
                        <Text style={[typography.caption, {
                            color: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                            fontWeight: '600',
                        }]}>
                            Mark all read
                        </Text>
                    </TouchableOpacity>
                )}
            </View>

            {/* Notifications List */}
            {notifications.length === 0 ? (
                <EmptyState
                    icon="notifications"
                    title="No notifications"
                    message="You're all caught up!"
                />
            ) : (
                <FlatList
                    data={notifications}
                    renderItem={renderNotification}
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

    if (diffMins < 1) return 'Just now';
    if (diffMins < 60) return `${diffMins}m ago`;
    if (diffHours < 24) return `${diffHours}h ago`;
    if (diffDays < 7) return `${diffDays}d ago`;
    return date.toLocaleDateString();
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    markAllButton: {
        paddingHorizontal: spacing.md,
        paddingVertical: spacing.sm,
        borderRadius: radius.md,
    },
    list: {
        padding: spacing.md,
        gap: spacing.sm,
    },
    notificationCard: {
        flexDirection: 'row',
        padding: spacing.md,
        borderRadius: radius.lg,
        elevation: 1,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.05,
        shadowRadius: 4,
    },
    iconContainer: {
        width: 48,
        height: 48,
        borderRadius: 24,
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: spacing.md,
    },
    content: {
        flex: 1,
    },
    message: {
        marginTop: 4,
        marginBottom: 4,
    },
    deleteButton: {
        padding: 8,
    },
});
