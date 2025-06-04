import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                      // Top decorative circles
          Positioned(
            left: -screenWidth * 0.4,
            top: -screenHeight * 0.16,
            child: Container(
              width: screenWidth * 0.73,
              height: screenWidth * 0.73,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFDFC2FF),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.72,
            top: -screenHeight * 0.11,
            child: Container(
              width: screenWidth * 0.73,
              height: screenWidth * 0.73,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEBD8D0),
              ),
            ),
          ),

            // Heart Circle - Left 
            Positioned(
              left: screenWidth * -0.3,
              bottom: screenHeight * -0.2, 
              child: Container(
                width: screenWidth * 1.45,
                height: screenWidth * 1.45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDFC2FF),
                ),
              ),
            ),

            // Heart Circle - Right 
            Positioned(
              left: screenWidth * 0.38,
              bottom: screenHeight * -0.10, // same offset for symmetry
              child: Container(
                width: screenWidth * 1.45,
                height: screenWidth * 1.45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDFC2FF),
                ),
              ),
            ),



           // Feet Image with Opacity
            Positioned(
              left: screenWidth * 0.70,
              top: screenHeight * 0.28,
              child: Opacity(
                opacity: 0.3, 
                child: SvgPicture.asset(
                  'assets/images/welcomefeet.svg',
                  width: screenWidth * 0.15,
                ),
              ),
            ),


            // Headline Text
            Positioned(
              left: screenWidth * 0.02,
              top: screenHeight * 0.22,
              child: Text(
                "Welcome to TinyTracks",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4947),
                ),
              ),
            ),

            // Paragraph Text
            Positioned(
              top: screenHeight * 0.55,
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              child: const Text(
                "Your child's journey is precious,\n and we’re here to help you cherish\n every moment.\n"
                "From first steps to memorable\n milestones, TinyTracks ensures\n you stay organized while \ncelebrating the joy of parenthood.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4947),
                ),
              ),
            ),

            Positioned(
              left: screenWidth * 0.8,
              bottom: screenHeight * 0.1,
              child: IconButton(
                icon: Icon(Icons.double_arrow),
                iconSize: screenWidth * 0.1,
                color: Color(0xFF4A4947),
                onPressed: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
}
