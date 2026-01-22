/**
 * ANTI-GRAVITY UI CONSTITUTION v1.0
 * Color System - React Native/Expo
 * 
 * Translated from Flutter colors.dart
 * Semantic color tokens for light and dark modes
 */

export const AppColors = {
    // Primary Colors
    primary: '#6366F1',           // Indigo-500
    primaryDarkMode: '#818CF8',   // Indigo-400

    // Accent Colors
    accent: '#F59E0B',            // Amber-500
    accentDark: '#FBBF24',        // Amber-400

    // Background Colors
    background: '#FAFAFA',        // Gray-50
    backgroundDark: '#0F172A',    // Slate-900

    // Surface Colors
    surface: '#FFFFFF',           // White
    surfaceDark: '#1E293B',       // Slate-800
    surfaceAlt: '#F1F5F9',        // Slate-100
    surfaceAltDark: '#334155',    // Slate-700

    // Text Colors
    textPrimary: '#0F172A',       // Slate-900
    textPrimaryDark: '#F1F5F9',   // Slate-100
    textSecondary: '#64748B',     // Slate-500
    textSecondaryDark: '#94A3B8', // Slate-400
    textTertiary: '#94A3B8',      // Slate-400
    textTertiaryDark: '#64748B',  // Slate-500

    // Border Colors
    border: '#E2E8F0',            // Slate-200
    borderDark: '#475569',        // Slate-600

    // Status Colors
    success: '#10B981',           // Green-500
    successDark: '#34D399',       // Green-400
    warning: '#F59E0B',           // Amber-500
    warningDark: '#FBBF24',       // Amber-400
    error: '#EF4444',             // Red-500
    errorDark: '#F87171',         // Red-400
    info: '#3B82F6',              // Blue-500
    infoDark: '#60A5FA',          // Blue-400
} as const;

export type AppColorKey = keyof typeof AppColors;
