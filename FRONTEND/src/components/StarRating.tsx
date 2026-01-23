/**
 * Star Rating Component
 * Interactive star rating display
 */

import { View, TouchableOpacity, StyleSheet } from 'react-native';
import { Star } from 'phosphor-react-native';

interface StarRatingProps {
    rating: number;
    onRatingChange?: (rating: number) => void;
    size?: number;
    color?: string;
    readonly?: boolean;
}

export function StarRating({
    rating,
    onRatingChange,
    size = 24,
    color = '#FFB800',
    readonly = false,
}: StarRatingProps) {
    const stars = [1, 2, 3, 4, 5];

    const handlePress = (value: number) => {
        if (!readonly && onRatingChange) {
            onRatingChange(value);
        }
    };

    return (
        <View style={styles.container}>
            {stars.map((star) => {
                const filled = star <= rating;
                const Component = readonly ? View : TouchableOpacity;

                return (
                    <Component
                        key={star}
                        onPress={() => handlePress(star)}
                        disabled={readonly}
                        style={styles.star}
                    >
                        <Star
                            size={size}
                            color={color}
                            weight={filled ? 'fill' : 'regular'}
                        />
                    </Component>
                );
            })}
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        gap: 4,
    },
    star: {
        padding: 2,
    },
});
