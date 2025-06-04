import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  
  // Getter for Parent
  static SupabaseClient get client => _client;
  
  // Auth m
  static Future<AuthResponse> signUp({
    required String email, 
    required String password
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  static Future<AuthResponse> signIn({
    required String email, 
    required String password
  }) async {
    return await _client.auth.signInWithPassword(
      email: email, 
      password: password
    );
  }
  
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  static User? get currentUser => _client.auth.currentUser;
  
  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  // Profile methods
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    
    return response;
  }
  
  static Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    await _client
        .from('profiles')
        .update(updates)
        .eq('id', userId);
  }
  
  // Child methods
  static Future<List<Map<String, dynamic>>> getUserChild(String userId) async {
    final response = await _client
        .from('child_details')
        .select()
        .eq('user_id', userId)
        .order('created_at');
    
    return List<Map<String, dynamic>>.from(response);
  }
  
  static Future<Map<String, dynamic>> createChild(Map<String, dynamic> childData) async {
    final response = await _client
        .from('child_details')
        .insert(childData)
        .select()
        .single();
    
    return response;
  }
  
  static Future<void> updateChild(String childId, Map<String, dynamic> updates) async {
    await _client
        .from('child_details')
        .update(updates)
        .eq('id', childId);
  }
  
  static Future<void> deleteChild(String childId) async {
    await _client
        .from('child_details')
        .delete()
        .eq('id', childId);
  }
  
  // Storage methods
  static Future<String> uploadProfileImage(String userId, File imageFile) async {
    final fileName = 'profile_$userId.jpg';
    
    await _client.storage
        .from('profile_images')
        .upload(fileName, imageFile, fileOptions: const FileOptions(
          upsert: true,
        ));
    
    return _client.storage
        .from('profile_images')
        .getPublicUrl(fileName);
  }
  
  static Future<void> deleteProfileImage(String userId) async {
    final fileName = 'profile_$userId.jpg';
    
    await _client.storage
        .from('profile_images')
        .remove([fileName]);
  }
  
  // Utility methods
  static bool get isSignedIn => _client.auth.currentUser != null;
  
  static String? get currentUserId => _client.auth.currentUser?.id;
  
  // Calculate age from birth date
  static int calculateAge(String birthDate) {
    final birth = DateTime.parse(birthDate);
    final now = DateTime.now();
    int age = now.year - birth.year;
    
    if (now.month < birth.month || 
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    
    return age;
  }
  
  
  static String formatBirthDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}