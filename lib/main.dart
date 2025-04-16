import 'package:firebase_db/screens/user_screen.dart';
import 'package:firebase_db/ui/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'blocs/user_crud/user_crud_event.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/user_crud/user_crud_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/gps_update_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase if not already done
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Initialize AuthService just once
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authService: _authService)..add(AuthCheckRequested()),
        ),
        BlocProvider<UserCrudBloc>(
          create: (_) => UserCrudBloc()..add(LoadUsers()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Debugging prints to track the flow
        if (state is AuthSignedOut) {
          print("User is signed out");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else if (state is AuthSuccess) {
          print("AuthSuccess: Navigating to UserScreen");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => UserScreen()),
          );
        } else if (state is AuthFailure) {
          print("AuthFailure: ${state.message}");
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Or a SplashScreen widget
      ),
    );
  }
}

