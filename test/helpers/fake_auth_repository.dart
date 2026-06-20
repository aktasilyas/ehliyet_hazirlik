import 'dart:async';

import 'package:ehliyet_hazirlik/core/errors/failures.dart';
import 'package:ehliyet_hazirlik/features/auth/domain/entities/user_entity.dart';
import 'package:ehliyet_hazirlik/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({UserEntity? user}) : _user = user {
    _controller.add(_user);
  }

  UserEntity? _user;
  final StreamController<UserEntity?> _controller =
      StreamController<UserEntity?>.broadcast();

  void setUser(UserEntity? user) {
    _user = user;
    _controller.add(user);
  }

  @override
  Stream<UserEntity?> authStateChanges() => _controller.stream;

  @override
  UserEntity? get currentUser => _user;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final user = UserEntity(id: '1', email: email, displayName: 'Test');
    _user = user;
    _controller.add(user);
    return Right(user);
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    const user = UserEntity(
      id: '2',
      email: 'google@test.com',
      displayName: 'Google User',
    );
    _user = user;
    _controller.add(user);
    return const Right(user);
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return signInWithEmail(email: email, password: password);
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    _user = null;
    _controller.add(null);
    return const Right(unit);
  }

  void dispose() {
    unawaited(_controller.close());
  }
}
