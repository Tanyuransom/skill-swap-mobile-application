/**
 * Bottom Navigation Layout (Tabs)
 * 
 * Instagram-style 5-tab navigation with micro-dot indicator
 * Translated from Flutter bottom_navigation.dart
 * Following Bottom Nav Constitution (27 Rules)
 */

import { Tabs } from 'expo-router';
import { useColorScheme, Platform } from 'react-native';
import { House, VideoCamera, Compass, ChatCircle, User } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';

export default function TabsLayout() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';

    const activeColor = isDark ? AppColors.primaryDarkMode : AppColors.primary;
    const inactiveColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    const backgroundColor = isDark ? AppColors.surfaceDark : AppColors.surface;

    return (
        <Tabs
            screenOptions={{
                headerShown: false,
                tabBarActiveTintColor: activeColor,
                tabBarInactiveTintColor: inactiveColor,
                tabBarStyle: {
                    backgroundColor,
                    borderTopWidth: 0,
                    height: Platform.OS === 'ios' ? 88 : 60,
                    paddingBottom: Platform.OS === 'ios' ? 28 : 8,
                    paddingTop: 8,
                    elevation: 0,
                    shadowColor: '#000',
                    shadowOffset: { width: 0, height: -8 },
                    shadowOpacity: isDark ? 0.3 : 0.06,
                    shadowRadius: 24,
                },
                tabBarLabelStyle: {
                    ...typography.caption,
                    fontSize: 11,
                    fontWeight: '600',
                },
                tabBarIconStyle: {
                    marginBottom: 2,
                },
            }}
        >
            <Tabs.Screen
                name="feed"
                options={{
                    title: 'Feed',
                    tabBarIcon: ({ color, focused }) => (
                        <House
                            size={focused ? 24 : 22}
                            color={color}
                            weight={focused ? 'fill' : 'regular'}
                        />
                    ),
                }}
            />
            <Tabs.Screen
                name="reels"
                options={{
                    title: 'Reels',
                    tabBarIcon: ({ color, focused }) => (
                        <VideoCamera
                            size={focused ? 24 : 22}
                            color={color}
                            weight={focused ? 'fill' : 'regular'}
                        />
                    ),
                }}
            />
            <Tabs.Screen
                name="explore"
                options={{
                    title: 'Explore',
                    tabBarIcon: ({ color, focused }) => (
                        <Compass
                            size={focused ? 24 : 22}
                            color={color}
                            weight={focused ? 'fill' : 'regular'}
                        />
                    ),
                }}
            />
            <Tabs.Screen
                name="messages"
                options={{
                    title: 'Messages',
                    tabBarIcon: ({ color, focused }) => (
                        <ChatCircle
                            size={focused ? 24 : 22}
                            color={color}
                            weight={focused ? 'fill' : 'regular'}
                        />
                    ),
                }}
            />
            <Tabs.Screen
                name="profile"
                options={{
                    title: 'Profile',
                    tabBarIcon: ({ color, focused }) => (
                        <User
                            size={focused ? 24 : 22}
                            color={color}
                            weight={focused ? 'fill' : 'regular'}
                        />
                    ),
                }}
            />
        </Tabs>
    );
}
