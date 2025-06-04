import 'package:flutter/material.dart';

class SignUpStep3Screen extends StatefulWidget {
  const SignUpStep3Screen({super.key});

  @override
  State<SignUpStep3Screen> createState() => _SignUpStep3ScreenState();
}

class _SignUpStep3ScreenState extends State<SignUpStep3Screen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _hcController = TextEditingController();

  String? selectedGenotype;
  String? selectedBloodGroup;

  Map<String, dynamic>? _previousData;

  String? _weightError;
  String? _heightError;
  String? _hcError;

  final List<String> genotypes = ['AA', 'AS', 'SS', 'AC', 'SC'];
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _previousData = Map<String, dynamic>.from(args);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _hcController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    bool isValid = true;

    if (_weightController.text.isNotEmpty) {
      double? weight = double.tryParse(_weightController.text);
      if (weight == null || weight <= 0 || weight > 100) {
        _weightError = "Enter valid weight (0-100kg)";
        isValid = false;
      } else {
        _weightError = null;
      }
    }

    if (_heightController.text.isNotEmpty) {
      double? height = double.tryParse(_heightController.text);
      if (height == null || height <= 0 || height > 200) {
        _heightError = "Enter valid height (0-200cm)";
        isValid = false;
      } else {
        _heightError = null;
      }
    }

    if (_hcController.text.isNotEmpty) {
      double? hc = double.tryParse(_hcController.text);
      if (hc == null || hc <= 0 || hc > 100) {
        _hcError = "Enter valid HC (0-100cm)";
        isValid = false;
      } else {
        _hcError = null;
      }
    }

    setState(() {});
    return isValid;
  }

  void _proceedToNextStep() {
    if (_validateInputs()) {
      // Combine all previous data with current screen data
      final combinedData = {
        ..._previousData ?? {},
        'weight': _weightController.text.isEmpty ? null : double.tryParse(_weightController.text),
        'height': _heightController.text.isEmpty ? null : double.tryParse(_heightController.text),
        'headCircumference': _hcController.text.isEmpty ? null : double.tryParse(_hcController.text),
        'genotype': selectedGenotype,
        'bloodGroup': selectedBloodGroup,
      };

      Navigator.pushNamed(
        context,
        '/sign-up-step4',
        arguments: combinedData,
      );
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              // Background Circles
              Positioned(
                left: -screenWidth * 0.4,
                top: -screenHeight * 0.16,
                child: Container(
                  width: screenWidth * 0.73,
                  height: screenWidth * 0.73,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDFC2FF),
                  ),
                ),
              ),
              Positioned(
                left: screenWidth * 0.72,
                top: -screenHeight * 0.11,
                child: Container(
                  width: screenWidth * 0.73,
                  height: screenWidth * 0.73,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEBD8D0),
                  ),
                ),
              ),

              // Titles
              Positioned(
                top: screenHeight * 0.19,
                left: screenWidth * 0.055,
                child: Text(
                  'HEALTH METRICS',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.073,
                    color: const Color(0xFF4A4947),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.25,
                left: screenWidth * 0.055,
                child: Text(
                  'Health and growth information',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[700],
                  ),
                ),
              ),

              // Left Column Inputs
              Positioned(
                top: screenHeight * 0.32,
                left: screenWidth * 0.055,
                child: Column(
                  children: [
                    _buildInputFieldWithError(
                      controller: _weightController,
                      label: "Weight (kg)",
                      error: _weightError,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: screenHeight * 0.09),
                    _buildInputFieldWithError(
                      controller: _hcController,
                      label: "HC (cm)",
                      error: _hcError,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: screenHeight * 0.09),
                    _buildDropdown(
                      label: 'Blood G',
                      value: selectedBloodGroup,
                      items: bloodGroups,
                      onChanged: (val) {
                        setState(() {
                          selectedBloodGroup = val;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Right Column Inputs
              Positioned(
                top: screenHeight * 0.41,
                left: screenWidth * 0.55,
                child: Column(
                  children: [
                    _buildInputFieldWithError(
                      controller: _heightController,
                      label: "Height (cm)",
                      error: _heightError,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: screenHeight * 0.09),
                    _buildDropdown(
                      label: 'Genotype',
                      value: selectedGenotype,
                      items: genotypes,
                      onChanged: (val) {
                        setState(() {
                          selectedGenotype = val;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Navigation Buttons - Updated to match Step 1 style
              Positioned(
                bottom: screenHeight * 0.1,
                left: screenWidth * 0.01,
                child: IconButton(
                  icon: Transform.rotate(
                    angle: 3.14159, // Rotate 180 degrees 
                    child: const Icon(
                      Icons.double_arrow,
                      size: 50, 
                      color: Color(0xFF4A4947), 
                    ),
                  ),
                  onPressed: _goBack,
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.1,
                left: screenWidth * 0.8,
                child: IconButton(
                  icon: const Icon(
                    Icons.double_arrow, 
                    size: 50, 
                    color: Color(0xFF4A4947), 
                  ),
                  onPressed: _proceedToNextStep,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFieldWithError({
    required TextEditingController controller,
    required String label,
    String? error,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(color: Colors.white, offset: Offset(-2, -2), blurRadius: 2),
              BoxShadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 2),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 20, fontFamily: 'Poppins', color: Color(0xFF4A4947)),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(fontSize: 20, fontFamily: 'Poppins', color: Color(0xFF4A4947)),
              border: InputBorder.none,
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      width: 150,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.white, offset: Offset(-2, -2), blurRadius: 2),
          BoxShadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 2),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        isExpanded: true,
        hint: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Color(0xFF4A4947))),
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Color(0xFF4A4947)),
        dropdownColor: const Color(0xFFD9D9D9),
        iconEnabledColor: const Color(0xFF4A4947),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}