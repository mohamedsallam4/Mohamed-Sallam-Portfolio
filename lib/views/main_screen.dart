import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/portfolio_view_model.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/nav_bar.dart';
import '../../widgets/footer.dart';
import '../../widgets/ai_chatbot_widget.dart';
import '../../widgets/skills_marquee_widget.dart';
import '../../widgets/back_to_top_button.dart'; // استدعاء زر الصعود لأعلى
import 'home/home_section.dart';
import 'about/about_section.dart';
import 'skills/skills_section.dart';
import 'projects/projects_section.dart';
import 'contact/contact_section.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  
  bool _showBackToTop = false;

  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final projectsKey = GlobalKey();
  final contactKey = GlobalKey();

  late final Map<String, GlobalKey> sectionKeys = {
    "Home": homeKey,
    "About": aboutKey,
    "Skills": skillsKey,
    "Projects": projectsKey,
    "Contact": contactKey,
  };

  @override
  void initState() {
    super.initState();
    // مراقبة حركة الـ Scroll لإظهار أو إخفاء الزرار
    _scrollController.addListener(() {
      if (_scrollController.offset >= 400 && !_showBackToTop) {
        setState(() => _showBackToTop = true);
      } else if (_scrollController.offset < 400 && _showBackToTop) {
        setState(() => _showBackToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  IconData _getSectionIcon(String title) {
    switch (title.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'about':
        return Icons.person_rounded;
      case 'skills':
        return Icons.code_rounded;
      case 'projects':
        return Icons.work_rounded;
      case 'contact':
        return Icons.email_rounded;
      default:
        return Icons.arrow_right_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<PortfolioViewModel>().isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryBackground,
      drawer: Drawer(
        backgroundColor: isDarkMode ? AppColors.secondaryBackground : Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.primaryBackground : Colors.grey[100],
              ),
              child: Center(
                child: Text(
                  "< Sallam />",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? AppColors.accentColor : Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: sectionKeys.keys.map((title) {
                  return ListTile(
                    leading: Icon(
                      _getSectionIcon(title),
                      color: isDarkMode ? AppColors.accentColor : Colors.grey[800],
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? AppColors.textPrimary : Colors.black87,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      final contextKey = sectionKeys[title]?.currentContext;
                      if (contextKey != null) {
                        Scrollable.ensureVisible(
                          contextKey,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "© 2026 Mohamed Sallam",
                style: TextStyle(
                  color: isDarkMode ? AppColors.textSecondary : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      // استخدام Stack لعرض المحتوى وزر الشات وبجانبه زر العودة للأعلى
      body: Stack(
        children: [
          Consumer<PortfolioViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.status == LoadingStatus.loading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.accentColor));
              }

              if (viewModel.status == LoadingStatus.error) {
                return Center(
                  child: Text(
                    "Error loading data: ${viewModel.errorMessage}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (viewModel.status == LoadingStatus.loaded && viewModel.portfolioData != null) {
                return Column(
                  children: [
                    NavBar(sectionKeys: sectionKeys, scaffoldKey: _scaffoldKey),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController, // ربط الـ Controller هنا
                        child: Column(
                          children: [
                            HomeSection(key: homeKey),
                            SkillsMarqueeWidget(
                              skills: viewModel.portfolioData!.skills,
                              isDarkMode: isDarkMode,
                            ),
                            AboutSection(key: aboutKey),
                            SkillsSection(key: skillsKey),
                            ProjectsSection(key: projectsKey),
                            ContactSection(key: contactKey),
                            const Footer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
          // زر الشات بوت العائم
          const AIChatbotWidget(),
          
          // زر الصعود لأعلى الصفحة العائم
          BackToTopButton(
            scrollController: _scrollController,
            isVisible: _showBackToTop,
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }
}