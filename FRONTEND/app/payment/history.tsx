/**
 * Payment History
 * Transaction history page
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    FlatList,
    useColorScheme,
} from 'react-native';
import { CheckCircle, XCircle, Clock } from 'phosphor-react-native';
import { AppColors } from '../../src/theme/colors';
import { typography } from '../../src/theme/typography';
import { spacing } from '../../src/theme/spacing';
import { radius } from '../../src/theme/radius';
import { paymentService, type Transaction } from '../../src/services/payment.service';
import { Loading } from '../../src/components/Loading';
import { EmptyState } from '../../src/components/EmptyState';

export default function PaymentHistoryScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';

    const [loading, setLoading] = useState(true);
    const [transactions, setTransactions] = useState<Transaction[]>([]);

    useEffect(() => {
        loadHistory();
    }, []);

    const loadHistory = async () => {
        try {
            setLoading(true);
            const data = await paymentService.getPaymentHistory();
            setTransactions(data);
        } catch (error) {
            console.error('Failed to load payment history:', error);
        } finally {
            setLoading(false);
        }
    };

    const renderTransaction = ({ item }: { item: Transaction }) => {
        const StatusIcon = item.status === 'completed' ? CheckCircle : item.status === 'failed' ? XCircle : Clock;
        const statusColor = item.status === 'completed' ? '#10B981' : item.status === 'failed' ? '#EF4444' : '#F59E0B';

        return (
            <View style={[styles.card, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}>
                <View style={styles.cardHeader}>
                    <Text style={[typography.title, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        {item.amount.toLocaleString()} {item.currency}
                    </Text>
                    <StatusIcon size={24} color={statusColor} weight="fill" />
                </View>

                <Text style={[typography.body, styles.method, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    {item.paymentMethod === 'orange_money' ? 'Orange Money' : 'MTN Mobile Money'}
                </Text>

                <Text style={[typography.caption, {
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                }]}>
                    {new Date(item.createdAt).toLocaleDateString()} • {item.phoneNumber}
                </Text>
            </View>
        );
    };

    if (loading) {
        return <Loading fullScreen />;
    }

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            <View style={styles.header}>
                <Text style={[typography.hero, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Payment History
                </Text>
            </View>

            {transactions.length === 0 ? (
                <EmptyState
                    icon="search"
                    title="No transactions yet"
                    message="Your payment history will appear here"
                />
            ) : (
                <FlatList
                    data={transactions}
                    renderItem={renderTransaction}
                    keyExtractor={(item) => item.id}
                    contentContainerStyle={styles.list}
                    showsVerticalScrollIndicator={false}
                />
            )}
        </View>
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
    list: {
        padding: spacing.md,
    },
    card: {
        borderRadius: radius.large,
        padding: spacing.md,
        marginBottom: spacing.md,
        elevation: 1,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.05,
        shadowRadius: 4,
    },
    cardHeader: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: spacing.sm,
    },
    method: {
        marginBottom: 4,
    },
});
