import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_selector/file_selector.dart';
import 'package:tiny_tracks/widgets/custom_nav_bar.dart'; 


class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

void _showExternalDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: const Color(0xFFDED4CA),
      child: SizedBox(
        width: 200,
        height: 150,
        child: Stack(
          children: [
            // Cancel Button
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: const Icon(Icons.circle, color: Color(0xFFDE1010), size: 24),
              ),
            ),

            // Open Button
            Positioned(
              left: 34,
              top: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F6FF),
                  minimumSize: const Size(136, 32),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close dialog
                  Navigator.pushNamed(context, '/external-documents');
                },
                child: const Text(
                  'open',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 24, color: Color(0xFF4A4947)),
                ),
              ),
            ),

            // Add Button
            Positioned(
              left: 34,
              top: 98,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F6FF),
                  minimumSize: const Size(136, 32),
                ),
                onPressed: () async {
                  Navigator.of(ctx).pop(); // Optional: close dialog

                  final XFile? file = await openFile();

                  if (file != null) {
                    final String path = file.path;
                    // Handle the selected file path (e.g. upload or save locally)
                    debugPrint("File picked: $path");
  } else {
    debugPrint("No file selected.");                 }
                },
                child: const Text(
                  'add',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 24, color: Color(0xFF4A4947)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget buildButton(BuildContext context, String title, {double fontSize = 13, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: 86,
        height: 88,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAF4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 4,
              left: 4,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: const Color(0xFF4A4947),
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: SvgPicture.asset('assets/images/file.svg', width: 24, height: 24),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDED4CA),
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, top: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Child Data & Documents",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFF4A4947),
              ),
            ),
            const SizedBox(height: 32),

            Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                buildButton(context, "Feeding", onTap: () => Navigator.pushNamed(context, '/feeding-documents')),
                buildButton(context, "Sleep", onTap: () => Navigator.pushNamed(context, '/sleep-documents')),
                buildButton(context, "DiaperChange", fontSize: 10, onTap: () => Navigator.pushNamed(context, '/diaper-change-documents')),
                buildButton(context, "Milestones", onTap: () => Navigator.pushNamed(context, '/milestones-documents')),
                buildButton(context, "Health", onTap: () => Navigator.pushNamed(context, '/health-documents')),
                buildButton(context, "Caregiver", onTap: () => Navigator.pushNamed(context, '/caregiver-documents')),
                buildButton(context, "Growth", onTap: () => Navigator.pushNamed(context, '/growth-documents')),
                buildButton(context, "Expense", onTap: () => Navigator.pushNamed(context, '/expense-documents')),
                buildButton(context, "Events", onTap: () => Navigator.pushNamed(context, '/events-documents')),
                buildButton(context, "External", onTap: () => _showExternalDialog(context)),
              ],
            ),

          ],
        ),
      ),

      bottomNavigationBar: const CustomNavBar(currentRoute: '/documents'),

    );
  }

}