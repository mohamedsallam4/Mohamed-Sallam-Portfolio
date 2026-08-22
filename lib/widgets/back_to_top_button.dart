import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../core/constants/app_colors.dart';

class BackToTopButton extends StatelessWidget {
  final ScrollController scrollController;
  final bool isVisible;
  final VoidCallback onPressed;

  const BackToTopButton({
    super.key,
    required this.scrollController,
    required this.isVisible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: 30,
      left: 30, // 👈 نقلناه للجانب الأيسر عشان ميحصلش تداخل مع زرار الشات بوت في اليمين
      child: FadeInUp(
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: AppColors.accentColor,
          elevation: 6,
          tooltip: "Back to Top",
          child: const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}