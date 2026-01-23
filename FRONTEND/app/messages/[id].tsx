/**
 * Chat Screen
 * Real-time messaging interface
 */

import { useState, useEffect, useRef } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    TextInput,
    TouchableOpacity,
    useColorScheme,
    KeyboardAvoidingView,
    Platform,
} from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { ArrowLeft, PaperPlaneRight } from 'phosphor-react-native';
import { AppColors } from '../../src/theme/colors';
import { typography } from '../../src/theme/typography';
import { spacing } from '../../src/theme/spacing';
import { radius } from '../../src/theme/radius';
import { messagingService, type Message } from '../../src/services/messaging.service';
import { Loading } from '../../src/components/Loading';
import { useAuth } from '../../src/hooks/useAuth';

export default function ChatScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { id } = useLocalSearchParams<{ id: string }>();
    const { user } = useAuth();
    const flatListRef = useRef<FlatList>(null);

    const [loading, setLoading] = useState(true);
    const [sending, setSending] = useState(false);
    const [messages, setMessages] = useState<Message[]>([]);
    const [inputText, setInputText] = useState('');

    useEffect(() => {
        if (id) {
            loadMessages();
            markAsRead();
        }
    }, [id]);

    const loadMessages = async () => {
        try {
            setLoading(true);
            const data = await messagingService.getMessages(id!);
            setMessages(data.reverse()); // Newest at bottom
        } catch (error) {
            console.error('Failed to load messages:', error);
        } finally {
            setLoading(false);
        }
    };

    const markAsRead = async () => {
        try {
            await messagingService.markAsRead(id!);
        } catch (error) {
            console.error('Failed to mark as read:', error);
        }
    };

    const handleSend = async () => {
        if (!inputText.trim() || sending) return;

        const messageText = inputText.trim();
        setInputText('');

        try {
            setSending(true);
            await messagingService.sendMessage(id!, messageText);
            await loadMessages(); // Reload to get new message
            flatListRef.current?.scrollToEnd({ animated: true });
        } catch (error) {
            console.error('Failed to send message:', error);
            setInputText(messageText); // Restore text on error
        } finally {
            setSending(false);
        }
    };

    const renderMessage = ({ item }: { item: Message }) => {
        const isMyMessage = item.senderId === user?.id;

        return (
            <View style={[
                styles.messageContainer,
                isMyMessage ? styles.myMessage : styles.theirMessage
            ]}>
                <View style={[
                    styles.messageBubble,
                    {
                        backgroundColor: isMyMessage
                            ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                            : (isDark ? AppColors.surfaceDark : AppColors.surface)
                    }
                ]}>
                    <Text style={[
                        typography.body,
                        {
                            color: isMyMessage
                                ? '#fff'
                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                        }
                    ]}>
                        {item.content}
                    </Text>
                    <Text style={[
                        typography.caption,
                        styles.timestamp,
                        {
                            color: isMyMessage
                                ? 'rgba(255,255,255,0.7)'
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)
                        }
                    ]}>
                        {formatTime(item.createdAt)}
                    </Text>
                </View>
            </View>
        );
    };

    if (loading) {
        return <Loading fullScreen />;
    }

    return (
        <KeyboardAvoidingView
            style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}
            behavior={Platform.OS === 'ios' ? 'padding' : undefined}
            keyboardVerticalOffset={Platform.OS === 'ios' ? 90 : 0}
        >
            {/* Header */}
            <View style={[styles.header, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
                    <ArrowLeft size={24} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                </TouchableOpacity>
                <Text style={[typography.title, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Chat
                </Text>
                <View style={{ width: 24 }} />
            </View>

            {/* Messages List */}
            <FlatList
                ref={flatListRef}
                data={messages}
                renderItem={renderMessage}
                keyExtractor={(item) => item.id}
                contentContainerStyle={styles.messagesList}
                showsVerticalScrollIndicator={false}
                onContentSizeChange={() => flatListRef.current?.scrollToEnd({ animated: false })}
            />

            {/* Input */}
            <View style={[styles.inputContainer, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}>
                <TextInput
                    style={[styles.input, {
                        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}
                    placeholder="Type a message..."
                    placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                    value={inputText}
                    onChangeText={setInputText}
                    multiline
                    maxLength={1000}
                />
                <TouchableOpacity
                    style={[styles.sendButton, {
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                        opacity: (!inputText.trim() || sending) ? 0.5 : 1
                    }]}
                    onPress={handleSend}
                    disabled={!inputText.trim() || sending}
                >
                    <PaperPlaneRight size={20} color="#fff" weight="fill" />
                </TouchableOpacity>
            </View>
        </KeyboardAvoidingView>
    );
}

function formatTime(dateString: string): string {
    const date = new Date(dateString);
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
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
        elevation: 2,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
    },
    backButton: {
        padding: 4,
    },
    messagesList: {
        padding: spacing.md,
    },
    messageContainer: {
        marginBottom: spacing.sm,
        maxWidth: '80%',
    },
    myMessage: {
        alignSelf: 'flex-end',
    },
    theirMessage: {
        alignSelf: 'flex-start',
    },
    messageBubble: {
        padding: spacing.md,
        borderRadius: radius.large,
    },
    timestamp: {
        fontSize: 11,
        marginTop: 4,
    },
    inputContainer: {
        flexDirection: 'row',
        padding: spacing.md,
        gap: spacing.sm,
        elevation: 4,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: -2 },
        shadowOpacity: 0.1,
        shadowRadius: 4,
    },
    input: {
        flex: 1,
        borderRadius: radius.large,
        paddingHorizontal: spacing.md,
        paddingVertical: spacing.sm,
        maxHeight: 100,
        fontSize: 16,
    },
    sendButton: {
        width: 44,
        height: 44,
        borderRadius: 22,
        justifyContent: 'center',
        alignItems: 'center',
    },
});
