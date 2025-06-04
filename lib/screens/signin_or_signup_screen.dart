import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInOrSignUpScreen extends StatefulWidget {
  const SignInOrSignUpScreen({super.key});

  @override
  State<SignInOrSignUpScreen> createState() => _SignInOrSignUpScreenState();
}

class _SignInOrSignUpScreenState extends State<SignInOrSignUpScreen> {
  Future<void> handleGoogleSignIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;

      if (!mounted) return;  

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google sign-in failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Stack(
          children: [
            // Top Left Ellipse
            Positioned(
              left: screenWidth * -0.4,
              top: screenHeight * -0.16,
              child: Container(
                width: screenWidth * 0.73,
                height: screenWidth * 0.73,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDFC2FF),
                ),
              ),
            ),

            // Top Right Ellipse
            Positioned(
              left: screenWidth * 0.72,
              top: screenHeight * -0.11,
              child: Container(
                width: screenWidth * 0.73,
                height: screenWidth * 0.73,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEBD8D0),
                ),
              ),
            ),

            // SIGN IN Button
            Positioned(
              left: screenWidth * 0.14,
              right: screenWidth * 0.14,
              top: screenHeight * 0.38,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/sign-in');
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9588B3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),

            // SIGN UP Button
            Positioned(
              left: screenWidth * 0.14,
              right: screenWidth * 0.14,
              top: screenHeight * 0.53,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/sign-up-step1');
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9588B3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),

            // "OR" Divider
            Positioned(
              left: screenWidth * 0.11,
              right: screenWidth * 0.11,
              top: screenHeight * 0.69,
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[500],
                      thickness: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xFF4A4947),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[500],
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              left: (screenWidth - 64) / 2, 
              top: screenHeight * 0.69 + 56, 
              child: GestureDetector(
               onTap: handleGoogleSignIn,

                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: SvgPicture.asset(
                    'assets/images/google.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
