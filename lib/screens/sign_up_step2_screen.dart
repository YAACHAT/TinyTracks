import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignUpStep2Screen extends StatefulWidget {
  const SignUpStep2Screen({super.key});

  @override
  SignUpScreen2State createState() => SignUpScreen2State();
}

class SignUpScreen2State extends State<SignUpStep2Screen> {
  final _childNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  String? _selectedGender;
  String? _storedBirthDate; 
  File? _pickedImage;

  // Validation errors
  String? _nameError;
  String? _birthDateError;
  String? _genderError;

  // Data from previous screen
  Map<String, dynamic>? _previousData;

  final ImagePicker _picker = ImagePicker();

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
    _childNameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2020),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
        _storedBirthDate = DateFormat('yyyy-MM-dd').format(picked);
        _birthDateError = null;
      });
    }
  }

  void _selectGender() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Male', 'Female'].map((gender) {
          return ListTile(
            title: Text(gender),
            onTap: () {
              setState(() {
                _selectedGender = gender;
                _genderError = null;
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _pickedImage = File(pickedFile.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _pickedImage = File(pickedFile.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    bool isValid = true;

    if (_childNameController.text.trim().isEmpty) {
      setState(() {
        _nameError = "Child's name is required";
      });
      isValid = false;
    } else {
      setState(() {
        _nameError = null;
      });
    }

    if (_birthDateController.text.isEmpty) {
      setState(() {
        _birthDateError = "Birth date is required";
      });
      isValid = false;
    } else {
      setState(() {
        _birthDateError = null;
      });
    }

    if (_selectedGender == null) {
      setState(() {
        _genderError = "Please select a gender";
      });
      isValid = false;
    } else {
      setState(() {
        _genderError = null;
      });
    }

    return isValid;
  }

  void _proceedToNextStep() {
    if (!_validateInputs()) return;

    // Combine previous data with current screen data
    final combinedData = {
      ..._previousData ?? {},
      'childName': _childNameController.text.trim(),
      'birthDate': _storedBirthDate,
      'gender': _selectedGender,
      'hasProfileImage': _pickedImage != null,
      'profileImagePath': _pickedImage?.path, // Store the file path, not upload yet
    };

    Navigator.pushNamed(
      context, 
      '/sign-up-step3',
      arguments: combinedData,
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }

  Widget _buildInputField(
      {required TextEditingController controller,
      required String hint,
      bool readOnly = false,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2),
              blurRadius: 2,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2, 2),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF4A4947),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF4A4947),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              // Background circles
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

              // Title
              Positioned(
                top: screenHeight * 0.21,
                left: screenWidth * 0.055,
                child: Text(
                  'CHILD PROFILE',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.073,
                    color: const Color(0xFF4A4947),
                  ),
                ),
              ),

              // Form fields
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.06,
                    right: screenWidth * 0.06,
                    top: screenHeight * 0.265,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Child's name + error
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputField(
                            controller: _childNameController,
                            hint: "Child's Name",
                          ),
                          if (_nameError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 5),
                              child: Text(
                                _nameError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: _nameError != null ? screenHeight * 0.02 : screenHeight * 0.04),

                      // Birthdate + error
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              _buildInputField(
                                controller: _birthDateController,
                                hint: 'Birth Date',
                                readOnly: true,
                                onTap: _selectDate,
                              ),
                              Positioned(
                                right: 20,
                                child: GestureDetector(
                                  onTap: _selectDate,
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF4A4947),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_birthDateError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 5),
                              child: Text(
                                _birthDateError!,
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: _birthDateError != null ? screenHeight * 0.02 : screenHeight * 0.04),

                      // Gender + error
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              _buildInputField(
                                controller: TextEditingController(text: _selectedGender ?? ''),
                                hint: 'Gender',
                                readOnly: true,
                                onTap: _selectGender,
                              ),
                              Positioned(
                                right: 20,
                                child: GestureDetector(
                                  onTap: _selectGender,
                                  child: const Icon(
                                    Icons.expand_more,
                                    size: 32,
                                    color: Color(0xFF4A4947),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_genderError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 5),
                              child: Text(
                                _genderError!,
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Profile image picker
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: screenWidth * 0.3,
                          height: screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A4947),
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: _pickedImage == null
                              ? const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 24,
                                  color: Color(0xFFFFFFFF),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: SizedBox(
                                    width: screenWidth * 0.3,
                                    height: screenWidth * 0.3,
                                    child: Image.file(
                                      _pickedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),

              // Navigation buttons - Updated to match Step 1 style
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
}