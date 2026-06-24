## Özet

Hafta 1–4 tüm geliştirmelerini `main` kararlı sürüme alır.

### İçerilen özellikler

**Hafta 1 — Altyapı**
- Clean Architecture + feature-first yapı
- Auth (Google + e-posta), Onboarding, Splash, Login
- 4 tab'lı shell navigasyon (Home, Quiz, Practice, Progress)
- Design system (AppColors, AppTheme, Plus Jakarta Sans, Material 3)

**Hafta 2 — Quiz Modülü**
- Mock sınav: 50 soru, 45 dakika, 4 kategori dağılımı
- Konu bazlı soru seti, sınav sonuç ekranı
- Supabase uzak kaynak + yerel 120 soru fallback

**Hafta 3 — Progress, AI, Practice**
- Firestore ilerleme kaydı, yanlış soru inceleme
- Claude AI açıklama (cache + günlük 10 limit)
- YouTube embed uygulamalı sınav videoları

**Hafta 4 — Premium, Signs, İstatistik**
- RevenueCat paywall, PremiumGuard widget
- 38 trafik levhası, kategori filtresi, arama
- Günlük seri takibi, fl_chart istatistik ekranı
- flutter_local_notifications günlük hatırlatıcı

## Test Planı

- [x] `flutter analyze` → 0 issue
- [x] `flutter test` → 12/12 geçti
- [ ] `flutter build appbundle --release` başarılı
- [ ] Firebase Crashlytics production'da aktif
- [ ] RevenueCat gerçek entitlement kontrolü

## Notlar

Production key'ler (Firebase, Supabase, RevenueCat, Anthropic) CI secret'lara taşınmalı, `env.dart` placeholder'ları kaldırılmalı.
