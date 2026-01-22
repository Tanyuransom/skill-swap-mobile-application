# 📁 Proposed Flutter `lib` Folder Structure

## 📊 Analysis of Figma Screens (27 Total)

### Categorization by Feature

#### 🔐 Authentication & Onboarding (7 screens)
1. `welcome screen.png` - Welcome 1
2. `welcome2.png` - Welcome 2
3. `welcome 3.png` - Welcome 3
4. `acount type.png` - Account Type Selection (Student/Tutor)
5. `create account.png` - Sign Up
6. `sign in.png` - Sign In
7. `forgot password.png` / `forgot password (1).png` - Password Recovery
8. `verification code.png` - Email/Phone Verification

#### 🏠 Home & Navigation (3 screens)
9. `student home screen.png` - Student Dashboard
10. `menu.png` - Side Menu/Drawer
11. `category.png` - Categories Overview

#### 🔍 Discovery & Search (5 screens)
12. `learn skill category.png` - Learn Skills Category
13. `search.png` - Search Screen
14. `filter.png` - Filter Options
15. `course selection.png` - Course List/Selection
16. `no data.png` - Empty State

#### 📚 Learning (1 screen)
17. `Learning screen.png` - Course Player/Learning Interface

#### 💬 Messaging (2 screens)
18. `inbox.png` - Inbox/Conversations List
19. `personal inbox.png` - Personal Chat

#### 👤 Profile & Settings (3 screens)
20. `profile.png` - User Profile
21. `edit profile.png` - Edit Profile
22. `payment settingssettings.png` - Payment Settings

#### 💳 Payments (1 screen)
23. `Payment method.png` - Payment Method Selection

#### 🔔 Notifications (1 screen)
24. `Notification menu.png` - Notification Settings

#### 📝 Blog (1 screen)
25. `blog discovery.png` - Blog Discovery/Reading

#### 🎨 Assets (1 file)
26. `Skill swap logo.png` - App Logo

---

## 🏗️ Proposed `lib` Folder Structure

Based on **Clean Architecture** + **Feature-First** organization:

```
lib/
├── main.dart                           # App entry point
│
├── app/                                # App-level configuration
│   ├── app.dart                       # MaterialApp setup
│   ├── router/                        # Navigation
│   │   ├── app_router.dart           # GoRouter/AutoRoute config
│   │   ├── route_names.dart          # Route constants
│   │   └── guards/                    # Route guards
│   │       ├── auth_guard.dart       # Authentication guard
│   │       └── role_guard.dart       # Role-based guard (student/tutor)
│   ├── theme/                         # App theming
│   │   ├── app_theme.dart            # Theme configuration
│   │   ├── app_colors.dart           # Color palette (#7B61FF, etc.)
│   │   ├── app_text_styles.dart      # Typography (Roboto)
│   │   └── app_dimensions.dart       # Spacing, sizes
│   └── constants/                     # App-wide constants
│       ├── app_constants.dart        # General constants
│       ├── api_constants.dart        # API endpoints
│       └── asset_constants.dart      # Asset paths
│
├── core/                               # Core utilities & services
│   ├── network/                       # Network layer
│   │   ├── dio_client.dart           # Dio configuration
│   │   ├── api_client.dart           # API client
│   │   ├── interceptors/             # HTTP interceptors
│   │   │   ├── auth_interceptor.dart
│   │   │   ├── logging_interceptor.dart
│   │   │   └── error_interceptor.dart
│   │   └── api_endpoints.dart        # API endpoint constants
│   ├── storage/                       # Local storage
│   │   ├── local_storage.dart        # Storage interface
│   │   ├── hive_storage.dart         # Hive implementation
│   │   └── secure_storage.dart       # Secure storage (tokens)
│   ├── utils/                         # Utility functions
│   │   ├── validators.dart           # Input validators
│   │   ├── formatters.dart           # Data formatters
│   │   ├── date_utils.dart           # Date utilities
│   │   └── logger.dart               # Logging utility
│   ├── errors/                        # Error handling
│   │   ├── failures.dart             # Failure classes
│   │   ├── exceptions.dart           # Exception classes
│   │   └── error_handler.dart        # Global error handler
│   └── extensions/                    # Dart extensions
│       ├── context_extensions.dart
│       ├── string_extensions.dart
│       └── date_extensions.dart
│
├── shared/                             # Shared across features
│   ├── widgets/                       # Reusable widgets
│   │   ├── buttons/
│   │   │   ├── primary_button.dart
│   │   │   ├── secondary_button.dart
│   │   │   └── icon_button.dart
│   │   ├── inputs/
│   │   │   ├── custom_text_field.dart
│   │   │   ├── password_field.dart
│   │   │   └── search_field.dart
│   │   ├── cards/
│   │   │   ├── skill_card.dart
│   │   │   ├── course_card.dart
│   │   │   └── blog_card.dart
│   │   ├── loaders/
│   │   │   ├── loading_indicator.dart
│   │   │   └── shimmer_loader.dart
│   │   ├── dialogs/
│   │   │   ├── confirmation_dialog.dart
│   │   │   └── error_dialog.dart
│   │   ├── app_bar/
│   │   │   └── custom_app_bar.dart
│   │   └── empty_states/
│   │       └── no_data_widget.dart   # Based on "no data.png"
│   ├── models/                        # Shared models
│   │   ├── user_model.dart
│   │   └── api_response_model.dart
│   └── providers/                     # Shared providers
│       ├── theme_provider.dart
│       └── user_provider.dart
│
└── features/                           # Feature modules
    │
    ├── onboarding/                    # Onboarding (3 screens)
    │   └── presentation/
    │       ├── screens/
    │       │   ├── welcome_screen_1.dart
    │       │   ├── welcome_screen_2.dart
    │       │   └── welcome_screen_3.dart
    │       └── widgets/
    │           └── onboarding_indicator.dart
    │
    ├── auth/                          # Authentication (5 screens)
    │   ├── data/
    │   │   ├── models/
    │   │   │   ├── login_request_model.dart
    │   │   │   ├── login_response_model.dart
    │   │   │   └── register_request_model.dart
    │   │   ├── datasources/
    │   │   │   ├── auth_remote_datasource.dart
    │   │   │   └── auth_local_datasource.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── login_usecase.dart
    │   │       ├── register_usecase.dart
    │   │       ├── logout_usecase.dart
    │   │       └── forgot_password_usecase.dart
    │   └── presentation/
    │       ├── providers/
    │       │   ├── auth_provider.dart
    │       │   └── auth_state.dart
    │       ├── screens/
    │       │   ├── account_type_screen.dart      # "acount type.png"
    │       │   ├── create_account_screen.dart    # "create account.png"
    │       │   ├── sign_in_screen.dart           # "sign in.png"
    │       │   ├── forgot_password_screen.dart   # "forgot password.png"
    │       │   └── verification_code_screen.dart # "verification code.png"
    │       └── widgets/
    │           ├── auth_header.dart
    │           └── role_selector.dart
    │
    ├── home/                          # Home & Dashboard (3 screens)
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── dashboard_data_model.dart
    │   │   ├── datasources/
    │   │   │   └── home_remote_datasource.dart
    │   │   └── repositories/
    │   │       └── home_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── dashboard_data.dart
    │   │   ├── repositories/
    │   │   │   └── home_repository.dart
    │   │   └── usecases/
    │   │       └── get_dashboard_data_usecase.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── home_provider.dart
    │       ├── screens/
    │       │   ├── student_home_screen.dart      # "student home screen.png"
    │       │   ├── menu_screen.dart              # "menu.png"
    │       │   └── category_screen.dart          # "category.png"
    │       └── widgets/
    │           ├── category_grid.dart
    │           ├── trending_section.dart
    │           └── recommendation_section.dart
    │
    ├── discovery/                     # Discovery & Search (5 screens)
    │   ├── data/
    │   │   ├── models/
    │   │   │   ├── skill_model.dart
    │   │   │   ├── course_model.dart
    │   │   │   └── filter_model.dart
    │   │   ├── datasources/
    │   │   │   └── discovery_remote_datasource.dart
    │   │   └── repositories/
    │   │       └── discovery_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── skill.dart
    │   │   │   ├── course.dart
    │   │   │   └── filter.dart
    │   │   ├── repositories/
    │   │   │   └── discovery_repository.dart
    │   │   └── usecases/
    │   │       ├── search_skills_usecase.dart
    │   │       ├── filter_skills_usecase.dart
    │   │       └── get_courses_usecase.dart
    │   └── presentation/
    │       ├── providers/
    │       │   ├── discovery_provider.dart
    │       │   └── filter_provider.dart
    │       ├── screens/
    │       │   ├── learn_skill_category_screen.dart  # "learn skill category.png"
    │       │   ├── search_screen.dart                # "search.png"
    │       │   ├── filter_screen.dart                # "filter.png"
    │       │   └── course_selection_screen.dart      # "course selection.png"
    │       └── widgets/
    │           ├── skill_card.dart
    │           ├── course_card.dart
    │           ├── filter_chip.dart
    │           └── search_bar.dart
    │
    ├── learning/                      # Learning Experience (1 screen)
    │   ├── data/
    │   │   ├── models/
    │   │   │   ├── lesson_model.dart
    │   │   │   └── progress_model.dart
    │   │   ├── datasources/
    │   │   │   └── learning_remote_datasource.dart
    │   │   └── repositories/
    │   │       └── learning_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── lesson.dart
    │   │   │   └── progress.dart
    │   │   ├── repositories/
    │   │   │   └── learning_repository.dart
    │   │   └── usecases/
    │   │       ├── get_lesson_usecase.dart
    │   │       └── update_progress_usecase.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── learning_provider.dart
    │       ├── screens/
    │       │   └── learning_screen.dart          # "Learning screen.png"
    │       └── widgets/
    │           ├── video_player_widget.dart
    │           ├── lesson_list.dart
    │           └── progress_indicator.dart
    │
    ├── messaging/                     # Messaging (2 screens)
    │   ├── data/
    │   │   ├── models/
    │   │   │   ├── conversation_model.dart
    │   │   │   └── message_model.dart
    │   │   ├── datasources/
    │   │   │   ├── messaging_remote_datasource.dart
    │   │   │   └── messaging_local_datasource.dart
    │   │   └── repositories/
    │   │       └── messaging_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── conversation.dart
    │   │   │   └── message.dart
    │   │   ├── repositories/
    │   │   │   └── messaging_repository.dart
    │   │   └── usecases/
    │   │       ├── get_conversations_usecase.dart
    │   │       ├── get_messages_usecase.dart
    │   │       └── send_message_usecase.dart
    │   └── presentation/
    │       ├── providers/
    │       │   ├── conversation_provider.dart
    │       │   └── message_provider.dart
    │       ├── screens/
    │       │   ├── inbox_screen.dart             # "inbox.png"
    │       │   └── personal_inbox_screen.dart    # "personal inbox.png"
    │       └── widgets/
    │           ├── conversation_tile.dart
    │           ├── message_bubble.dart
    │           └── message_input.dart
    │
    ├── profile/                       # Profile & Settings (3 screens)
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── profile_model.dart
    │   │   ├── datasources/
    │   │   │   └── profile_remote_datasource.dart
    │   │   └── repositories/
    │   │       └── profile_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── profile.dart
    │   │   ├── repositories/
    │   │   │   └── profile_repository.dart
    │   │   └── usecases/
    │   │       ├── get_profile_usecase.dart
    │   │       └── update_profile_usecase.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── profile_provider.dart
    │       ├── screens/
    │       │   ├── profile_screen.dart           # "profile.png"
    │       │   ├── edit_profile_screen.dart      # "edit profile.png"
    │       │   └── payment_settings_screen.dart  # "payment settingssettings.png"
    │       └── widgets/
    │           ├── profile_header.dart
    │           └── settings_tile.dart
    │
    ├── payment/                       # Payment (1 screen)
    │   ├── data/
    │   │   ├── models/
    │   │   │   ├── payment_method_model.dart
    │   │   │   └── transaction_model.dart
    │   │   ├── datasources/
    │   │   │   └── payment_remote_datasource.dart
    │   │   └── repositories/
    │   │       └── payment_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── payment_method.dart
    │   │   │   └── transaction.dart
    │   │   ├── repositories/
    │   │   │   └── payment_repository.dart
    │   │   └── usecases/
    │   │       ├── process_payment_usecase.dart
    │   │       └── get_payment_methods_usecase.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── payment_provider.dart
    │       ├── screens/
    │       │   └── payment_method_screen.dart    # "Payment method.png"
    │       └── widgets/
    │           ├── payment_method_card.dart
    │           └── mtn_orange_selector.dart
    │
    ├── notifications/                 # Notifications (1 screen)
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── notification_model.dart
    │   │   ├── datasources/
    │   │   │   └── notification_remote_datasource.dart
    │   │   └── repositories/
    │   │       └── notification_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── notification.dart
    │   │   ├── repositories/
    │   │   │   └── notification_repository.dart
    │   │   └── usecases/
    │   │       └── get_notifications_usecase.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── notification_provider.dart
    │       ├── screens/
    │       │   └── notification_menu_screen.dart # "Notification menu.png"
    │       └── widgets/
    │           └── notification_tile.dart
    │
    └── blog/                          # Blog (1 screen)
        ├── data/
        │   ├── models/
        │   │   └── blog_post_model.dart
        │   ├── datasources/
        │   │   └── blog_remote_datasource.dart
        │   └── repositories/
        │       └── blog_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── blog_post.dart
        │   ├── repositories/
        │   │   └── blog_repository.dart
        │   └── usecases/
        │       └── get_blog_posts_usecase.dart
        └── presentation/
            ├── providers/
            │   └── blog_provider.dart
            ├── screens/
            │   └── blog_discovery_screen.dart    # "blog discovery.png"
            └── widgets/
                ├── blog_card.dart
                └── featured_blog.dart
```

---

## 📊 Structure Summary

### Total Folders: ~150
### Total Features: 10

| Feature | Screens | Clean Architecture Layers |
|---------|---------|---------------------------|
| Onboarding | 3 | Presentation only |
| Auth | 5 | Data + Domain + Presentation |
| Home | 3 | Data + Domain + Presentation |
| Discovery | 4 | Data + Domain + Presentation |
| Learning | 1 | Data + Domain + Presentation |
| Messaging | 2 | Data + Domain + Presentation |
| Profile | 3 | Data + Domain + Presentation |
| Payment | 1 | Data + Domain + Presentation |
| Notifications | 1 | Data + Domain + Presentation |
| Blog | 1 | Data + Domain + Presentation |

---

## 🎯 Key Design Principles

### 1. **Clean Architecture**
- **Data Layer**: Models, DataSources, Repository Implementations
- **Domain Layer**: Entities, Repository Interfaces, UseCases
- **Presentation Layer**: Providers (Riverpod), Screens, Widgets

### 2. **Feature-First Organization**
- Each feature is self-contained
- Easy to add/remove features
- Clear boundaries

### 3. **Separation of Concerns**
- Business logic in UseCases
- UI logic in Providers
- UI rendering in Screens/Widgets

### 4. **Scalability**
- Easy to add new features
- Easy to test (each layer independently)
- Easy to maintain

### 5. **Reusability**
- Shared widgets in `shared/widgets/`
- Shared models in `shared/models/`
- Core utilities in `core/`

---

## 🔄 Student vs. Tutor Handling

### Approach: **Single App with Role-Based Views**

Instead of two separate apps, use **role-based routing and conditional UI**:

1. **Role Detection**:
   - User selects role during onboarding (`account_type_screen.dart`)
   - Role stored in `UserProvider`
   - Role persisted in local storage

2. **Role-Based Routing**:
   - `RoleGuard` checks user role before navigation
   - Different home screens for Student vs. Tutor
   - Conditional menu items based on role

3. **Shared Features**:
   - Auth, Profile, Messaging, Notifications, Blog → Shared by both
   - Discovery, Learning → Student-specific
   - Course Management (future) → Tutor-specific

4. **Future Tutor Features** (not in Figma yet):
   - Create Course
   - Upload Content
   - Manage Students
   - View Analytics
   - Earnings

---

## 📝 Notes

1. **No Code Yet**: This is just the structure proposal
2. **Based on 27 Figma Screens**: All screens accounted for
3. **Clean Architecture**: Follows best practices
4. **Scalable**: Easy to add tutor-specific features later
5. **Maintainable**: Clear separation of concerns
6. **Testable**: Each layer can be tested independently

---

## ✅ Next Steps (After Approval)

1. Create all folders in `FRONTEND/lib/`
2. Create placeholder files (`.gitkeep` or empty `.dart` files)
3. Set up `pubspec.yaml` with required dependencies
4. Create initial `main.dart` and `app.dart`
5. Implement routing structure
6. Start with Auth feature (highest priority)
