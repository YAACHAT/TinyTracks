import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFDFC2FF),
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable content
            Positioned.fill(
              bottom: screenHeight * 0.12, // leave space for fixed button
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Headline
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.02),
                          child: const Text(
                            "About Us",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                              color: Color(0xFF4A4947),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Text background container
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCFBBFF),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "At TinyTracks, we understand that parenting is both an incredible journey and a whirlwind of responsibilities. That’s why we’ve built a platform dedicated to helping Nigerian parents stay on top of their child's early activities, events, expenses and growth milestones.",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Color(0xFF4A4947),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Extra body text
                        const Text(
                          "This app provides tools to:\n\n"
                          "• Track activities: Record important events, from first smiles to first steps.\n\n"
                          "• Budget better: Manage expenses and plan effectively for your child’s needs.\n\n"
                          "• Store together: Safeguard external documents like birth certificates, immunization records, and school reports in one accessible place.",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color(0xFF4A4947),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Fixed Button 
            Positioned(
              bottom: screenHeight * 0.035,
              right: screenWidth * 0.05,
              child: IconButton(
                icon: Icon(Icons.double_arrow),
                iconSize: screenWidth * 0.1,
                color: Color(0xFF4A4947),
                onPressed: () {
                  Navigator.pushNamed(context, '/get-started'); 
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
