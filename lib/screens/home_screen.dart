import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:tiny_tracks/widgets/custom_nav_bar.dart'; 


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final profileCardWidth = screenWidth * 0.9;
    final profileCardHeight = screenHeight * 0.24;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        children: [
          // W-shaped background with simulated inner shadow
          Positioned(
            bottom: 0,
            child: Stack(
              children: [
                // Clipped background
                ClipPath(
                  clipper: WCurveClipper(),
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.5,
                    color: const Color(0xFFEAE1FF),
                  ),
                ),
                // Simulated inner shadow using gradient overlay
                ClipPath(
                  clipper: WCurveClipper(),
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(51, 79, 79, 79), 
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          // Profile Card
          Positioned(
            top: screenHeight * 0.12,
            left: (screenWidth - profileCardWidth) / 2,
            child: InnerShadow(
              shadows: [
                BoxShadow(
                  color: Color(0x4D000000),
                  blurRadius: 20,
                  offset: Offset(3, 3),
                ),
                BoxShadow(
                  color: Color(0x33FFFFFF),
                  blurRadius: 10,
                  offset: Offset(3, 3),
                ),
              ],
              child: Container(
                width: profileCardWidth,
                height: profileCardHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFFDED4CA),
                  borderRadius: BorderRadius.circular(75),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: profileCardWidth * 0.06,
                      top: profileCardHeight * 0.13,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: profileCardHeight * 0.375,
                          backgroundColor: const Color(0xFFBCAC9E),
                          backgroundImage: _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? const Icon(Icons.add_a_photo, color: Colors.white, size: 30)
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      left: profileCardWidth * 0.52,
                      top: profileCardHeight * 0.2,
                      child: const Text(
                        'Name',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF4A4947),
                        ),
                      ),
                    ),
                    Positioned(
                      left: profileCardWidth * 0.52,
                      top: profileCardHeight * 0.36,
                      child: const Text(
                        'year/month',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF4A4947),
                        ),
                      ),
                    ),
                    Positioned(
                      left: profileCardWidth * 0.52,
                      top: profileCardHeight * 0.54,
                      child: const Text(
                        'gender',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF4A4947),
                        ),
                      ),
                    ),

                    Positioned(
                      right: profileCardWidth * 0.10,
                      bottom: profileCardHeight * 0.1,
                      child: const Icon(
                        Icons.notifications,
                        size: 24,
                        color: Color(0xFF4A4947),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Activity Logs title
          Positioned(
            left: screenWidth * 0.05,
            top: (screenHeight * 0.55) - 8,
            child: const Text(
              'Activity Logs',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Color(0xFF4A4947),
              ),
            ),
          ),

          // Scrollable Buttons
          Positioned(
            top: screenHeight * 0.65,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 126,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                children: [
                            activityButton(context, 'Feeding', 0xFFFFEB99, '/feeding', 'assets/images/feeding.svg'),
                            const SizedBox(width: 16),
                            activityButton(context, 'Sleep', 0xFFA8D0E6, '/sleep', 'assets/images/sleep.svg'),
                            const SizedBox(width: 16),
                            activityButton(context, 'Diaper', 0xFFA8E6CF, '/diaper-change', 'assets/images/DC.svg'),
                            const SizedBox(width: 16),
                            activityButton(context, 'Milestones', 0xFFFFB6C1, '/milestones', 'assets/images/milestones.svg'),
                            const SizedBox(width: 16),
                            activityButton(context, 'Health', 0xFF66CCCC, '/health', 'assets/images/health.svg'),
                            const SizedBox(width: 16),
                            activityButton(context, 'Caregiver', 0xFFD2B48C, '/caregiver', 'assets/images/caregiver.svg'),
                            const SizedBox(width: 16),
                            activityButton(context, 'Hygiene', 0xFFFFFFFF, '/hygiene', 'assets/images/hygiene.svg'),
                            const SizedBox(width: 16),
                            activityButton(context, 'Growth', 0xFFFFC499, '/growth', 'assets/images/growth.svg'),
                          ],

              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: const CustomNavBar(currentRoute: '/home'),

    );
  }

  Widget activityButton(BuildContext context, String label, int colorHex, String route, String iconPath) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, route),
    child: Container(
      width: 125,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(colorHex),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0), 
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 36,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget navIcon(BuildContext context, IconData icon, String route) {
    return IconButton(
      icon: Icon(icon, size: 30, color: const Color(0xFF4A4947)),
      onPressed: () => Navigator.pushNamed(context, route),
    );
  }
}

class WCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 40);
    path.quadraticBezierTo(size.width * 0.75, 80, size.width, 40);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
