import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/portfolio_view_model.dart';
import '../core/constants/app_colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    // 🧠 جلب الثيم والاسم
    final isDarkMode = context.watch<PortfolioViewModel>().isDarkMode;
    final name = context.read<PortfolioViewModel>().portfolioData?.profile.name ?? "Developer";

    return Container(
      padding: const EdgeInsets.all(20),
      // تغيير لون الخلفية
      color: isDarkMode ? AppColors.primaryBackground : Colors.white,
      width: double.infinity,
      child: Text(
        "Designed & Built by $name © ${DateTime.now().year}",
        textAlign: TextAlign.center,
        style: TextStyle(
          // تغيير لون النص
          color: isDarkMode ? AppColors.textSecondary : Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }
}
