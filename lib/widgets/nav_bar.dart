import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // مطلوب لتطبيق تأثير الـ BackdropFilter (Blur)
import '../view_models/portfolio_view_model.dart';
import '../core/constants/app_colors.dart';

class NavBar extends StatelessWidget {
  final Map<String, GlobalKey> sectionKeys;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NavBar({
    super.key,
    required this.sectionKeys,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PortfolioViewModel>();
    final isDarkMode = viewModel.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    // ألوان تتناسب مع تأثير الزجاج المعتم (Glassmorphism)
    final glassColor = isDarkMode 
        ? AppColors.primaryBackground.withOpacity(0.7) 
        : Colors.white.withOpacity(0.75);
    final borderColor = isDarkMode 
        ? Colors.white.withOpacity(0.1) 
        : Colors.black.withOpacity(0.08);

    return ClipRect(
      child: BackdropFilter(
        // تأثير البلور (Blur) الزجاجي الساحر
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50, vertical: 16),
          decoration: BoxDecoration(
            color: glassColor,
            border: Border(
              bottom: BorderSide(
                color: borderColor,
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // الشعار أو الاسم
              GestureDetector(
                onTap: () => _scrollToSection("Home"),
                child: Text(
                  "< Sallam />",
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppColors.textPrimary : Colors.black87,
                  ),
                ),
              ),

              // روابط القائمة لو شاشة ديسكتوب، أو زر القائمة لو موبايل
              if (isMobile)
                IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: isDarkMode ? AppColors.textPrimary : Colors.black87,
                  ),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                )
              else
                Row(
                  children: sectionKeys.keys.map((title) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextButton(
                        onPressed: () => _scrollToSection(title),
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(
                            isDarkMode ? AppColors.textSecondary : Colors.grey[800],
                          ),
                          overlayColor: WidgetStateProperty.all(
                            AppColors.accentColor.withOpacity(0.1),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              // زر تبديل الثيم (Dark / Light Mode)
              IconButton(
                icon: Icon(
                  isDarkMode ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                  color: isDarkMode ? AppColors.accentColor : Colors.amber[800],
                ),
                onPressed: () {
                  viewModel.toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToSection(String title) {
    final contextKey = sectionKeys[title]?.currentContext;
    if (contextKey != null) {
      Scrollable.ensureVisible(
        contextKey,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }
}