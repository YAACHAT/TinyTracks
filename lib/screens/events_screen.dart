import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'notification_provider.dart';
import 'package:tiny_tracks/widgets/custom_nav_bar.dart';
import '../services/events_service.dart';

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

  final EventsService _eventsService = EventsService();
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _children = [];
  String? _selectedChildId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChildren();
    _loadEvents();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Color(0xFFB3AE9E)),
        ),
      ),
    );
  }

  Future<void> _loadChildren() async {
    final children = await _eventsService.getUserChildren();
    if (!mounted) return;
    setState(() {
      _children = children;
      if (_children.isNotEmpty) {
        _selectedChildId = _children.first['id'];
      }
    });
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    final events = await _eventsService.getUserEvents();
    if (!mounted) return;
    setState(() {
      _events = events.map((event) => EventsService.formatEventForDisplay(event)).toList();
      _isLoading = false;
    });
  }

  Future<void> _loadEventsForDate(DateTime date) async {
    final events = await _eventsService.getEventsByDate(date);
    if (!mounted) return;
    setState(() {
      _events = events.map((event) => EventsService.formatEventForDisplay(event)).toList();
    });
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _addEvent() async {
    if (_selectedDay == null ||
        _eventNameController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a date.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final eventId = await _eventsService.addEvent(
      childId: _selectedChildId,
      eventName: _eventNameController.text.trim(),
      location: _locationController.text.trim(),
      eventDate: _selectedDay!,
      eventTime: _selectedTime,
      description: _descriptionController.text.trim(),
      setReminder: true,
      reminderMinutesBefore: 60,
    );

    if (!mounted) return;

    if (eventId != null) {
      setState(() {
        _eventNameController.clear();
        _locationController.clear();
        _descriptionController.clear();
        _selectedTime = null;
        _isLoading = false;
      });

      await _loadEvents();

      if (!mounted) return;
      Provider.of<NotificationProvider>(context, listen: false).newEventAdded();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully!')),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add event. Please try again.')),
      );
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      final eventDate = event['date'] as DateTime;
      return isSameDay(eventDate, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      child: TableCalendar<Map<String, dynamic>>(
                        firstDay: DateTime.utc(2000, 1, 1),
                        lastDay: DateTime.utc(2100, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        eventLoader: _getEventsForDay,
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                          _loadEventsForDate(selectedDay);
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
                          markersMaxCount: 3,
                          markerDecoration: BoxDecoration(
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
                    const SizedBox(height: 16),
                    if (_children.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFEF8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedChildId,
                            hint: const Text('Select Child'),
                            isExpanded: true,
                            items: _children.map((child) {
                              return DropdownMenuItem<String>(
                                value: child['id'],
                                child: Text(child['childname']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedChildId = value;
                              });
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
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
                    if (_selectedDay != null) ...[
                      const SizedBox(height: 32),
                      Text(
                        'Events for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF4A4947),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._getEventsForDay(_selectedDay!).map((event) => _buildEventCard(event)),
                    ],
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const CustomNavBar(currentRoute: '/events'),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event['name'],
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF4A4947),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Color(0xFF4A4947)),
                    onPressed: () => _editEvent(event),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => _deleteEvent(event['id']),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFFB3AE9E)),
              const SizedBox(width: 4),
              Text(
                event['location'],
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color(0xFF4A4947),
                ),
              ),
            ],
          ),
          if (event['time'] != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Color(0xFFB3AE9E)),
                const SizedBox(width: 4),
                Text(
                  (event['time'] as TimeOfDay).format(context),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF4A4947),
                  ),
                ),
              ],
            ),
          ],
          if (event['child_name'] != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.child_care, size: 16, color: Color(0xFFB3AE9E)),
                const SizedBox(width: 4),
                Text(
                  event['child_name'],
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF4A4947),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text(
            event['description'],
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
          if (event['is_reminder_set']) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_active, size: 14, color: Color(0xFF4CAF50)),
                  SizedBox(width: 4),
                  Text(
                    'Reminder Set',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _editEvent(Map<String, dynamic> event) async {
    _eventNameController.text = event['name'];
    _locationController.text = event['location'];
    _descriptionController.text = event['description'];
    _selectedDay = event['date'];
    _selectedTime = event['time'];
    _selectedChildId = event['child_id'];

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Event'),
        content: const Text('Event details loaded in the form above. Make your changes and tap the add button to update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEvent(String eventId) async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _eventsService.deleteEvent(eventId);
      if (!mounted) return;
      if (success) {
        await _loadEvents();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete event')),
        );
      }
    }
  }
}