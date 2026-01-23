/**
 * Earnings Dashboard
 * View wallet balance, earnings, and request payouts
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    useColorScheme,
    Alert,
} from 'react-native';
import { useRouter } from 'expo-router';
import { CurrencyDollar, TrendUp, ArrowRight, Wallet } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { Loading } from '@/components/Loading';

export default function EarningsScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [loading, setLoading] = useState(true);
    const [earnings, setEarnings] = useState({
        totalEarnings: 0,
        availableBalance: 0,
        pendingPayouts: 0,
    });

    useEffect(() => {
        loadEarnings();
    }, []);

    const loadEarnings = async () => {
        try {
            setLoading(true);
            // TODO: Load from API
            setEarnings({
                totalEarnings: 125000,
                availableBalance: 45000,
                pendingPayouts: 15000,
            });
        } catch (error) {
            console.error('Failed to load earnings:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleRequestPayout = () => {
        Alert.alert(
            'Request Payout',
            `Request payout of ${earnings.availableBalance.toLocaleString()} XAF?`,
            [
                { text: 'Cancel', style: 'cancel' },
                {
                    text: 'Request',
                    onPress: () => {
                        // TODO: Implement payout request
                        Alert.alert('Success', 'Payout requested! Processing within 24-48 hours.');
                    }
                }
            ]
        );
    };

    if (loading) {
        return <Loading fullScreen />;
    }

    return (
        <ScrollView style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.header}>
                <Text style={[typography.hero, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Earnings
                </Text>
            </View>

            {/* Balance Cards */}
            <View style={styles.cardsContainer}>
                {/* Total Earnings */}
                <View style={[styles.card, styles.primaryCard, {
                    backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary
                }]}>
                    <View style={styles.cardIcon}>
                        <CurrencyDollar size={32} color="#fff" weight="bold" />
                    </View>
                    <Text style={[typography.caption, styles.cardLabel]}>
                        Total Earnings
                    </Text>
                    <Text style={[typography.h1, styles.cardValue]}>
                        {earnings.totalEarnings.toLocaleString()}
                    </Text>
                    <Text style={[typography.caption, styles.cardCurrency]}>
                        XAF
                    </Text>
                </View>

                {/* Available Balance */}
                <View style={[styles.card, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <View style={[styles.cardIconSmall, {
                        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                    }]}>
                        <Wallet size={24} color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
                    </View>
                    <Text style={[typography.caption, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        Available
                    </Text>
                    <Text style={[typography.h2, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginTop: spacing.xs
                    }]}>
                        {earnings.availableBalance.toLocaleString()} XAF
                    </Text>
                </View>

                {/* Pending Payouts */}
                <View style={[styles.card, {
                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                }]}>
                    <View style={[styles.cardIconSmall, {
                        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                    }]}>
                        <TrendUp size={24} color="#F59E0B" />
                    </View>
                    <Text style={[typography.caption, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        Pending
                    </Text>
                    <Text style={[typography.h2, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        marginTop: spacing.xs
                    }]}>
                        {earnings.pendingPayouts.toLocaleString()} XAF
                    </Text>
                </View>
            </View>

            {/* Request Payout Button */}
            <TouchableOpacity
                style={[styles.payoutButton, {
                    backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary,
                    opacity: earnings.availableBalance > 0 ? 1 : 0.5
                }]}
                onPress={handleRequestPayout}
                disabled={earnings.availableBalance === 0}
            >
                <Text style={[typography.button, { color: '#fff' }]}>
                    Request Payout
                </Text>
                <ArrowRight size={20} color="#fff" weight="bold" />
            </TouchableOpacity>

            {/* Payout Info */}
            <View style={[styles.infoCard, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}>
                <Text style={[typography.bodyMedium, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    marginBottom: spacing.sm
                }]}>
                    Payout Information
                </Text>
                <Text style={[typography.body, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    lineHeight: 22
                }]}>
                    • Minimum payout: 10,000 XAF{'\n'}
                    • Processing time: 24-48 hours{'\n'}
                    • Payment methods: Orange Money, MTN Mobile Money{'\n'}
                    • Platform fee: 10% per transaction
                </Text>
            </View>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    cardsContainer: {
        padding: spacing.md,
        gap: spacing.md,
    },
    card: {
        padding: spacing.lg,
        borderRadius: radius.lg,
    },
    primaryCard: {
        paddingVertical: spacing.xl,
    },
    cardIcon: {
        marginBottom: spacing.md,
    },
    cardIconSmall: {
        width: 48,
        height: 48,
        borderRadius: 24,
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: spacing.md,
    },
    cardLabel: {
        color: 'rgba(255,255,255,0.8)',
        marginBottom: spacing.xs,
    },
    cardValue: {
        color: '#fff',
        marginTop: spacing.xs,
    },
    cardCurrency: {
        color: 'rgba(255,255,255,0.8)',
        marginTop: spacing.xs,
    },
    payoutButton: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        gap: spacing.sm,
        margin: spacing.md,
        padding: spacing.md,
        borderRadius: radius.lg,
    },
    infoCard: {
        margin: spacing.md,
        padding: spacing.md,
        borderRadius: radius.lg,
    },
});
