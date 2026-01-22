/**
 * ANTI-GRAVITY UI CONSTITUTION v1.0
 * Spacing System - React Native/Expo
 * 
 * Translated from Flutter spacing.dart
 * Base-8 spacing system
 */

export const spacing = {
    xs: 8,
    sm: 16,
    md: 24,
    lg: 32,
    xl: 40,
    xxl: 48,
    xxxl: 64,
} as const;

// Padding shortcuts
export const padding = {
    xs: spacing.xs,
    sm: spacing.sm,
    md: spacing.md,
    lg: spacing.lg,
    xl: spacing.xl,
} as const;

// Margin shortcuts
export const margin = {
    xs: spacing.xs,
    sm: spacing.sm,
    md: spacing.md,
    lg: spacing.lg,
    xl: spacing.xl,
} as const;

// Gap shortcuts (for flexbox)
export const gap = {
    xs: spacing.xs,
    sm: spacing.sm,
    md: spacing.md,
    lg: spacing.lg,
    xl: spacing.xl,
} as const;

export type SpacingKey = keyof typeof spacing;
