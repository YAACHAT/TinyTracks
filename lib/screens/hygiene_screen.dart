import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HygieneScreen extends StatefulWidget {
  const HygieneScreen({super.key});

  @override
  State<HygieneScreen> createState() => _HygieneScreenState();
}

class _HygieneScreenState extends State<HygieneScreen> {
  TimeOfDay? bathTime;
  TimeOfDay? nailTime;
  DateTime? nailDate;
  TimeOfDay? cutTime;
  DateTime? cutDate;
  TimeOfDay? makeTime;
  DateTime? makeDate;

  bool bathReminder = false;
  bool nailReminder = false;
  bool cutReminder = false;
  bool makeReminder = false;

  Future<void> _selectTime(Function(TimeOfDay) onSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) onSelected(picked);
  }

  Future<void> _selectDate(Function(DateTime) onSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) onSelected(picked);
  }

  Widget buildReminderRow({
    required String iconPath,
    required String title,
    Widget? timeButton,
    Widget? dateButton,
    required bool switchValue,
    required Function(bool) onSwitchChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(iconPath, height: 32),
            const SizedBox(width: 32),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF4A4947),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (timeButton != null) timeButton,
            if (timeButton != null && dateButton != null) const SizedBox(width: 24),
            if (dateButton != null) dateButton,
            const Spacer(),
            GestureDetector(
              onTap: () => onSwitchChanged(!switchValue),
              child: Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: switchValue ? const Color(0xFFA5C9D4) : const Color(0xFFD9D9D9),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: switchValue ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTimeButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 70,
      height: 32,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFAAAAAA),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Color(0xFF4A4947),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Hygiene',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4947),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bath Time
            buildReminderRow(
              iconPath: 'assets/images/bath.svg',
              title: 'Bath Time',
              
              timeButton: buildTimeButton(
                bathTime != null ? bathTime!.format(context) : '00:00',
                () => _selectTime((time) => setState(() => bathTime = time)),
              ),
              switchValue: bathReminder,
              onSwitchChanged: (val) => setState(() => bathReminder = val),
            ),
            const SizedBox(height: 48),

            // Nail Trimming
            buildReminderRow(
              iconPath: 'assets/images/nail.svg',
              title: 'Nail Trimming',
              timeButton: buildTimeButton(
                nailTime != null ? nailTime!.format(context) : '00:00',
                () => _selectTime((time) => setState(() => nailTime = time)),
              ),
              dateButton: buildTimeButton(
                nailDate != null ? DateFormat('dd/MM/yy').format(nailDate!) : 'dd/mm/yy',
                () => _selectDate((date) => setState(() => nailDate = date)),
              ),
              switchValue: nailReminder,
              onSwitchChanged: (val) => setState(() => nailReminder = val),
            ),
            const SizedBox(height: 48),

            // Hair Cut
            buildReminderRow(
              iconPath: 'assets/images/cut.svg',
              title: 'Hair Cut',
              timeButton: buildTimeButton(
                cutTime != null ? cutTime!.format(context) : '00:00',
                () => _selectTime((time) => setState(() => cutTime = time)),
              ),
              dateButton: buildTimeButton(
                cutDate != null ? DateFormat('dd/MM/yy').format(cutDate!) : 'dd/mm/yy',
                () => _selectDate((date) => setState(() => cutDate = date)),
              ),
              switchValue: cutReminder,
              onSwitchChanged: (val) => setState(() => cutReminder = val),
            ),
            const SizedBox(height: 48),

            // Hair Making
            buildReminderRow(
              iconPath: 'assets/images/make.svg',
              title: 'Hair Making',
              timeButton: buildTimeButton(
                makeTime != null ? makeTime!.format(context) : '00:00',
                () => _selectTime((time) => setState(() => makeTime = time)),
              ),
              dateButton: buildTimeButton(
                makeDate != null ? DateFormat('dd/MM/yy').format(makeDate!) : 'dd/mm/yy',
                () => _selectDate((date) => setState(() => makeDate = date)),
              ),
              switchValue: makeReminder,
              onSwitchChanged: (val) => setState(() => makeReminder = val),
            ),
          ],
        ),
      ),
    );
  }
}
