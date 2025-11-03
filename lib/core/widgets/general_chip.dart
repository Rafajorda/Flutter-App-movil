import 'package:flutter/material.dart';

class GeneralChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final Color? selectedColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const GeneralChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.selectedColor,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style:
            textStyle ??
            TextStyle(
              color: isSelected ? const Color(0xFF3E3B32) : Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: selectedColor ?? const Color(0xFFD9C6A5),
      backgroundColor: backgroundColor ?? const Color(0xFF7B8C5F),
    );
  }
}
