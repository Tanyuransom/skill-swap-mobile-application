/**
 * Bottom Navigation Layout (Tabs)
 * 
 * SkillSwapp Navigation - Modern 5-tab layout
 * Optimized for skill-sharing platform
 */

import { Tabs } from 'expo-router';
import { useColorScheme, Platform } from 'react-native';
import { House, BookOpen, GraduationCap, ChatCircle, User } from 'phosphor-react-native';
import { AppColors } from '../../src/theme/colors';
import { typography } from '../../src/theme/typography';

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
                    elevation: 8,
                    shadowColor: '#000',
                    shadowOffset: { width: 0, height: -4 },
                    shadowOpacity: isDark ? 0.3 : 0.08,
                    shadowRadius: 16,
                },
                tabBarLabelStyle: {
                    ...typography.caption,
                    fontSize: 11,
                    fontWeight: '600',
                    letterSpacing: 0.3,
                },
                tabBarIconStyle: {
                    marginBottom: 2,
                },
            }}
        >
            <Tabs.Screen
                name="feed"
                options={{
                    title: 'Home',
                    tabBarIcon: ({ color, focused }) => (
                        <House
                            size={focused ? 26 : 24}
                            color={color}
                            weight={focused ? 'fill' : 'regular'}
                        />
                    ),
                }}
            />
            <Tabs.Screen
                name="courses"
                options={{
                    title: 'Courses',
                    tabBarIcon: ({ color, focused }) => (
                        <BookOpen
                            size={focused ? 26 : 24}
                            color={color}
                            weight={focused ? 'fill' : 'regular'}
                        />
                    ),
                }}
            />
            <Tabs.Screen
                name="learning"
                options={{
                    title: 'Learning',
                    tabBarIcon: ({ color, focused }) => (
                        <GraduationCap
                            size={focused ? 26 : 24}
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
                            size={focused ? 26 : 24}
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
                            size={focused ? 26 : 24}
                            color={color}
                            weight={focused ? 'fill' : 'regular'}
                        />
                    ),
                }}
            />
        </Tabs>
    );
}

