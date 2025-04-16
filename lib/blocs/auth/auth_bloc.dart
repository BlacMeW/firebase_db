import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignUpRequested>(_onSignUp);
    on<SignInRequested>(_onSignIn);
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<FacebookSignInRequested>(_onFacebookSignIn);
    on<PhoneSignInRequested>(_onPhoneSignIn);
    on<VerifySmsCodeRequested>(_onVerifySmsCode);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async {
    final user = authService.currentUser;
    if (user != null) {
      emit(AuthSuccess(user: user));
    } else {
      emit(AuthSignedOut());
    }
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await authService.signUp(event.email, event.password);
    emit(user != null ? AuthSuccess(user: user) : AuthFailure(message: 'Sign up failed'));
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await authService.signIn(event.email, event.password);
    emit(user != null ? AuthSuccess(user: user) : AuthFailure(message: 'Sign in failed'));
  }

  Future<void> _onGoogleSignIn(GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await authService.signInWithGoogle();
    emit(user != null ? AuthSuccess(user: user) : AuthFailure(message: 'Google sign-in failed'));
  }

  Future<void> _onFacebookSignIn(FacebookSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await authService.signInWithFacebook();
    emit(user != null ? AuthSuccess(user: user) : AuthFailure(message: 'Facebook sign-in failed'));
  }

  Future<void> _onPhoneSignIn(PhoneSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authService.signInWithPhone(
        phoneNumber: event.phoneNumber,
        onCodeSent: event.onCodeSent,
        onAutoVerify: (user) {
          emit(user != null ? AuthSuccess(user: user) : AuthFailure(message: 'Auto verification failed'));
        },
        onError: (error) {
          emit(AuthFailure(message: error.message ?? 'Phone sign-in failed'));
        },
      );
    } catch (e) {
      emit(AuthFailure(message: 'Phone sign-in error'));
    }
  }

  Future<void> _onVerifySmsCode(VerifySmsCodeRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await authService.verifySmsCode(
      verificationId: event.verificationId,
      smsCode: event.smsCode,
    );
    emit(user != null ? AuthSuccess(user: user) : AuthFailure(message: 'SMS verification failed'));
  }

  // Future<void> _onSignOut(SignOutRequested event, Emitter<AuthState> emit) async {
  //   print("User is signed out From Blog");
  //   emit(AuthLoading());
  //   await authService.signOut();
  //   print("User is signed out From Blog 2 Step");
  //   emit(AuthSignedOut());
  //   print("User is signed out From Blog");
  // }

  Future<void> _onSignOut(SignOutRequested event, Emitter<AuthState> emit) async {
    print("User is signed out From Blog");
    emit(AuthLoading());
    await authService.signOut();
    print("User is signed out From Blog 2 Step");

    // Optional: Add a small delay before emitting AuthSignedOut
    await Future.delayed(Duration(milliseconds: 500));
    emit(AuthSignedOut());
    print("User is signed out From Blog");
  }
}
