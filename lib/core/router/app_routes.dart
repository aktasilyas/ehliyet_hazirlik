abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';
  static const quizMock = '/quiz/mock';
  static const quizTopic = '/quiz/topic';
  static const quizSession = '/quiz/session';
  static const quizResult = '/quiz/result';
  static const practice = '/practice';
  static const practiceDetail = '/practice/:id';
  static const signs = '/signs';
  static const signsCategory = '/signs/:category';
  static const progress = '/progress';
  static const wrongReview = '/wrong-review';
  static const settings = '/settings';
  static const premium = '/premium';
}

abstract final class RouteNames {
  static const splash = 'splash';
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const home = 'home';
  static const quiz = 'quiz';
  static const practice = 'practice';
  static const progress = 'progress';
  static const settings = 'settings';
}
