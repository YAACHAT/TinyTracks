import 'package:flutter/material.dart';

class ExternalDocumentScreen extends StatelessWidget {
  const ExternalDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF4),
      appBar: AppBar(
      
        title: const Text(
          'External Documents',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF4A4947),
          ),
        ),
        backgroundColor: const Color(0xFFDED4CA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A4947)),
      ),
      body: const Center(
        child: Text(
          'No external documents yet.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFF4A4947),
          ),
        ),
      ),
    );
  }
}
