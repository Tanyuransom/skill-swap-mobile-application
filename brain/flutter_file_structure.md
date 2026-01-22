# 📁 SKILLSWAPP - FLUTTER FILE STRUCTURE

> **Architecture**: Clean Architecture + Feature-First Organization  
> **State Management**: Riverpod  
> **Purpose**: Enterprise-grade, scalable, maintainable Flutter application structure

---

## 🎯 ARCHITECTURE PRINCIPLES

1. **Clean Architecture**: Separation of concerns (Presentation, Domain, Data)
2. **Feature-First**: Organize by features, not by layers
3. **SOLID Principles**: Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion
4. **Scalability**: Easy to add new features without affecting existing code
5. **Testability**: Easy to write unit, widget, and integration tests

---

## 📂 COMPLETE FILE STRUCTURE

```
skillswapp/
├── lib/
│   ├── main.dart                          # App entry point
│   │
│   ├── app/                               # App-level configuration
│   │   ├── app.dart                       # MaterialApp configuration
│   │   ├── router/                        # App routing
│   │   │   ├── app_router.dart           # Main router configuration
│   │   │   ├── route_names.dart          # Route name constants
│   │   │   └── guards/                    # Route guards (auth, role-based)
│   │   │       ├── auth_guard.dart
│   │   │       └── role_guard.dart
│   │   ├── theme/                         # App theming
│   │   │   ├── app_theme.dart            # Theme configuration
│   │   │   ├── app_colors.dart           # Color palette
│   │   │   ├── app_text_styles.dart      # Typography
│   │   │   └── app_dimensions.dart       # Spacing, sizes
│   │   └── constants/                     # App-wide constants
│   │       ├── app_constants.dart
│   │       ├── api_constants.dart
│   │       └── asset_constants.dart
│   │
│   ├── core/                              # Core utilities & services
│   │   ├── di/                            # Dependency Injection
│   │   │   └── injection.dart            # Service locator setup
│   │   │
│   │   ├── network/                       # Network layer
│   │   │   ├── dio_client.dart           # Dio configuration
│   │   │   ├── api_client.dart           # API client
│   │   │   ├── interceptors/             # HTTP interceptors
│   │   │   │   ├── auth_interceptor.dart
│   │   │   │   ├── logging_interceptor.dart
│   │   │   │   └── error_interceptor.dart
│   │   │   └── api_endpoints.dart        # API endpoint constants
│   │   │
│   │   ├── storage/                       # Local storage
│   │   │   ├── local_storage.dart        # Storage interface
│   │   │   ├── hive_storage.dart         # Hive implementation
│   │   │   └── secure_storage.dart       # Secure storage (tokens)
│   │   │
│   │   ├── utils/                         # Utility functions
│   │   │   ├── validators.dart           # Input validators
│   │   │   ├── formatters.dart           # Data formatters
│   │   │   ├── date_utils.dart           # Date utilities
│   │   │   ├── string_utils.dart         # String utilities
│   │   │   └── logger.dart               # Logging utility
│   │   │
│   │   ├── errors/                        # Error handling
│   │   │   ├── failures.dart             # Failure classes
│   │   │   ├── exceptions.dart           # Exception classes
│   │   │   └── error_handler.dart        # Global error handler
│   │   │
│   │   └── extensions/                    # Dart extensions
│   │       ├── context_extensions.dart
│   │       ├── string_extensions.dart
│   │       ├── date_extensions.dart
│   │       └── num_extensions.dart
│   │
│   ├── shared/                            # Shared across features
│   │   ├── widgets/                       # Reusable widgets
│   │   │   ├── buttons/
│   │   │   │   ├── primary_button.dart
│   │   │   │   ├── secondary_button.dart
│   │   │   │   ├── text_button.dart
│   │   │   │   └── icon_button.dart
│   │   │   ├── inputs/
│   │   │   │   ├── text_field.dart
│   │   │   │   ├── password_field.dart
│   │   │   │   ├── search_field.dart
│   │   │   │   └── dropdown_field.dart
│   │   │   ├── cards/
│   │   │   │   ├── course_card.dart
│   │   │   │   ├── tutor_card.dart
│   │   │   │   └── certificate_card.dart
│   │   │   ├── loaders/
│   │   │   │   ├── loading_indicator.dart
│   │   │   │   ├── shimmer_loader.dart
│   │   │   │   └── skeleton_loader.dart
│   │   │   ├── dialogs/
│   │   │   │   ├── confirmation_dialog.dart
│   │   │   │   ├── error_dialog.dart
│   │   │   │   └── success_dialog.dart
│   │   │   ├── bottom_sheets/
│   │   │   │   ├── filter_bottom_sheet.dart
│   │   │   │   └── sort_bottom_sheet.dart
│   │   │   ├── app_bar/
│   │   │   │   ├── custom_app_bar.dart
│   │   │   │   └── search_app_bar.dart
│   │   │   ├── empty_states/
│   │   │   │   └── empty_state_widget.dart
│   │   │   └── misc/
│   │   │       ├── rating_stars.dart
│   │   │       ├── badge_widget.dart
│   │   │       └── avatar_widget.dart
│   │   │
│   │   ├── models/                        # Shared models
│   │   │   ├── user_model.dart
│   │   │   ├── pagination_model.dart
│   │   │   └── api_response_model.dart
│   │   │
│   │   └── providers/                     # Shared providers
│   │       ├── theme_provider.dart
│   │       └── connectivity_provider.dart
│   │
│   └── features/                          # Feature modules
│       │
│       ├── auth/                          # Authentication feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── login_request_model.dart
│       │   │   │   ├── login_response_model.dart
│       │   │   │   ├── register_request_model.dart
│       │   │   │   └── auth_user_model.dart
│       │   │   ├── datasources/
│       │   │   │   ├── auth_remote_datasource.dart
│       │   │   │   └── auth_local_datasource.dart
│       │   │   └── repositories/
│       │   │       └── auth_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── auth_user.dart
│       │   │   ├── repositories/
│       │   │   │   └── auth_repository.dart
│       │   │   └── usecases/
│       │   │       ├── login_usecase.dart
│       │   │       ├── register_usecase.dart
│       │   │       ├── logout_usecase.dart
│       │   │       ├── google_signin_usecase.dart
│       │   │       ├── facebook_signin_usecase.dart
│       │   │       └── forgot_password_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── auth_provider.dart
│       │       │   └── auth_state.dart
│       │       ├── screens/
│       │       │   ├── welcome_screen.dart
│       │       │   ├── signin_screen.dart
│       │       │   ├── signup_screen.dart
│       │       │   ├── account_type_screen.dart
│       │       │   ├── forgot_password_screen.dart
│       │       │   └── verification_code_screen.dart
│       │       └── widgets/
│       │           ├── social_login_buttons.dart
│       │           ├── auth_header.dart
│       │           └── terms_checkbox.dart
│       │
│       ├── home/                          # Home/Dashboard feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   └── dashboard_data_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── home_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── home_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── dashboard_data.dart
│       │   │   ├── repositories/
│       │   │   │   └── home_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_dashboard_data_usecase.dart
│       │   │       └── get_recommendations_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   └── home_provider.dart
│       │       ├── screens/
│       │       │   └── student_home_screen.dart
│       │       └── widgets/
│       │           ├── home_app_bar.dart
│       │           ├── category_list.dart
│       │           ├── recommended_courses.dart
│       │           └── trending_courses.dart
│       │
│       ├── courses/                       # Courses feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── course_model.dart
│       │   │   │   ├── module_model.dart
│       │   │   │   ├── lesson_model.dart
│       │   │   │   └── category_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── course_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── course_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── course.dart
│       │   │   │   ├── module.dart
│       │   │   │   ├── lesson.dart
│       │   │   │   └── category.dart
│       │   │   ├── repositories/
│       │   │   │   └── course_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_courses_usecase.dart
│       │   │       ├── get_course_details_usecase.dart
│       │   │       ├── search_courses_usecase.dart
│       │   │       ├── filter_courses_usecase.dart
│       │   │       ├── create_course_usecase.dart
│       │   │       └── enroll_course_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── course_list_provider.dart
│       │       │   ├── course_detail_provider.dart
│       │       │   └── course_filter_provider.dart
│       │       ├── screens/
│       │       │   ├── category_screen.dart
│       │       │   ├── course_list_screen.dart
│       │       │   ├── course_detail_screen.dart
│       │       │   ├── search_screen.dart
│       │       │   └── filter_screen.dart
│       │       └── widgets/
│       │           ├── course_card.dart
│       │           ├── course_header.dart
│       │           ├── course_curriculum.dart
│       │           ├── course_reviews.dart
│       │           └── enroll_button.dart
│       │
│       ├── learning/                      # Learning/Course Player feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── enrollment_model.dart
│       │   │   │   ├── progress_model.dart
│       │   │   │   └── quiz_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── learning_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── learning_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── enrollment.dart
│       │   │   │   ├── progress.dart
│       │   │   │   └── quiz.dart
│       │   │   ├── repositories/
│       │   │   │   └── learning_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_enrollment_usecase.dart
│       │   │       ├── update_progress_usecase.dart
│       │   │       ├── submit_quiz_usecase.dart
│       │   │       └── complete_course_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── learning_provider.dart
│       │       │   └── progress_provider.dart
│       │       ├── screens/
│       │       │   ├── learning_screen.dart
│       │       │   ├── quiz_screen.dart
│       │       │   └── final_exam_screen.dart
│       │       └── widgets/
│       │           ├── video_player_widget.dart
│       │           ├── lesson_list.dart
│       │           ├── progress_bar.dart
│       │           └── quiz_question.dart
│       │
│       ├── verification/                  # AI Verification feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── verification_request_model.dart
│       │   │   │   ├── exam_model.dart
│       │   │   │   ├── question_model.dart
│       │   │   │   └── verification_result_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── verification_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── verification_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── verification_request.dart
│       │   │   │   ├── exam.dart
│       │   │   │   ├── question.dart
│       │   │   │   └── verification_result.dart
│       │   │   ├── repositories/
│       │   │   │   └── verification_repository.dart
│       │   │   └── usecases/
│       │   │       ├── request_verification_usecase.dart
│       │   │       ├── start_exam_usecase.dart
│       │   │       ├── submit_exam_usecase.dart
│       │   │       └── get_verification_status_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── verification_provider.dart
│       │       │   └── exam_provider.dart
│       │       ├── screens/
│       │       │   ├── verification_request_screen.dart
│       │       │   ├── verification_exam_screen.dart
│       │       │   └── verification_result_screen.dart
│       │       └── widgets/
│       │           ├── skill_domain_selector.dart
│       │           ├── exam_timer.dart
│       │           ├── question_widget.dart
│       │           └── verification_badge.dart
│       │
│       ├── profile/                       # User Profile feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── profile_model.dart
│       │   │   │   └── user_stats_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── profile_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── profile_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── profile.dart
│       │   │   │   └── user_stats.dart
│       │   │   ├── repositories/
│       │   │   │   └── profile_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_profile_usecase.dart
│       │   │       ├── update_profile_usecase.dart
│       │   │       └── upload_profile_picture_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   └── profile_provider.dart
│       │       ├── screens/
│       │       │   ├── profile_screen.dart
│       │       │   ├── edit_profile_screen.dart
│       │       │   └── settings_screen.dart
│       │       └── widgets/
│       │           ├── profile_header.dart
│       │           ├── profile_stats.dart
│       │           └── settings_tile.dart
│       │
│       ├── payment/                       # Payment feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── payment_method_model.dart
│       │   │   │   ├── transaction_model.dart
│       │   │   │   └── wallet_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── payment_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── payment_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── payment_method.dart
│       │   │   │   ├── transaction.dart
│       │   │   │   └── wallet.dart
│       │   │   ├── repositories/
│       │   │   │   └── payment_repository.dart
│       │   │   └── usecases/
│       │   │       ├── process_payment_usecase.dart
│       │   │       ├── add_payment_method_usecase.dart
│       │   │       ├── get_wallet_balance_usecase.dart
│       │   │       └── get_transactions_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   └── payment_provider.dart
│       │       ├── screens/
│       │       │   ├── payment_method_screen.dart
│       │       │   ├── payment_settings_screen.dart
│       │       │   └── transaction_history_screen.dart
│       │       └── widgets/
│       │           ├── payment_method_card.dart
│       │           ├── add_card_form.dart
│       │           └── transaction_tile.dart
│       │
│       ├── messaging/                     # Messaging feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── conversation_model.dart
│       │   │   │   └── message_model.dart
│       │   │   ├── datasources/
│       │   │   │   ├── messaging_remote_datasource.dart
│       │   │   │   └── messaging_local_datasource.dart
│       │   │   └── repositories/
│       │   │       └── messaging_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── conversation.dart
│       │   │   │   └── message.dart
│       │   │   ├── repositories/
│       │   │   │   └── messaging_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_conversations_usecase.dart
│       │   │       ├── get_messages_usecase.dart
│       │   │       ├── send_message_usecase.dart
│       │   │       └── mark_as_read_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── conversation_provider.dart
│       │       │   └── message_provider.dart
│       │       ├── screens/
│       │       │   ├── inbox_screen.dart
│       │       │   └── chat_screen.dart
│       │       └── widgets/
│       │           ├── conversation_tile.dart
│       │           ├── message_bubble.dart
│       │           └── message_input.dart
│       │
│       ├── notifications/                 # Notifications feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   └── notification_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── notification_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── notification_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── notification.dart
│       │   │   ├── repositories/
│       │   │   │   └── notification_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_notifications_usecase.dart
│       │   │       └── mark_notification_read_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   └── notification_provider.dart
│       │       ├── screens/
│       │       │   └── notification_screen.dart
│       │       └── widgets/
│       │           └── notification_tile.dart
│       │
│       ├── reviews/                       # Reviews & Ratings feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   └── review_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── review_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── review_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── review.dart
│       │   │   ├── repositories/
│       │   │   │   └── review_repository.dart
│       │   │   └── usecases/
│       │   │       ├── submit_review_usecase.dart
│       │   │       ├── get_reviews_usecase.dart
│       │   │       └── update_review_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   └── review_provider.dart
│       │       ├── screens/
│       │       │   └── submit_review_screen.dart
│       │       └── widgets/
│       │           ├── review_card.dart
│       │           └── rating_input.dart
│       │
│       ├── certificates/                  # Certificates feature
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   └── certificate_model.dart
│       │   │   ├── datasources/
│       │   │   │   └── certificate_remote_datasource.dart
│       │   │   └── repositories/
│       │   │       └── certificate_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── certificate.dart
│       │   │   ├── repositories/
│       │   │   │   └── certificate_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_certificates_usecase.dart
│       │   │       └── download_certificate_usecase.dart
│       │   └── presentation/
│       │       ├── providers/
│       │       │   └── certificate_provider.dart
│       │       ├── screens/
│       │       │   ├── certificates_screen.dart
│       │       │   └── certificate_detail_screen.dart
│       │       └── widgets/
│       │           └── certificate_card.dart
│       │
│       └── blog/                          # Blog/Content feature (future)
│           ├── data/
│           │   ├── models/
│           │   │   └── blog_post_model.dart
│           │   ├── datasources/
│           │   │   └── blog_remote_datasource.dart
│           │   └── repositories/
│           │       └── blog_repository_impl.dart
│           ├── domain/
│           │   ├── entities/
│           │   │   └── blog_post.dart
│           │   ├── repositories/
│           │   │   └── blog_repository.dart
│           │   └── usecases/
│           │       └── get_blog_posts_usecase.dart
│           └── presentation/
│               ├── providers/
│               │   └── blog_provider.dart
│               ├── screens/
│               │   ├── blog_discovery_screen.dart
│               │   └── blog_detail_screen.dart
│               └── widgets/
│                   └── blog_card.dart
│
├── assets/                                # Static assets
│   ├── images/
│   │   ├── logo/
│   │   │   ├── logo.png
│   │   │   └── logo_white.png
│   │   ├── icons/
│   │   │   └── (custom icons)
│   │   ├── illustrations/
│   │   │   ├── welcome_1.png
│   │   │   ├── welcome_2.png
│   │   │   ├── welcome_3.png
│   │   │   └── empty_state.png
│   │   └── placeholders/
│   │       ├── course_placeholder.png
│   │       └── avatar_placeholder.png
│   ├── fonts/
│   │   └── Inter/
│   │       ├── Inter-Regular.ttf
│   │       ├── Inter-Medium.ttf
│   │       ├── Inter-SemiBold.ttf
│   │       └── Inter-Bold.ttf
│   └── animations/
│       └── (Lottie animations)
│
├── test/                                  # Tests
│   ├── unit/
│   │   ├── core/
│   │   └── features/
│   │       ├── auth/
│   │       ├── courses/
│   │       └── (other features)
│   ├── widget/
│   │   └── (widget tests)
│   └── integration/
│       └── (integration tests)
│
├── analysis_options.yaml                  # Linting rules
├── pubspec.yaml                           # Dependencies
└── README.md                              # Project documentation
```

---

## 📦 KEY DEPENDENCIES (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # Routing
  go_router: ^13.0.0

  # Network
  dio: ^5.4.0
  retrofit: ^4.0.0
  pretty_dio_logger: ^1.3.1

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.0.0

  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

  # UI
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  flutter_svg: ^2.0.9
  lottie: ^3.0.0

  # Video Player
  video_player: ^2.8.1
  chewie: ^1.7.4

  # Authentication
  google_sign_in: ^6.1.6
  flutter_facebook_auth: ^6.0.3

  # Payment
  flutter_stripe: ^10.1.0

  # Push Notifications
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9

  # Utils
  intl: ^0.18.1
  url_launcher: ^6.2.2
  share_plus: ^7.2.1
  image_picker: ^1.0.5
  permission_handler: ^11.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

  # Code Generation
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  retrofit_generator: ^8.0.0
  hive_generator: ^2.0.1

  # Testing
  mockito: ^5.4.4
  mocktail: ^1.0.2
```

---

## 🎨 DESIGN SYSTEM STRUCTURE

### Colors (`app/theme/app_colors.dart`)
```dart
class AppColors {
  // Primary
  static const primary = Color(0xFF6C63FF);
  static const primaryDark = Color(0xFF5A52E0);
  static const primaryLight = Color(0xFF8B84FF);
  
  // Secondary
  static const secondary = Color(0xFFFF6584);
  
  // Status
  static const success = Color(0x00D4AA);
  static const warning = Color(0xFFFFB800);
  static const error = Color(0xFFFF4757);
  
  // Neutral
  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF2C3E50);
  static const textSecondary = Color(0xFF7F8C8D);
  
  // ... more colors
}
```

### Typography (`app/theme/app_text_styles.dart`)
```dart
class AppTextStyles {
  static const heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
  );
  
  static const heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
  );
  
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
  );
  
  // ... more text styles
}
```

---

## 🔄 DATA FLOW EXAMPLE

### Example: Course List Feature

```
User Action (Tap Category)
        ↓
Presentation Layer (course_list_screen.dart)
        ↓
Provider (course_list_provider.dart)
        ↓
UseCase (get_courses_usecase.dart)
        ↓
Repository Interface (course_repository.dart)
        ↓
Repository Implementation (course_repository_impl.dart)
        ↓
Remote DataSource (course_remote_datasource.dart)
        ↓
API Client (dio_client.dart)
        ↓
Backend API
        ↓
Response flows back up the chain
        ↓
UI updates with data
```

---

## 🧪 TESTING STRUCTURE

### Unit Tests
- Test business logic (UseCases)
- Test data transformations (Models)
- Test utilities

### Widget Tests
- Test individual widgets
- Test user interactions
- Test widget rendering

### Integration Tests
- Test complete user flows
- Test API integration
- Test navigation

---

## 📝 NAMING CONVENTIONS

### Files
- **Screens**: `*_screen.dart` (e.g., `signin_screen.dart`)
- **Widgets**: `*_widget.dart` or descriptive name (e.g., `course_card.dart`)
- **Models**: `*_model.dart` (e.g., `course_model.dart`)
- **Providers**: `*_provider.dart` (e.g., `auth_provider.dart`)
- **UseCases**: `*_usecase.dart` (e.g., `login_usecase.dart`)
- **Repositories**: `*_repository.dart` (e.g., `auth_repository.dart`)

### Classes
- **PascalCase**: `class CourseCard extends StatelessWidget`
- **Providers**: `class AuthProvider extends StateNotifier`
- **Models**: `class CourseModel`

### Variables
- **camelCase**: `final userName = 'John';`
- **Constants**: `const kDefaultPadding = 16.0;`

---

## ✅ BENEFITS OF THIS STRUCTURE

1. **Scalability**: Easy to add new features without affecting existing code
2. **Maintainability**: Clear separation of concerns
3. **Testability**: Each layer can be tested independently
4. **Reusability**: Shared widgets and utilities
5. **Team Collaboration**: Clear structure for multiple developers
6. **Clean Architecture**: Business logic separated from UI
7. **Feature Independence**: Features are self-contained modules

---

## 🚀 NEXT STEPS

1. **Review this structure** and provide feedback
2. **Create the folder structure** in the Flutter project
3. **Set up dependencies** in pubspec.yaml
4. **Implement core utilities** (network, storage, DI)
5. **Start with authentication feature** (highest priority)

---

**Document Version**: 1.0  
**Created**: 2026-01-11  
**Status**: Proposed - Awaiting Approval
