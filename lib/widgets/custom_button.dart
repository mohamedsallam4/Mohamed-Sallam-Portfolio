import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutline; // هل هو زر مفرغ أم ممتلئ؟

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutline
            ? Colors.transparent
            : AppColors.primaryColor,
        foregroundColor: isOutline ? AppColors.primaryColor : Colors.white,
        side: isOutline
            ? const BorderSide(color: AppColors.primaryColor)
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isOutline ? AppColors.accentColor : Colors.white,
        ),
      ),
    );
  }
}
