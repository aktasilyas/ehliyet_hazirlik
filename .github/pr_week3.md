## Özet

- **Progress modülü:** Firestore/yerel ilerleme kaydı, `ProgressTabScreen`, `WrongReviewScreen`
- **AI Explain:** Claude API + Firestore cache + günlük 10 istek limiti, sınav sonuç ekranı entegrasyonu
- **Practice:** YouTube embed (`youtube_player_flutter`), Remote Config video ID override, `PracticeTabScreen` + `PracticeDetailScreen`
- **l10n:** Progress, AI explain, practice Türkçe string'leri eklendi

## Test Planı

- [x] `flutter analyze` → 0 issue
- [x] `flutter test` → 12/12 geçti
- [ ] Sınav tamamlandığında Firestore'a oturum kaydı yazılıyor mu?
- [ ] AI açıklama butonu yanlış sorularda görünüyor mu?
- [ ] Practice sekmesinde YouTube video embed çalışıyor mu?

## Notlar

Bu branch develop'a local merge yapıldı ve push edildi. PR geçmiş kayıt amaçlıdır.
