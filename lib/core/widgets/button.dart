import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const GeneralButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBg =
        backgroundColor ?? Theme.of(context).colorScheme.primary;
    final Color effectiveText =
        textColor ?? Theme.of(context).colorScheme.onPrimary;

    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      inherit: true,
      color: effectiveText,
      fontWeight: FontWeight.bold,
    );

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? Icon(icon, color: effectiveText)
          : const SizedBox.shrink(),
      label: Text(label, style: textStyle),
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBg,
        foregroundColor: effectiveText,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        textStyle: textStyle,
      ),
    );
  }
}
