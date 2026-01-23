/**
 * Reel Info Overlay Component
 * Bottom overlay with username, description, and sound info
 */

import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { MusicNote } from 'phosphor-react-native';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import type { Reel } from '@/services/reels.service';

interface ReelInfoProps {
    reel: Reel;
    onProfilePress: () => void;
}

export function ReelInfo({ reel, onProfilePress }: ReelInfoProps) {
    return (
        <View style={styles.container}>
            {/* Username */}
            <TouchableOpacity onPress={onProfilePress}>
                <Text style={styles.username}>
                    @{reel.userHandle || reel.userName || 'user'}
                </Text>
            </TouchableOpacity>

            {/* Description */}
            {reel.description && (
                <Text style={styles.description} numberOfLines={2}>
                    {reel.description}
                </Text>
            )}

            {/* Sound/Music Info */}
            <View style={styles.soundContainer}>
                <MusicNote size={14} color="#fff" weight="fill" />
                <Text style={styles.soundText} numberOfLines={1}>
                    Original sound - {reel.userName || 'User'}
                </Text>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        position: 'absolute',
        bottom: 20,
        left: spacing.md,
        right: 80, // Leave space for sidebar
        gap: spacing.xs,
    },
    username: {
        ...typography.bodyMedium,
        color: '#fff',
        fontWeight: '700',
        textShadowColor: 'rgba(0, 0, 0, 0.75)',
        textShadowOffset: { width: 0, height: 1 },
        textShadowRadius: 3,
    },
    description: {
        ...typography.body,
        color: '#fff',
        lineHeight: 18,
        textShadowColor: 'rgba(0, 0, 0, 0.75)',
        textShadowOffset: { width: 0, height: 1 },
        textShadowRadius: 3,
    },
    soundContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        gap: 6,
        marginTop: spacing.xs,
    },
    soundText: {
        ...typography.caption,
        color: '#fff',
        flex: 1,
        textShadowColor: 'rgba(0, 0, 0, 0.75)',
        textShadowOffset: { width: 0, height: 1 },
        textShadowRadius: 3,
    },
});
