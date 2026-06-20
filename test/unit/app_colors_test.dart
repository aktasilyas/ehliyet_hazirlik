import 'package:ehliyet_hazirlik/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('primary rengi dokümandaki değere sahip', () {
      expect(AppColors.primary, const Color(0xFF1A73E8));
    });

    test('secondary rengi dokümandaki değere sahip', () {
      expect(AppColors.secondary, const Color(0xFF0F9D58));
    });

    test('error rengi dokümandaki değere sahip', () {
      expect(AppColors.error, const Color(0xFFEA4335));
    });
  });
}
