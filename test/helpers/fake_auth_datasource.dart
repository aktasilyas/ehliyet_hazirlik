import 'package:ehliyet_hazirlik/core/errors/exceptions.dart';
import 'package:ehliyet_hazirlik/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ehliyet_hazirlik/features/auth/domain/entities/user_entity.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Stream<UserEntity?> authStateChanges() => Stream.value(null);

  @override
  UserEntity? get currentUser => null;

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (email == 'fail@example.com') {
      throw const AuthException('user-not-found');
    }
    return UserEntity(id: '1', email: email);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    return const UserEntity(id: '2', email: 'google@test.com');
  }

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return signInWithEmail(email: email, password: password);
  }

  @override
  Future<void> signOut() async {}
}
