import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final supabase = Supabase.instance.client;
  bool isAuth = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Only check session after a brief delay to avoid immediate navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExistingSession();
    });
  }

  // Check if user is already signed in
  Future<void> _checkExistingSession() async {
    try {
      final session = supabase.auth.currentSession;
      if (session != null) {
        final childResponse = await supabase
            .from('child_details')
            .select('id')
            .eq('user_id', session.user.id)
            .limit(1);

        if (!mounted) return;

        if (childResponse.isNotEmpty) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        // stay on sign-in screen
      }
    } catch (e) {
      developer.log('Error checking session: $e');
    }
  }


  // Check if user has completed profile setup
  Future<void> _checkProfileAndNavigate(String userId) async {
    try {
      // Check if user has child details (meaning registration is complete)
      final childResponse = await supabase
          .from('child_details')
          .select('id')
          .eq('user_id', userId)
          .limit(1);

      if (!mounted) return;

      if (childResponse.isNotEmpty) {
        // Profile complete - go to home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Profile incomplete - redirect to complete registration
        Navigator.pushReplacementNamed(context, '/sign-up-step2');
      }
    } catch (e) {
      developer.log('Error checking profile: $e', level: 1000);
      
    }
  }

  Future<void> _signIn() async {
    if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please enter both email and password';
      });
      return;
    }

    setState(() {
      isAuth = true;
      errorMessage = null;
    });

    try {
      // Attempt to sign in with Supabase
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      if (!mounted) return;

      if (response.user != null) {
        // Sign in successful, check profile completion
        await _checkProfileAndNavigate(response.user!.id);
      } else {
        setState(() {
          isAuth = false;
          errorMessage = 'Sign in failed. Please try again.';
        });
      }
    } on AuthException catch (e) {
      setState(() {
        isAuth = false;
        errorMessage = _getReadableAuthError(e.message);
      });
    } catch (e) {
      setState(() {
        isAuth = false;
        errorMessage = 'An unexpected error occurred. Please try again.';
      });
    }
  }

  String _getReadableAuthError(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    } else if (error.contains('Email not confirmed')) {
      return 'Please check your email and confirm your account';
    } else if (error.contains('Too many requests')) {
      return 'Too many attempts. Please try again later';
    } else if (error.contains('User not found')) {
      return 'No account found with this email';
    } else {
      return 'Sign in failed: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background circles
          Positioned(
            left: -size.width * 0.4,
            top: -size.height * 0.17,
            child: Container(
              width: size.width * 0.73,
              height: size.width * 0.73,
              decoration: const BoxDecoration(
                color: Color(0xFFDFC2FF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: size.width * 0.72,
            top: -size.height * 0.11,
            child: Container(
              width: size.width * 0.73,
              height: size.width * 0.73,
              decoration: const BoxDecoration(
                color: Color(0xFFEBD8D0),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Logo and title
          Positioned(
            top: size.height * 0.18,
            left: size.width * 0.12,
            child: SvgPicture.asset(
              'assets/images/lastfp.svg',
              width: size.width * 0.1,
              height: size.width * 0.1,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: size.height * 0.18,
            left: size.width * 0.25,
            child: const Text(
              'TinyTracks',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                color: Color(0xFF4A4947),
              ),
            ),
          ),

          // Email input
          Positioned(
            top: size.height * 0.34,
            left: size.width * 0.05,
            child: Container(
              width: size.width * 0.9,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color(0xFF4A4947),
                  fontFamily: 'Poppins',
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  hintStyle: TextStyle(
                    color: Color(0xFF4A4947),
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),

          // Password input
          Positioned(
            top: size.height * 0.44,
            left: size.width * 0.05,
            child: Container(
              width: size.width * 0.9,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: password,
                obscureText: true,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Color(0xFF4A4947),
                  fontFamily: 'Poppins',
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Color(0xFF4A4947),
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                onSubmitted: (_) => _signIn(),
              ),
            ),
          ),

          // Error message
          if (errorMessage != null)
            Positioned(
              top: size.height * 0.52,
              left: size.width * 0.1,
              right: size.width * 0.1,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 0, 0, 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // Loading indicator
          if (isAuth)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9588B3)),
                ),
              ),
            ),

          // Sign In Button
          Positioned(
            bottom: size.height * 0.05,
            left: size.width * 0.14,
            child: GestureDetector(
              onTap: isAuth ? null : _signIn,
              child: Container(
                width: size.width * 0.73,
                height: 60,
                decoration: BoxDecoration(
                  color: isAuth
                      ? const Color.fromRGBO(149, 136, 179, 0.7)
                      : const Color(0xFF9588B3),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),

          // Sign Up link
          Positioned(
            bottom: size.height * 0.24,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/sign-up-step1'),
              child: Text(
                "No account? Select Sign Up instead",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9588B3),
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
