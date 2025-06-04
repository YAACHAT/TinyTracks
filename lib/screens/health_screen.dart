import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final Map<String, bool> vaccineCheck = {
    "BCG (for Tuberculosis)": false,
    "OPV (Oral Polio Vaccine)": false,
    "IPV (Inactivated Polio Vaccine)": false,
    "DPT (Diphtheria, Pertussis, Tetanus)": false,
    "Hepatitis B (Hep B)": false,
    "Measles": false,
    "Yellow Fever": false,
    "PCV (Pneumococcal Conjugate Vaccine)": false,
    "Rotavirus": false,
  };

  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController prescriptionController = TextEditingController();

  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController temperatureTimeController = TextEditingController();
  final TextEditingController temperatureDateController = TextEditingController();

  final Map<String, TextEditingController> vaccineDateControllers = {};

  @override
void initState() {
  super.initState();
  for (var vaccine in vaccineCheck.keys) {
    vaccineDateControllers[vaccine] = TextEditingController();
  }
}
@override
void dispose() {
  for (var controller in vaccineDateControllers.values) {
    controller.dispose();
  }
  super.dispose();
}

  void saveAndClear(TextEditingController controller) {
    debugPrint(controller.text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF66CCCC),
      appBar: AppBar(
        title: const Text('Health'),
        backgroundColor: const Color(0xFF66CCCC),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Immunization check",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 2),
                  SvgPicture.asset("assets/images/inject.svg", height: 20),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...vaccineCheck.keys.map((vaccine) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: vaccineCheck[vaccine],
                      onChanged: (value) {
                        setState(() {
                          vaccineCheck[vaccine] = value!;
                        });
                      },
                    ),
                    Expanded(child: Text(vaccine)),
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF478F8F),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: vaccineDateControllers[vaccine],
                        readOnly: true,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && mounted) {
                            vaccineDateControllers[vaccine]!.text = "${picked.day.toString().padLeft(2, '0')}/"
                                "${picked.month.toString().padLeft(2, '0')}/"
                                "${picked.year}";
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "when?",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )

                  ],
                ),
              );
            }),
            const SizedBox(height: 32),
            SizedBox(
              height: 241,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildHorizontalCard(
                    width,
                    "Symptoms",
                    "assets/images/symp.svg",
                    "add symptoms",
                    symptomsController,
                  ),
                  const SizedBox(width: 16),
                  buildHorizontalCard(
                    width,
                    "Doctor's visit",
                    "assets/images/doctor.svg",
                    "doctor's note",
                    doctorController,
                  ),
                  const SizedBox(width: 16),
                  buildHorizontalCard(
                    width,
                    "Prescription",
                    "assets/images/pills.svg",
                    "illness & drug(s)",
                    prescriptionController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  "Temperature",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF4A4947),
                  ),
                ),
                const SizedBox(width: 2),
                SvgPicture.asset("assets/images/temp.svg", height: 20),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                buildTempBox(width, temperatureController, "°C"),
                const SizedBox(width: 8),
                buildTempBox(width, temperatureTimeController, "00:00"),
                const SizedBox(width: 8),
                buildTempBox(width, temperatureDateController, "dd/mm/yy"),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  debugPrint(temperatureController.text);
                  debugPrint(temperatureTimeController.text);
                  debugPrint(temperatureDateController.text);
                  temperatureController.clear();
                  temperatureTimeController.clear();
                  temperatureDateController.clear();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SvgPicture.asset('assets/images/save.svg', height: 40),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHorizontalCard(double width, String title, String iconPath, String hint,
      TextEditingController controller) {
    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF4A4947),
                ),
              ),
              const SizedBox(width: 2),
              SvgPicture.asset(iconPath, height: 20),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 155,
            width: 300,
            decoration: BoxDecoration(
              color: const Color(0xFF478F8F),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: SvgPicture.asset("assets/images/addT.svg", height: 20),
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => saveAndClear(controller),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SvgPicture.asset('assets/images/save.svg', height: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget buildTempBox(double width, TextEditingController controller, String hint) {
  final isTemp = hint == "°C";
  final isTime = hint == "00:00";
  final isDate = hint == "dd/mm/yy";

  return Container(
    height: 40,
    width: 88,
    decoration: BoxDecoration(
      color: const Color(0xFFDFFFFF),
      borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              if (isDate) {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null && mounted) {
                  controller.text = "${picked.day.toString().padLeft(2, '0')}/"
                      "${picked.month.toString().padLeft(2, '0')}/"
                      "${picked.year}";
                }
              } else if (isTime) {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null && mounted) {
                  final formattedTime = picked.format(context);
                  controller.text = formattedTime;
                }
              }
            },

            child: AbsorbPointer(
              absorbing: isTime || isDate,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                ),
              ),
            ),
          ),
        ),
        if (isTemp)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  final current = double.tryParse(controller.text) ?? 0.0;
                  controller.text = (current + 0.1).toStringAsFixed(1);
                },
                child: const Icon(Icons.arrow_drop_up, size: 20),
              ),
              GestureDetector(
                onTap: () {
                  final current = double.tryParse(controller.text) ?? 0.0;
                  controller.text = (current - 0.1).toStringAsFixed(1);
                },
                child: const Icon(Icons.arrow_drop_down, size: 20),
              ),
            ],
          ),
      ],
    ),
  );
}

  }

