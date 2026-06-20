// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Ehliyet Hazırlık';

  @override
  String get splashLoading => 'Yükleniyor...';

  @override
  String get onboardingTitle1 => 'Ehliyet Sınavına Hazırlan';

  @override
  String get onboardingDesc1 =>
      'Reklamsız, modern arayüzle gerçek sınav formatında çalış.';

  @override
  String get onboardingTitle2 => 'AI ile Öğren';

  @override
  String get onboardingDesc2 =>
      'Yanlış yaptığın sorulara yapay zeka destekli açıklamalar al.';

  @override
  String get onboardingTitle3 => 'Yazılı + Uygulamalı';

  @override
  String get onboardingDesc3 =>
      'Mock sınav, konu çalışması ve uygulamalı sınav videoları tek uygulamada.';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingNext => 'İleri';

  @override
  String get onboardingStart => 'Başla';

  @override
  String get loginTitle => 'Giriş Yap';

  @override
  String get loginSubtitle => 'İlerlemeni kaydetmek için hesabınla giriş yap.';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get registerButton => 'Kayıt Ol';

  @override
  String get googleSignIn => 'Google ile Giriş Yap';

  @override
  String get homeTab => 'Ana Sayfa';

  @override
  String get quizTab => 'Sınav';

  @override
  String get practiceTab => 'Uygulama';

  @override
  String get progressTab => 'İlerleme';

  @override
  String homeGreeting(String name) {
    return 'Merhaba, $name!';
  }

  @override
  String get homeDailyGoal => 'Günlük Hedef';

  @override
  String get homeQuickStart => 'Hızlı Başlat';

  @override
  String get homeMockExam => 'Mock Sınav';

  @override
  String get homeTopicStudy => 'Konu Çalışması';

  @override
  String get quizTitle => 'Sınav Modları';

  @override
  String get practiceTitle => 'Uygulamalı Sınav';

  @override
  String get progressTitle => 'İlerlemen';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get errorGeneric => 'Bir hata oluştu. Lütfen tekrar dene.';

  @override
  String get errorInvalidEmail => 'Geçersiz e-posta adresi.';

  @override
  String get errorWeakPassword => 'Şifre en az 6 karakter olmalı.';

  @override
  String get errorUserNotFound => 'Kullanıcı bulunamadı.';

  @override
  String get errorWrongPassword => 'Hatalı şifre.';

  @override
  String get errorEmailInUse => 'Bu e-posta zaten kullanımda.';

  @override
  String get mockExamTitle => 'Mock Sınav';

  @override
  String get mockExamDescription =>
      'Gerçek ehliyet sınavı formatında 50 soruluk deneme sınavı.';

  @override
  String get mockExamSubtitle => '50 soru, 45 dakika';

  @override
  String get mockExamQuestionCount => 'Soru Sayısı';

  @override
  String get mockExamDuration => 'Süre';

  @override
  String get mockExamDurationValue => '45 dakika';

  @override
  String get mockExamDistribution => 'Konu Dağılımı';

  @override
  String get mockExamDistributionValue =>
      'Trafik 23 · İlk Yardım 12 · Motor 8 · Çevre 7';

  @override
  String get mockExamStart => 'Sınava Başla';

  @override
  String get topicSelectTitle => 'Konu Seç';

  @override
  String get topicSelectSubtitle => 'Tek konuya odaklanarak çalış';

  @override
  String get topicQuestionCount => '20 soruluk set';

  @override
  String get quizSessionTitle => 'Sınav';

  @override
  String get quizNoSession => 'Aktif sınav bulunamadı.';

  @override
  String get quizPrevious => 'Önceki';

  @override
  String get quizNext => 'Sonraki';

  @override
  String get quizFinish => 'Bitir';

  @override
  String get quizFinishTitle => 'Sınavı Bitir';

  @override
  String quizFinishMessage(int count) {
    return '$count soruyu boş bıraktın. Sınavı bitirmek istiyor musun?';
  }

  @override
  String get quizContinue => 'Devam Et';

  @override
  String get quizResultTitle => 'Sınav Sonucu';

  @override
  String get quizResultPassed => 'Tebrikler, geçtin!';

  @override
  String get quizResultFailed => 'Tekrar denemelisin';

  @override
  String quizResultScore(int correct, int total, int percentage) {
    return '$correct / $total doğru (%$percentage)';
  }

  @override
  String get quizResultCorrect => 'Doğru';

  @override
  String get quizResultWrong => 'Yanlış';

  @override
  String get quizResultByCategory => 'Konu Bazlı Sonuç';

  @override
  String get quizWrongAnswers => 'Yanlış Cevaplar — AI Açıklama';

  @override
  String get quizBackHome => 'Ana Sayfaya Dön';

  @override
  String get quizRetry => 'Yeni Mock Sınav';

  @override
  String get progressOverview => 'Genel Özet';

  @override
  String get progressTotalSessions => 'Toplam Sınav';

  @override
  String get progressAccuracy => 'Doğruluk Oranı';

  @override
  String get progressCorrect => 'Doğru / Toplam';

  @override
  String get progressByCategory => 'Konu Dağılımı';

  @override
  String get progressNoData => 'Henüz yeterli veri yok. Sınav çözerek başla!';

  @override
  String progressWrongReview(int count) {
    return '$count yanlış soruyu tekrar et';
  }

  @override
  String get wrongReviewTitle => 'Yanlış Analizim';

  @override
  String get wrongReviewEmpty => 'Yanlış soru kaydı yok. Harika gidiyorsun!';

  @override
  String wrongReviewQuestion(String id) {
    return 'Soru: $id';
  }

  @override
  String wrongReviewStats(int correct, int answered) {
    return '$correct / $answered doğru';
  }

  @override
  String get practiceExamRequirement => 'Sınavda Ne İsteniyor?';

  @override
  String get aiExplainTitle => 'AI Açıklama';

  @override
  String get aiExplainButton => 'AI ile Açıkla';

  @override
  String get aiExplainCached => 'Önbellekten yüklendi';

  @override
  String get signsTitle => 'Trafik Levhaları';

  @override
  String get signsSearch => 'Levha ara...';

  @override
  String get signsEmpty => 'Sonuç bulunamadı.';

  @override
  String get signsDetailDescription => 'AÇIKLAMA';

  @override
  String get premiumTitle => 'Premium\'a Geç';

  @override
  String get premiumSubtitle => 'Tüm özelliklerin kilidini aç';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get premiumLocked => 'Premium İçerik';

  @override
  String get premiumUnlockCta => 'Kilidi açmak için dokun';

  @override
  String get premiumActive => 'Premium üyeliğiniz aktif';

  @override
  String get premiumRestore => 'Satın alımı geri yükle';

  @override
  String get premiumSubscribe => 'Abone Ol';

  @override
  String get premiumBestValue => 'En İyi Değer';

  @override
  String get premiumFeatureUnlimited => 'Sınırsız yapay zeka açıklaması';

  @override
  String get premiumFeatureAi => 'Gelişmiş AI açıklamaları';

  @override
  String get premiumFeatureStats => 'Detaylı istatistikler ve grafikler';

  @override
  String get premiumFeatureSigns => 'Tüm trafik levhaları (40+)';

  @override
  String get premiumFeatureNotifications => 'Akıllı çalışma hatırlatıcıları';

  @override
  String get statsTitle => 'İstatistikler';

  @override
  String get statsStreak => 'Günlük Seri';

  @override
  String get statsLongestStreak => 'En Uzun Seri';

  @override
  String get statsStudiedToday => 'Bugün';

  @override
  String get statsWeeklyActivity => 'Haftalık Aktivite';

  @override
  String get statsAccuracyByCategory => 'Konu Bazlı Doğruluk';

  @override
  String get statsOverall => 'Genel İstatistikler';
}
