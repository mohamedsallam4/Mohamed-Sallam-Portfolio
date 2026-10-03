import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/portfolio_model.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final bool isDarkMode; 

  const ProjectCard({super.key, required this.project, required this.isDarkMode});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.isDarkMode ? AppColors.secondaryBackground : Colors.grey[100];
    final titleColor = widget.isDarkMode ? AppColors.textPrimary : Colors.black87;
    final bodyColor = widget.isDarkMode ? AppColors.textSecondary : Colors.grey[700];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        // دمج تأثير الرفع للأعلى مع تكبير حجم الكارت بسلاسة (Scale + Translate)
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -12.0 : 0.0)
          ..scale(_isHovered ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: cardColor, 
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppColors.accentColor.withOpacity(0.5) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentColor.withOpacity(_isHovered ? 0.3 : 0.05),
              blurRadius: _isHovered ? 25 : 15,
              offset: Offset(0, _isHovered ? 15 : 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 260,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: widget.project.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[800]),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white54),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.project.title,
                    style: TextStyle(color: titleColor, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.project.description,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: bodyColor, fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.project.technologies.map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode ? AppColors.primaryBackground : Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child: Text(tech, style: const TextStyle(color: AppColors.accentColor, fontSize: 12)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.project.githubUrl.isNotEmpty)
                        _LinkButton(
                          iconWidget: FaIcon(FontAwesomeIcons.github, size: 20, color: titleColor), 
                          url: widget.project.githubUrl, 
                          tooltip: "View Code"
                        ),
                      if (widget.project.liveUrl != null && widget.project.liveUrl!.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        _LinkButton(
                          iconWidget: FaIcon(FontAwesomeIcons.externalLinkAlt, size: 20, color: titleColor), 
                          url: widget.project.liveUrl!, 
                          tooltip: "Live Demo"
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final Widget iconWidget;
  final String url;
  final String tooltip;

  const _LinkButton({required this.iconWidget, required this.url, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri);
      },
      icon: iconWidget, 
      hoverColor: AppColors.accentColor.withOpacity(0.2),
    );
  }
}