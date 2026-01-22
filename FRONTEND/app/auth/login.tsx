/**
 * Login Screen
 * 
 * Professional login with email/password and social auth
 * Following ANTI-GRAVITY UI Constitution
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    TextInput,
    TouchableOpacity,
    StyleSheet,
    useColorScheme,
    KeyboardAvoidingView,
    Platform,
    ScrollView,
    Alert,
    Image,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Eye, EyeSlash, Envelope, Lock } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { useRef } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { googleAuthService, useGoogleAuth } from '@/services/google-auth.service';

export default function LoginScreen() {
    const router = useRouter();
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const { login } = useAuth();

    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [showPassword, setShowPassword] = useState(false);
    const [keepLoggedIn, setKeepLoggedIn] = useState(false);
    const [loading, setLoading] = useState(false);

    // Google OAuth
    const { request, response, promptAsync } = useGoogleAuth();

    // Handle Google OAuth response
    useEffect(() => {
        if (response) {
            handleGoogleResponse();
        }
    }, [response]);

    const handleGoogleResponse = async () => {
        try {
            const authResponse = await googleAuthService.handleGoogleResponse(response);
            if (authResponse) {
                router.replace('/(tabs)/feed');
            }
        } catch (error: any) {
            Alert.alert('Google Sign-In Failed', error.message);
        }
    };

    const handleLogin = async () => {
        if (!email.trim() || !password) {
            Alert.alert('Validation Error', 'Please enter email and password');
            return;
        }

        setLoading(true);
        try {
            await login({ email: email.trim(), password });
            // Navigate to main app
            router.replace('/(tabs)/feed');
        } catch (error: any) {
            setLoading(false);

            // Handle specific error cases
            const status = (error as any).status;
            const message = error.message || 'Login failed';

            if (status === 403 && message.includes('not verified')) {
                // Email not verified
                Alert.alert(
                    'Email Not Verified',
                    'Please verify your email address. Would you like us to resend the verification code?',
                    [
                        { text: 'Cancel', style: 'cancel' },
                        {
                            text: 'Resend Code',
                            onPress: () => {
                                router.push({
                                    pathname: '/auth/verification',
                                    params: { email: email.trim(), context: 'signup' },
                                });
                            },
                        },
                    ]
                );
            } else if (status === 403 && message.includes('inactive')) {
                // Account inactive
                Alert.alert('Account Inactive', 'Your account has been deactivated. Please contact support.');
            } else if (status === 401) {
                // Invalid credentials
                Alert.alert('Login Failed', 'Invalid email or password');
            } else {
                // Generic error
                Alert.alert('Login Failed', message);
            }
        }
    };

    const handleGoogleLogin = async () => {
        try {
            await promptAsync();
        } catch (error: any) {
            Alert.alert('Error', 'Failed to initiate Google sign-in');
        }
    };

    const handleAppleLogin = () => {
        // TODO: Implement Apple login
        Alert.alert('Coming Soon', 'Apple sign-in will be available soon');
    };

    return (
        <KeyboardAvoidingView
            style={[
                styles.container,
                { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }
            ]}
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        >
            <ScrollView
                contentContainerStyle={styles.scrollContent}
                showsVerticalScrollIndicator={false}
            >
                {/* Header */}
                <View style={styles.header}>
                    <Text style={[
                        typography.hero,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }
                    ]}>
                        Login account
                    </Text>
                    <Text style={[
                        typography.body,
                        { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, marginTop: spacing.xs }
                    ]}>
                        Welcome back!
                    </Text>
                </View>

                {/* Email Input */}
                <View style={styles.inputContainer}>
                    <Text style={[
                        typography.bodyMedium,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, marginBottom: spacing.xs }
                    ]}>
                        Email
                    </Text>
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
                            placeholder="example@gmail.com"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            value={email}
                            onChangeText={setEmail}
                            keyboardType="email-address"
                            autoCapitalize="none"
                            autoComplete="email"
                        />
                    </View>
                </View>

                {/* Password Input */}
                <View style={styles.inputContainer}>
                    <Text style={[
                        typography.bodyMedium,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, marginBottom: spacing.xs }
                    ]}>
                        Password
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
                            placeholder="Enter password"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            value={password}
                            onChangeText={setPassword}
                            secureTextEntry={!showPassword}
                            autoCapitalize="none"
                            autoComplete="password"
                        />
                        <TouchableOpacity
                            onPress={() => setShowPassword(!showPassword)}
                            style={styles.eyeIcon}
                        >
                            {showPassword ? (
                                <Eye size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                            ) : (
                                <EyeSlash size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                            )}
                        </TouchableOpacity>
                    </View>
                </View>

                {/* Keep Logged In & Forgot Password */}
                <View style={styles.optionsRow}>
                    <TouchableOpacity
                        style={styles.checkboxRow}
                        onPress={() => setKeepLoggedIn(!keepLoggedIn)}
                    >
                        <View style={[
                            styles.checkbox,
                            {
                                backgroundColor: keepLoggedIn
                                    ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                    : 'transparent',
                                borderColor: isDark ? AppColors.borderDark : AppColors.border,
                            }
                        ]} />
                        <Text style={[
                            typography.body,
                            { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, marginLeft: spacing.xs }
                        ]}>
                            Keep me logged in
                        </Text>
                    </TouchableOpacity>

                    <TouchableOpacity onPress={() => router.push('/auth/forgot-password')}>
                        <Text style={[
                            typography.body,
                            { color: isDark ? AppColors.primaryDarkMode : AppColors.primary }
                        ]}>
                            Forgot password?
                        </Text>
                    </TouchableOpacity>
                </View>

                {/* Login Button */}
                <TouchableOpacity
                    style={[
                        styles.loginButton,
                        { backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary }
                    ]}
                    onPress={handleLogin}
                    disabled={loading}
                >
                    <Text style={[typography.button, { color: '#FFFFFF' }]}>
                        {loading ? 'Logging in...' : 'Login'}
                    </Text>
                </TouchableOpacity>

                {/* Divider */}
                <View style={styles.divider}>
                    <View style={[styles.dividerLine, { backgroundColor: isDark ? AppColors.borderDark : AppColors.border }]} />
                    <Text style={[
                        typography.caption,
                        { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, marginHorizontal: spacing.sm }
                    ]}>
                        Or sign up with
                    </Text>
                    <View style={[styles.dividerLine, { backgroundColor: isDark ? AppColors.borderDark : AppColors.border }]} />
                </View>

                {/* Social Login Buttons */}
                <View style={styles.socialButtons}>
                    <TouchableOpacity
                        style={[
                            styles.socialButton,
                            { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface, borderColor: isDark ? AppColors.borderDark : AppColors.border }
                        ]}
                        onPress={handleGoogleLogin}
                    >
                        <Image
                            source={require('../../assets/images/google-logo.png')}
                            style={styles.socialIcon}
                            resizeMode="contain"
                        />
                        <Text style={[typography.button, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                            Google
                        </Text>
                    </TouchableOpacity>

                    <TouchableOpacity
                        style={[
                            styles.socialButton,
                            { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface, borderColor: isDark ? AppColors.borderDark : AppColors.border }
                        ]}
                        onPress={handleAppleLogin}
                    >
                        <Image
                            source={require('../../assets/images/apple-logo.png')}
                            style={styles.socialIcon}
                            resizeMode="contain"
                        />
                        <Text style={[typography.button, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                            Apple
                        </Text>
                    </TouchableOpacity>
                </View>

                {/* Sign Up Link */}
                <TouchableOpacity
                    style={styles.signupLink}
                    onPress={() => router.push('/auth/register')}
                >
                    <Text style={[
                        typography.body,
                        { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }
                    ]}>
                        Don't have an account?{' '}
                        <Text style={{ color: isDark ? AppColors.primaryDarkMode : AppColors.primary, fontWeight: '600' }}>
                            Sign up
                        </Text>
                    </Text>
                </TouchableOpacity>
            </ScrollView>
        </KeyboardAvoidingView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    scrollContent: {
        padding: spacing.lg,
        paddingTop: spacing.xxl,
    },
    header: {
        marginBottom: spacing.xl,
    },
    inputContainer: {
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
    optionsRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: spacing.lg,
    },
    checkboxRow: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    checkbox: {
        width: 20,
        height: 20,
        borderRadius: 4,
        borderWidth: 2,
    },
    loginButton: {
        height: 56,
        borderRadius: radius.large,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: spacing.lg,
    },
    divider: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: spacing.lg,
    },
    dividerLine: {
        flex: 1,
        height: 1,
    },
    socialButtons: {
        flexDirection: 'row',
        gap: spacing.md,
        marginBottom: spacing.xl,
    },
    socialButton: {
        flex: 1,
        height: 56,
        borderRadius: radius.large,
        borderWidth: 1.5,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        gap: spacing.xs,
    },
    socialIcon: {
        width: 20,
        height: 20,
    },
    signupLink: {
        alignItems: 'center',
        marginTop: spacing.md,
    },
});
