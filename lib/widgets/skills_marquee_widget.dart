import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants/app_colors.dart';

class SkillsMarqueeWidget extends StatelessWidget {
  final List<String> skills;
  final bool isDarkMode;

  const SkillsMarqueeWidget({
    super.key,
    required this.skills,
    required this.isDarkMode,
  });

  // جعل نوع الإرجاع dynamic لتوافق أيقونات FontAwesome بالكامل
  dynamic _getSkillIcon(String skill) {
    switch (skill.toLowerCase().trim()) {
      case 'flutter':
      case 'flutter web':
        return FontAwesomeIcons.mobileScreen;
      case 'dart':
        return FontAwesomeIcons.code;
      case 'c++':
        return FontAwesomeIcons.laptopCode;
      case 'python':
        return FontAwesomeIcons.python;
      case 'java':
        return FontAwesomeIcons.java;
      case 'javascript':
        return FontAwesomeIcons.js;
      case 'firebase':
        return FontAwesomeIcons.fire;
      case 'git':
        return FontAwesomeIcons.gitAlt;
      case 'bloc':
      case 'provider':
      case 'state management':
        return FontAwesomeIcons.cubes;
      case 'clean architecture':
        return FontAwesomeIcons.sitemap;
      case 'rest apis':
      case 'node.js':
        return FontAwesomeIcons.server;
      case 'payment methods':
      case 'stripe':
        return FontAwesomeIcons.creditCard;
      case 'ci/cd':
        return FontAwesomeIcons.infinity;
      case 'testing':
        return FontAwesomeIcons.vial;
      case 'opengl':
        return FontAwesomeIcons.cube;
      default:
        return FontAwesomeIcons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chipBg = isDarkMode ? AppColors.secondaryBackground : Colors.grey[100];
    final textColor = isDarkMode ? AppColors.textPrimary : Colors.black87;

    // تكرار القائمة لضمان استمرارية الحركة بسلاسة
    final duplicatedSkills = [...skills, ...skills, ...skills];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Expertise & Technologies",
              style: TextStyle(
                color: isDarkMode ? AppColors.textPrimary : Colors.black87,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: duplicatedSkills.length,
              itemBuilder: (context, index) {
                final skill = duplicatedSkills[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.accentColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        _getSkillIcon(skill),
                        size: 16,
                        color: AppColors.accentColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        skill,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}