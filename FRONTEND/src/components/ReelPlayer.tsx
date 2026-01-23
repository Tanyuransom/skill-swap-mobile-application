/**
 * Reel Player Component
 * Full-screen video player with TikTok-style UI
 */

import { useRef, useState, useEffect } from 'react';
import {
    View,
    StyleSheet,
    Dimensions,
    TouchableWithoutFeedback,
    Animated,
} from 'react-native';
import { Video, ResizeMode } from 'expo-av';
import type { Reel } from '@/services/reels.service';

const { width: SCREEN_WIDTH, height: SCREEN_HEIGHT } = Dimensions.get('window');

interface ReelPlayerProps {
    reel: Reel;
    isActive: boolean;
    onDoubleTap: () => void;
}

export function ReelPlayer({ reel, isActive, onDoubleTap }: ReelPlayerProps) {
    const videoRef = useRef<Video>(null);
    const [isPlaying, setIsPlaying] = useState(true);
    const [lastTap, setLastTap] = useState(0);
    const heartScale = useRef(new Animated.Value(0)).current;

    useEffect(() => {
        if (isActive) {
            videoRef.current?.playAsync();
            setIsPlaying(true);
        } else {
            videoRef.current?.pauseAsync();
            setIsPlaying(false);
        }
    }, [isActive]);

    const handleSingleTap = () => {
        if (isPlaying) {
            videoRef.current?.pauseAsync();
            setIsPlaying(false);
        } else {
            videoRef.current?.playAsync();
            setIsPlaying(true);
        }
    };

    const handleTap = () => {
        const now = Date.now();
        const DOUBLE_TAP_DELAY = 300;

        if (now - lastTap < DOUBLE_TAP_DELAY) {
            // Double tap
            onDoubleTap();
            animateHeart();
        } else {
            // Single tap
            setTimeout(() => {
                if (Date.now() - lastTap >= DOUBLE_TAP_DELAY) {
                    handleSingleTap();
                }
            }, DOUBLE_TAP_DELAY);
        }

        setLastTap(now);
    };

    const animateHeart = () => {
        heartScale.setValue(0);
        Animated.sequence([
            Animated.spring(heartScale, {
                toValue: 1,
                useNativeDriver: true,
                friction: 3,
            }),
            Animated.timing(heartScale, {
                toValue: 0,
                duration: 400,
                delay: 200,
                useNativeDriver: true,
            }),
        ]).start();
    };

    return (
        <TouchableWithoutFeedback onPress={handleTap}>
            <View style={styles.container}>
                <Video
                    ref={videoRef}
                    source={{ uri: reel.videoUrl }}
                    style={styles.video}
                    resizeMode={ResizeMode.COVER}
                    shouldPlay={isActive}
                    isLooping
                    isMuted={false}
                />

                {/* Double-tap heart animation */}
                <Animated.View
                    style={[
                        styles.heartAnimation,
                        {
                            transform: [{ scale: heartScale }],
                            opacity: heartScale,
                        },
                    ]}
                >
                    <View style={styles.heart}>
                        {/* Heart SVG would go here - using placeholder */}
                        <View style={styles.heartPlaceholder} />
                    </View>
                </Animated.View>
            </View>
        </TouchableWithoutFeedback>
    );
}

const styles = StyleSheet.create({
    container: {
        width: SCREEN_WIDTH,
        height: SCREEN_HEIGHT,
        backgroundColor: '#000',
    },
    video: {
        width: '100%',
        height: '100%',
    },
    heartAnimation: {
        position: 'absolute',
        top: '50%',
        left: '50%',
        marginLeft: -50,
        marginTop: -50,
    },
    heart: {
        width: 100,
        height: 100,
        justifyContent: 'center',
        alignItems: 'center',
    },
    heartPlaceholder: {
        width: 80,
        height: 80,
        backgroundColor: 'rgba(255, 255, 255, 0.9)',
        borderRadius: 40,
    },
});
