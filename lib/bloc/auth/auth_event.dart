part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class GoogleSignInRequested extends AuthEvent {}

class FacebookSignInRequested extends AuthEvent {}

class PhoneSignInRequested extends AuthEvent {
  final String phoneNumber;
  final Function(String verificationId) onCodeSent;
  final Function(User? user) onAutoVerify;
  final Function(FirebaseAuthException error) onError;

  const PhoneSignInRequested({
    required this.phoneNumber,
    required this.onCodeSent,
    required this.onAutoVerify,
    required this.onError,
  });

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifySmsCodeRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;

  const VerifySmsCodeRequested({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object?> get props => [verificationId, smsCode];
}

class SignOutRequested extends AuthEvent {}
