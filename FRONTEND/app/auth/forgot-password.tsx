/**
 * Forgot Password Screen
 * 
 * Request password reset OTP
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
import { useRouter } from 'expo-router';
import { Key, Envelope, ArrowLeft } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { useAuth } from '@/hooks/useAuth';

export default function ForgotPasswordScreen() {
    const router = useRouter();
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const { forgotPassword } = useAuth();

    const [email, setEmail] = useState('');
    const [loading, setLoading] = useState(false);

    const handleSendCode = async () => {
        if (!email.trim()) {
            Alert.alert('Validation Error', 'Please enter your email address');
            return;
        }

        if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
            Alert.alert('Validation Error', 'Please enter a valid email address');
            return;
        }

        setLoading(true);
        try {
            await forgotPassword(email.trim());

            // Navigate to verification screen
            router.push({
                pathname: '/auth/verification',
                params: { email: email.trim(), context: 'password-reset' },
            });
        } catch (error: any) {
            Alert.alert('Error', 'Failed to send verification code. Please try again.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <KeyboardAvoidingView
            style={[
                styles.container,
                { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }
            ]}
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        >
            <View style={styles.content}>
                {/* Back Button */}
                <TouchableOpacity
                    style={styles.backButton}
                    onPress={() => router.back()}
                >
                    <ArrowLeft
                        size={24}
                        color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary}
                    />
                </TouchableOpacity>

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
                        Forgot Your Password?
                    </Text>
                    <Text style={[
                        typography.body,
                        {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            marginTop: spacing.xs,
                            textAlign: 'center'
                        }
                    ]}>
                        Enter your email to receive a verification code
                    </Text>
                </View>

                {/* Email Input */}
                <View style={styles.inputContainer}>
                    <View style={[
                        styles.inputWrapper,
                        { backgroundColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt }
                    ]}>
                        <Envelope
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
                            placeholder="Enter your email"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            value={email}
                            onChangeText={setEmail}
                            keyboardType="email-address"
                            autoCapitalize="none"
                            autoComplete="email"
                            autoFocus
                        />
                    </View>
                </View>

                {/* Send Code Button */}
                <TouchableOpacity
                    style={[
                        styles.sendButton,
                        { backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary }
                    ]}
                    onPress={handleSendCode}
                    disabled={loading}
                >
                    <Text style={[typography.button, { color: '#FFFFFF' }]}>
                        {loading ? 'Sending...' : 'Send Code'}
                    </Text>
                </TouchableOpacity>

                {/* Back to Login */}
                <TouchableOpacity
                    style={styles.backToLogin}
                    onPress={() => router.back()}
                >
                    <ArrowLeft
                        size={16}
                        color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                        style={{ marginRight: 4 }}
                    />
                    <Text style={[
                        typography.body,
                        { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }
                    ]}>
                        back to login
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
        paddingTop: spacing.xxl,
        alignItems: 'center',
    },
    backButton: {
        alignSelf: 'flex-start',
        width: 40,
        height: 40,
        justifyContent: 'center',
        marginBottom: spacing.md,
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
        marginBottom: spacing.lg,
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
    sendButton: {
        width: '100%',
        height: 56,
        borderRadius: radius.large,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: spacing.lg,
    },
    backToLogin: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: spacing.md,
    },
});
