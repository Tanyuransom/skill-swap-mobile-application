/**
 * Tutor Profile Screen (Public View)
 * Students can view tutor's courses, posts, and reels
 */

import { useState, useEffect } from 'react';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    TouchableOpacity,
    Image,
    useColorScheme,
    FlatList,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { ArrowLeft, GraduationCap, Users, Star, UserPlus, UserMinus } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { socialFeedService, type Post } from '@/services/social-feed.service';
import { reelsService, type Reel } from '@/services/reels.service';
import { courseService, type Course } from '@/services/course.service';
import { PostCard } from '@/components/PostCard';
import { Loading } from '@/components/Loading';

type TabType = 'courses' | 'posts' | 'reels';

export default function TutorProfileScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();
    const { userId } = useLocalSearchParams<{ userId: string }>();

    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState<TabType>('courses');
    const [isFollowing, setIsFollowing] = useState(false);
    const [tutor, setTutor] = useState<any>(null);
    const [courses, setCourses] = useState<Course[]>([]);
    const [posts, setPosts] = useState<Post[]>([]);
    const [reels, setReels] = useState<Reel[]>([]);

    useEffect(() => {
        if (userId) {
            loadTutorProfile();
        }
    }, [userId]);

    const loadTutorProfile = async () => {
        try {
            setLoading(true);
            // Load tutor stats and content
            const [coursesData, postsData, reelsData] = await Promise.all([
                courseService.getAllCourses(), // TODO: Filter by tutor
                socialFeedService.getUserPosts(userId!),
                reelsService.getUserReels(userId!),
            ]);

            setCourses(coursesData.filter(c => c.tutorId === userId));
            setPosts(postsData);
            setReels(reelsData);

            // Mock tutor data
            setTutor({
                id: userId,
                name: 'John Doe',
                bio: 'Expert in Web Development with 10+ years of experience',
                avatar: 'https://via.placeholder.com/150',
                coursesCount: coursesData.length,
                studentsCount: 1234,
                rating: 4.8,
                followersCount: 5678,
            });
        } catch (error) {
            console.error('Failed to load tutor profile:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleFollow = async () => {
        try {
            if (isFollowing) {
                await socialFeedService.unfollowUser(userId!);
            } else {
                await socialFeedService.followUser(userId!);
            }
            setIsFollowing(!isFollowing);
        } catch (error) {
            console.error('Failed to follow/unfollow:', error);
        }
    };

    if (loading || !tutor) {
        return <Loading fullScreen />;
    }

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.header}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
                    <ArrowLeft size={24} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                </TouchableOpacity>
            </View>

            <ScrollView>
                {/* Profile Info */}
                <View style={styles.profileSection}>
                    <Image source={{ uri: tutor.avatar }} style={styles.avatar} />
                    <Text style={[typography.h2, styles.name, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}>
                        {tutor.name}
                    </Text>
                    <Text style={[typography.body, styles.bio, {
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                    }]}>
                        {tutor.bio}
                    </Text>

                    {/* Stats */}
                    <View style={styles.statsRow}>
                        <View style={styles.stat}>
                            <Text style={[typography.h3, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}>
                                {tutor.coursesCount}
                            </Text>
                            <Text style={[typography.caption, {
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                            }]}>
                                Courses
                            </Text>
                        </View>
                        <View style={styles.stat}>
                            <Text style={[typography.h3, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}>
                                {tutor.studentsCount}
                            </Text>
                            <Text style={[typography.caption, {
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                            }]}>
                                Students
                            </Text>
                        </View>
                        <View style={styles.stat}>
                            <View style={styles.ratingRow}>
                                <Star size={20} color="#FFB800" weight="fill" />
                                <Text style={[typography.h3, {
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                    marginLeft: 4
                                }]}>
                                    {tutor.rating}
                                </Text>
                            </View>
                            <Text style={[typography.caption, {
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                            }]}>
                                Rating
                            </Text>
                        </View>
                    </View>

                    {/* Follow Button */}
                    <TouchableOpacity
                        style={[styles.followButton, {
                            backgroundColor: isFollowing
                                ? (isDark ? AppColors.surfaceDark : AppColors.surface)
                                : (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                        }]}
                        onPress={handleFollow}
                    >
                        {isFollowing ? (
                            <UserMinus size={20} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                        ) : (
                            <UserPlus size={20} color="#fff" />
                        )}
                        <Text style={[typography.button, {
                            color: isFollowing
                                ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
                                : '#fff',
                            marginLeft: spacing.sm
                        }]}>
                            {isFollowing ? 'Following' : 'Follow'}
                        </Text>
                    </TouchableOpacity>
                </View>

                {/* Tabs */}
                <View style={styles.tabs}>
                    <TouchableOpacity
                        style={[styles.tab, activeTab === 'courses' && styles.activeTab]}
                        onPress={() => setActiveTab('courses')}
                    >
                        <GraduationCap size={20} color={activeTab === 'courses'
                            ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                            : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)
                        } />
                        <Text style={[typography.bodyMedium, {
                            color: activeTab === 'courses'
                                ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)
                        }]}>
                            Courses
                        </Text>
                    </TouchableOpacity>

                    <TouchableOpacity
                        style={[styles.tab, activeTab === 'posts' && styles.activeTab]}
                        onPress={() => setActiveTab('posts')}
                    >
                        <Text style={[typography.bodyMedium, {
                            color: activeTab === 'posts'
                                ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)
                        }]}>
                            Posts
                        </Text>
                    </TouchableOpacity>

                    <TouchableOpacity
                        style={[styles.tab, activeTab === 'reels' && styles.activeTab]}
                        onPress={() => setActiveTab('reels')}
                    >
                        <Text style={[typography.bodyMedium, {
                            color: activeTab === 'reels'
                                ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)
                        }]}>
                            Reels
                        </Text>
                    </TouchableOpacity>
                </View>

                {/* Content */}
                <View style={styles.content}>
                    {activeTab === 'courses' && (
                        <View style={styles.coursesGrid}>
                            {courses.map(course => (
                                <TouchableOpacity
                                    key={course.id}
                                    style={[styles.courseCard, {
                                        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
                                    }]}
                                    onPress={() => router.push(`/courses/${course.id}` as any)}
                                >
                                    <Image source={{ uri: course.thumbnailUrl }} style={styles.courseThumbnail} />
                                    <Text style={[typography.bodyMedium, styles.courseTitle, {
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                                    }]} numberOfLines={2}>
                                        {course.title}
                                    </Text>
                                    <Text style={[typography.caption, {
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary
                                    }]}>
                                        {course.price === 0 ? 'Free' : `${course.price} ${course.currency}`}
                                    </Text>
                                </TouchableOpacity>
                            ))}
                        </View>
                    )}

                    {activeTab === 'posts' && (
                        <View>
                            {posts.map(post => (
                                <PostCard key={post.id} post={post} />
                            ))}
                        </View>
                    )}

                    {activeTab === 'reels' && (
                        <View style={styles.reelsGrid}>
                            {reels.map(reel => (
                                <TouchableOpacity
                                    key={reel.id}
                                    style={styles.reelCard}
                                    onPress={() => router.push('/(tabs)/reels' as any)}
                                >
                                    <Image source={{ uri: reel.thumbnailUrl }} style={styles.reelThumbnail} />
                                </TouchableOpacity>
                            ))}
                        </View>
                    )}
                </View>
            </ScrollView>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    backButton: {
        padding: 4,
    },
    profileSection: {
        alignItems: 'center',
        padding: spacing.lg,
    },
    avatar: {
        width: 100,
        height: 100,
        borderRadius: 50,
        marginBottom: spacing.md,
    },
    name: {
        marginBottom: spacing.xs,
    },
    bio: {
        textAlign: 'center',
        marginBottom: spacing.lg,
    },
    statsRow: {
        flexDirection: 'row',
        gap: spacing.xl,
        marginBottom: spacing.lg,
    },
    stat: {
        alignItems: 'center',
    },
    ratingRow: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    followButton: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: spacing.xl,
        paddingVertical: spacing.md,
        borderRadius: radius.full,
    },
    tabs: {
        flexDirection: 'row',
        borderBottomWidth: 1,
        borderBottomColor: '#E5E7EB',
    },
    tab: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        gap: spacing.xs,
        paddingVertical: spacing.md,
    },
    activeTab: {
        borderBottomWidth: 2,
        borderBottomColor: AppColors.primary,
    },
    content: {
        padding: spacing.md,
    },
    coursesGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: spacing.md,
    },
    courseCard: {
        width: '48%',
        borderRadius: radius.lg,
        overflow: 'hidden',
    },
    courseThumbnail: {
        width: '100%',
        height: 100,
    },
    courseTitle: {
        padding: spacing.sm,
    },
    reelsGrid: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        gap: 4,
    },
    reelCard: {
        width: '32.5%',
        aspectRatio: 9 / 16,
    },
    reelThumbnail: {
        width: '100%',
        height: '100%',
        borderRadius: radius.sm,
    },
});
