import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'notification_provider.dart';
import 'package:tiny_tracks/widgets/custom_nav_bar.dart'; 

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<Map<String, dynamic>> _events = [];

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addEvent() {
    if (_selectedDay == null ||
        _eventNameController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a date.')),
      );
      return;
    }

    final newEvent = {
      'date': _selectedDay,
      'name': _eventNameController.text.trim(),
      'location': _locationController.text.trim(),
      'description': _descriptionController.text.trim(),
      'time': _selectedTime?.format(context) ?? 'No time selected',
    };

    setState(() {
      _events.add(newEvent);
      _eventNameController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _selectedTime = null;
    });

    // Trigger notification after adding event
    Provider.of<NotificationProvider>(context, listen: false).newEventAdded();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event added successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 81.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Child's Events",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color(0xFF4A4947),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.calendar_today, color: Color(0xFF4A4947)),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCF0),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color(0xFFBCAC9E),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF4A4947),
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(color: Color(0xFF4A4947)),
                    defaultTextStyle: TextStyle(color: Color(0xFF4A4947)),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF4A4947),
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF4A4947)),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF4A4947)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Consumer<NotificationProvider>(
                builder: (context, notifier, child) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.notifications, size: 32, color: Color(0xFF4A4947)),
                        if (notifier.hasNewEvent)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.event, size: 29, color: Color(0xFFB3AE9E)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      children: [
                        _buildInputField(
                          controller: _eventNameController,
                          hintText: "Event Name :",
                        ),
                        const SizedBox(height: 8),
                        _buildInputField(
                          controller: _locationController,
                          hintText: "Location :",
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickTime,
                          child: AbsorbPointer(
                            child: _buildInputField(
                              controller: TextEditingController(
                                text: _selectedTime != null
                                    ? _selectedTime!.format(context)
                                    : "",
                              ),
                              hintText: "Time :",
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInputField(
                          controller: _descriptionController,
                          hintText: "Description",
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A4947),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addEvent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const CustomNavBar(currentRoute: '/events'),    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF4A4947),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        fillColor: const Color(0xFFFFFEF8),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
