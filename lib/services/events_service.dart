import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart'; 
import 'dart:developer'; 

class EventsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;


  Future<String?> addEvent({
    required String? childId,
    required String eventName,
    required String location,
    required DateTime eventDate,
    TimeOfDay? eventTime,
    required String description,
    bool setReminder = false,
    int reminderMinutesBefore = 60,
  }) async {
    try {
      String? timeString;
      if (eventTime != null) {
        timeString = '${eventTime.hour.toString().padLeft(2, '0')}:${eventTime.minute.toString().padLeft(2, '0')}:00';
      }

      final response = await _supabase.rpc('add_event', params: {
        'p_child_id': childId,
        'p_event_name': eventName,
        'p_location': location,
        'p_event_date': eventDate.toIso8601String().split('T')[0],
        'p_event_time': timeString,
        'p_description': description,
        'p_set_reminder': setReminder,
        'p_reminder_minutes_before': reminderMinutesBefore,
      });

      return response as String?;
    } catch (e) {
      log('Error adding event: $e'); 
      return null;
    }
  }

  // Get all events for the current user
  Future<List<Map<String, dynamic>>> getUserEvents() async {
    try {
      final response = await _supabase.rpc('get_user_events');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      log('Error getting user events: $e'); 
      return [];
    }
  }

  // Get events for a specific date
  Future<List<Map<String, dynamic>>> getEventsByDate(DateTime date) async {
    try {
      final response = await _supabase.rpc('get_events_by_date', params: {
        'p_event_date': date.toIso8601String().split('T')[0],
      });
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      log('Error getting events by date: $e'); 
      return [];
    }
  }

  // Get upcoming reminders
  Future<List<Map<String, dynamic>>> getUpcomingReminders({int hoursAhead = 24}) async {
    try {
      final response = await _supabase.rpc('get_upcoming_reminders', params: {
        'p_hours_ahead': hoursAhead,
      });
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      log('Error getting upcoming reminders: $e'); 
      return [];
    }
  }

  // Mark event as completed
  Future<bool> markEventCompleted(String eventId) async {
    try {
      final response = await _supabase.rpc('mark_event_completed', params: {
        'p_event_id': eventId,
      });
      return response as bool;
    } catch (e) {
      log('Error marking event as completed: $e'); 
      return false;
    }
  }

  // Update an event
  Future<bool> updateEvent({
    required String eventId,
    required String eventName,
    required String location,
    required DateTime eventDate,
    TimeOfDay? eventTime,
    required String description,
  }) async {
    try {
      // Convert TimeOfDay to Time string format
      String? timeString;
      if (eventTime != null) {
        timeString = '${eventTime.hour.toString().padLeft(2, '0')}:${eventTime.minute.toString().padLeft(2, '0')}:00';
      }

      final response = await _supabase.rpc('update_event', params: {
        'p_event_id': eventId,
        'p_event_name': eventName,
        'p_location': location,
        'p_event_date': eventDate.toIso8601String().split('T')[0],
        'p_event_time': timeString,
        'p_description': description,
      });
      return response as bool;
    } catch (e) {
      log('Error updating event: $e');
      return false;
    }
  }

  // Delete an event
  Future<bool> deleteEvent(String eventId) async {
    try {
      final response = await _supabase.rpc('delete_event', params: {
        'p_event_id': eventId,
      });
      return response as bool;
    } catch (e) {
      log('Error deleting event: $e'); 
      return false;
    }
  }

  // Get child details for dropdown/selection
  Future<List<Map<String, dynamic>>> getUserChildren() async {
    try {
      final response = await _supabase
          .from('child_details')
          .select('id, childname')
          .eq('user_id', currentUserId!);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      log('Error getting user children: $e'); 
      return [];
    }
  }

  // Helper method to convert database time string to TimeOfDay
  static TimeOfDay? parseTimeOfDay(String? timeString) {
    if (timeString == null) return null;
    
    final parts = timeString.split(':');
    if (parts.length >= 2) {
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
    return null;
  }

  // Helper method to format event data for display
  static Map<String, dynamic> formatEventForDisplay(Map<String, dynamic> event) {
    return {
      'id': event['id'],
      'child_id': event['child_id'],
      'name': event['event_name'],
      'location': event['location'],
      'date': DateTime.parse(event['event_date']),
      'time': parseTimeOfDay(event['event_time']),
      'description': event['description'],
      'is_reminder_set': event['is_reminder_set'],
      'reminder_datetime': event['reminder_datetime'] != null 
          ? DateTime.parse(event['reminder_datetime']) 
          : null,
      'is_completed': event['is_completed'],
      'created_at': DateTime.parse(event['created_at']),
      'child_name': event['child_name'],
    };
  }

  // Stream for real-time updates (because I want to)
  Stream<List<Map<String, dynamic>>> eventsStream() {
    return _supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUserId!)
        .order('event_date', ascending: true)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }
}