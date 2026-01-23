/**
 * Upload Certificate Screen
 * Upload PDF/Image certificate for verification
 */

import { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    Image,
    useColorScheme,
    Alert,
    ActivityIndicator,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { ArrowLeft, Upload, FilePdf, FileImage, CheckCircle } from 'phosphor-react-native';
import * as DocumentPicker from 'expo-document-picker';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { verificationService } from '@/services/verification.service';

export default function UploadCertificateScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { categoryId, categoryName } = useLocalSearchParams<{ categoryId: string; categoryName: string }>();

    const [file, setFile] = useState<any>(null);
    const [uploading, setUploading] = useState(false);

    const pickDocument = async () => {
        try {
            const result = await DocumentPicker.getDocumentAsync({
                type: ['application/pdf', 'image/*'],
                copyToCacheDirectory: true,
            });

            if (result.assets && result.assets.length > 0) {
                setFile(result.assets[0]);
            }
        } catch (error) {
            console.error('Error picking document:', error);
            Alert.alert('Error', 'Failed to pick document');
        }
    };

    const handleUpload = async () => {
        if (!file) return;

        try {
            setUploading(true);

            // Create FormData
            const formData = new FormData();
            formData.append('file', {
                uri: file.uri,
                type: file.mimeType,
                name: file.name,
            } as any);
            formData.append('categoryId', categoryId!);
            formData.append('categoryName', categoryName!);

            // Upload certificate
            await verificationService.uploadCertificate(formData);

            Alert.alert(
                'Success',
                'Certificate uploaded! Admin will review it within 24-48 hours.',
                [
                    {
                        text: 'OK',
                        onPress: () => router.replace('/tutor/verification/pending-approval' as any)
                    }
                ]
            );
        } catch (error) {
            console.error('Upload failed:', error);
            Alert.alert('Error', 'Failed to upload certificate. Please try again.');
        } finally {
            setUploading(false);
        }
    };

    const getFileIcon = () => {
        if (!file) return null;

        if (file.mimeType?.includes('pdf')) {
            return <FilePdf size={64} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />;
        }
        return <FileImage size={64} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />;
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
                    Upload Certificate
                </Text>
                <View style={{ width: 24 }} />
            </View>

            <View style={styles.content}>
                {/* Category Info */}
                <View style={[styles.categoryCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <Text style={[typography.caption, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        Selected Category
                    </Text>
                    <Text style={[typography.h3, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginTop: spacing.xs
                    }]}>
                        {categoryName}
                    </Text>
                </View>

                {/* Instructions */}
                <View style={[styles.instructionsCard, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <Text style={[typography.bodyMedium, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginBottom: spacing.sm
                    }]}>
                        Upload your certificate or credential
                    </Text>
                    <Text style={[typography.body, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        lineHeight: 22
                    }]}>
                        • Accepted formats: PDF, JPG, PNG{'\n'}
                        • Maximum file size: 10MB{'\n'}
                        • Certificate must be valid and legible{'\n'}
                        • Admin will review within 24-48 hours
                    </Text>
                </View>

                {/* Upload Area */}
                {!file ? (
                    <TouchableOpacity
                        style={[styles.uploadBox, {
                            borderColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        }]}
                        onPress={pickDocument}
                    >
                        <Upload size={48} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                        <Text style={[typography.h4, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            marginTop: spacing.md
                        }]}>
                            Choose File
                        </Text>
                        <Text style={[typography.body, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            marginTop: spacing.xs
                        }]}>
                            PDF, JPG, or PNG
                        </Text>
                    </TouchableOpacity>
                ) : (
                    <View style={[styles.filePreview, {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                    }]}>
                        {getFileIcon()}
                        <Text style={[typography.bodyMedium, {
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            marginTop: spacing.md
                        }]} numberOfLines={1}>
                            {file.name}
                        </Text>
                        <Text style={[typography.caption, {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                        }]}>
                            {(file.size / 1024 / 1024).toFixed(2)} MB
                        </Text>
                        <TouchableOpacity
                            style={styles.changeButton}
                            onPress={pickDocument}
                        >
                            <Text style={[typography.button, {
                                color: isDark ? AppColors.primaryDarkMode : AppColors.primary
                            }]}>
                                Change File
                            </Text>
                        </TouchableOpacity>
                    </View>
                )}

                {/* Upload Button */}
                {file && (
                    <TouchableOpacity
                        style={[styles.uploadButton, {
                            backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                            opacity: uploading ? 0.7 : 1
                        }]}
                        onPress={handleUpload}
                        disabled={uploading}
                    >
                        {uploading ? (
                            <ActivityIndicator color="#fff" />
                        ) : (
                            <>
                                <CheckCircle size={20} color="#fff" weight="bold" />
                                <Text style={[typography.button, { color: '#fff', marginLeft: spacing.sm }]}>
                                    Upload Certificate
                                </Text>
                            </>
                        )}
                    </TouchableOpacity>
                )}
            </View>
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
        flex: 1,
        padding: spacing.md,
    },
    categoryCard: {
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.lg,
    },
    instructionsCard: {
        padding: spacing.md,
        borderRadius: radius.lg,
        marginBottom: spacing.xl,
    },
    uploadBox: {
        borderWidth: 2,
        borderStyle: 'dashed',
        borderRadius: radius.lg,
        padding: spacing.xxl,
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: 200,
    },
    filePreview: {
        padding: spacing.xl,
        borderRadius: radius.lg,
        alignItems: 'center',
        marginBottom: spacing.lg,
    },
    changeButton: {
        marginTop: spacing.md,
        padding: spacing.sm,
    },
    uploadButton: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        padding: spacing.md,
        borderRadius: radius.lg,
    },
});
