import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_colors.dart';

class DownloadCvButton extends StatefulWidget {
  final String cvUrl;
  const DownloadCvButton({super.key, required this.cvUrl});

  @override
  State<DownloadCvButton> createState() => _DownloadCvButtonState();
}

class _DownloadCvButtonState extends State<DownloadCvButton> {
  bool _isHovered = false;

  void _downloadCV() async {
    if (widget.cvUrl.isNotEmpty) {
      String finalUrl = widget.cvUrl;

      // تحويل رابط جوجل درايف ليعمل بكفاءة في المعاينة والتحميل
      if (finalUrl.contains('drive.google.com')) {
        finalUrl = finalUrl.replaceAll('/view?usp=sharing', '/preview');
      }

      final Uri uri = Uri.parse(finalUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open CV link.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV link is not available right now.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton.icon(
          onPressed: _downloadCV,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered ? AppColors.accentColor.withOpacity(0.8) : AppColors.accentColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: _isHovered ? 8 : 4,
            shadowColor: AppColors.accentColor.withOpacity(0.5),
          ),
          icon: const Icon(Icons.download_rounded, size: 20),
          label: const Text(
            "Download CV",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}