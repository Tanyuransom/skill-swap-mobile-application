/**
 * ANTI-GRAVITY UI CONSTITUTION v1.0
 * Typography System - React Native/Expo
 * 
 * Translated from Flutter typography.dart
 * 5-tier type scale with Inter font family
 */

import { TextStyle } from 'react-native';

export const fontFamily = {
    regular: 'Inter-Regular',
    semiBold: 'Inter-SemiBold',
    bold: 'Inter-Bold',
} as const;

export const typography = {
    hero: {
        fontFamily: fontFamily.bold,
        fontSize: 32,
        lineHeight: 40,
        fontWeight: '700' as const,
    },

    h1: {
        fontFamily: fontFamily.bold,
        fontSize: 28,
        lineHeight: 36,
        fontWeight: '700' as const,
    },

    h2: {
        fontFamily: fontFamily.bold,
        fontSize: 24,
        lineHeight: 32,
        fontWeight: '700' as const,
    },

    h3: {
        fontFamily: fontFamily.semiBold,
        fontSize: 20,
        lineHeight: 28,
        fontWeight: '600' as const,
    },

    h4: {
        fontFamily: fontFamily.semiBold,
        fontSize: 18,
        lineHeight: 24,
        fontWeight: '600' as const,
    },

    title: {
        fontFamily: fontFamily.semiBold,
        fontSize: 24,
        lineHeight: 32,
        fontWeight: '600' as const,
    },

    section: {
        fontFamily: fontFamily.semiBold,
        fontSize: 18,
        lineHeight: 24,
        fontWeight: '600' as const,
    },

    body: {
        fontFamily: fontFamily.regular,
        fontSize: 15,
        lineHeight: 24,
        fontWeight: '400' as const,
    },

    bodyMedium: {
        fontFamily: fontFamily.semiBold,
        fontSize: 15,
        lineHeight: 24,
        fontWeight: '500' as const,
    },

    caption: {
        fontFamily: fontFamily.regular,
        fontSize: 12,
        lineHeight: 16,
        fontWeight: '400' as const,
    },

    label: {
        fontFamily: fontFamily.semiBold,
        fontSize: 14,
        lineHeight: 20,
        fontWeight: '500' as const,
    },

    button: {
        fontFamily: fontFamily.semiBold,
        fontSize: 15,
        lineHeight: 20,
        fontWeight: '600' as const,
    },
} as const;

export type TypographyKey = keyof typeof typography;
export type TypographyStyle = typeof typography[TypographyKey];
