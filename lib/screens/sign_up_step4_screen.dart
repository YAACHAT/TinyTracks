import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpStep4Screen extends StatefulWidget {
  const SignUpStep4Screen({super.key});

  @override
  State<SignUpStep4Screen> createState() => _SignUpStep4ScreenState();
}

class _SignUpStep4ScreenState extends State<SignUpStep4Screen> {
  Map<String, dynamic>? _signUpData;
  bool _isLoading = false;
  String? _errorMessage;

  // Supabase client
  final supabase = Supabase.instance.client;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _signUpData = Map<String, dynamic>.from(args);
    }
  }

  Future<String?> _uploadProfileImage(String userId, String imagePath) async {
    try {
      final file = File(imagePath);
      
      // Check if file exists
      if (!await file.exists()) {
        developer.log('Profile image file does not exist: $imagePath');
        return null;
      }

      final fileName = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Read file as bytes
      final bytes = await file.readAsBytes();

      // Upload to Supabase Storage
      await supabase.storage
          .from('profile_images')
          .uploadBinary(fileName, bytes);

      // Generate public URL
      final String publicUrl = supabase.storage
          .from('profile_images')
          .getPublicUrl(fileName);

      developer.log('Successfully uploaded profile image for user $userId: $publicUrl');
      return publicUrl;
      
    } catch (err) {
      developer.log('Error uploading image for user $userId', error: err);
      return null;
    }
  }

  Future<void> _finalizeSignUp() async {
    if (_signUpData == null ||
        !_signUpData!.containsKey('email') ||
        !_signUpData!.containsKey('password')) {
      setState(() {
        _errorMessage = 'Missing email or password.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // CREATE AUTH USER FIRST
      final AuthResponse authResponse = await supabase.auth.signUp(
        email: _signUpData!['email'],
        password: _signUpData!['password'],
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create user account.');
      }

      final String userId = authResponse.user!.id;

      // UPLOAD PROFILE IMAGE IF EXISTS
      String? profileImageUrl;
      if (_signUpData!['hasProfileImage'] == true &&
          _signUpData!['profileImagePath'] is String) {
        final localPath = _signUpData!['profileImagePath'] as String;
        profileImageUrl = await _uploadProfileImage(userId, localPath);
        if (profileImageUrl == null) {
          developer.log('Warning: profile image upload failed for user $userId.');
        }
      }

      // INSERT INTO `profiles` TABLE
      final profileMap = <String, dynamic>{
        'id': userId,
        'email': _signUpData!['email'],
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Remove null values
      profileMap.removeWhere((key, value) => value == null);

      await supabase
          .from('profiles')
          .upsert(profileMap, onConflict: 'id');

      // INSERT INTO `child_details` TABLE
      final Map<String, dynamic> childMap = {
        'user_id': userId, // Foreign key linking to profiles.id
        'name': _signUpData!['childName'],
        'birth_date': _signUpData!['birthDate'] is DateTime
            ? (_signUpData!['birthDate'] as DateTime).toIso8601String()
            : _signUpData!['birthDate'],
        'gender': _signUpData!['gender'],
        'weight': _signUpData!['weight'],
        'height': _signUpData!['height'],
        'head_circumference': _signUpData!['headCircumference'],
        'genotype': _signUpData!['genotype'],
        'blood_group': _signUpData!['bloodGroup'],
        'profile_image_url': profileImageUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Remove null values before inserting
      childMap.removeWhere((key, value) => value == null);

      await supabase.from('child_details').insert(childMap);

      // SUCCESS - Navigate to home and clear navigation stack
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

    } on AuthException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = _readableAuthError(e.message);
      });
    } on PostgrestException catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Database error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Sign up failed: ${e.toString()}';
      });
    }
  }

  String _readableAuthError(String error) {
    if (error.contains('already registered') || error.contains('already been registered')) {
      return 'That email is already in use.';
    } else if (error.contains('password')) {
      return 'Password must be at least 6 characters.';
    } else if (error.contains('email')) {
      return 'Please enter a valid email address.';
    } else if (error.contains('weak password')) {
      return 'Password is too weak. Please use a stronger password.';
    } else {
      return 'Sign up failed: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        children: [
          // Top-left circle
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

          // Top-right circle
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

          // "All done!" text
          Positioned(
            top: size.height * 0.27,
            left: size.width * 0.06,
            right: size.width * 0.06,
            child: const Text(
              "All done!\nNow be more powerful and parent better with data.",
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4947),
              ),
            ),
          ),

          // Footprint SVG
          Positioned(
            top: size.height * 0.48,
            left: size.width * 0.85,
            child: SvgPicture.asset(
              'assets/images/lastfp.svg',
              width: size.width * 0.08,
              height: size.width * 0.08,
              fit: BoxFit.contain,
            ),
          ),

          // Error message (if any)
          if (_errorMessage != null)
            Positioned(
              bottom: size.height * 0.15,
              left: size.width * 0.1,
              right: size.width * 0.1,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 0, 0, 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // "SIGN UP" button (or spinner if loading)
          Positioned(
            bottom: size.height * 0.05,
            left: size.width * 0.14,
            child: GestureDetector(
              onTap: _isLoading ? null : _finalizeSignUp,
              child: Container(
                width: size.width * 0.73,
                height: 60,
                decoration: BoxDecoration(
                  color: _isLoading
                      ? const Color.fromRGBO(149, 136, 179, 0.7)
                      : const Color(0xFF9588B3),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'SIGN UP',
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
        ],
      ),
    );
  }
}