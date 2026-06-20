import 'package:firebase_auth/firebase_auth.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';

Failure mapAuthException(Object error) {
  if (error is AuthException) {
    return AuthFailure(error.message);
  }

  if (error is FirebaseAuthException) {
    return AuthFailure(_firebaseAuthMessage(error.code));
  }

  return AuthFailure(error.toString());
}

String _firebaseAuthMessage(String code) {
  return switch (code) {
    'invalid-email' => 'Geçersiz e-posta adresi.',
    'user-not-found' => 'Kullanıcı bulunamadı.',
    'wrong-password' => 'Hatalı şifre.',
    'email-already-in-use' => 'Bu e-posta zaten kullanımda.',
    'weak-password' => 'Şifre en az 6 karakter olmalı.',
    'user-disabled' => 'Hesabın devre dışı bırakılmış.',
    'too-many-requests' => 'Çok fazla deneme. Lütfen sonra tekrar dene.',
    'network-request-failed' => 'Ağ bağlantısı hatası.',
    'account-exists-with-different-credential' =>
      'Bu e-posta farklı bir giriş yöntemiyle kayıtlı.',
    _ => 'Kimlik doğrulama hatası: $code',
  };
}
