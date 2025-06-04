import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/database_service.dart';

class FeedingScreen extends StatefulWidget {
  const FeedingScreen({super.key});

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  final _allergyController = TextEditingController();
  final _favouritesController = TextEditingController();
  final _specialNeedsController = TextEditingController();

  final Set<String> selectedRestrictions = {};
  final DatabaseService _db = DatabaseService();

  final List<String> restrictionOptions = [
    'vegetarian',
    'high-sugar',
    'canned foods',
    'caffeine',
    'raw foods',
    'high-fat',
  ];

void saveText(String label, TextEditingController controller) async {
  final text = controller.text.trim();
  if (text.isNotEmpty) {
    debugPrint("Saved $label: $text");

    try { 
      await _db.saveFeedingRecord(
        foodAllergies: label == 'allergy' ? text : null,
        favourites: label == 'favourite' ? text : null,
        specialNeeds: label == 'special needs' ? text : null,
        dietaryRestrictions: [], // Not  restrictions
      );
      debugPrint('Saved $label to feeding_records');
    } catch (e) {
      debugPrint('Failed to save $label to DB: $e');
    }

    controller.clear();
  }
}


  void toggleRestriction(String option) {
    setState(() {
      if (selectedRestrictions.contains(option)) {
        selectedRestrictions.remove(option);
      } else {
        selectedRestrictions.add(option);
      }
    });
    debugPrint('Selected restrictions: $selectedRestrictions');
  }

  @override
  void dispose() {
    _allergyController.dispose();
    _favouritesController.dispose();
    _specialNeedsController.dispose();
    super.dispose();
  }

  Widget buildInputSection({
    required String title,
    required String iconPath,
    required TextEditingController controller,
    required VoidCallback onSave,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(iconPath, height: 32),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF4A4947),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 282,
              height: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFB3AC6B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/images/addT.svg'),
                      const SizedBox(width: 6),
                      const Text(
                        'add food',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF4A4947),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: onSave,
              child: SvgPicture.asset('assets/images/save.svg', height: 40),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

 Widget buildRestrictionsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Title with icon
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset('assets/images/restrictions.svg', height: 32),
          const SizedBox(width: 8),
          const Text(
            'Dietary Restrictions',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF4A4947),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),

      // Option Buttons
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: restrictionOptions.map((option) {
          final selected = selectedRestrictions.contains(option);
          return GestureDetector(
            onTap: () => toggleRestriction(option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDE6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected ? const Color(0xFF4A4947) : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Text(
                option,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4947),
                ),
              ),
            ),
          );
        }).toList(),
      ),

      const SizedBox(height: 4),

      // Apply Button
      if (selectedRestrictions.isNotEmpty)
        SizedBox(
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFb39e6b),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          onPressed: () async {
            debugPrint('Applied restrictions: $selectedRestrictions');

            try {
              await _db.saveFeedingRecord(
                dietaryRestrictions: selectedRestrictions.toList(),
              );
              debugPrint('Dietary restrictions saved to DB');
            } catch (e) {
              debugPrint('Failed to save dietary restrictions: $e');
            }

            setState(() => selectedRestrictions.clear());
          },

            child: const Text(
              'Apply',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEB99),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFEB99),
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'Feeding',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A4947),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildInputSection(
              title: 'Food Allergies',
              iconPath: 'assets/images/allegy.svg',
              controller: _allergyController,
              onSave: () => saveText('allergy', _allergyController),
            ),
            buildInputSection(
              title: 'Favourites',
              iconPath: 'assets/images/fav.svg',
              controller: _favouritesController,
              onSave: () => saveText('favourite', _favouritesController),
            ),
            buildInputSection(
              title: 'Special Needs',
              iconPath: 'assets/images/special.svg',
              controller: _specialNeedsController,
              onSave: () => saveText('special needs', _specialNeedsController),
            ),
            buildRestrictionsSection(),
          ],
        ),
      ),
    );
  }
}
