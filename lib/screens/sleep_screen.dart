import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  late Timer _timer;
  int _seconds = 0;
  bool _isRunning = false;
  final TextEditingController _noteController = TextEditingController();

  String get _formattedTime {
    final hours = (_seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = (_seconds ~/ 60 % 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _startTimer() {
    if (!_isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _seconds++;
        });
      });
      setState(() {
        _isRunning = true;
      });
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _seconds = 0;
    });
  }

  void _saveNote() {
    debugPrint('Saved Note: ${_noteController.text}');
    _noteController.clear();
  }

  @override
  void dispose() {
    if (_isRunning) _timer.cancel();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8D0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8D0E6),
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'Sleep',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A4947),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // icon and timer
            Row(
              children: [
                SvgPicture.asset('assets/images/sleep2.svg'),
                const SizedBox(width: 32),
                Text(
                  _formattedTime,
                  style: const TextStyle(
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A4947),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Timer buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton('Start', _startTimer),
                const SizedBox(width: 12),
                _buildControlButton('Stop', _stopTimer),
                const SizedBox(width: 12),
                _buildControlButton('Reset', _resetTimer),
              ],
            ),
            const SizedBox(height: 40),

            // Note box
            Center(
              child: Container(
                width: 357,
                height: 135,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _noteController,
                  maxLines: null,
                  style: const TextStyle(color: Color(0xFF4A4947)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset('assets/images/addT.svg'),
                        const SizedBox(width: 6),
                        const Text(
                          'add note',
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
            ),

            const SizedBox(height: 16),

            // Save button
            const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _saveNote,
                  child: SvgPicture.asset('assets/images/save.svg', height: 40),
                ),
              ),

          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF7698A1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Color(0xFF4A4947),
          ),
        ),
      ),
    );
  }
}
