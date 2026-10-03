import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
final String title;
final bool isDarkMode;

const SectionTitle({
super.key,
required this.title,
required this.isDarkMode,
});

@override
Widget build(BuildContext context) {
final textColor = isDarkMode ? AppColors.textPrimary : Colors.black87;

return Column(
  children: [
    // عنوان القسم الرئيسي
    Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      textAlign: TextAlign.center,
    ),
    const SizedBox(height: 12),
    // الخط المتدرج والمضيء الفاخر (Gradient Line)
    Container(
      height: 4,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          colors: [
            AppColors.accentColor.withOpacity(0.1),
            AppColors.accentColor,
            AppColors.accentColor.withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    ),
  ],
);


}
}