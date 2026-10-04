import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../view_models/portfolio_view_model.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/section_title.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<PortfolioViewModel>().isDarkMode;
    final bio = context.read<PortfolioViewModel>().portfolioData?.profile.bio ?? "No bio available";
    final projectCount = context.read<PortfolioViewModel>().portfolioData?.projects.length ?? 0;

    return Container(
      color: isDarkMode ? AppColors.secondaryBackground : Colors.grey[100], 
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      width: double.infinity,
      child: Column(
        children: [
          FadeInDown(child: SectionTitle(title: "About Me", isDarkMode: isDarkMode)),
          const SizedBox(height: 40),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.primaryBackground : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, height: 1.8, color: isDarkMode ? AppColors.textSecondary : Colors.grey[800]),
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 20),
                  // Animated Counters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AnimatedCounter(target: projectCount, label: "Projects Completed", isDarkMode: isDarkMode),
                      _AnimatedCounter(target: 3, label: "Years Experience", isDarkMode: isDarkMode),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCounter extends StatelessWidget {
  final int target; final String label; final bool isDarkMode;
  const _AnimatedCounter({required this.target, required this.label, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: target),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) => Text(
            "+$value",
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.accentColor),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[400] : Colors.grey[700])),
      ],
    );
  }
}