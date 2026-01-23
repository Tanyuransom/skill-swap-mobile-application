/**
 * Select Category Screen (Enhanced)
 * Choose from 300+ categories for verification
 */

import { useState, useMemo } from 'react';
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity,
    ScrollView,
    TextInput,
    useColorScheme,
    SectionList,
} from 'react-native';
import { useRouter } from 'expo-router';
import { ArrowLeft, MagnifyingGlass, CheckCircle } from 'phosphor-react-native';
import { AppColors } from '@/theme/colors';
import { typography } from '@/theme/typography';
import { spacing } from '@/theme/spacing';
import { radius } from '@/theme/radius';
import { CATEGORIES, getMainCategories, getCategoriesByMain, searchCategories, type Category } from '@/data/categories';

export default function SelectCategoryScreen() {
    const colorScheme = useColorScheme();
    const isDark = colorScheme === 'dark';
    const router = useRouter();

    const [searchQuery, setSearchQuery] = useState('');
    const [selectedCategory, setSelectedCategory] = useState<Category | null>(null);

    const filteredCategories = useMemo(() => {
        if (searchQuery.trim()) {
            return searchCategories(searchQuery);
        }

        // Group by main category
        const mainCategories = getMainCategories();
        return mainCategories.map(main => ({
            title: main,
            data: getCategoriesByMain(main),
        }));
    }, [searchQuery]);

    const handleContinue = () => {
        if (selectedCategory) {
            router.push({
                pathname: '/tutor/verification/upload-certificate' as any,
                params: {
                    categoryId: selectedCategory.id,
                    categoryName: selectedCategory.name,
                },
            });
        }
    };

    return (
        <View style={[styles.container, { backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background }]}>
            {/* Header */}
            <View style={styles.header}>
                <TouchableOpacity onPress={() => router.back()} style={styles.backButton}>
                    <ArrowLeft size={24} color={isDark ? AppColors.textPrimaryDark : AppColors.textPrimary} />
                </TouchableOpacity>
                <Text style={[typography.h2, {
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                }]}>
                    Select Category
                </Text>
                <View style={{ width: 24 }} />
            </View>

            {/* Search Bar */}
            <View style={[styles.searchContainer, {
                backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface
            }]}>
                <MagnifyingGlass size={20} color={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary} />
                <TextInput
                    style={[styles.searchInput, {
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                    }]}
                    placeholder="Search 300+ categories..."
                    placeholderTextColor={isDark ? AppColors.textSecondaryDark : AppColors.textSecondary}
                    value={searchQuery}
                    onChangeText={setSearchQuery}
                />
            </View>

            {/* Categories List */}
            {searchQuery.trim() ? (
                // Search Results
                <ScrollView contentContainerStyle={styles.content}>
                    {(filteredCategories as Category[]).map((category) => (
                        <TouchableOpacity
                            key={category.id}
                            style={[
                                styles.categoryCard,
                                {
                                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                                    borderWidth: 2,
                                    borderColor: selectedCategory?.id === category.id
                                        ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                        : 'transparent',
                                }
                            ]}
                            onPress={() => setSelectedCategory(category)}
                        >
                            {selectedCategory?.id === category.id && (
                                <CheckCircle
                                    size={20}
                                    color={isDark ? AppColors.primaryDarkMode : AppColors.primary}
                                    weight="fill"
                                    style={styles.checkIcon}
                                />
                            )}
                            <Text style={[typography.bodyMedium, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}>
                                {category.name}
                            </Text>
                            <Text style={[typography.caption, {
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                marginTop: 2
                            }]}>
                                {category.main} → {category.sub}
                            </Text>
                        </TouchableOpacity>
                    ))}
                </ScrollView>
            ) : (
                // Grouped by Main Category
                <SectionList
                    sections={filteredCategories as any}
                    keyExtractor={(item: Category) => item.id}
                    renderSectionHeader={({ section: { title } }) => (
                        <View style={[styles.sectionHeader, {
                            backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background
                        }]}>
                            <Text style={[typography.h4, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}>
                                {title}
                            </Text>
                        </View>
                    )}
                    renderItem={({ item }: { item: Category }) => (
                        <TouchableOpacity
                            style={[
                                styles.categoryCard,
                                {
                                    backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
                                    borderWidth: 2,
                                    borderColor: selectedCategory?.id === item.id
                                        ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                                        : 'transparent',
                                }
                            ]}
                            onPress={() => setSelectedCategory(item)}
                        >
                            {selectedCategory?.id === item.id && (
                                <CheckCircle
                                    size={20}
                                    color={isDark ? AppColors.primaryDarkMode : AppColors.primary}
                                    weight="fill"
                                    style={styles.checkIcon}
                                />
                            )}
                            <Text style={[typography.bodyMedium, {
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
                            }]}>
                                {item.name}
                            </Text>
                            {item.sub && (
                                <Text style={[typography.caption, {
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                    marginTop: 2
                                }]}>
                                    {item.sub}
                                </Text>
                            )}
                        </TouchableOpacity>
                    )}
                    contentContainerStyle={styles.list}
                />
            )}

            {/* Continue Button */}
            <View style={styles.footer}>
                <TouchableOpacity
                    style={[styles.continueButton, {
                        backgroundColor: selectedCategory
                            ? (isDark ? AppColors.primaryDarkMode : AppColors.primary)
                            : (isDark ? AppColors.surfaceDark : AppColors.surface),
                        opacity: selectedCategory ? 1 : 0.5
                    }]}
                    onPress={handleContinue}
                    disabled={!selectedCategory}
                >
                    <Text style={[typography.button, { color: '#fff' }]}>
                        Continue
                    </Text>
                </TouchableOpacity>
            </View>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: spacing.md,
        paddingTop: spacing.xl,
    },
    backButton: {
        padding: 4,
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        margin: spacing.md,
        paddingHorizontal: spacing.md,
        paddingVertical: spacing.sm,
        borderRadius: radius.lg,
        gap: spacing.sm,
    },
    searchInput: {
        flex: 1,
        fontSize: 16,
    },
    content: {
        padding: spacing.md,
        gap: spacing.sm,
    },
    list: {
        paddingBottom: 100,
    },
    sectionHeader: {
        paddingVertical: spacing.md,
        paddingHorizontal: spacing.md,
    },
    categoryCard: {
        padding: spacing.md,
        borderRadius: radius.lg,
        marginHorizontal: spacing.md,
        marginBottom: spacing.sm,
        position: 'relative',
    },
    checkIcon: {
        position: 'absolute',
        top: spacing.sm,
        right: spacing.sm,
    },
    footer: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        padding: spacing.md,
        paddingBottom: spacing.xl,
    },
    continueButton: {
        padding: spacing.md,
        borderRadius: radius.lg,
        alignItems: 'center',
    },
});
