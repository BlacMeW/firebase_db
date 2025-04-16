import 'package:firebase_db/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'bloc/user_crud/user_crud_event.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/user_crud/user_crud_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/gps_update_screen.dart';
// import 'screens/user_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authService: authService)..add(AuthCheckRequested()),
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthSuccess) {
          return UserScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
