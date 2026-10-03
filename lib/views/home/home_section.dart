import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart'; 

import '../../view_models/portfolio_view_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_icon_button.dart';
import '../../widgets/download_cv_button.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<PortfolioViewModel>().isDarkMode;
    final data = context.read<PortfolioViewModel>().portfolioData;
    final profile = data!.profile;
    final socials = data.socials;
    final contact = data.contact;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 600),
      color: isDarkMode ? AppColors.primaryBackground : Colors.white,

      child: ResponsiveHelper(
        mobile: Column(
          children: [
            FadeInDown(child: _buildProfileImage(profile.avatarUrl, profile.profileBackground, size: 200, isDarkMode: isDarkMode)),
            const SizedBox(height: 40),
            FadeInUp(
              child: Column(
                children: [
                  _buildTexts(profile, isDarkMode, centered: true),
                  const SizedBox(height: 30),
                  _buildButtons(profile.cvUrl, contact.phone, context),
                  const SizedBox(height: 30),
                  _buildSocials(socials),
                ],
              ),
            ),
          ],
        ),
        desktop: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: FadeInLeft(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTexts(profile, isDarkMode, centered: false),
                    const SizedBox(height: 40),
                    _buildButtons(profile.cvUrl, contact.phone, context),
                    const SizedBox(height: 40),
                    _buildSocials(socials),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: FadeInRight(
                child: Center(
                  child: _buildProfileImage(profile.avatarUrl, profile.profileBackground, size: 350, isDarkMode: isDarkMode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTexts(dynamic profile, bool isDarkMode, {required bool centered}) {
    final subTextColor = isDarkMode ? AppColors.textSecondary : Colors.grey[700];

    return Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const Text("Hello, I'm", style: TextStyle(color: AppColors.accentColor, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        
        // تدرج الألوان الساحر (Gradient Text) على اسمك بدون أي متغيرات غير مسخدمة
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.accentColor,
              isDarkMode ? Colors.white : Colors.black54,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            profile.name, 
            style: TextStyle(
              color: Colors.white, 
              fontSize: centered ? 40 : 60, 
              fontWeight: FontWeight.bold, 
              height: 1.1,
            ), 
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ),
        
        const SizedBox(height: 10),
        Text(profile.role, style: TextStyle(color: subTextColor, fontSize: 24, fontWeight: FontWeight.w500)),
        const SizedBox(height: 20),
        Text(profile.bio, style: TextStyle(color: subTextColor, fontSize: 16, height: 1.6), textAlign: centered ? TextAlign.center : TextAlign.start),
      ],
    );
  }

  Widget _buildButtons(String cvUrl, String phone, BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        CustomButton(
          text: "Contact Me",
          onPressed: () async {
            final cleanPhone = phone.replaceAll('+', '').replaceAll(' ', '');
            final whatsappUrl = "https://api.whatsapp.com/send/?phone=$cleanPhone&text&type=phone_number&app_absent=0";
            final Uri uri = Uri.parse(whatsappUrl);
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
        DownloadCvButton(cvUrl: cvUrl),
      ],
    );
  }

  Widget _buildSocials(List<dynamic> socials) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: socials.map((social) => SocialIconButton(platform: social.platform, url: social.url)).toList(),
    );
  }

  Widget _buildProfileImage(String avatarUrl, String backgroundUrl, {required double size, required bool isDarkMode}) {
    final glowColor = isDarkMode ? AppColors.accentColor.withOpacity(0.5) : AppColors.accentColor.withOpacity(0.3);
    final glowBlur = isDarkMode ? 35.0 : 20.0;
    final glowSpread = isDarkMode ? 8.0 : 2.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (backgroundUrl.isNotEmpty)
          SizedBox(
            width: size * 1.8, 
            height: size * 1.8,
            child: Opacity(
              opacity: isDarkMode ? 0.7 : 0.4,
              child: backgroundUrl.endsWith('.json')
                  ? Lottie.network(
                      backgroundUrl,
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox();
                      },
                    )
                  : CachedNetworkImage(
                      imageUrl: backgroundUrl,
                      fit: BoxFit.contain,
                    ),
            ),
          ),

        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accentColor, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: glowBlur,
                spreadRadius: glowSpread,
              ),
            ],
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.person, size: 50),
            ),
          ),
        ),
      ],
    );
  }
}