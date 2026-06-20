import 'package:ehliyet_hazirlik/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:ehliyet_hazirlik/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Onboarding ekranı ilk sayfayı gösterir', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('tr'),
          home: OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ehliyet Sınavına Hazırlan'), findsOneWidget);
    expect(find.text('İleri'), findsOneWidget);
  });
}
