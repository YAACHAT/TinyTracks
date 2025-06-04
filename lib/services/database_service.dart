import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import '../models/user_profile.dart';

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  String? _currentUid;

  // Authentication helpers
  void setCurrentUser(String? uid) {
    _currentUid = uid;
  }

  String _ensureAuth() {
    if (_currentUid == null) {
      throw Exception('User not authenticated');
    }
    return _currentUid!;
  }

  // READ FUNCTIONS for any table
  Future<List<Map<String, dynamic>>> readAll(String tableName) async {
    try {
      final uid = _ensureAuth();
      final response = await _client
          .from(tableName)
          .select()
          .eq('uid', uid)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error retriving from $tableName: $e');
    }
  }

  Future<Map<String, dynamic>?> readById(String tableName, String id) async {
    try {
      final uid = _ensureAuth();
      final response = await _client
          .from(tableName)
          .select()
          .eq('uid', uid)
          .eq('id', id)
          .maybeSingle();
      return response;
    } catch (e) {
      throw Exception('Error reading record from $tableName: $e');
    }
  }

  Future<List<Map<String, dynamic>>> readWithDateRange(
    String tableName,
    String dateColumn,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final uid = _ensureAuth();
      final response = await _client
          .from(tableName)
          .select()
          .eq('uid', uid)
          .gte(dateColumn, startDate.toIso8601String().split('T')[0])
          .lte(dateColumn, endDate.toIso8601String().split('T')[0])
          .order(dateColumn, ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error reading $tableName with date range: $e');
    }
  }

  // WRITE FUNCTIONS
  Future<Map<String, dynamic>> create(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    try {
      final uid = _ensureAuth();
      data['uid'] = uid; // Ensure uid is always included
      final response = await _client
          .from(tableName)
          .insert(data)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Oops! Error saving at $tableName: $e');
    }
  }

  Future<Map<String, dynamic>> update(
    String tableName,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final uid = _ensureAuth();
      data['updated_at'] = DateTime.now().toIso8601String();
      final response = await _client
          .from(tableName)
          .update(data)
          .eq('uid', uid)
          .eq('id', id)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception(' Update Error at $tableName: $e');
    }
  }

  Future<void> delete(String tableName, String id) async {
    try {
      final uid = _ensureAuth();
      await _client
          .from(tableName)
          .delete()
          .eq('uid', uid)
          .eq('id', id);
    } catch (e) {
      throw Exception('Error clearing from $tableName: $e');
    }
  }

  // USER PROFILE FUNCTIONS
  Future<UserProfile?> getUserProfile([String? uid]) async {
    try {
      final targetUid = uid ?? _ensureAuth();
      final response = await _client
          .from('users_profile')
          .select()
          .eq('uid', targetUid)
          .maybeSingle();
      
      return response != null ? UserProfile.fromSupabase(response) : null;
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  Future<void> insertUserProfile(UserProfile userProfile) async {
    try {
      await _client.from('users_profile').insert(userProfile.toSupabase());
      debugPrint('User profile inserted successfully');
    } catch (e) {
      throw Exception('Error inserting user profile: $e');
    }
  }

  Future<void> updateUserProfile({
    String? uid,
    String? childName,
    DateTime? birthDate,
    String? gender,
    String? imageUrl,
  }) async {
    try {
      final targetUid = uid ?? _ensureAuth();
      Map<String, dynamic> updates = {};
      if (childName != null) updates['child_name'] = childName;
      if (birthDate != null) updates['birth_date'] = birthDate.toIso8601String();
      if (gender != null) updates['gender'] = gender;
      if (imageUrl != null) updates['image_url'] = imageUrl;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _client.from('users_profile').update(updates).eq('uid', targetUid);
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  // FEEDING RECORDS
  Future<void> saveFeedingRecord({
    String? foodAllergies,
    String? favourites,
    String? specialNeeds,
    List<String>? dietaryRestrictions,
  }) async {
    await create('feeding_records', {
      'food_allergies': foodAllergies,
      'favourites': favourites,
      'special_needs': specialNeeds,
      'dietary_restrictions': dietaryRestrictions,
    });
  }

  Future<List<Map<String, dynamic>>> getFeedingRecords() async {
    return await readAll('feeding_records');
  }

  // SLEEP RECORDS
  Future<void> saveSleepRecord({
    required int durationMinutes,
    String? notes,
    DateTime? sleepDate,
  }) async {
    await create('sleep_records', {
      'duration_minutes': durationMinutes,
      'notes': notes,
      'sleep_date': (sleepDate ?? DateTime.now()).toIso8601String().split('T')[0],
    });
  }

  Future<List<Map<String, dynamic>>> getSleepRecords() async {
    return await readAll('sleep_records');
  }

  Future<List<Map<String, dynamic>>> getSleepRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await readWithDateRange('sleep_records', 'sleep_date', startDate, endDate);
  }

  // DIAPER RECORDS
  Future<void> saveDiaperRecord({
    required String colorTag,
    String? notes,
    DateTime? changeDate,
  }) async {
    await create('diaper_records', {
      'color_tag': colorTag,
      'notes': notes,
      'change_date': (changeDate ?? DateTime.now()).toIso8601String().split('T')[0],
    });
  }

  Future<List<Map<String, dynamic>>> getDiaperRecords() async {
    return await readAll('diaper_records');
  }

  Future<List<Map<String, dynamic>>> getDiaperRecordsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await readWithDateRange('diaper_records', 'change_date', startDate, endDate);
  }

  // MILESTONE RECORDS
  Future<void> saveMilestoneRecord({
    required String milestoneType,
    required DateTime milestoneDate,
    String? notes,
  }) async {
    await create('milestone_records', {
      'milestone_type': milestoneType,
      'milestone_date': milestoneDate.toIso8601String().split('T')[0],
      'notes': notes,
    });
  }

  Future<List<Map<String, dynamic>>> getMilestoneRecords() async {
    try {
      final uid = _ensureAuth();
      final response = await _client
          .from('milestone_records')
          .select()
          .eq('uid', uid)
          .order('milestone_date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching milestone records: $e');
    }
  }

  // HEALTH RECORDS
  Future<void> saveHealthRecord({
    required String recordType,
    String? immunizationName,
    DateTime? immunizationDate,
    String? symptoms,
    String? doctorNotes,
    String? prescriptions,
    double? temperatureValue,
    String? temperatureTime,
    DateTime? temperatureDate,
  }) async {
    await create('health_records', {
      'record_type': recordType,
      'immunization_name': immunizationName,
      'immunization_date': immunizationDate?.toIso8601String().split('T')[0],
      'symptoms': symptoms,
      'doctor_notes': doctorNotes,
      'prescriptions': prescriptions,
      'temperature_value': temperatureValue,
      'temperature_time': temperatureTime,
      'temperature_date': temperatureDate?.toIso8601String().split('T')[0],
    });
  }

  Future<List<Map<String, dynamic>>> getHealthRecords({String? recordType}) async {
    try {
      final uid = _ensureAuth();
      var query = _client.from('health_records').select().eq('uid', uid);
      if (recordType != null) {
        query = query.eq('record_type', recordType);
      }
      final response = await query.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching health records: $e');
    }
  }

  // CAREGIVER RECORDS
  Future<void> saveCaregiver({
    required String name,
    String? address,
    String? phoneNumber,
    String? email,
    double? payPerHour,
    DateTime? dateAdded,
  }) async {
    await create('caregivers', {
      'name': name,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'pay_per_hour': payPerHour,
      'date_added': dateAdded?.toIso8601String().split('T')[0],
    });
  }

  Future<List<Map<String, dynamic>>> getCaregivers() async {
    return await readAll('caregivers');
  }

  // GROWTH RECORDS
  Future<void> saveGrowthRecord({
    double? weight,
    double? height,
    double? headCircumference,
    required DateTime recordDate,
  }) async {
    await create('growth_records', {
      'weight': weight,
      'height': height,
      'head_circumference': headCircumference,
      'record_date': recordDate.toIso8601String().split('T')[0],
    });
  }

  Future<List<Map<String, dynamic>>> getGrowthRecords() async {
    try {
      final uid = _ensureAuth();
      final response = await _client
          .from('growth_records')
          .select()
          .eq('uid', uid)
          .order('record_date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching growth records: $e');
    }
  }

  // BUDGET RECORDS
  Future<void> saveBudgetRecord({
    required double totalAllocation,
    required String expenseCategory,
    required Map<String, dynamic> expenseItems,
    required double totalExpenses,
    required double moneyLeft,
  }) async {
    await create('budget_records', {
      'total_allocation': totalAllocation,
      'expense_category': expenseCategory,
      'expense_items': expenseItems,
      'total_expenses': totalExpenses,
      'money_left': moneyLeft,
    });
  }

  Future<List<Map<String, dynamic>>> getBudgetRecords() async {
    return await readAll('budget_records');
  }

  // EVENTS
  Future<void> saveEvent({
    required String eventName,
    String? location,
    required DateTime eventDate,
    DateTime? eventTime,
    String? description,
    bool? isCompleted,
  }) async {
    await create('events', {
      'event_name': eventName,
      'location': location,
      'event_date': eventDate.toIso8601String().split('T')[0],
      'event_time': eventTime?.toIso8601String().split('T')[1].split('.')[0],
      'description': description,
      'is_completed': isCompleted ?? false,
    });
  }

  Future<List<Map<String, dynamic>>> getEvents({bool? completed}) async {
    try {
      final uid = _ensureAuth();
      var query = _client.from('events').select().eq('uid', uid);
      if (completed != null) {
        query = query.eq('is_completed', completed);
      }
      final response = await query
          .order('event_date', ascending: false)
          .order('event_time', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  Future<void> markEventCompleted(String eventId) async {
    await update('events', eventId, {'is_completed': true});
  }

  // HYGIENE REMINDERS
  Future<void> saveHygieneReminder({
    required String reminderType,
    required DateTime reminderDate,
    required DateTime reminderTime,
  }) async {
    await create('hygiene_reminders', {
      'reminder_type': reminderType,
      'reminder_date': reminderDate.toIso8601String().split('T')[0],
      'reminder_time': reminderTime.toIso8601String().split('T')[1].split('.')[0],
    });
  }

  Future<List<Map<String, dynamic>>> getHygieneReminders() async {
    try {
      final uid = _ensureAuth();
      final response = await _client
          .from('hygiene_reminders')
          .select()
          .eq('uid', uid)
          .order('reminder_date', ascending: false)
          .order('reminder_time', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching hygiene reminders: $e');
    }
  }

  // EXTERNAL FILES
  Future<void> saveExternalFile({
    required String fileName,
    required String fileUrl,
    String? fileType,
  }) async {
    await create('external_files', {
      'file_name': fileName,
      'file_url': fileUrl,
      'file_type': fileType,
    });
  }

  Future<List<Map<String, dynamic>>> getExternalFiles() async {
    try {
      final uid = _ensureAuth();
      final response = await _client
          .from('external_files')
          .select()
          .eq('uid', uid)
          .order('uploaded_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching external files: $e');
    }
  }

  // CHILD HEALTH DATA
  Future<void> insertChildHealthData({
    String? uid,
    double? weight,
    double? height,
    double? headCircumference,
    String? genotype,
    String? bloodGroup,
  }) async {
    try {
      final targetUid = uid ?? _ensureAuth();
      await _client.from('child_health_data').insert({
        'uid': targetUid,
        'weight': weight,
        'height': height,
        'head_circumference': headCircumference,
        'genotype': genotype,
        'blood_group': bloodGroup,
      });
    } catch (e) {
      throw Exception('Error inserting child health data: $e');
    }
  }

  Future<Map<String, dynamic>?> getChildHealthData([String? uid]) async {
    try {
      final targetUid = uid ?? _ensureAuth();
      final response = await _client
          .from('child_health_data')
          .select()
          .eq('uid', targetUid)
          .maybeSingle();
      return response;
    } catch (e) {
      throw Exception('Error fetching child health data: $e');
    }
  }

  // ANALYTICS & INSIGHTS
  Future<Map<String, dynamic>> getDailyStats(DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];
    final uid = _ensureAuth();
    
    try {
      final sleepData = await _client
          .from('sleep_records')
          .select('duration_minutes')
          .eq('uid', uid)
          .eq('sleep_date', dateStr);
      
      final diaperData = await _client
          .from('diaper_records')
          .select('color_tag')
          .eq('uid', uid)
          .eq('change_date', dateStr);
      
      final totalSleep = sleepData.fold<int>(0, (sum, record) => sum + ((record['duration_minutes'] ?? 0) as int));
      final diaperChanges = diaperData.length;
      
      return {
        'date': dateStr,
        'total_sleep_minutes': totalSleep,
        'diaper_changes': diaperChanges,
        'sleep_hours': (totalSleep / 60).toStringAsFixed(1),
      };
    } catch (e) {
      throw Exception('Error fetching daily stats: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getWeeklyGrowthTrend() async {
    try {
      final uid = _ensureAuth();
      final oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
      
      final response = await _client
          .from('growth_records')
          .select()
          .eq('uid', uid)
          .gte('record_date', oneWeekAgo.toIso8601String().split('T')[0])
          .order('record_date', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error fetching weekly growth trend: $e');
    }
  }

  // BULK OPERATIONS
  Future<void> deleteAllUserData([String? uid]) async {
    try {
      final targetUid = uid ?? _ensureAuth();
      
      final tables = [
        'users_profile', 'child_health_data', 'feeding_records',
        'sleep_records', 'diaper_records', 'milestone_records',
        'health_records', 'caregivers', 'hygiene_reminders',
        'growth_records', 'budget_records', 'events', 'external_files'
      ];
      
      for (String table in tables) {
        await _client.from(table).delete().eq('uid', targetUid);
      }
      
      debugPrint('All user data deleted from Supabase for UID: $targetUid');
    } catch (e) {
      throw Exception('Error deleting user data: $e');
    }
  }

  // FILE UPLOAD
  Future<String?> uploadProfileImage(String filePath) async {
    final uid = _ensureAuth();
    final file = File(filePath);
    final fileExt = path.extension(filePath);
    final fileName = 'profile_images/$uid$fileExt';

    try {
      await _client.storage.from('avatars').upload(fileName, file);
      final publicUrl = _client.storage.from('avatars').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  // REAL-TIME SUBSCRIPTIONS
  RealtimeChannel subscribeToTable(
    String tableName,
    void Function(PostgresChangePayload) onData,
  ) {
    final uid = _ensureAuth();
    final channel = _client
        .channel('public:$tableName:uid=eq.$uid')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: tableName,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'uid',
            value: uid,
          ),
          callback: onData,
        )
        .subscribe();
    
    return channel;
  }
}