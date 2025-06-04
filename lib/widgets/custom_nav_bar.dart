import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavBar extends StatelessWidget {
  final String currentRoute;

  const CustomNavBar({super.key, required this.currentRoute});

  Widget _buildIcon(BuildContext context, String route, Widget iconWidget) {
    final bool isActive = ModalRoute.of(context)?.settings.name == route || currentRoute == route;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: isActive
            ? BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.7),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(74, 30, 89, 1),                  
                      blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              )
            : null,
        padding: const EdgeInsets.all(8),
        child: iconWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: const Color(0xFFF3F3F3),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIcon(
            context,
            '/home',
            const Icon(Icons.home, size: 24, color: Color(0xFF4A4947)),
          ),
          _buildIcon(
            context,
            '/budgeting',
            SvgPicture.asset('assets/images/naira.svg', height: 24),
          ),
          _buildIcon(
            context,
            '/events',
            const Icon(Icons.event, size: 24, color: Color(0xFF4A4947)),
          ),
          _buildIcon(
            context,
            '/documents',
            SvgPicture.asset('assets/images/document.svg', height: 24),
          ),
        ],
      ),
    );
  }
}
