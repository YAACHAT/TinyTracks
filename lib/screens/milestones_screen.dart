import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MilestonesScreen extends StatefulWidget {
  const MilestonesScreen({super.key});

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> with SingleTickerProviderStateMixin {
  String? selectedMilestone;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool showInputFields = false;

  final List<String> milestones = [
    "Sitting",
    "Crawling",
    "Talking",
    "Walking",
    "Imitation",
    "First School Day(s)"
  ];

  void onMilestoneTap(String milestone) {
    setState(() {
      selectedMilestone = milestone;
      showInputFields = true;
    });
  }

  void saveMilestone() {
    debugPrint("Milestone: $selectedMilestone");
    debugPrint("Date: ${_dateController.text}");
    debugPrint("Note: ${_noteController.text}");
    _noteController.clear();
    _dateController.clear();
    setState(() {
      showInputFields = false;
      selectedMilestone = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB6C1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB6C1),
        elevation: 0,
        title: const Text(
          'Milestones',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4947),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: milestones.map((milestone) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB37F8C),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: selectedMilestone == milestone ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  onPressed: () => onMilestoneTap(milestone), //existing function to handle tap
                  child: Text(
                    milestone,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF4A4947),
                    ),
                  ),
                );

              }).toList(),
            ),

            const SizedBox(height: 48),

            AnimatedSlide(
              offset: showInputFields ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 200),
              child: showInputFields
                  ? Column(
                      children: [
                       Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFffdbe4),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: TextField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            hintText: 'Enter date',
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFffdbe4),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: TextField(
                            controller: _noteController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Enter note',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: saveMilestone,
                            child: SvgPicture.asset('assets/images/save.svg', height: 40),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
