# Ehliyet Hazırlık — Proje Durum Belgesi

> **Güncelleme:** Her feature branch merge edildiğinde bu dosya da commit içinde güncellenir.
> Yeni bir bilgisayar veya chat oturumuna başlandığında bu dosyayı okuyarak kaldığınız yerden devam edebilirsiniz.

---

## Anlık Durum

| | Değer |
|---|---|
| **Son güncelleme** | 2026-06-20 |
| **Aktif branch** | `develop` |
| **Sonraki branch** | `feature/week-5-play-store` |
| **Uygulama versiyonu** | 1.0.0+1 |
| **Flutter analyze** | ✅ 0 issue |
| **Testler** | ✅ 12/12 geçti |

---

## Git Branch Yapısı

```
main      ──●──────────────────────────────────── (fde502b) Initial commit — Hafta 1–2
             \
develop    ───●────────────────────────────────── (Hafta 4 merge)
               \                        /       /
feature/week-3  ●──●──────────────────           \
feature/week-4                          ●──●──────
```

| Branch | Durum | Açıklama |
|--------|-------|----------|
| `main` | ✅ Yayında | Hafta 1–2 (ilk commit) |
| `develop` | ✅ Aktif | Hafta 4 dahil |
| `feature/week-3-progress-ai-practice` | ✅ Merge edildi | Kapatılabilir |
| `feature/week-4-premium-signs-stats` | ✅ Merge edildi | Kapatılabilir |
| `feature/week-5-play-store` | ⏳ Açılmadı | Sonraki sprint |

---

## 30 Günlük Plan — Genel İlerleme

| Hafta | Konu | Durum |
|-------|------|-------|
| Hafta 1 | Kurulum, Auth, Navigation, Design System | ✅ Tamamlandı |
| Hafta 2 | Quiz Modülü | ✅ Tamamlandı |
| Hafta 3 | Progress, AI Explain, Practice | ✅ Tamamlandı |
| Hafta 4 | Premium (RevenueCat), Trafik Levhaları, İstatistik | ✅ Tamamlandı |
| Hafta 5 | Play Store Hazırlığı | ⏳ Bekliyor |

---

## Detaylı Checklist

### ✅ Hafta 1 — Proje Altyapısı

#### Proje Kurulumu
- [x] `pubspec.yaml` — Mimari dokümandaki tüm paketler eklendi
- [x] `analysis_options.yaml` — Strict lint kuralları
- [x] `lib/` Clean Architecture + feature-first klasör yapısı (`.gitkeep`)
- [x] `firebase_options.dart` — Placeholder Firebase config
- [x] `lib/core/constants/env.dart` — Supabase + Anthropic placeholder key'ler

#### Design System
- [x] `AppColors` — Primary `#1565C0`, Secondary `#FF6F00`, Error `#C62828`
- [x] `AppTheme` — Plus Jakarta Sans, Material 3, dark mode desteği
- [x] `AppCard`, `LoadingView` — Ortak widget'lar

#### Auth Feature (Clean Architecture)
- [x] `UserEntity` — freezed model
- [x] `AuthRepository` (abstract) + `AuthRepositoryImpl`
- [x] `AuthRemoteDataSource` — Google + e-posta giriş (Firebase placeholder)
- [x] `SignInWithEmailUseCase`, `SignInWithGoogleUseCase`, `SignOutUseCase`
- [x] `authStateProvider` — Riverpod StreamProvider
- [x] `LoginScreen` — e-posta + Google giriş butonu

#### Ekranlar & Navigation
- [x] `SplashScreen` — auth redirect
- [x] `OnboardingScreen` — 3 sayfa, skip / ileri
- [x] `HomeScreen` — placeholder
- [x] 4 tab'lı `MainShellScreen` (Home, Quiz, Practice, Progress)
- [x] `go_router` — named routes, auth guard, shell route

#### Lokalizasyon
- [x] `lib/l10n/app_tr.arb` — Türkçe string'ler
- [x] `flutter gen-l10n` ile `AppLocalizations` üretildi

#### Testler (Hafta 1)
- [x] `app_colors_test.dart` — 3 renk testi
- [x] `auth_repository_test.dart` — giriş başarı / hata / çıkış (3 test)
- [x] `onboarding_screen_test.dart` — 2 widget testi

---

### ✅ Hafta 2 — Quiz Modülü

#### Domain
- [x] `QuestionEntity` — 6 alan, null-safe
- [x] `QuestionCategory` — traffic / first_aid / mechanics / rules
- [x] `QuizSession` — timer, cevaplar, tamamlanma durumu
- [x] `QuestionRepository` (abstract)
- [x] `GetMockExamQuestionsUseCase`, `GetTopicQuestionsUseCase`

#### Data
- [x] `QuestionModel` — json_serializable
- [x] `MockQuestionsLocalDataSource` — 120 yerel soru
- [x] `SupabaseQuestionRemoteDataSource` — uzak kaynak + yerel fallback
- [x] `QuestionRepositoryImpl`
- [x] `supabase/migrations/001_questions.sql`

#### Presentation
- [x] `QuizTabScreen` — giriş ekranı
- [x] `TopicSelectScreen` — 4 kategori seçimi
- [x] `MockExamScreen` — 50 soru, 45 dk timer
- [x] `QuizSessionScreen` — soru gösterimi, seçenek butonu
- [x] `QuizResultScreen` — puan, doğru/yanlış özet
- [x] `QuizTimerBar`, `QuizWidgets` — ortak bileşenler
- [x] `quizSessionProvider`, `quizResultProvider` — manuel NotifierProvider

#### Testler (Hafta 2)
- [x] `question_repository_test.dart` — mock sınav 50 soru, konu filtresi (2 test)

---

### ✅ Hafta 3 — Progress, AI Explain, Practice

#### Progress Feature
- [x] `ProgressEntities` — `UserProgressSummary`, `QuestionStatRecord`, `StudySession`
- [x] `ProgressRepository` (abstract)
- [x] `GetProgressSummaryUseCase`, `GetWrongQuestionStatsUseCase`, `SaveSessionUseCase`
- [x] `InMemoryProgressLocalDataSource` — SharedPreferences tabanlı yerel kayıt
- [x] `FirestoreProgressRemoteDataSource` — Firestore'a oturum kayıt, istatistik çekme
- [x] `ProgressRepositoryImpl` — remote önce, yerel fallback
- [x] `progressSummaryProvider`, `wrongQuestionStatsProvider`, `saveSessionProvider`
- [x] `ProgressTabScreen` — özet kart, kategori dağılım çubuğu, son oturumlar listesi
- [x] `WrongReviewScreen` — yanlış soru listesi, tekrar çalışma butonu
- [x] Quiz sonrası Firestore'a otomatik kayıt (`QuizResultScreen` entegrasyon)

#### AI Explain Feature
- [x] `AiExplainRepository` (abstract)
- [x] `AiExplainRepositoryImpl` — Claude HTTP + Firestore cache + günlük 10 limit
- [x] `aiExplainProvider` — AsyncNotifierProvider
- [x] `AiExplainButton` widget — sınav sonucu ekranında her yanlış soruya eklendi
- [x] Firestore şeması: `ai_explanations/{questionId}`

#### Practice Feature
- [x] `PracticeTopic` entity — id, başlık, videoId, açıklama, altKonular
- [x] `PracticeConfigDataSource` — 10 yerel konu + Remote Config video ID override
- [x] `practiceTopicsProvider`, `practiceTopicDetailProvider`
- [x] `PracticeTabScreen` — konu grid listesi
- [x] `PracticeDetailScreen` — `youtube_player_flutter` embed, konu detayı
- [x] Remote Config key formatı: `practice_{id}_video`

#### Lokalizasyon (Hafta 3)
- [x] Progress, wrong review, AI explain, practice string'leri `app_tr.arb`'ye eklendi
- [x] `flutter gen-l10n` çalıştırıldı

#### Testler (Hafta 3)
- [x] `progress_local_datasource_test.dart` — oturum kayıt → özet istatistik (1 test)
- [x] `ai_explain_repository_test.dart` — statik fallback (1 test)

---

### ✅ Hafta 4 — Premium, Trafik Levhaları, İstatistik

> Branch: `feature/week-4-premium-signs-stats` → `develop`'a merge edildi.

#### Premium / RevenueCat
- [x] `pubspec.yaml`'a `purchases_flutter` (zaten mevcuttu)
- [x] `PremiumRepository` (abstract) + `RevenueCatPremiumRepositoryImpl`
- [x] `DevPremiumDataSource` — dev/test fallback (her zaman free döner)
- [x] Offering / entitlement kontrolü
- [x] `PaywallScreen` — aylık / yıllık plan, restore satın alma, feature listesi
- [x] `PremiumGuard` — içerik kilitleme widget'ı (stack blur + kilit ikonu)
- [x] `premiumStatusProvider` — AsyncNotifierProvider, purchase + restore action

#### Trafik Levhaları (Signs) Feature
- [x] `SignEntity` — id, code, name, category, description, iconCode, isPremium
- [x] `SignCategory` enum — warning / prohibition / obligation / informational / priority
- [x] `HardcodedSignsDataSource` — 38 levha (5 kategori)
- [x] `SignsRepository` (abstract) + `SignsRepositoryImpl`
- [x] `GetAllSignsUseCase`, `GetSignsByCategoryUseCase`, `GetSignByIdUseCase`, `SearchSignsUseCase`
- [x] `SignsTabScreen` — SearchBar + kategori FilterChip + 2 sütun grid
- [x] `SignDetailScreen` — büyük ikon, kategori chip, açıklama, AI Explain butonu
- [x] `signsSearchQueryProvider`, `selectedSignCategoryProvider`, `filteredSignsProvider`

#### İstatistik & Streak
- [x] `StreakNotifier` — SharedPreferences tabanlı seri takibi (günlük/en uzun)
- [x] `StatsScreen` — seri kartı, haftalık aktivite çemberleri, konu bazlı bar chart
- [x] `ProgressTabScreen`'e Stats ve WrongReview butonları eklendi
- [x] `_AccuracyBarChart` — `fl_chart` BarChart, konu doğruluk yüzdesi

#### Bildirimler
- [x] `flutter_local_notifications: ^18.0.0` pubspec'e eklendi
- [x] `NotificationService` — singleton, initialize, requestPermission
- [x] `scheduleDailyReminders()` — günlük tekrar bildirimi
- [x] `showStreakWarning(streak)` — seri tehlike uyarısı
- [x] `bootstrap.dart`'a `initializeNotifications()` eklendi

#### Router & l10n (Hafta 4)
- [x] `AppRoutes.signDetail`, `AppRoutes.stats` route'ları eklendi
- [x] Router `SignsTabScreen`, `SignDetailScreen`, `StatsScreen`, `PaywallScreen`'e bağlandı
- [x] l10n: signs, premium, stats string'leri `app_tr.arb`'ye eklendi

---

### ⏳ Hafta 5 — Play Store Hazırlığı

> Branch: `feature/week-5-play-store` — **henüz açılmadı**

- [ ] `release/v1.0.0` branch açılması
- [ ] Uygulama ikonu ve splash görsel üretimi (`flutter_launcher_icons`)
- [ ] `flutter build appbundle --release`
- [ ] ProGuard / R8 kuralları
- [ ] Firebase Crashlytics entegrasyonu (production)
- [ ] Firebase / Supabase / RevenueCat gerçek key'lerin CI'a taşınması
- [ ] Play Store console: store listing, ekran görüntüleri, içerik derecelendirme
- [ ] `main`'e merge + tag: `v1.0.0`

---

## Mimari Özet

```
lib/
├── core/
│   ├── constants/    app_colors.dart, app_theme.dart, env.dart
│   ├── errors/       failures.dart, exceptions.dart
│   ├── providers/    onboarding_provider.dart
│   ├── router/       app_router.dart, app_routes.dart, main_shell_screen.dart
│   ├── utils/        app_initializer.dart, auth_error_mapper.dart
│   └── widgets/      app_card.dart, loading_view.dart, placeholder_screens.dart
├── features/
│   ├── auth/         ✅ domain / data / presentation
│   ├── quiz/         ✅ domain / data / presentation
│   ├── progress/     ✅ domain / data / presentation
│   ├── ai_explain/   ✅ domain / data / presentation
│   ├── practice/     ✅ domain / data / presentation
│   ├── home/         ✅ HomeScreen (placeholder)
│   ├── settings/     ✅ SettingsScreen (placeholder)
│   ├── signs/        ✅ domain / data / presentation (38 levha)
│   └── premium/      ✅ domain / data / presentation (RevenueCat + DevFallback)
└── l10n/             app_tr.arb → AppLocalizations
```

---

## Teknik Notlar (Yeni Oturum İçin)

| Konu | Notlar |
|------|--------|
| **build_runner** | Dart 3.10 + eski analyzer uyumsuzluğu (`visitDotShorthandInvocation`). Quiz/progress provider'ları **manuel** yazıldı (codegen yok). Auth ve router codegen çalışıyor. |
| **Firebase/Supabase** | Placeholder değerler. Dev/test modunda local fallback aktif. Gerçek key'ler production öncesi `.env` / CI secret'lara taşınacak. |
| **Claude AI** | `ANTHROPIC_API_KEY` `env.dart`'ta placeholder. Günlük 10 istek limiti `AiExplainRepositoryImpl`'da Firestore sayaçla korunuyor. |
| **YouTube** | `youtube_player_flutter` — varsayılan video ID: `Vd9QkWONiT4`. Remote Config key: `practice_{id}_video`. |
| **freezed** | Yalnızca `UserEntity`'de kullanılıyor. Quiz/progress entity'leri manuel class (build_runner sorunu). |
| **Supabase migrations** | `supabase/migrations/001_questions.sql` — sorular tablosu. |
| **Firestore şeması** | `users/{userId}/sessions`, `question_stats`, `ai_explanations/{questionId}` |
| **flutter gen-l10n** | `l10n.yaml` mevcutsa komut satırı argümanları devre dışı. `flutter gen-l10n` ile çalıştır. |

---

## Yeni Oturumda Hızlı Başlangıç

```bash
# 1. Repoyu klonla (ilk kez)
git clone https://github.com/aktasilyas/ehliyet_hazirlik.git
cd ehliyet_hazirlik

# 2. Mevcut makinede devam (fetch + branch)
git fetch origin
git checkout develop

# 3. Bağımlılıkları yükle
flutter pub get

# 4. Lokalizasyon dosyalarını üret
flutter gen-l10n

# 5. Sağlık kontrolü
flutter analyze   # → 0 issue olmalı
flutter test      # → tüm testler geçmeli

# 6. Yeni hafta için branch aç
git checkout -b feature/week-5-play-store
```

---

## Commit Mesaj Formatı

```
feat(week-N): kısa açıklama
fix(modül): hata açıklaması
refactor(modül): yeniden yapılandırma
test(modül): test açıklaması
docs: belge güncellemesi
```

---

*Bu dosya proje içinde `PROJECT_STATUS.md` olarak tutulur. Her hafta sonu feature branch merge commit'inde güncellenir.*
