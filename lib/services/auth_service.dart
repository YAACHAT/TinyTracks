import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny_tracks/models/auth_state.dart' as app_auth;
import 'package:flutter/foundation.dart';

class AuthManager {
  final SupabaseClient _supabase = Supabase.instance.client;
  final StreamController<app_auth.AuthState> _authStateController = StreamController<app_auth.AuthState>.broadcast();
  
  app_auth.AuthState _currentState = const app_auth.AuthState.initial();
  
  AuthManager() {
    _initialize();
  }

  Stream<app_auth.AuthState> get authStateChanges => _authStateController.stream;
  app_auth.AuthState get currentState => _currentState;

  void _initialize() {
    // Listen to Supabase auth state changes
    _supabase.auth.onAuthStateChange.listen((data) {
      _handleAuthStateChange(data.session);
    });

    // Check initial auth state
    _handleAuthStateChange(_supabase.auth.currentSession);
  }

  Future<void> _handleAuthStateChange(Session? session) async {
    if (session == null) {
      _updateState(const app_auth.AuthState.unauthenticated());
      return;
    }

    try {
      // Check if user profile is complete
      final userProfile = await _getUserProfile(session.user.id);
      
      if (userProfile == null || userProfile['child_name'] == null) {
        _updateState(app_auth.AuthState.profileIncomplete(
          userId: session.user.id,
          email: session.user.email ?? '',
        ));
      } else {
        _updateState(app_auth.AuthState.authenticated(
          userId: session.user.id,
          email: session.user.email ?? '',
          userProfile: userProfile,
        ));
      }
    } catch (e) {
      _updateState(app_auth.AuthState.unauthenticated(error: e.toString()));
    }
  }

  Future<Map<String, dynamic>?> _getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  void _updateState(app_auth.AuthState newState) {
    _currentState = newState;
    _authStateController.add(newState);
  }

  // Sign up with email and password
  Future<app_auth.AuthState> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _updateState(const app_auth.AuthState.authenticating());

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        final error = 'Sign up failed. Please try again.';
        _updateState(app_auth.AuthState.unauthenticated(error: error));
        return app_auth.AuthState.unauthenticated(error: error);
      }

      // Return profile incomplete state as user needs to complete profile
      final newState = app_auth.AuthState.profileIncomplete(
        userId: response.user!.id,
        email: email,
      );
      _updateState(newState);
      return newState;

    } catch (e) {
      final error = _handleAuthError(e);
      _updateState(app_auth.AuthState.unauthenticated(error: error));
      return app_auth.AuthState.unauthenticated(error: error);
    }
  }

  // Sign in with email and password
  Future<app_auth.AuthState> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _updateState(const app_auth.AuthState.authenticating());

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        final error = 'Sign in failed. Please check your credentials.';
        _updateState(app_auth.AuthState.unauthenticated(error: error));
        return app_auth.AuthState.unauthenticated(error: error);
      }

      // Auth state updated by the listener
      return _currentState;

    } catch (e) {
      final error = _handleAuthError(e);
      _updateState(app_auth.AuthState.unauthenticated(error: error));
      return app_auth.AuthState.unauthenticated(error: error);
    }
  }

  // Complete user profile
  Future<app_auth.AuthState> completeProfile({
    required String childName,
    required String birthDate,
    required String gender,
    File? profileImage,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await _uploadProfileImage(user.id, profileImage);
      }

      // Create user profile
      final profileData = {
        'user_id': user.id,
        'child_name': childName,
        'birth_date': birthDate,
        'gender': gender,
        'profile_image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('user_profiles').upsert(profileData);

      final newState = app_auth.AuthState.authenticated(
        userId: user.id,
        email: user.email ?? '',
        userProfile: profileData,
      );
      _updateState(newState);
      return newState;

    } catch (e) {
      final error = 'Failed to complete profile: ${e.toString()}';
      _updateState(app_auth.AuthState.unauthenticated(error: error));
      return app_auth.AuthState.unauthenticated(error: error);
    }
  }

  Future<String?> _uploadProfileImage(String userId, File imageFile) async {
    try {
      final fileName = 'profile_$userId.jpg';
      final path = 'profiles/$fileName';

      await _supabase.storage
          .from('user-profiles')
          .upload(path, imageFile, fileOptions: const FileOptions(upsert: true));

      return _supabase.storage
          .from('user-profiles')
          .getPublicUrl(path);
    } catch (e) {
      // Using debugPrint instead of print for production
      debugPrint('Error uploading profile image: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _updateState(const app_auth.AuthState.unauthenticated());
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  String _handleAuthError(dynamic error) {
    if (error is AuthException) {
      switch (error.message.toLowerCase()) {
        case 'invalid login credentials':
          return 'Invalid email or password';
        case 'email not confirmed':
          return 'Please verify your email address';
        case 'user already registered':
          return 'This email is already registered';
        default:
          return error.message;
      }
    }
    return 'An unexpected error occurred';
  }

  void dispose() {
    _authStateController.close();
  }
}