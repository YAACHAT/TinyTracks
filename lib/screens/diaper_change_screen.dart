import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiaperChangeScreen extends StatefulWidget {
  const DiaperChangeScreen({super.key});

  @override
  DiaperChangeScreenState createState() => DiaperChangeScreenState();
}

class DiaperChangeScreenState extends State<DiaperChangeScreen> {
  final TextEditingController _noteController = TextEditingController();

  void saveNote() {
    final note = _noteController.text;
    debugPrint("Saved note: $note");
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        title: const Text(
          'Diaper Change',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4947),
          ),
        ),
        backgroundColor: const Color(0xFFA8E6CF),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title text
            const Text(
              'Select poo colour and write an overall note',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xFF4A4947),
              ),
            ),
            const SizedBox(height: 24),

            // Circle Buttons for Color Selection
            GridView.builder(
              itemCount: 4, // Adjust to 4 for brown, green, yellow, black
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final colors = [
                  const Color(0xFF964B00), // brown
                  const Color(0xFF34C759), // green
                  const Color(0xFFF7DC6F), // yellow
                  const Color(0xFF000000), // black
                ];

                final colorMessages = [
                  "This is typical.",
                  "This is typical or expected.",
                  "Usually typical but if overly runny, could be a sign of diarrhea.",
                  "This is expected in the first few days of life. Not typical if it comes back later in infancy.",
                ];

                return GestureDetector(
                  onTap: () {
                    final message = colorMessages[index];
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(message),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 18, // Size of the circle button
                    backgroundColor: colors[index],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Centered Red, Grey, and White Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text("This may be from introducing red solids or something else, like blood."),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 28, 
                    backgroundColor: const Color(0xFFFF0000), // red
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text("This may be a sign of digestive concern, so call the pediatrician."),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 28, 
                    backgroundColor: const Color(0xFF808080), // grey
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text("This may indicate liver trouble, so call your pediatrician."),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 28, 
                    backgroundColor: const Color(0xFFFFFFFF), // white
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),

            // TextBox for Note
            Container(
              height: 94,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: const Color(0xFF76A198),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: SvgPicture.asset('assets/images/addT.svg', height: 18),
                  ),
                  hintText: "add note",
                  hintStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF4A4947),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Save Button
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: saveNote,
                child: SvgPicture.asset('assets/images/save.svg', height: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
