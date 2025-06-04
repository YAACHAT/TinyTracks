import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

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


            // Headline Text
            Positioned(
              left: screenWidth * 0.03,
              right: screenWidth * 0.03,
              top: screenHeight * 0.215,
              child: Text(
                "Start the adventure today—because every tiny track leads to a big story!",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Color(0xFF4A4947),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Get Started Button
            Positioned(
              left: screenWidth * 0.14,
              right: screenWidth * 0.14,
              top: screenHeight * 0.65,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/auth-choice');
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9588B3),
                    borderRadius: BorderRadius.circular(40), // Rounded button
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      color: Color(0xFFFFFFFF),
                    ),
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
