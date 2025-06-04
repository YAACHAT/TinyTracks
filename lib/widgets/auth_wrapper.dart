import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/auth_state.dart';
import '../screens/welcome_screen.dart';
import '../screens/home_screen.dart';
import '../screens/signin_or_signup_screen.dart';
import '../services/service_locator.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authManager = getIt<AuthManager>();
    
    return StreamBuilder<AuthState>(
      stream: authManager.authStateChanges,
      initialData: authManager.currentState,
      builder: (context, snapshot) {
        final authState = snapshot.data ?? const AuthState.initial();
        
        switch (authState.status) {
          case AuthStatus.initial:
          case AuthStatus.authenticating:
            return const AuthLoadingScreen(message: 'Dear Daddy or Mummy, Please set child Profile...');
            
          case AuthStatus.authenticated:
            return const HomeScreen();
            
          case AuthStatus.profileIncomplete:
            return const SignInOrSignUpScreen();
            
          case AuthStatus.unauthenticated:
            return const WelcomeScreen();
        }
      },
    );
  }
}

class AuthLoadingScreen extends StatelessWidget {
  final String message;
  
  const AuthLoadingScreen({
    super.key, 
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}