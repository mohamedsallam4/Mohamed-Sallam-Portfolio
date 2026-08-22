import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_colors.dart';

class SocialIconButton extends StatelessWidget {
  final String platform;
  final String url;

  const SocialIconButton({
    super.key,
    required this.platform,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        String finalUrl = url;
        if (platform.toLowerCase() == 'email' && !url.startsWith('mailto:')) {
          finalUrl = 'mailto:$url';
        }
        final Uri uri = Uri.parse(finalUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          debugPrint("Could not launch $finalUrl");
        }
      },
      // استدعاء الـ Widget مباشرة
      icon: _getIconWidget(platform),
      hoverColor: AppColors.accentColor.withOpacity(0.1),
    );
  }

  // إرجاع FaIcon كـ Widget كاملة لتفادي أي تعارض في الأنواع
  Widget _getIconWidget(String platform) {
    switch (platform.toLowerCase()) {
      case 'github':
        return const FaIcon(FontAwesomeIcons.github, color: AppColors.textSecondary, size: 24);
      case 'linkedin':
        return const FaIcon(FontAwesomeIcons.linkedin, color: AppColors.textSecondary, size: 24);
      case 'email':
        return const FaIcon(FontAwesomeIcons.solidEnvelope, color: AppColors.textSecondary, size: 24);
      case 'facebook':
        return const FaIcon(FontAwesomeIcons.facebook, color: AppColors.textSecondary, size: 24);
      case 'twitter':
      case 'x':
        return const FaIcon(FontAwesomeIcons.xTwitter, color: AppColors.textSecondary, size: 24);
      case 'whatsapp':
        return const FaIcon(FontAwesomeIcons.whatsapp, color: AppColors.textSecondary, size: 24);
      default:
        return const FaIcon(FontAwesomeIcons.link, color: AppColors.textSecondary, size: 24);
    }
  }
}