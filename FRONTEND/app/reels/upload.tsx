/**
 * Upload Reel Screen
 * Create and upload short-form video content
 */

import { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    TextInput,
    Image,
    useColorScheme,
    Alert,
    ActivityIndicator,
    ScrollView,
} from 'react-native';
import { useRouter } from 'expo-router';
import * as ImagePicker from 'expo-image-picker';
import { ArrowLeft, VideoCamera, Upload, X } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { reelsService } from '@/services/reels.service';

const CLOUDINARY_CLOUD_NAME = 'YOUR_CLOUD_NAME'; // Replace with actual cloud name
const CLOUDINARY_UPLOAD_PRESET = 'skillswapp_reels'; // Create this preset in Cloudinary

export default function UploadReelScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [video, setVideo] = useState<any>(null);
    const [thumbnail, setThumbnail] = useState<string | null>(null);
    const [title, setTitle] = useState('');
    const [description, setDescription] = useState('');
    const [uploading, setUploading] = useState(false);
    const [uploadProgress, setUploadProgress] = useState(0);

    const pickVideo = async () => {
        try {
            const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync();

            if (status !== 'granted') {
                Alert.alert('Permission Required', 'Please grant camera roll permissions to upload videos');
                return;
            }

            const result = await ImagePicker.launchImageLibraryAsync({
                mediaTypes: ImagePicker.MediaTypeOptions.Videos,
                allowsEditing: true,
                aspect: [9, 16],
                quality: 1,
                videoMaxDuration: 60, // 60 seconds max
            });

            if (!result.canceled && result.assets[0]) {
                const asset = result.assets[0];
                setVideo(asset);

                // Generate thumbnail (first frame)
                // In production, use expo-video-thumbnails
                setThumbnail(asset.uri);
            }
        } catch (error) {
            console.error('Error picking video:', error);
            Alert.alert('Error', 'Failed to pick video');
        }
    };

    const uploadToCloudinary = async (videoUri: string): Promise<string> => {
        const formData = new FormData();

        formData.append('file', {
            uri: videoUri,
            type: 'video/mp4',
            name: 'reel.mp4',
        } as any);

        formData.append('upload_preset', CLOUDINARY_UPLOAD_PRESET);
        formData.append('cloud_name', CLOUDINARY_CLOUD_NAME);

        try {
            const response = await fetch(
                `https://api.cloudinary.com/v1_1/${CLOUDINARY_CLOUD_NAME}/video/upload`,
                {
                    method: 'POST',
                    body: formData as any,
                    headers: {
                        'Accept': 'application/json',
                    },
                }
            );

            const data = await response.json();

            if (data.secure_url) {
                return data.secure_url;
            } else {
                throw new Error('Upload failed');
            }
        } catch (error) {
            console.error('Cloudinary upload error:', error);
            throw error;
        }
    };

    const handleUpload = async () => {
        if (!video) {
            Alert.alert('Error', 'Please select a video');
            return;
        }

        if (!title.trim()) {
            Alert.alert('Error', 'Please enter a title');
            return;
        }

        try {
            setUploading(true);
            setUploadProgress(10);

            // Upload to Cloudinary
            setUploadProgress(30);
            const videoUrl = await uploadToCloudinary(video.uri);

            setUploadProgress(70);

            // Save to backend
            await reelsService.createReel({
                videoUrl,
                thumbnailUrl: videoUrl.replace('/upload/', '/upload/so_0/'), // Cloudinary thumbnail
                title: title.trim(),
                description: description.trim(),
                duration: video.duration || 0,
            });

            setUploadProgress(100);

            Alert.alert('Success', 'Reel uploaded successfully!', [
                {
                    text: 'View',
                    onPress: () => router.replace('/(tabs)/reels' as any)
                }
            ]);
        } catch (error) {
            console.error('Upload failed:', error);
            Alert.alert('Error', 'Failed to upload reel. Please try again.');
        } finally {
            setUploading(false);
            setUploadProgress(0);
        }
    };

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
                    Upload Reel
                </Text>
                <View style={{ width: 24 }} />
            </View>

            <ScrollView contentContainerStyle={styles.content}>
                {/* Video Preview */}
                {!video ? (
                    <TouchableOpacity
                        style={[styles.uploadBox, {
                            borderColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        }]}
                        onPress={pickVideo}
                    >
                        <VideoCamera size={64} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                        <Text style={[typography.h4, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            marginTop: spacing.md
                        }]}>
                            Select Video
                        </Text>
                        <Text style={[typography.body, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            marginTop: spacing.xs,
                            textAlign: 'center'
                        }]}>
                            Max 60 seconds • 9:16 ratio
                        </Text>
                    </TouchableOpacity>
                ) : (
                    <View style={styles.videoPreview}>
                        <Image source={{ uri: thumbnail || video.uri }} style={styles.thumbnail} />
                        <TouchableOpacity
                            style={styles.removeButton}
                            onPress={() => {
                                setVideo(null);
                                setThumbnail(null);
                            }}
                        >
                            <X size={20} color="#fff" weight="bold" />
                        </TouchableOpacity>
                        <View style={styles.videoInfo}>
                            <Text style={[typography.caption, { color: '#fff' }]}>
                                {Math.round(video.duration || 0)}s
                            </Text>
                        </View>
                    </View>
                )}

                {/* Form Fields */}
                {video && (
                    <>
                        <View style={styles.inputGroup}>
                            <Text style={[typography.label, {
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                            }]}>
                                Title *
                            </Text>
                            <TextInput
                                style={[styles.input, {
                                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                }]}
                                placeholder="Give your reel a catchy title"
                                placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                                value={title}
                                onChangeText={setTitle}
                                maxLength={100}
                            />
                        </View>

                        <View style={styles.inputGroup}>
                            <Text style={[typography.label, {
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                            }]}>
                                Description
                            </Text>
                            <TextInput
                                style={[styles.input, styles.textArea, {
                                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                }]}
                                placeholder="Tell viewers what this reel is about..."
                                placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                                multiline
                                numberOfLines={4}
                                textAlignVertical="top"
                                value={description}
                                onChangeText={setDescription}
                                maxLength={500}
                            />
                        </View>

                        {/* Upload Button */}
                        <TouchableOpacity
                            style={[styles.uploadButton, {
                                backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                                opacity: uploading ? 0.7 : 1
                            }]}
                            onPress={handleUpload}
                            disabled={uploading}
                        >
                            {uploading ? (
                                <>
                                    <ActivityIndicator color="#fff" />
                                    <Text style={[typography.button, { color: '#fff', marginLeft: spacing.sm }]}>
                                        Uploading {uploadProgress}%
                                    </Text>
                                </>
                            ) : (
                                <>
                                    <Upload size={20} color="#fff" weight="bold" />
                                    <Text style={[typography.button, { color: '#fff', marginLeft: spacing.sm }]}>
                                        Upload Reel
                                    </Text>
                                </>
                            )}
                        </TouchableOpacity>

                        {/* Upload Progress Bar */}
                        {uploading && (
                            <View style={[styles.progressBar, {
                                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                            }]}>
                                <View style={[styles.progressFill, {
                                    width: `${uploadProgress}%`,
                                    backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                                }]} />
                            </View>
                        )}
                    </>
                )}
            </ScrollView>
        </View>
    );
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
    },
    backButton: {
        padding: 4,
    },
    content: {
        padding: spacing.md,
        paddingBottom: spacing.xxl,
    },
    uploadBox: {
        borderWidth: 2,
        borderStyle: 'dashed',
        borderRadius: radius.lg,
        padding: spacing.xxl,
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: 300,
        marginBottom: spacing.xl,
    },
    videoPreview: {
        width: '100%',
        aspectRatio: 9 / 16,
        borderRadius: radius.lg,
        overflow: 'hidden',
        marginBottom: spacing.xl,
        position: 'relative',
    },
    thumbnail: {
        width: '100%',
        height: '100%',
    },
    removeButton: {
        position: 'absolute',
        top: spacing.sm,
        right: spacing.sm,
        backgroundColor: 'rgba(0,0,0,0.6)',
        borderRadius: 20,
        width: 32,
        height: 32,
        justifyContent: 'center',
        alignItems: 'center',
    },
    videoInfo: {
        position: 'absolute',
        bottom: spacing.sm,
        left: spacing.sm,
        backgroundColor: 'rgba(0,0,0,0.6)',
        paddingHorizontal: spacing.sm,
        paddingVertical: 4,
        borderRadius: radius.sm,
    },
    inputGroup: {
        marginBottom: spacing.lg,
    },
    input: {
        borderRadius: radius.lg,
        padding: spacing.md,
        fontSize: 16,
        marginTop: spacing.xs,
    },
    textArea: {
        minHeight: 100,
    },
    uploadButton: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        padding: spacing.md,
        borderRadius: radius.lg,
        marginTop: spacing.lg,
    },
    progressBar: {
        height: 4,
        borderRadius: 2,
        overflow: 'hidden',
        marginTop: spacing.md,
    },
    progressFill: {
        height: '100%',
        borderRadius: 2,
    },
});
