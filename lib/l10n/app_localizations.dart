import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ehliyet Hazırlık'**
  String get appTitle;

  /// No description provided for @splashLoading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get splashLoading;

  /// No description provided for @onboardingTitle1.
  ///
  /// In tr, this message translates to:
  /// **'Ehliyet Sınavına Hazırlan'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In tr, this message translates to:
  /// **'Reklamsız, modern arayüzle gerçek sınav formatında çalış.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In tr, this message translates to:
  /// **'AI ile Öğren'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In tr, this message translates to:
  /// **'Yanlış yaptığın sorulara yapay zeka destekli açıklamalar al.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In tr, this message translates to:
  /// **'Yazılı + Uygulamalı'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In tr, this message translates to:
  /// **'Mock sınav, konu çalışması ve uygulamalı sınav videoları tek uygulamada.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingSkip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get onboardingStart;

  /// No description provided for @loginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İlerlemeni kaydetmek için hesabınla giriş yap.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get registerButton;

  /// No description provided for @googleSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Google ile Giriş Yap'**
  String get googleSignIn;

  /// No description provided for @homeTab.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get homeTab;

  /// No description provided for @quizTab.
  ///
  /// In tr, this message translates to:
  /// **'Sınav'**
  String get quizTab;

  /// No description provided for @practiceTab.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama'**
  String get practiceTab;

  /// No description provided for @progressTab.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get progressTab;

  /// No description provided for @homeGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @homeDailyGoal.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Hedef'**
  String get homeDailyGoal;

  /// No description provided for @homeQuickStart.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Başlat'**
  String get homeQuickStart;

  /// No description provided for @homeMockExam.
  ///
  /// In tr, this message translates to:
  /// **'Mock Sınav'**
  String get homeMockExam;

  /// No description provided for @homeTopicStudy.
  ///
  /// In tr, this message translates to:
  /// **'Konu Çalışması'**
  String get homeTopicStudy;

  /// No description provided for @quizTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Modları'**
  String get quizTitle;

  /// No description provided for @practiceTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamalı Sınav'**
  String get practiceTitle;

  /// No description provided for @progressTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlerlemen'**
  String get progressTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @signOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get signOut;

  /// No description provided for @errorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu. Lütfen tekrar dene.'**
  String get errorGeneric;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz e-posta adresi.'**
  String get errorInvalidEmail;

  /// No description provided for @errorWeakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 6 karakter olmalı.'**
  String get errorWeakPassword;

  /// No description provided for @errorUserNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı bulunamadı.'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In tr, this message translates to:
  /// **'Hatalı şifre.'**
  String get errorWrongPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta zaten kullanımda.'**
  String get errorEmailInUse;

  /// No description provided for @mockExamTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mock Sınav'**
  String get mockExamTitle;

  /// No description provided for @mockExamDescription.
  ///
  /// In tr, this message translates to:
  /// **'Gerçek ehliyet sınavı formatında 50 soruluk deneme sınavı.'**
  String get mockExamDescription;

  /// No description provided for @mockExamSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'50 soru, 45 dakika'**
  String get mockExamSubtitle;

  /// No description provided for @mockExamQuestionCount.
  ///
  /// In tr, this message translates to:
  /// **'Soru Sayısı'**
  String get mockExamQuestionCount;

  /// No description provided for @mockExamDuration.
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get mockExamDuration;

  /// No description provided for @mockExamDurationValue.
  ///
  /// In tr, this message translates to:
  /// **'45 dakika'**
  String get mockExamDurationValue;

  /// No description provided for @mockExamDistribution.
  ///
  /// In tr, this message translates to:
  /// **'Konu Dağılımı'**
  String get mockExamDistribution;

  /// No description provided for @mockExamDistributionValue.
  ///
  /// In tr, this message translates to:
  /// **'Trafik 23 · İlk Yardım 12 · Motor 8 · Çevre 7'**
  String get mockExamDistributionValue;

  /// No description provided for @mockExamStart.
  ///
  /// In tr, this message translates to:
  /// **'Sınava Başla'**
  String get mockExamStart;

  /// No description provided for @topicSelectTitle.
  ///
  /// In tr, this message translates to:
  /// **'Konu Seç'**
  String get topicSelectTitle;

  /// No description provided for @topicSelectSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Tek konuya odaklanarak çalış'**
  String get topicSelectSubtitle;

  /// No description provided for @topicQuestionCount.
  ///
  /// In tr, this message translates to:
  /// **'20 soruluk set'**
  String get topicQuestionCount;

  /// No description provided for @quizSessionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınav'**
  String get quizSessionTitle;

  /// No description provided for @quizNoSession.
  ///
  /// In tr, this message translates to:
  /// **'Aktif sınav bulunamadı.'**
  String get quizNoSession;

  /// No description provided for @quizPrevious.
  ///
  /// In tr, this message translates to:
  /// **'Önceki'**
  String get quizPrevious;

  /// No description provided for @quizNext.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki'**
  String get quizNext;

  /// No description provided for @quizFinish.
  ///
  /// In tr, this message translates to:
  /// **'Bitir'**
  String get quizFinish;

  /// No description provided for @quizFinishTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınavı Bitir'**
  String get quizFinishTitle;

  /// No description provided for @quizFinishMessage.
  ///
  /// In tr, this message translates to:
  /// **'{count} soruyu boş bıraktın. Sınavı bitirmek istiyor musun?'**
  String quizFinishMessage(int count);

  /// No description provided for @quizContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get quizContinue;

  /// No description provided for @quizResultTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sınav Sonucu'**
  String get quizResultTitle;

  /// No description provided for @quizResultPassed.
  ///
  /// In tr, this message translates to:
  /// **'Tebrikler, geçtin!'**
  String get quizResultPassed;

  /// No description provided for @quizResultFailed.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar denemelisin'**
  String get quizResultFailed;

  /// No description provided for @quizResultScore.
  ///
  /// In tr, this message translates to:
  /// **'{correct} / {total} doğru (%{percentage})'**
  String quizResultScore(int correct, int total, int percentage);

  /// No description provided for @quizResultCorrect.
  ///
  /// In tr, this message translates to:
  /// **'Doğru'**
  String get quizResultCorrect;

  /// No description provided for @quizResultWrong.
  ///
  /// In tr, this message translates to:
  /// **'Yanlış'**
  String get quizResultWrong;

  /// No description provided for @quizResultByCategory.
  ///
  /// In tr, this message translates to:
  /// **'Konu Bazlı Sonuç'**
  String get quizResultByCategory;

  /// No description provided for @quizBackHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfaya Dön'**
  String get quizBackHome;

  /// No description provided for @quizRetry.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Mock Sınav'**
  String get quizRetry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
