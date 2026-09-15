import 'package:flutter/material.dart';

/// Indicador dinámico y animado de puntos (dots) para la página activa del carrusel.
class PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;

  const PageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor = const Color(0xFF2563EB), // Primary Blue
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) {
          final isSelected = index == currentIndex;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            height: 8.0,
            width: isSelected ? 24.0 : 8.0,
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor
                  : Color(0xFFCBD5E1), // Slate 300
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        },
      ),
    );
  }
}
