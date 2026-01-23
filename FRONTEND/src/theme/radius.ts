/**
 * ANTI-GRAVITY UI CONSTITUTION v1.0
 * Radius System - React Native/Expo
 * 
 * Translated from Flutter radius.dart
 * 4 radius levels with shadows
 */

export const radius = {
    small: 8,
    medium: 12,
    large: 16,
    xlarge: 24,
    full: 9999,
    // Aliases
    sm: 8,
    md: 12,
    lg: 16,
    xl: 24,
} as const;

export const shadows = {
    small: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 1 },
        shadowOpacity: 0.05,
        shadowRadius: 2,
        elevation: 1,
    },
    medium: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.08,
        shadowRadius: 8,
        elevation: 3,
    },
    large: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 8 },
        shadowOpacity: 0.12,
        shadowRadius: 16,
        elevation: 5,
    },
} as const;

export type RadiusKey = keyof typeof radius;
export type ShadowKey = keyof typeof shadows;
