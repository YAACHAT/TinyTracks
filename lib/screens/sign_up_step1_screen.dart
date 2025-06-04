import 'package:flutter/material.dart';

class SignUpStep1Screen extends StatefulWidget {
  const SignUpStep1Screen({super.key});

  @override
  State<SignUpStep1Screen> createState() => _SignUpStep1ScreenState();
}

class _SignUpStep1ScreenState extends State<SignUpStep1Screen> {
  // Controllers to capture text input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();


  // State for password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // State for validation
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validate inputs before proceeding
  bool _validateInputs() {
    bool isValid = true;
    
    // Email validation
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text.trim())) {
      setState(() {
        _emailError = 'Enter a valid email address';
      });
      isValid = false;
    } else {
      setState(() {
        _emailError = null;
      });
    }

    // Password validation
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      isValid = false;
    } else {
      setState(() {
        _passwordError = null;
      });
    }

    // Confirm password validation
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      isValid = false;
    } else if (_confirmPasswordController.text != _passwordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      isValid = false;
    } else {
      setState(() {
        _confirmPasswordError = null;
      });
    }

    return isValid;
  }

  void _proceedToNextStep() {
    if (_validateInputs()) {
      // Create a map with the data from this screen
      final signUpData = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      };

      // Navigate to next screen with the data
      Navigator.pushNamed(
        context, 
        '/sign-up-step2',
        arguments: signUpData,
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
      resizeToAvoidBottomInset: true, // Changed to true for keyboard
      body: SingleChildScrollView( // Added for keyboard handling
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              // Top decorative circles (unchanged)
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

              // Main content
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.21),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.055),
                      child: Text(
                        'CREATE AN ACCOUNT',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.073,
                          color: const Color(0xFF4A4947),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.055),

                    // Input fields - now using custom methods
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.058),
                      child: Column(
                        children: [
                          _buildEmailInput(screenWidth),
                          SizedBox(height: screenHeight * 0.045),
                          _buildPasswordInput(screenWidth),
                          SizedBox(height: screenHeight * 0.045),
                          _buildConfirmPasswordInput(screenWidth),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation buttons
              Positioned(
                bottom: screenHeight * 0.1,
                left: screenWidth * 0.01,
                child: IconButton(
                  icon: Transform.rotate(
                    angle: 3.14159, // Rotate 180 degrees 
                    child: Icon(
                      Icons.double_arrow,
                      size: 50, 
                      color: Color(0xFF4A4947), 
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth-choice');
                  },
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.1,
                left: screenWidth * 0.8,
                child: IconButton(
                  icon: Icon(
                    Icons.double_arrow, 
                    size: 50, 
                    color: Color(0xFF4A4947), 
                  ),
                  onPressed: _proceedToNextStep,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom email input with validation
  Widget _buildEmailInput(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: screenWidth * 0.87,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                offset: Offset(-2, -2),
                blurRadius: 2,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.045,
              color: const Color(0xFF4A4947),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Email Address',
              hintStyle: TextStyle(
                color: const Color(0xFF4A4947),
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        if (_emailError != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5),
            child: Text(
              _emailError!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  // Custom password input with toggle visibility
  Widget _buildPasswordInput(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: screenWidth * 0.87,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                offset: Offset(-2, -2),
                blurRadius: 2,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.045,
              color: const Color(0xFF4A4947),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Password',
              hintStyle: TextStyle(
                color: const Color(0xFF4A4947),
                fontFamily: 'Poppins',
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF4A4947),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ),
        if (_passwordError != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5),
            child: Text(
              _passwordError!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  // Custom confirm password input with toggle visibility
  Widget _buildConfirmPasswordInput(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: screenWidth * 0.87,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                offset: Offset(-2, -2),
                blurRadius: 2,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: screenWidth * 0.045,
              color: const Color(0xFF4A4947),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Confirm Password',
              hintStyle: TextStyle(
                color: const Color(0xFF4A4947),
                fontFamily: 'Poppins',
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF4A4947),
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
          ),
        ),
        if (_confirmPasswordError != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5),
            child: Text(
              _confirmPasswordError!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}