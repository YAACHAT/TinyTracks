import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CaregiverScreen extends StatefulWidget {
  const CaregiverScreen({super.key});

  @override
  State<CaregiverScreen> createState() => _CaregiverScreenState();
}

class _CaregiverScreenState extends State<CaregiverScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _payController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void saveCaregiverInfo() {
    debugPrint("Name: ${_nameController.text}");
    debugPrint("Address: ${_addressController.text}");
    debugPrint("Phone: ${_phoneController.text}");
    debugPrint("Email: ${_emailController.text}");
    debugPrint("Date: ${_dateController.text}");
    debugPrint("Pay/hr: ${_payController.text}");

    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
    _payController.clear();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
    bool isReadOnly = false,
    Widget? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label${isOptional ? ' (optional)' : ''}",
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF4A4947),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 32,
          width: 250,
          decoration: BoxDecoration(
            color: const Color(0xFF938462),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            readOnly: isReadOnly,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: prefix,
              prefixText: prefix != null ? null : '',
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2B48C),
      appBar: AppBar(
        title: const Text(
          'Caregiver',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4947),
          ),
        ),
        backgroundColor: const Color(0xFFD2B48C),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset('assets/images/care.svg', height: 32),
            ),
            // Fields
            buildTextField(label: "Name", controller: _nameController),
            const SizedBox(height: 24),
            buildTextField(label: "Address", controller: _addressController),
            const SizedBox(height: 24),
            buildTextField(
              label: "Phone",
              controller: _phoneController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            buildTextField(label: "Email", controller: _emailController),
            const SizedBox(height: 24),
            buildTextField(
              label: "Date",
              controller: _dateController,
              isReadOnly: true,
            ),
            const SizedBox(height: 24),
            buildTextField(
              label: "Pay/hr",
              controller: _payController,
              keyboardType: TextInputType.number,
              isOptional: true,
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  "₦",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: saveCaregiverInfo,
                child: SvgPicture.asset('assets/images/save.svg', height: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
