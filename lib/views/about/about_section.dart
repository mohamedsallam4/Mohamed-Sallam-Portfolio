import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/portfolio_view_model.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/section_title.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<PortfolioViewModel>().isDarkMode; // 🧠
    final bio = context.read<PortfolioViewModel>().portfolioData?.profile.bio ?? "No bio available";

    return Container(
      // تغيير لون الخلفية (secondaryBackground في الليل، رمادي فاتح جداً في النهار)
      color: isDarkMode ? AppColors.secondaryBackground : Colors.grey[100], 
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      width: double.infinity,
      child: Column(
        children: [
          // تمرير لون النص للعنوان (سنعدل SectionTitle لاحقاً ليدعم هذا)
          SectionTitle(title: "About Me", isDarkMode: isDarkMode), 
          const SizedBox(height: 40),
          
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              // تغيير لون خلفية الصندوق (primaryBackground في الليل، أبيض في النهار)
              color: isDarkMode ? AppColors.primaryBackground : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // ظل خفيف دائماً
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.8,
                // تغيير لون النص الداخلي
                color: isDarkMode ? AppColors.textSecondary : Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
