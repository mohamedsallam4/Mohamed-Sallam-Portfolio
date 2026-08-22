import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/portfolio_view_model.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/section_title.dart';
import 'widgets/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<PortfolioViewModel>().isDarkMode; // 🧠
    final projects = context.read<PortfolioViewModel>().portfolioData?.projects ?? [];

    return Container(
      // تغيير لون الخلفية
      color: isDarkMode ? AppColors.primaryBackground : Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              SectionTitle(title: "Featured Projects", isDarkMode: isDarkMode), // تمرير الثيم
              const SizedBox(height: 50),

              if (projects.isEmpty)
                Text("No projects added yet.", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),

              LayoutBuilder(
                builder: (context, constraints) {
                  double width = constraints.maxWidth;
                  int crossAxisCount = 1;
                  if (width >= 1100) crossAxisCount = 3;
                  else if (width >= 650) crossAxisCount = 2;

                  double cardWidth = (width - ((crossAxisCount - 1) * 30)) / crossAxisCount;
                  double estimatedHeight = 820; 
                  double childAspectRatio = cardWidth / estimatedHeight;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      // سنعدل كارت المشروع لاحقاً ليدعم الثيم
                      return ProjectCard(project: projects[index], isDarkMode: isDarkMode);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
