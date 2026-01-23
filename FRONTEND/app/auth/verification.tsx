/**
 * Verification Screen
 * 
 * OTP verification (reusable for signup and password reset)
 * Following ANTI-GRAVITY UI Constitution
 */

import { useState, useRef, useEffect } from 'react';
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
import { Envelope } from 'phosphor-react-native';
import { AppColors } from '../src/theme/colors';
import { typography } from '../src/theme/typography';
import { spacing } from '../src/theme/spacing';
import { radius } from '../src/theme/radius';
import { useAuth } from '../src/hooks/useAuth';
import { VerificationContext } from '../src/types/auth.types';

export default function VerificationScreen() {
    const router = useRouter();
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const { verifyOTP, resendOTP } = useAuth();

    const params = useLocalSearchParams<{ email: string; context: VerificationContext }>();
    const email = params.email || '';
    const context = params.context || 'signup';

    const [otp, setOtp] = useState(['', '', '', '', '', '']);
    const [loading, setLoading] = useState(false);
    const [resendCountdown, setResendCountdown] = useState(60);
    const [canResend, setCanResend] = useState(false);

    const inputRefs = useRef<(TextInput | null)[]>([]);

    // Countdown timer for resend
    useEffect(() => {
        if (resendCountdown > 0) {
            const timer = setTimeout(() => setResendCountdown(resendCountdown - 1), 1000);
            return () => clearTimeout(timer);
        } else {
            setCanResend(true);
        }
    }, [resendCountdown]);

    const handleOtpChange = (value: string, index: number) => {
        // Only allow numbers
        if (value && !/^\d$/.test(value)) return;

        const newOtp = [...otp];
        newOtp[index] = value;
        setOtp(newOtp);

        // Auto-advance to next input
        if (value && index < 5) {
            inputRefs.current[index + 1]?.focus();
        }
    };

    const handleKeyPress = (e: any, index: number) => {
        // Handle backspace
        if (e.nativeEvent.key === 'Backspace' && !otp[index] && index > 0) {
            inputRefs.current[index - 1]?.focus();
        }
    };

    const handleVerify = async () => {
        const otpCode = otp.join('');

        if (otpCode.length !== 6) {
            Alert.alert('Invalid OTP', 'Please enter all 6 digits');
            return;
        }

        setLoading(true);
        try {
            if (context === 'signup') {
                // Verify OTP for signup - this will log the user in
                await verifyOTP({ email, otp: otpCode });
                // Navigate to main app
                router.replace('/(tabs)/feed');
            } else {
                // For password reset, just verify the OTP and navigate to reset password screen
                // We don't call verifyOTP here because that's for signup only
                router.push({
                    pathname: '/auth/reset-password',
                    params: { email, otp: otpCode },
                });
            }
        } catch (error: any) {
            const message = error.message || 'Invalid or expired OTP';
            Alert.alert('Verification Failed', message);
        } finally {
            setLoading(false);
        }
    };

    const handleResend = async () => {
        if (!canResend) return;

        try {
            await resendOTP(email);
            Alert.alert('Success', 'A new verification code has been sent to your email');
            setResendCountdown(60);
            setCanResend(false);
            setOtp(['', '', '', '', '', '']);
            inputRefs.current[0]?.focus();
        } catch (error: any) {
            Alert.alert('Error', 'Failed to resend code. Please try again.');
        }
    };

    const getHeading = () => {
        if (context === 'signup') {
            return 'Verify Your Email';
        }
        return 'Verify Your Email';
    };

    const getSubheading = () => {
        if (context === 'signup') {
            return `Enter the 6-digit code sent to ${email}`;
        }
        return `Enter the 6-digit code sent to ${email}`;
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
                {/* Icon */}
                <View style={[
                    styles.iconContainer,
                    { backgroundColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt }
                ]}>
                    <Envelope
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
                        {getHeading()}
                    </Text>
                    <Text style={[
                        typography.body,
                        {
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            marginTop: spacing.xs,
                            textAlign: 'center'
                        }
                    ]}>
                        {getSubheading()}
                    </Text>
                </View>

                {/* OTP Inputs */}
                <View style={styles.otpContainer}>
                    {otp.map((digit, index) => (
                        <TextInput
                            key={index}
                            ref={(ref) => { inputRefs.current[index] = ref; }}
                            style={[
                                styles.otpInput,
                                typography.hero,
                                {
                                    backgroundColor: isDark ? AppColors.surfaceAltDark : AppColors.surfaceAlt,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                    borderColor: digit ? (isDark ? AppColors.primaryDarkMode : AppColors.primary) : (isDark ? AppColors.borderDark : AppColors.border),
                                }
                            ]}
                            value={digit}
                            onChangeText={(value) => handleOtpChange(value, index)}
                            onKeyPress={(e) => handleKeyPress(e, index)}
                            keyboardType="number-pad"
                            maxLength={1}
                            selectTextOnFocus
                            autoFocus={index === 0}
                        />
                    ))}
                </View>

                {/* Continue Button */}
                <TouchableOpacity
                    style={[
                        styles.continueButton,
                        { backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary }
                    ]}
                    onPress={handleVerify}
                    disabled={loading}
                >
                    <Text style={[typography.button, { color: '#FFFFFF' }]}>
                        {loading ? 'Verifying...' : 'Continue'}
                    </Text>
                </TouchableOpacity>

                {/* Resend Code */}
                <View style={styles.resendContainer}>
                    <Text style={[
                        typography.body,
                        { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }
                    ]}>
                        Didn't receive the code?{' '}
                    </Text>
                    <TouchableOpacity onPress={handleResend} disabled={!canResend}>
                        <Text style={[
                            typography.bodyMedium,
                            {
                                color: canResend
                                    ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                    : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary)
                            }
                        ]}>
                            {canResend ? 'Resend Code' : `Resend in ${resendCountdown}s`}
                        </Text>
                    </TouchableOpacity>
                </View>
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
    otpContainer: {
        flexDirection: 'row',
        gap: spacing.sm,
        marginBottom: spacing.xl,
    },
    otpInput: {
        width: 50,
        height: 60,
        borderRadius: radius.medium,
        borderWidth: 2,
        textAlign: 'center',
        fontSize: 24,
    },
    continueButton: {
        width: '100%',
        height: 56,
        borderRadius: radius.large,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: spacing.lg,
    },
    resendContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
    },
});
