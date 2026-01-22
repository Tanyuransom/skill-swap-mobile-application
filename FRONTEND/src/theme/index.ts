/**
 * ANTI-GRAVITY UI CONSTITUTION v1.0
 * Theme Index - React Native/Expo
 * 
 * Central theme export
 */

import { AppColors } from './colors';
import { spacing, padding, margin, gap } from './spacing';
import { typography, fontFamily } from './typography';
import { radius, shadows } from './radius';
import { animations, timings } from './animations';

export const theme = {
    colors: AppColors,
    spacing,
    padding,
    margin,
    gap,
    typography,
    fontFamily,
    radius,
    shadows,
    animations,
    timings,
} as const;

export type Theme = typeof theme;

// Re-export individual modules
export { AppColors, spacing, typography, radius, shadows, animations };
export * from './colors';
export * from './spacing';
export * from './typography';
export * from './radius';
export * from './animations';
