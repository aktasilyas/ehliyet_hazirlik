import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/practice/presentation/screens/practice_detail_screen.dart';
import '../../features/practice/presentation/screens/practice_tab_screen.dart';
import '../../features/progress/presentation/screens/wrong_review_screen.dart';
import '../../features/quiz/presentation/screens/mock_exam_screen.dart';
import '../../features/quiz/presentation/screens/quiz_result_screen.dart';
import '../../features/quiz/presentation/screens/quiz_session_screen.dart';
import '../../features/quiz/presentation/screens/topic_select_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/placeholder_screens.dart';
import 'app_routes.dart';
import 'main_shell_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);
  final onboardingState = ref.watch(onboardingCompleteProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoading =
          authState.isLoading || onboardingState.isLoading;
      final location = state.matchedLocation;

      if (isLoading) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final onboardingDone = onboardingState.requireValue;
      final UserEntity? user = authState.when(
        data: (UserEntity? data) => data,
        error: (_, _) => null,
        loading: () => null,
      );

      final isSplash = location == AppRoutes.splash;
      final isOnboarding = location == AppRoutes.onboarding;
      final isLogin = location == AppRoutes.login;

      if (!onboardingDone) {
        return isOnboarding ? null : AppRoutes.onboarding;
      }

      if (user == null) {
        if (isLogin || isOnboarding) {
          return null;
        }
        return AppRoutes.login;
      }

      if (isSplash || isOnboarding || isLogin) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      MainShellScreen.buildShellRoute(),
      GoRoute(
        path: AppRoutes.quizMock,
        builder: (context, state) => const MockExamScreen(),
      ),
      GoRoute(
        path: AppRoutes.quizTopic,
        builder: (context, state) => const TopicSelectScreen(),
      ),
      GoRoute(
        path: AppRoutes.quizSession,
        builder: (context, state) => const QuizSessionScreen(),
      ),
      GoRoute(
        path: AppRoutes.quizResult,
        builder: (context, state) => const QuizResultScreen(),
      ),
      GoRoute(
        path: AppRoutes.practice,
        builder: (context, state) => const PracticeTabScreen(),
      ),
      GoRoute(
        path: AppRoutes.practiceDetail,
        builder: (context, state) => PracticeDetailScreen(
          topicId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.signs,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Trafik Levhaları'),
      ),
      GoRoute(
        path: AppRoutes.signsCategory,
        builder: (context, state) => PlaceholderScreen(
          title: 'Levha: ${state.pathParameters['category']}',
        ),
      ),
      GoRoute(
        path: AppRoutes.wrongReview,
        builder: (context, state) => const WrongReviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.premium,
        builder: (context, state) =>
            const PlaceholderScreen(title: 'Premium'),
      ),
    ],
  );
}
