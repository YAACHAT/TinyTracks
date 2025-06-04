import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> showItemDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Color(0xFFDED4CA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Share and Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/images/share.svg',
                  width: 24,
                  height: 24,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 14,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Content or Title (Optional)
            Text(
              "What would you like to do?",
              style: TextStyle(
                color: Color(0xFF4A4947),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            // Buttons: View & Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DialogActionButton(
                  label: "View",
                  onPressed: () {
                    // handle view logic
                    Navigator.of(context).pop();
                  },
                ),
                _DialogActionButton(
                  label: "Delete",
                  onPressed: () {
                    // handle delete logic
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}

class _DialogActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _DialogActionButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFF5F6FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: Color(0xFF4A4947),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
