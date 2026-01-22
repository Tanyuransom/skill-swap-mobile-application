/**
 * ANTI-GRAVITY UI CONSTITUTION v1.0
 * Animation System - React Native/Expo
 * 
 * Translated from Flutter animations.dart
 * Duration and easing curves
 */

import { Easing } from 'react-native-reanimated';

export const animations = {
    // Durations (in milliseconds)
    fast: 200,
    standard: 300,
    slow: 500,

    // Easing curves
    // easeOutCubic: cubic-bezier(0.33, 1, 0.68, 1)
    easing: Easing.bezier(0.33, 1, 0.68, 1),

    // Spring config for micro-interactions
    spring: {
        damping: 15,
        stiffness: 150,
    },
} as const;

export const timings = {
    splash: 2500,
    tabSwitch: 0,
    pageTransition: 300,
    modalSlide: 300,
    buttonPress: 200,
} as const;
