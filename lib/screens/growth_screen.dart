import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _hcController = TextEditingController();
  String selectedDate = 'dd/mm/yy';

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yy').format(picked);
      });
    }
  }

  void _save() {
    debugPrint("Weight: ${_weightController.text}");
    debugPrint("Height: ${_heightController.text}");
    debugPrint("HC: ${_hcController.text}");
    debugPrint("Date: $selectedDate");

    _weightController.clear();
    _heightController.clear();
    _hcController.clear();
    setState(() {
      selectedDate = 'dd/mm/yy';
    });
  }

  Widget _buildInputField({
    required String iconPath,
    required String label,
    required TextEditingController controller,
    required String suffix,
  }) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: SvgPicture.asset(iconPath, height: 24),
        ),
        const SizedBox(width: 8),
        Container(
          width: 166,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE5CC),
            borderRadius: BorderRadius.circular(45),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF4A4947),
                ),
                suffixText: suffix,
                suffixStyle: const TextStyle(color: Color(0xFF4A4947)),
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
      backgroundColor: const Color(0xFFFFC499),
      appBar: AppBar(
        title: const Text('Growth'),
        backgroundColor: const Color(0xFFFFC499),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
              iconPath: 'assets/images/weight.svg',
              label: 'Weight :',
              controller: _weightController,
              suffix: 'kg',
            ),
            const SizedBox(height: 56),
            _buildInputField(
              iconPath: 'assets/images/height.svg',
              label: 'Height :',
              controller: _heightController,
              suffix: 'cm',
            ),
            const SizedBox(height: 56),
            _buildInputField(
              iconPath: 'assets/images/HC.svg',
              label: 'HC :',
              controller: _hcController,
              suffix: 'cm',
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  width: 166,
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFb38e6b),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: _pickDate,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedDate,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF4A4947),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _save,
                  child: SvgPicture.asset('assets/images/save.svg', height: 40),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
