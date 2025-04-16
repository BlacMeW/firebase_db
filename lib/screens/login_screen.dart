import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../blocs/auth/auth_bloc.dart';
import '../services/auth_service.dart';
import 'user_screen.dart';  // Make sure you import your UserScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;

  void handleAuth() {
    String email = emailController.text;
    String password = passwordController.text;

    if (isLogin) {
      // Dispatch SignInRequested event
      BlocProvider.of<AuthBloc>(context).add(SignInRequested(email: email, password: password));
    } else {
      // Dispatch SignUpRequested event
      BlocProvider.of<AuthBloc>(context).add(SignUpRequested(email: email, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleAuth,
              child: Text(isLogin ? "Login" : "Register"),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? "Don't have an account? Register" : "Already have an account? Login"),
            ),
            // Add a listener to navigate on success or failure
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserScreen()),
                  );
                } else if (state is AuthFailure) {
                  // Handle the error message display
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Container(), // Add an empty child as we don't need extra UI here
            ),
          ],
        ),
      ),
    );
  }
}
