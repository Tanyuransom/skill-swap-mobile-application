/**
 * Payment Method Selection
 * Modern payment page with Orange Money and MTN Mobile Money
 */

import { useState } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    TextInput,
    useColorScheme,
    Image,
    Alert,
    ScrollView,
} from 'react-native';
import { useRouter } from 'expo-router';
import { ArrowLeft, CreditCard } from 'phosphor-react-native';
import { AppColors } from '../../src/theme/colors';
import { typography } from '../../src/theme/typography';
import { spacing } from '../../src/theme/spacing';
import { radius } from '../../src/theme/radius';
import { paymentService } from '../../src/services/payment.service';

import { camPayService } from '../../src/services/campay.service';

export default function PaymentScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [selectedMethod, setSelectedMethod] = useState<PaymentMethod | null>(null);
    const [phoneNumber, setPhoneNumber] = useState('');
    const [processing, setProcessing] = useState(false);

    const subscriptionPrice = 5000; // 5000 XAF per month

    const handlePayment = async () => {
        if (!selectedMethod) {
            Alert.alert('Error', 'Please select a payment method');
            return;
        }

        if (!phoneNumber.trim()) {
            Alert.alert('Error', 'Please enter your phone number');
            return;
        }

        try {
            setProcessing(true);

            // Use CamPay for real payment processing
            const response = await camPayService.initiatePayment(
                subscriptionPrice,
                phoneNumber.trim(),
                'SkillSwapp Monthly Subscription'
            );

            Alert.alert(
                'Payment Initiated',
                `Please dial ${response.ussdCode} on your phone to complete the payment.`,
                [
                    {
                        text: 'OK',
                        onPress: () => {
                            // Save transaction to backend
                            paymentService.initiatePayment({
                                amount: subscriptionPrice,
                                paymentMethod: selectedMethod,
                                phoneNumber: phoneNumber.trim(),
                            });
                            router.push('/(tabs)/learning');
                        },
                    },
                ]
            );
        } catch (error) {
            console.error('Payment failed:', error);
            Alert.alert('Error', 'Payment failed. Please try again.');
        } finally {
            setProcessing(false);
        }
    };

    return (
        <ScrollView
            style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}
            contentContainerStyle={styles.content}
        >
            {/* Header */}
            <View style={styles.header}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
                    <ArrowLeft size={24} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                </TouchableOpacity>
                <Text style={[typography.hero, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Subscribe
                </Text>
                <View style={{ width: 24 }} />
            </View>

            {/* Subscription Info */}
            <View style={[styles.priceCard, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}>
                <CreditCard size={32} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                <Text style={[typography.hero, styles.price, {
                    color: isDark ? AppColors.primaryDarkMode : AppColors.primary
                }]}>
                    {subscriptionPrice.toLocaleString()} XAF
                </Text>
                <Text style={[typography.body, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    per month
                </Text>
                <Text style={[typography.caption, styles.benefits, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    • Unlimited access to all courses{'\n'}
                    • Progress tracking{'\n'}
                    • Certificates upon completion{'\n'}
                    • Direct messaging with instructors
                </Text>
            </View>

            {/* Payment Methods */}
            <Text style={[typography.title, styles.sectionTitle, {
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
            }]}>
                Select Payment Method
            </Text>

            {/* Orange Money */}
            <TouchableOpacity
                style={[
                    styles.paymentMethod,
                    {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                        borderColor: selectedMethod === 'orange_money'
                            ? '#FF7900'
                            : 'transparent',
                        borderWidth: selectedMethod === 'orange_money' ? 2 : 0,
                    }
                ]}
                onPress={() => setSelectedMethod('orange_money')}
            >
                <Image
                    source={require('../../assets/images/payment/orange_money.png')}
                    style={styles.logo}
                    resizeMode="contain"
                />
                <Text style={[typography.title, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Orange Money
                </Text>
            </TouchableOpacity>

            {/* MTN Mobile Money */}
            <TouchableOpacity
                style={[
                    styles.paymentMethod,
                    {
                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                        borderColor: selectedMethod === 'mtn_momo'
                            ? '#FFCC00'
                            : 'transparent',
                        borderWidth: selectedMethod === 'mtn_momo' ? 2 : 0,
                    }
                ]}
                onPress={() => setSelectedMethod('mtn_momo')}
            >
                <Image
                    source={require('../../assets/images/payment/mtn_momo.png')}
                    style={styles.logo}
                    resizeMode="contain"
                />
                <Text style={[typography.title, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    MTN Mobile Money
                </Text>
            </TouchableOpacity>

            {/* Phone Number Input */}
            {selectedMethod && (
                <View style={styles.inputSection}>
                    <Text style={[typography.body, styles.inputLabel, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        Phone Number
                    </Text>
                    <TextInput
                        style={[styles.input, {
                            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                        }]}
                        placeholder="6 XX XX XX XX"
                        placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                        value={phoneNumber}
                        onChangeText={setPhoneNumber}
                        keyboardType="phone-pad"
                        maxLength={15}
                    />
                </View>
            )}

            {/* Pay Button */}
            <TouchableOpacity
                style={[styles.payButton, {
                    backgroundColor: selectedMethod && phoneNumber.trim()
                        ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                        : (isDark ? AppColors.surfaceDark : AppColors.surface),
                    opacity: (selectedMethod && phoneNumber.trim() && !processing) ? 1 : 0.5
                }]}
                onPress={handlePayment}
                disabled={!selectedMethod || !phoneNumber.trim() || processing}
            >
                <Text style={[typography.button, { color: '#fff' }]}>
                    {processing ? 'Processing...' : `Pay ${subscriptionPrice.toLocaleString()} XAF`}
                </Text>
            </TouchableOpacity>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    content: {
        padding: spacing.md,
    },
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        marginBottom: spacing.lg,
        paddingTop: spacing.xl,
    },
    backButton: {
        padding: 4,
    },
    priceCard: {
        borderRadius: radius.large,
        padding: spacing.xl,
        alignItems: 'center',
        marginBottom: spacing.xl,
        elevation: 2,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: 8,
    },
    price: {
        marginTop: spacing.sm,
    },
    benefits: {
        marginTop: spacing.md,
        lineHeight: 20,
        textAlign: 'center',
    },
    sectionTitle: {
        marginBottom: spacing.md,
    },
    paymentMethod: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: spacing.md,
        borderRadius: radius.large,
        marginBottom: spacing.md,
        elevation: 1,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.05,
        shadowRadius: 4,
    },
    logo: {
        width: 60,
        height: 60,
        marginRight: spacing.md,
    },
    inputSection: {
        marginTop: spacing.md,
        marginBottom: spacing.xl,
    },
    inputLabel: {
        marginBottom: spacing.sm,
    },
    input: {
        borderRadius: radius.large,
        padding: spacing.md,
        fontSize: 16,
    },
    payButton: {
        borderRadius: radius.large,
        padding: spacing.md,
        alignItems: 'center',
        marginTop: spacing.md,
    },
});
