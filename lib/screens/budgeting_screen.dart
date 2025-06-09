import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiny_tracks/widgets/custom_nav_bar.dart';
import '../services/budgeting_service.dart';
import '../services/storage_service.dart'; 

class BudgetingScreen extends StatefulWidget {
  const BudgetingScreen({super.key});

  @override
  State<BudgetingScreen> createState() => _BudgetingScreenState();
}

class _BudgetingScreenState extends State<BudgetingScreen> {
  final TextEditingController totalAllocationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

double get totalExpenses => double.tryParse(_calculateExpenses().replaceAll('₦', '')) ?? 0;
double get totalAllocation => double.tryParse(totalAllocationController.text) ?? 0;
double get leftToSpend => totalAllocation - totalExpenses;
bool get isBudgetExhausted => leftToSpend <= 0;
 
final BudgetingService _budgetingService = BudgetingService();
final StorageService _storageService = StorageService();

  List<Map<String, String>> expenses = [];
  Set<String> selectedCategories = {}; 

void addExpense() {
  final name = nameController.text.trim();
  final amount = amountController.text.trim();
  
  if (name.isEmpty || amount.isEmpty) return;

  final expenseAmount = double.tryParse(amount) ?? 0;
  
  // Check if adding this expense would exceed the budget
  if (totalExpenses + expenseAmount > totalAllocation) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cannot add expense: Would exceed total allocation'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  if (totalAllocation <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please set a total allocation first'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() {
    expenses.add({'name': name, 'amount': amount});
    nameController.clear();
    amountController.clear();
  });
}

  void removeExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
  }

@override
void initState() {
  super.initState();
  _loadSavedData();
}

Future<void> _loadSavedData() async {
  try {
    // First 
    final savedAllocation = await _storageService.getTotalAllocation();
    final savedExpenses = await _storageService.getExpensesList();
    final savedCategories = await _storageService.getSelectedCategories();

    // budget from database
    final latestBudget = await _budgetingService.getLatestBudget();

    if (!mounted) return;

    setState(() {
      // database values if they exist
      if (latestBudget != null) {
        totalAllocationController.text = latestBudget['total_allocation'].toString();
        expenses = List<Map<String, String>>.from(latestBudget['expense_list']);
        selectedCategories = Set<String>.from(latestBudget['selected_categories']);
      } else if (savedAllocation != null) {
        // local storage
        totalAllocationController.text = savedAllocation;
        expenses = savedExpenses;
        selectedCategories = savedCategories;
      }
    });
  } catch (e) {
    debugPrint('Error loading saved data: $e');
  }
}

@override
void dispose() {
  totalAllocationController.dispose();
  nameController.dispose();
  amountController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEAE1FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Budget',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(width: 2),
                  SvgPicture.asset('assets/images/piggy.svg', height: 32),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                height: screenHeight * 0.3,
                width: screenWidth, 
                decoration: BoxDecoration(
                  color: const Color(0xFFf3f2ff),
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(color: const Color.fromARGB(0, 0, 0, 0)),
                ),
                child: Row(
                  children: [
                    _buildBoardSection(0),
                    _buildDivider(),
                    _buildBoardSection(1),
                    _buildDivider(),
                    _buildBoardSection(2),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                color: const Color(0xFFEAE1FF),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expense Category',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Childcare Services',
                        'Basic Needs',
                        'Healthcare',
                        'Education',
                        'Entertainment',
                        'Transportation',
                        'Extracurriculars',
                        'Home Essentials',
                      ].map((category) {
                        final isSelected = selectedCategories.contains(category);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedCategories.remove(category);
                              } else {
                                selectedCategories.add(category);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA1A0B3),
                              borderRadius: BorderRadius.circular(30),
                              border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                            ),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Expense and Amount',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(nameController, 'Enter name'),
              const SizedBox(height: 8),
              _buildInputField(amountController, 'Enter amount', isNumeric: true),
              const SizedBox(height: 12),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/addB.svg',
                  height: 40,
                  colorFilter: isBudgetExhausted 
                      ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                      : null,
                ),
                onPressed: isBudgetExhausted ? null : addExpense,
              ),
              const SizedBox(height: 16),
              const Text(
                'Expense List',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(minHeight: 188),
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFf3f2ff),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: expenses.isEmpty
                    ? const Text(
                        'No expenses yet.',
                        style: TextStyle(fontFamily: 'Poppins'),
                      )
                    : Column(
                        children: expenses.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return ListTile(
                            title: Text(
                              item['name'] ?? '',
                              style: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            subtitle: Text(
                              '₦${item['amount']}',
                              style: const TextStyle(fontFamily: 'Poppins'),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => removeExpense(index),
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: SvgPicture.asset('assets/images/save.svg', height: 40),
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  
                  final totalAlloc = totalAllocationController.text;
                  if (totalAlloc.isEmpty) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Please enter total allocation')),
                    );
                    return;
                  }

                  if (selectedCategories.isEmpty) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Please select at least one category')),
                    );
                    return;
                  }

                  try {
                    // Save current values to storage
                    await _storageService.saveBudgetData(
                      totalAllocation: totalAlloc,
                      expenses: expenses,
                      categories: selectedCategories,
                    );

                    // Save to database
                    final budgetId = await _budgetingService.createBudget(
                      totalAllocation: totalAlloc,
                      expenseList: expenses,
                      selectedCategories: selectedCategories,
                      totalExpenses: _calculateExpenses(),
                      leftToSpend: _calculateLeftToSpend(),
                    );

                    if (!mounted) return;

                    if (budgetId != null) {
                      setState(() {
                        expenses.clear();
                        selectedCategories.clear();
                      });

                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Budget saved successfully!')),
                      );
                    } else {
                      throw Exception('Failed to save budget');
                    }
                  } catch (e) {
                    if (!mounted) return;
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Failed to save budget. Please try again.')),
                    );
                  }
                },
                  tooltip: 'Save Budget',
                ),
              ),
            ],
          ),
        ),
      ),

        bottomNavigationBar: const CustomNavBar(currentRoute: '/budgeting'),

    );
  }

  Widget _buildInputField(TextEditingController controller, String hint,
      {bool isNumeric = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2FF),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _calculateExpenses() {
    double total = 0;
    for (var item in expenses) {
      final value = double.tryParse(item['amount'] ?? '') ?? 0;
      total += value;
    }
    return '₦${total.toStringAsFixed(2)}';
  }

  String _calculateLeftToSpend() {
    final totalAlloc = double.tryParse(totalAllocationController.text) ?? 0;
    final spent = double.tryParse(_calculateExpenses().replaceAll('₦', '')) ?? 0;
    return '₦${(totalAlloc - spent).toStringAsFixed(2)}';
  }

Widget _buildBoardSection(int index) {
  final titles = ['Total Allocation', 'Expenses', 'Left to spend'];
  final values = [
    totalAllocation.toStringAsFixed(2),
    totalExpenses.toStringAsFixed(2),
    leftToSpend.toStringAsFixed(2)
  ];

  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          titles[index],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        SvgPicture.asset('assets/images/naira2.svg', height: 24),
        const SizedBox(height: 8),
        Container(
          width: 98,
          height: 29,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color.fromARGB(255, 80, 79, 79)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: index == 0
                ? TextField(
                    controller: totalAllocationController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      height: 1.2,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) => setState(() {}), // Trigger rebuild on change
                  )
                : Text(
                    '₦${values[index]}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: index == 2 && leftToSpend <= 0 ? Colors.red : null,
                    ),
                  ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildDivider() {
    return Container(
      width: 2,
      height: double.infinity,
      color: Colors.black12,
    );
  }
}
