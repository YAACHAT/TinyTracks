import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  // Budget related keys
  static const String _totalAllocationKey = 'total_allocation';
  static const String _expensesListKey = 'expenses_list';
  static const String _selectedCategoriesKey = 'selected_categories';
  static const String _lastUpdatedKey = 'last_updated';

  // Save budget-related data
  Future<void> saveBudgetData({
    required String totalAllocation,
    required List<Map<String, String>> expenses,
    required Set<String> categories,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_totalAllocationKey, totalAllocation);
    await prefs.setString(_expensesListKey, json.encode(expenses));
    await prefs.setStringList(_selectedCategoriesKey, categories.toList());
    await prefs.setString(_lastUpdatedKey, DateTime.now().toIso8601String());
  }

  // Get total allocation
  Future<String?> getTotalAllocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_totalAllocationKey);
  }

  // Get expenses list
  Future<List<Map<String, String>>> getExpensesList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesJson = prefs.getString(_expensesListKey);
    if (expensesJson != null) {
      final List<dynamic> decoded = json.decode(expensesJson);
      return decoded.map((e) => Map<String, String>.from(e)).toList();
    }
    return [];
  }

  // Get selected categories
  Future<Set<String>> getSelectedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? categories = prefs.getStringList(_selectedCategoriesKey);
    return categories?.toSet() ?? {};
  }

  // Clear all budget data
  Future<void> clearBudgetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_totalAllocationKey);
    await prefs.remove(_expensesListKey);
    await prefs.remove(_selectedCategoriesKey);
    await prefs.remove(_lastUpdatedKey);
  }
}