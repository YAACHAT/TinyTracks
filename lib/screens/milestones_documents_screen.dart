import 'package:flutter/material.dart';

class MilestonesDocumentScreen extends StatelessWidget {
  const MilestonesDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDED4CA),
        elevation: 0,
        title: const Text(
          'Milestones Document',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4947),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A4947)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'This is the Milestones Document Screen',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            color: Color(0xFF4A4947),
          ),
        ),
      ),
    );
  }
}
