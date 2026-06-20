enum QuestionCategory {
  traffic,
  firstAid,
  engine,
  environment;

  String get apiValue => switch (this) {
        QuestionCategory.traffic => 'traffic',
        QuestionCategory.firstAid => 'first_aid',
        QuestionCategory.engine => 'engine',
        QuestionCategory.environment => 'environment',
      };

  String get displayName => switch (this) {
        QuestionCategory.traffic => 'Trafik',
        QuestionCategory.firstAid => 'İlk Yardım',
        QuestionCategory.engine => 'Motor',
        QuestionCategory.environment => 'Çevre',
      };

  static QuestionCategory fromApi(String value) => switch (value) {
        'traffic' => QuestionCategory.traffic,
        'first_aid' => QuestionCategory.firstAid,
        'engine' => QuestionCategory.engine,
        'environment' => QuestionCategory.environment,
        _ => QuestionCategory.traffic,
      };
}

enum QuizMode {
  mock,
  topic,
}

const mockExamDistribution = <QuestionCategory, int>{
  QuestionCategory.traffic: 23,
  QuestionCategory.firstAid: 12,
  QuestionCategory.engine: 8,
  QuestionCategory.environment: 7,
};

const mockExamDuration = Duration(minutes: 45);
const mockExamQuestionCount = 50;
