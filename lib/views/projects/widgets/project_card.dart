import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/portfolio_model.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final bool isDarkMode;

  const ProjectCard({
    super.key,
    required this.project,
    required this.isDarkMode,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  bool _isHovered = false;

  void _onHover(PointerEvent details, Size size) {
    final percentX = (details.localPosition.dx / size.width) - 0.5;
    final percentY = (details.localPosition.dy / size.height) - 0.5;
    setState(() {
      _rotateX = -percentY * 0.15;
      _rotateY = percentX * 0.15;
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _rotateX = 0.0;
      _rotateY = 0.0;
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (e) => _onHover(e, Size(constraints.maxWidth, constraints.maxHeight)),
          onExit: _onExit,
          child: TweenAnimationBuilder<Matrix4>(
            duration: const Duration(milliseconds: 200),
            tween: Matrix4Tween(
              begin: Matrix4.identity(),
              end: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rotateX)
                ..rotateY(_rotateY)
                ..translate(0.0, _isHovered ? -10.0 : 0.0),
            ),
            builder: (context, transform, child) => Transform(
              transform: transform,
              alignment: FractionalOffset.center,
              child: child,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? AppColors.secondaryBackground : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovered ? AppColors.accentColor.withOpacity(0.6) : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentColor.withOpacity(_isHovered ? 0.25 : 0.05),
                    blurRadius: _isHovered ? 25 : 12,
                    offset: Offset(0, _isHovered ? 15 : 6),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // إعدادات الصورة
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: AnimatedScale(
                        scale: _isHovered ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: CachedNetworkImage(
                          imageUrl: widget.project.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.accentColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                            child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // تفاصيل المشروع
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project.title,
                          style: TextStyle(
                            color: widget.isDarkMode ? AppColors.textPrimary : Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.project.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.isDarkMode ? AppColors.textSecondary : Colors.grey[700],
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.project.technologies
                              .map((tech) => _AnimatedTag(tech: tech, isDark: widget.isDarkMode))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.project.githubUrl.isNotEmpty)
                              _LinkBtn(
                                iconWidget: FaIcon(
                                  FontAwesomeIcons.github,
                                  size: 18,
                                  color: widget.isDarkMode ? AppColors.textPrimary : Colors.black87,
                                ),
                                url: widget.project.githubUrl,
                                tooltip: "View Code",
                              ),
                            if (widget.project.liveUrl?.isNotEmpty ?? false) ...[
                              const SizedBox(width: 8),
                              _LinkBtn(
                                iconWidget: FaIcon(
                                  FontAwesomeIcons.arrowUpRightFromSquare,
                                  size: 18,
                                  color: widget.isDarkMode ? AppColors.textPrimary : Colors.black87,
                                ),
                                url: widget.project.liveUrl!,
                                tooltip: "Live Demo",
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
          ),
        );
      },
    );
  }
}

class _AnimatedTag extends StatefulWidget {
  final String tech;
  final bool isDark;

  const _AnimatedTag({required this.tech, required this.isDark});

  @override
  State<_AnimatedTag> createState() => _AnimatedTagState();
}

class _AnimatedTagState extends State<_AnimatedTag> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _hover
                ? AppColors.accentColor.withOpacity(0.15)
                : (widget.isDark ? AppColors.primaryBackground : Colors.white),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _hover ? AppColors.accentColor : AppColors.primaryColor.withOpacity(0.5),
            ),
          ),
          child: Text(
            widget.tech,
            style: const TextStyle(
              color: AppColors.accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// 🌟 الـ LinkBtn بعد التحديث الجذري للاعتماد على الويدجت الكاملة 🌟
class _LinkBtn extends StatelessWidget {
  final Widget iconWidget;
  final String url;
  final String tooltip;

  const _LinkBtn({
    required this.iconWidget,
    required this.url,
    required this.tooltip,
  });

  Future<void> _launchURL(BuildContext context) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch url');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر فتح الرابط: $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () => _launchURL(context),
      icon: iconWidget,
      hoverColor: AppColors.accentColor.withOpacity(0.2),
    );
  }
}