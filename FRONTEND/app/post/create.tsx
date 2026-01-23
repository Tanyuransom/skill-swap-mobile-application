/**
 * Create Post Modal
 * Twitter-style compose screen
 */

import { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TextInput,
    TouchableOpacity,
    useColorScheme,
    Image,
    KeyboardAvoidingView,
    Platform,
    Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import { X, Image as ImageIcon, PaperPlaneRight } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { socialFeedService } from '@/services/social-feed.service';
import { useAuth } from '@/hooks/useAuth';

export default function CreatePostScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { user } = useAuth();

    const [text, setText] = useState('');
    const [submitting, setSubmitting] = useState(false);

    // TODO: Implement image picker
    const [mediaUrl, setMediaUrl] = useState<string | undefined>(undefined);

    const handleSubmit = async () => {
        if (!text.trim() && !mediaUrl) return;

        try {
            setSubmitting(true);
            await socialFeedService.createPost({
                postType: mediaUrl ? 'image' : 'text',
                description: text,
                mediaUrl,
            });
            router.back();
        } catch (error) {
            console.error('Failed to create post:', error);
            Alert.alert('Error', 'Failed to create post');
        } finally {
            setSubmitting(false);
        }
    };

    const remainingChars = 280 - text.length;
    const isLengthValid = remainingChars >= 0;

    return (
        <KeyboardAvoidingView
            style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}
            behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        >
            {/* Header */}
            <View style={[styles.header, { borderBottomColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}>
                <TouchableOpacity onPress={() => router.back()} style={styles.closeButton}>
                    <X size={24} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                </TouchableOpacity>
                <TouchableOpacity
                    style={[styles.postButton, {
                        backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                        opacity: (!text.trim() || !isLengthValid || submitting) ? 0.5 : 1
                    }]}
                    onPress={handleSubmit}
                    disabled={!text.trim() || !isLengthValid || submitting}
                >
                    <Text style={[typography.button, { color: '#fff' }]}>
                        Post
                    </Text>
                </TouchableOpacity>
            </View>

            <View style={styles.content}>
                <View style={styles.inputRow}>
                    {/* User Avatar */}
                    <View style={[styles.avatar, {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                    }]}>
                        {/* Placeholder for now */}
                    </View>

                    <View style={styles.inputContainer}>
                        <TextInput
                            style={[styles.input, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}
                            placeholder="What's happening?"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            multiline
                            autoFocus
                            value={text}
                            onChangeText={setText}
                            textAlignVertical="top"
                        />

                        {/* Selected Image Preview (User uploaded_image_0 placeholder for now) */}
                        {mediaUrl && (
                            <View style={styles.mediaPreview}>
                                <Image source={{ uri: mediaUrl }} style={styles.previewImage} />
                                <TouchableOpacity
                                    style={styles.removeMedia}
                                    onPress={() => setMediaUrl(undefined)}
                                >
                                    <X size={16} color="#fff" />
                                </TouchableOpacity>
                            </View>
                        )}
                    </View>
                </View>
            </View>

            {/* Toolbar */}
            <View style={[styles.toolbar, { borderTopColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}>
                <TouchableOpacity style={styles.toolButton}>
                    <ImageIcon size={24} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                </TouchableOpacity>

                <View style={styles.spacer} />

                <Text style={[typography.caption, {
                    color: !isLengthValid ? '#EF4444' : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)
                }]}>
                    {remainingChars}
                </Text>
            </View>
        </KeyboardAvoidingView>
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
        paddingTop: Platform.OS === 'ios' ? spacing.xl : spacing.md,
        borderBottomWidth: 1,
    },
    closeButton: {
        padding: 4,
    },
    postButton: {
        paddingHorizontal: spacing.lg,
        paddingVertical: 8,
        borderRadius: radius.full,
    },
    content: {
        flex: 1,
        padding: spacing.md,
    },
    inputRow: {
        flexDirection: 'row',
    },
    avatar: {
        width: 40,
        height: 40,
        borderRadius: 20,
        marginRight: spacing.md,
    },
    inputContainer: {
        flex: 1,
    },
    input: {
        fontSize: 18,
        minHeight: 120,
    },
    toolbar: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: spacing.md,
        borderTopWidth: 1,
    },
    toolButton: {
        padding: 8,
    },
    spacer: {
        flex: 1,
    },
    mediaPreview: {
        marginTop: spacing.md,
        borderRadius: radius.lg,
        overflow: 'hidden',
        position: 'relative',
    },
    previewImage: {
        width: '100%',
        height: 200,
        borderRadius: radius.lg,
    },
    removeMedia: {
        position: 'absolute',
        top: 8,
        right: 8,
        backgroundColor: 'rgba(0,0,0,0.6)',
        borderRadius: 12,
        padding: 4,
    },
});
