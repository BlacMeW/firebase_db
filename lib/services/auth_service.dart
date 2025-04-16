import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Sign Up
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

  // ✅ Sign In
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

  // ✅ Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ✅ Current User
  User? get currentUser => _auth.currentUser;

  // ✅ Auth State Change Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
