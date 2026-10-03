import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../view_models/portfolio_view_model.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/section_title.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 🧠 جلب حالة الثيم والبيانات
    final isDarkMode = context.watch<PortfolioViewModel>().isDarkMode;
    final skills = context.read<PortfolioViewModel>().portfolioData?.skills ?? [];

    return Container(
      // تغيير لون الخلفية
      color: isDarkMode ? AppColors.primaryBackground : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      width: double.infinity,
      child: Column(
        children: [
          SectionTitle(title: "My Skills", isDarkMode: isDarkMode),
          const SizedBox(height: 50),

          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: List.generate(skills.length, (index) {
              return FadeInUp(
                delay: Duration(milliseconds: index * 100),
                // تمرير حالة الثيم لكل مهارة
                child: _buildSkillChip(skills[index], isDarkMode),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skillName, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        // تغيير لون الخلفية (secondaryBackground في الليل، رمادي فاتح جداً في النهار)
        color: isDarkMode ? AppColors.secondaryBackground : Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          // تغيير لون الحدود (Accent Color في الليل، رمادي خفيف في النهار)
          color: isDarkMode ? AppColors.accentColor.withOpacity(0.5) : Colors.grey[300]!,
        ),
        boxShadow: [
          if (isDarkMode) // إضافة ظل فقط في الوضع الليلي ليعطي توهجاً خفيفاً
            BoxShadow(
              color: AppColors.accentColor.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Text(
        skillName,
        style: TextStyle(
          // تغيير لون النص
          color: isDarkMode ? AppColors.textPrimary : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
