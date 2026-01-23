/**
 * Register Screen
 * 
 * User registration with email/password
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
import { Envelope, Lock, Eye, EyeSlash, User } from 'phosphor-react-native';
import { AppColors } from '../src/theme/colors';
import { typography } from '../src/theme/typography';
import { spacing } from '../src/theme/spacing';
import { radius } from '../src/theme/radius';
import { useAuth } from '../src/hooks/useAuth';
import { UserRole } from '../src/types/auth.types';
import { googleAuthService, useGoogleAuth } from '../src/services/google-auth.service';

export default function RegisterScreen() {
    const router = useRouter();
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const { register } = useAuth();

    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [role, setRole] = useState<UserRole>('student');
    const [showPassword, setShowPassword] = useState(false);
    const [showConfirmPassword, setShowConfirmPassword] = useState(false);
    const [agreedToTerms, setAgreedToTerms] = useState(false);
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

    const handleGoogleLogin = async () => {
        try {
            await promptAsync();
        } catch (error: any) {
            Alert.alert('Error', 'Failed to initiate Google sign-in');
        }
    };

    const validateForm = (): string | null => {
        if (!firstName.trim()) return 'First name is required';
        if (!lastName.trim()) return 'Last name is required';
        if (!email.trim()) return 'Email is required';
        if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) return 'Invalid email format';
        if (password.length < 8) return 'Password must be at least 8 characters';
        if (password !== confirmPassword) return 'Passwords do not match';
        if (!agreedToTerms) return 'You must agree to Terms & Conditions';
        return null;
    };

    const handleRegister = async () => {
        const error = validateForm();
        if (error) {
            Alert.alert('Validation Error', error);
            return;
        }

        setLoading(true);
        try {
            const response = await register({
                email: email.trim(),
                password,
                role,
                firstName: firstName.trim(),
                lastName: lastName.trim(),
            });

            // Navigate to verification screen
            router.push({
                pathname: '/auth/verification',
                params: { email: response.email, context: 'signup' },
            });
        } catch (error: any) {
            const message = error.message || 'Registration failed. Please try again.';
            Alert.alert('Registration Error', message);
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
                        Create account
                    </Text>
                    <Text style={[
                        typography.body,
                        { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, marginTop: spacing.xs }
                    ]}>
                        Sign up to continue
                    </Text>
                </View>

                {/* First Name Input */}
                <View style={styles.inputContainer}>
                    <Text style={[
                        typography.bodyMedium,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, marginBottom: spacing.xs }
                    ]}>
                        First Name
                    </Text>
                    <View style={[
                        styles.inputWrapper,
                        { backgroundColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt }
                    ]}>
                        <User
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
                            placeholder="John"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            value={firstName}
                            onChangeText={setFirstName}
                            autoCapitalize="words"
                            autoComplete="given-name"
                        />
                    </View>
                </View>

                {/* Last Name Input */}
                <View style={styles.inputContainer}>
                    <Text style={[
                        typography.bodyMedium,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, marginBottom: spacing.xs }
                    ]}>
                        Last Name
                    </Text>
                    <View style={[
                        styles.inputWrapper,
                        { backgroundColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt }
                    ]}>
                        <User
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
                            placeholder="Doe"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            value={lastName}
                            onChangeText={setLastName}
                            autoCapitalize="words"
                            autoComplete="family-name"
                        />
                    </View>
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
                            placeholder="Create password"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            value={password}
                            onChangeText={setPassword}
                            secureTextEntry={!showPassword}
                            autoCapitalize="none"
                            autoComplete="password-new"
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

                {/* Role Selection */}
                <View style={styles.inputContainer}>
                    <Text style={[
                        typography.bodyMedium,
                        { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary, marginBottom: spacing.xs }
                    ]}>
                        I want to join as
                    </Text>
                    <View style={styles.roleContainer}>
                        <TouchableOpacity
                            style={[
                                styles.roleButton,
                                role === 'student' && styles.roleButtonActive,
                                {
                                    backgroundColor: role === 'student'
                                        ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                        : (isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt),
                                    borderColor: isDark ? AppColors.borderDark : AppColors.border,
                                }
                            ]}
                            onPress={() => setRole('student')}
                        >
                            <Text style={[
                                typography.button,
                                { color: role === 'student' ? '#FFFFFF' : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary) }
                            ]}>
                                Student
                            </Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            style={[
                                styles.roleButton,
                                role === 'tutor' && styles.roleButtonActive,
                                {
                                    backgroundColor: role === 'tutor'
                                        ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                        : (isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt),
                                    borderColor: isDark ? AppColors.borderDark : AppColors.border,
                                }
                            ]}
                            onPress={() => setRole('tutor')}
                        >
                            <Text style={[
                                typography.button,
                                { color: role === 'tutor' ? '#FFFFFF' : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary) }
                            ]}>
                                Tutor
                            </Text>
                        </TouchableOpacity>
                    </View>
                </View>

                {/* Terms & Conditions */}
                <TouchableOpacity
                    style={styles.checkboxRow}
                    onPress={() => setAgreedToTerms(!agreedToTerms)}
                >
                    <View style={[
                        styles.checkbox,
                        {
                            backgroundColor: agreedToTerms
                                ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                : 'transparent',
                            borderColor: isDark ? AppColors.borderDark : AppColors.border,
                        }
                    ]} />
                    <Text style={[
                        typography.body,
                        { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, marginLeft: spacing.xs, flex: 1 }
                    ]}>
                        I agree to the{' '}
                        <Text style={{ color: isDark ? AppColors.primaryDarkMode : AppColors.primary }}>
                            Terms and Conditions
                        </Text>
                    </Text>
                </TouchableOpacity>

                {/* Register Button */}
                <TouchableOpacity
                    style={[
                        styles.registerButton,
                        { backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary }
                    ]}
                    onPress={handleRegister}
                    disabled={loading}
                >
                    <Text style={[typography.button, { color: '#FFFFFF' }]}>
                        {loading ? 'Creating account...' : 'Create account'}
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

                {/* Login Link */}
                <TouchableOpacity
                    style={styles.loginLink}
                    onPress={() => router.push('/auth/login')}
                >
                    <Text style={[
                        typography.body,
                        { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }
                    ]}>
                        Already have an account?{' '}
                        <Text style={{ color: isDark ? AppColors.primaryDarkMode : AppColors.primary, fontWeight: '600' }}>
                            Login
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
    roleContainer: {
        flexDirection: 'row',
        gap: spacing.sm,
    },
    roleButton: {
        flex: 1,
        height: 56,
        borderRadius: radius.medium,
        justifyContent: 'center',
        alignItems: 'center',
        borderWidth: 1.5,
    },
    roleButtonActive: {
        borderWidth: 0,
    },
    checkboxRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: spacing.lg,
    },
    checkbox: {
        width: 20,
        height: 20,
        borderRadius: 4,
        borderWidth: 2,
    },
    registerButton: {
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
    loginLink: {
        alignItems: 'center',
        marginTop: spacing.md,
    },
});
