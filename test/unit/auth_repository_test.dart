import 'package:ehliyet_hazirlik/core/errors/failures.dart';
import 'package:ehliyet_hazirlik/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../helpers/fake_auth_datasource.dart';

void main() {
  late AuthRepositoryImpl repository;

  setUp(() {
    repository = AuthRepositoryImpl(FakeAuthRemoteDataSource());
  });

  group('AuthRepositoryImpl', () {
    test('e-posta ile giriş başarılı kullanıcı döner', () async {
      final result = await repository.signInWithEmail(
        email: 'test@example.com',
        password: '123456',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Beklenmeyen hata'),
        (user) {
          expect(user.email, 'test@example.com');
        },
      );
    });

    test('hatalı giriş AuthFailure döner', () async {
      final result = await repository.signInWithEmail(
        email: 'fail@example.com',
        password: '123456',
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Hata bekleniyordu'),
      );
    });

    test('çıkış başarılı olur', () async {
      final result = await repository.signOut();

      expect(result, const Right<Failure, Unit>(unit));
    });
  });
}
