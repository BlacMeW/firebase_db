import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Sign Up (Email/Password)
  Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  // ✅ Sign In (Email/Password)
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign In Error: $e");
      return null;
    }
  }

  // ✅ Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // ✅ Facebook Sign-In
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.tokenString);
        final userCredential =
        await _auth.signInWithCredential(facebookAuthCredential);
        return userCredential.user;
      } else {
        print("Facebook Sign-In Error: ${result.message}");
        return null;
      }
    } catch (e) {
      print("Facebook Sign-In Exception: $e");
      return null;
    }
  }

  // ✅ Phone Sign-In (Step 1)
  Future<void> signInWithPhone({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(User? user) onAutoVerify,
    required Function(FirebaseAuthException error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        final result = await _auth.signInWithCredential(credential);
        onAutoVerify(result.user);
      },
      verificationFailed: onError,
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // ✅ Phone Sign-In (Step 2)
  Future<User?> verifySmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print("SMS Verification Error: $e");
      return null;
    }
  }

  // ✅ Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    // await GoogleSignIn().signOut();
    // await FacebookAuth.instance.logOut();
  }

  // ✅ Current User
  User? get currentUser => _auth.currentUser;

  // ✅ Auth State Change Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
