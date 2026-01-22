/**
 * Theme Store - Zustand
 * 
 * Manages theme mode (light/dark) with persistence
 * Translated from Flutter theme_provider.dart
 */

import { create } from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { ColorSchemeName } from 'react-native';

interface ThemeState {
    themeMode: 'light' | 'dark' | 'system';
    setThemeMode: (mode: 'light' | 'dark' | 'system') => Promise<void>;
    toggleTheme: () => Promise<void>;
    loadTheme: () => Promise<void>;
}

const THEME_KEY = 'theme_mode';

export const useThemeStore = create<ThemeState>((set, get) => ({
    themeMode: 'system',

    setThemeMode: async (mode) => {
        try {
            await AsyncStorage.setItem(THEME_KEY, mode);
            set({ themeMode: mode });
        } catch (error) {
            console.error('Failed to save theme mode:', error);
        }
    },

    toggleTheme: async () => {
        const current = get().themeMode;
        const next = current === 'light' ? 'dark' : 'light';
        await get().setThemeMode(next);
    },

    loadTheme: async () => {
        try {
            const saved = await AsyncStorage.getItem(THEME_KEY);
            if (saved && (saved === 'light' || saved === 'dark' || saved === 'system')) {
                set({ themeMode: saved });
            }
        } catch (error) {
            console.error('Failed to load theme mode:', error);
        }
    },
}));
