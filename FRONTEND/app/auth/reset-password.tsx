/**
 * Reset Password Screen
 * 
 * Set new password after OTP verification
 * Following ANTI-GRAVITY UI Constitution
 */

import { useState } from 'react';
import {
    View,
    Text,
    TextInput,
    TouchableOpacity,
    StyleSheet,
    useColorScheme,
    KeyboardAvoidingView,
    Platform,
    Alert,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Key, Lock, Eye, EyeSlash } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { useAuth } from '@/hooks/useAuth';

export default function ResetPasswordScreen() {
    const router = useRouter();
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const { resetPassword } = useAuth();

    const params = useLocalSearchParams<{ email: string; otp: string }>();
    const email = params.email || '';
    const otp = params.otp || '';

    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [showNewPassword, setShowNewPassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);
    const [loading, setLoading] = useState(false);

    const getPasswordStrength = (password: string): { text: string; color: string } => {
        if (password.length === 0) return { text: '', color: '' };
        if (password.length < 8) return { text: 'Weak', color: isDark ? AppColors.errorDark : AppColors.error };
        if (password.length < 12) return { text: 'Medium', color: isDark ? AppColors.warningDark : AppColors.warning };
        return { text: 'Strong', color: isDark ? AppColors.successDark : AppColors.success };
    };

    const handleResetPassword = async () => {
        if (!newPassword || !confirmPassword) {
            Alert.alert('Validation Error', 'Please fill in all fields');
            return;
        }

        if (newPassword.length < 8) {
            Alert.alert('Validation Error', 'Password must be at least 8 characters');
            return;
        }

        if (newPassword !== confirmPassword) {
            Alert.alert('Validation Error', 'Passwords do not match');
            return;
        }

        setLoading(true);
        try {
            await resetPassword({
                email,
                otp,
                newPassword,
            });

            Alert.alert(
                'Success',
                'Your password has been reset successfully',
                [
                    {
                        text: 'OK',
                        onPress: () => router.replace('/auth/login'),
                    },
                ]
            );
        } catch (error: any) {
            const message = error.message || 'Failed to reset password. Please try again.';
            Alert.alert('Error', message);
        } finally {
            setLoading(false);
        }
    };

    const passwordStrength = getPasswordStrength(newPassword);

    return (
        <KeyboardAvoidingView
            style={[
                styles.container,
                { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }
            ]}
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        >
            <View style={styles.content}>
                {/* Icon */}
                <View style={[
                    styles.iconContainer,
                    { backgroundColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt }
                ]}>
                    <Key
                        size={40}
                        color={isDark ? AppColors.primaryDarkMode : AppColors.primary}
                    />
                </View>

                {/* Header */}
                <View style={styles.header}>
                    <Text style={[
                        typography.hero,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, textAlign: 'center' }
                    ]}>
                        Reset Your Password
                    </Text>
                    <Text style={[
                        typography.body,
                        {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            marginTop: spacing.xs,
                            textAlign: 'center'
                        }
                    ]}>
                        Enter your new password
                    </Text>
                </View>

                {/* New Password Input */}
                <View style={styles.inputContainer}>
                    <Text style={[
                        typography.bodyMedium,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, marginBottom: spacing.xs }
                    ]}>
                        New Password
                    </Text>
                    <View style={[
                        styles.inputWrapper,
                        { backgroundColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt }
                    ]}>
                        <Lock
                            size={20}
                            color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            style={styles.inputIcon}
                        />
                        <TextInput
                            style={[
                                styles.input,
                                typography.body,
                                { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }
                            ]}
                            placeholder="Enter new password"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            value={newPassword}
                            onChangeText={setNewPassword}
                            secureTextEntry={!showNewPassword}
                            autoCapitalize="none"
                            autoComplete="password-new"
                            autoFocus
                        />
                        <TouchableOpacity
                            onPress={() => setShowNewPassword(!showNewPassword)}
                            style={styles.eyeIcon}
                        >
                            {showNewPassword ? (
                                <Eye size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                            ) : (
                                <EyeSlash size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                            )}
                        </TouchableOpacity>
                    </View>
                    {passwordStrength.text && (
                        <Text style={[
                            typography.caption,
                            { color: passwordStrength.color, marginTop: spacing.xs }
                        ]}>
                            Password strength: {passwordStrength.text}
                        </Text>
                    )}
                </View>

                {/* Confirm Password Input */}
                <View style={styles.inputContainer}>
                    <Text style={[
                        typography.bodyMedium,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, marginBottom: spacing.xs }
                    ]}>
                        Confirm Password
                    </Text>
                    <View style={[
                        styles.inputWrapper,
                        { backgroundColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt }
                    ]}>
                        <Lock
                            size={20}
                            color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            style={styles.inputIcon}
                        />
                        <TextInput
                            style={[
                                styles.input,
                                typography.body,
                                { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }
                            ]}
                            placeholder="Re-enter password"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            value={confirmPassword}
                            onChangeText={setConfirmPassword}
                            secureTextEntry={!showConfirmPassword}
                            autoCapitalize="none"
                            autoComplete="password-new"
                        />
                        <TouchableOpacity
                            onPress={() => setShowConfirmPassword(!showConfirmPassword)}
                            style={styles.eyeIcon}
                        >
                            {showConfirmPassword ? (
                                <Eye size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                            ) : (
                                <EyeSlash size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                            )}
                        </TouchableOpacity>
                    </View>
                </View>

                {/* Reset Password Button */}
                <TouchableOpacity
                    style={[
                        styles.resetButton,
                        { backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary }
                    ]}
                    onPress={handleResetPassword}
                    disabled={loading}
                >
                    <Text style={[typography.button, { color: '#FFFFFF' }]}>
                        {loading ? 'Resetting...' : 'Reset Password'}
                    </Text>
                </TouchableOpacity>

                {/* Cancel Button */}
                <TouchableOpacity
                    style={[
                        styles.cancelButton,
                        { borderColor: isDark ? AppColors.borderDark : AppColors.border }
                    ]}
                    onPress={() => router.replace('/auth/login')}
                    disabled={loading}
                >
                    <Text style={[
                        typography.button,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }
                    ]}>
                        Cancel
                    </Text>
                </TouchableOpacity>
            </View>
        </KeyboardAvoidingView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    content: {
        flex: 1,
        padding: spacing.lg,
        paddingTop: spacing.xxxl,
        alignItems: 'center',
    },
    iconContainer: {
        width: 80,
        height: 80,
        borderRadius: radius.full,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: spacing.xl,
    },
    header: {
        marginBottom: spacing.xl,
        alignItems: 'center',
    },
    inputContainer: {
        width: '100%',
        marginBottom: spacing.md,
    },
    inputWrapper: {
        flexDirection: 'row',
        alignItems: 'center',
        borderRadius: radius.medium,
        paddingHorizontal: spacing.md,
        height: 56,
    },
    inputIcon: {
        marginRight: spacing.sm,
    },
    input: {
        flex: 1,
        height: '100%',
    },
    eyeIcon: {
        padding: spacing.xs,
    },
    resetButton: {
        width: '100%',
        height: 56,
        borderRadius: radius.large,
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: spacing.lg,
        marginBottom: spacing.sm,
    },
    cancelButton: {
        width: '100%',
        height: 56,
        borderRadius: radius.large,
        justifyContent: 'center',
        alignItems: 'center',
        borderWidth: 1.5,
    },
});
