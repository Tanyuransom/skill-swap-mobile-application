/**
 * Profile Screen
 * Modern user profile with edit functionality
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    TextInput,
    useColorScheme,
    ActivityIndicator,
    Image,
} from 'react-native';
import { User, PencilSimple, SignOut } from 'phosphor-react-native';
import { AppColors } from '../../src/theme/colors';
import { typography } from '../../src/theme/typography';
import { spacing } from '../../src/theme/spacing';
import { radius } from '../../src/theme/radius';
import { userService, type User as UserType } from '../../src/services/user.service';
import { useAuth } from '../../src/hooks/useAuth';

export default function ProfileScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const { logout } = useAuth();

    const [loading, setLoading] = useState(true);
    const [editing, setEditing] = useState(false);
    const [profile, setProfile] = useState<UserType | null>(null);
    const [formData, setFormData] = useState({
        firstName: '',
        lastName: '',
        bio: '',
        skills: [] as string[],
    });

    useEffect(() => {
        loadProfile();
    }, []);

    const loadProfile = async () => {
        try {
            setLoading(true);
            const data = await userService.getMyProfile();
            setProfile(data);
            setFormData({
                firstName: data.firstName,
                lastName: data.lastName,
                bio: data.bio || '',
                skills: data.skills || [],
            });
        } catch (error) {
            console.error('Failed to load profile:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleSave = async () => {
        try {
            setLoading(true);
            const updated = await userService.updateProfile(formData);
            setProfile(updated);
            setEditing(false);
        } catch (error) {
            console.error('Failed to update profile:', error);
        } finally {
            setLoading(false);
        }
    };

    if (loading && !profile) {
        return (
            <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
                <ActivityIndicator size="large" color={isDark ? AppColors.primaryDarkMode : AppColors.primary} />
            </View>
        );
    }

    return (
        <ScrollView
            style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}
            contentContainerStyle={styles.content}
        >
            {/* Header */}
            <View style={styles.header}>
                <Text style={[typography.h1, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                    Profile
                </Text>
                <TouchableOpacity onPress={() => setEditing(!editing)}>
                    <PencilSimple
                        size={24}
                        color={isDark ? AppColors.primaryDarkMode : AppColors.primary}
                        weight="bold"
                    />
                </TouchableOpacity>
            </View>

            {/* Avatar */}
            <View style={styles.avatarContainer}>
                {profile?.avatar ? (
                    <Image source={{ uri: profile.avatar }} style={styles.avatar} />
                ) : (
                    <View style={[styles.avatar, { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}>
                        <User size={64} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                    </View>
                )}
            </View>

            {/* Profile Info */}
            <View style={[styles.card, { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}>
                <View style={styles.field}>
                    <Text style={[typography.caption, { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }]}>
                        First Name
                    </Text>
                    {editing ? (
                        <TextInput
                            style={[styles.input, {
                                backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            }]}
                            value={formData.firstName}
                            onChangeText={(text) => setFormData({ ...formData, firstName: text })}
                            placeholder="First name"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                        />
                    ) : (
                        <Text style={[typography.body, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                            {profile?.firstName}
                        </Text>
                    )}
                </View>

                <View style={styles.field}>
                    <Text style={[typography.caption, { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }]}>
                        Last Name
                    </Text>
                    {editing ? (
                        <TextInput
                            style={[styles.input, {
                                backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            }]}
                            value={formData.lastName}
                            onChangeText={(text) => setFormData({ ...formData, lastName: text })}
                            placeholder="Last name"
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                        />
                    ) : (
                        <Text style={[typography.body, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                            {profile?.lastName}
                        </Text>
                    )}
                </View>

                <View style={styles.field}>
                    <Text style={[typography.caption, { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }]}>
                        Email
                    </Text>
                    <Text style={[typography.body, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                        {profile?.email}
                    </Text>
                </View>

                <View style={styles.field}>
                    <Text style={[typography.caption, { color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary }]}>
                        Bio
                    </Text>
                    {editing ? (
                        <TextInput
                            style={[styles.input, styles.textArea, {
                                backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            }]}
                            value={formData.bio}
                            onChangeText={(text) => setFormData({ ...formData, bio: text })}
                            placeholder="Tell us about yourself..."
                            placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                            multiline
                            numberOfLines={4}
                        />
                    ) : (
                        <Text style={[typography.body, { color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary }]}>
                            {profile?.bio || 'No bio yet'}
                        </Text>
                    )}
                </View>
            </View>

            {/* Action Buttons */}
            {editing && (
                <TouchableOpacity
                    style={[styles.button, { backgroundColor: isDark ? AppColors.primaryDarkMode : AppColors.primary }]}
                    onPress={handleSave}
                    disabled={loading}
                >
                    {loading ? (
                        <ActivityIndicator color="#fff" />
                    ) : (
                        <Text style={[typography.button, { color: '#fff' }]}>Save Changes</Text>
                    )}
                </TouchableOpacity>
            )}

            <TouchableOpacity
                style={[styles.logoutButton, { backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface }]}
                onPress={logout}
            >
                <SignOut size={20} color={isDark ? AppColors.errorDark : AppColors.error} />
                <Text style={[typography.button, { color: isDark ? AppColors.errorDark : AppColors.error, marginLeft: spacing.xs }]}>
                    Logout
                </Text>
            </TouchableOpacity>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    content: {
        padding: spacing.md,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: spacing.lg,
    },
    avatarContainer: {
        alignItems: 'center',
        marginBottom: spacing.lg,
    },
    avatar: {
        width: 120,
        height: 120,
        borderRadius: 60,
        justifyContent: 'center',
        alignItems: 'center',
    },
    card: {
        borderRadius: radius.lg,
        padding: spacing.md,
        marginBottom: spacing.md,
    },
    field: {
        marginBottom: spacing.md,
    },
    input: {
        borderRadius: radius.md,
        padding: spacing.sm,
        marginTop: spacing.xs,
        fontSize: 16,
    },
    textArea: {
        height: 100,
        textAlignVertical: 'top',
    },
    button: {
        borderRadius: radius.md,
        padding: spacing.md,
        alignItems: 'center',
        marginBottom: spacing.md,
    },
    logoutButton: {
        borderRadius: radius.md,
        padding: spacing.md,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
    },
});
