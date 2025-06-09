import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

class BudgetingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<String?> createBudget({
    required String totalAllocation,
    required List<Map<String, String>> expenseList,
    required Set<String> selectedCategories,
    required String totalExpenses,
    required String leftToSpend,
  }) async {
    try {
      final response = await _supabase.from('budgets').insert({
        'user_id': currentUserId,
        'total_allocation': double.parse(totalAllocation),
        'total_expenses': double.parse(totalExpenses.replaceAll('₦', '')),
        'left_to_spend': double.parse(leftToSpend.replaceAll('₦', '')),
        'selected_categories': selectedCategories.toList(),
        'expense_list': expenseList,
        'created_at': DateTime.now().toIso8601String(),
        'is_active': true,
      }).select('id').single();

      return response['id'];
    } catch (e) {
      log('Error creating budget: $e');
      return null;
    }
  }

    Future<Map<String, dynamic>?> getLatestBudget() async {
    try {
      final response = await _supabase
          .from('budgets')
          .select()
          .eq('user_id', currentUserId!)
          .eq('is_active', true)
          .order('created_at', ascending: false)
          .limit(1)
          .single();
      
      return response; 
    } catch (e) {
      log('Error getting latest budget: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUserBudgets() async {
    try {
      final response = await _supabase
          .from('budgets')
          .select()
          .eq('user_id', currentUserId!)
          .eq('is_active', true)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      log('Error getting user budgets: $e');
      return [];
    }
  }

  Future<bool> updateBudget({
    required String budgetId,
    required String totalAllocation,
    required List<Map<String, String>> expenseList,
    required Set<String> selectedCategories,
    required String totalExpenses,
    required String leftToSpend,
  }) async {
    try {
      await _supabase.from('budgets').update({
        'total_allocation': double.parse(totalAllocation),
        'total_expenses': double.parse(totalExpenses.replaceAll('₦', '')),
        'left_to_spend': double.parse(leftToSpend.replaceAll('₦', '')),
        'selected_categories': selectedCategories.toList(),
        'expense_list': expenseList,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', budgetId);

      return true;
    } catch (e) {
      log('Error updating budget: $e');
      return false;
    }
  }

  Future<bool> deleteBudget(String budgetId) async {
    try {
      // Soft delete by setting is_active to false
      await _supabase.from('budgets').update({
        'is_active': false,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', budgetId);
      
      return true;
    } catch (e) {
      log('Error deleting budget: $e');
      return false;
    }
  }

  // Helper method to calculate total expenses
  String calculateTotalExpenses(List<Map<String, String>> expenseList) {
    double total = 0;
    for (var expense in expenseList) {
      total += double.tryParse(expense['amount'] ?? '0') ?? 0;
    }
    return total.toStringAsFixed(2);
  }

  // Helper method to calculate left to spend
  String calculateLeftToSpend(String totalAllocation, String totalExpenses) {
    final total = double.tryParse(totalAllocation) ?? 0;
    final expenses = double.tryParse(totalExpenses.replaceAll('₦', '')) ?? 0;
    return (total - expenses).toStringAsFixed(2);
  }
}