import 'dart:async';
import 'dart:math';
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

    return Container(
      // تصميم تدرج ناعم فاخر للوضع النهاري
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? null
            : const RadialGradient(
                center: Alignment(0.6, -0.4),
                radius: 1.2,
                colors: [
                  Color(0xFFFFFBEB), // كهرماني فاتح ناعم جداً
                  Color(0xFFF8FAFC), // Slate رمادي ناصع وفاخر
                ],
              ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: ParticlesBackground(isDarkMode: isDarkMode)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 650),
            child: ResponsiveHelper(
              mobile: _buildMobileLayout(profile, data.socials, data.contact, isDarkMode, context),
              desktop: _buildDesktopLayout(profile, data.socials, data.contact, isDarkMode, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(dynamic profile, List socials, dynamic contact, bool isDarkMode, BuildContext context) {
    return Column(
      children: [
        FadeInDown(duration: const Duration(milliseconds: 700), child: _buildProfileImage(profile.avatarUrl, profile.profileBackground, size: 200, isDarkMode: isDarkMode)),
        const SizedBox(height: 40),
        _buildTexts(profile, isDarkMode, centered: true),
        const SizedBox(height: 30),
        FadeInUp(delay: const Duration(milliseconds: 600), child: _buildButtons(profile.cvUrl, contact.phone, context)),
        const SizedBox(height: 30),
        FadeInUp(delay: const Duration(milliseconds: 800), child: _buildSocials(socials)),
      ],
    );
  }

  Widget _buildDesktopLayout(dynamic profile, List socials, dynamic contact, bool isDarkMode, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTexts(profile, isDarkMode, centered: false),
              const SizedBox(height: 40),
              FadeInUp(delay: const Duration(milliseconds: 600), child: _buildButtons(profile.cvUrl, contact.phone, context)),
              const SizedBox(height: 40),
              FadeInUp(delay: const Duration(milliseconds: 800), child: _buildSocials(socials)),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: FadeInRight(duration: const Duration(milliseconds: 800), child: Center(child: _buildProfileImage(profile.avatarUrl, profile.profileBackground, size: 350, isDarkMode: isDarkMode))),
        ),
      ],
    );
  }

  Widget _buildTexts(dynamic profile, bool isDarkMode, {required bool centered}) {
    return Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        FadeInDown(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(isDarkMode ? 0.15 : 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "👋 Welcome to my portfolio",
              style: TextStyle(
                color: AppColors.accentColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        FadeInLeft(
          delay: const Duration(milliseconds: 200),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDarkMode
                  ? [AppColors.accentColor, Colors.white]
                  : [const Color(0xFFD97706), const Color(0xFF0F172A)],
            ).createShader(bounds),
            child: Text(
              profile.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: centered ? 42 : 62,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
              textAlign: centered ? TextAlign.center : TextAlign.start,
            ),
          ),
        ),
        const SizedBox(height: 14),
        FadeIn(
          delay: const Duration(milliseconds: 400),
          child: TypewriterText(
            text: profile.role,
            style: TextStyle(
              color: isDarkMode ? AppColors.primaryColor : const Color(0xFF2563EB),
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          delay: const Duration(milliseconds: 600),
          child: Text(
            profile.bio,
            style: TextStyle(
              color: isDarkMode ? AppColors.textSecondary : const Color(0xFF475569),
              fontSize: 16,
              height: 1.75,
            ),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ),
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
          onPressed: () => launchUrl(
            Uri.parse("https://api.whatsapp.com/send/?phone=${phone.replaceAll('+', '').replaceAll(' ', '')}"),
          ),
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
    return Stack(
      alignment: Alignment.center,
      children: [
        if (backgroundUrl.isNotEmpty)
          SizedBox(
            width: size * 1.8,
            height: size * 1.8,
            child: Opacity(
              opacity: isDarkMode ? 0.7 : 0.85,
              child: backgroundUrl.endsWith('.json')
                  ? Lottie.network(backgroundUrl, errorBuilder: (context, error, stackTrace) => const SizedBox())
                  : CachedNetworkImage(imageUrl: backgroundUrl),
            ),
          ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accentColor, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentColor.withOpacity(isDarkMode ? 0.4 : 0.25),
                blurRadius: 35,
                spreadRadius: 8,
              ),
            ],
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.person, size: 80, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  const TypewriterText({super.key, required this.text, required this.style});
  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayed = "";
  int _index = 0;
  Timer? _timer;
  bool _cursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 90), (t) {
      if (_index < widget.text.length) {
        setState(() => _displayed = widget.text.substring(0, ++_index));
      } else {
        _timer?.cancel();
      }
    });
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (t) => setState(() => _cursor = !_cursor));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_displayed, style: widget.style),
          Opacity(opacity: _cursor ? 1.0 : 0.0, child: Text("|", style: widget.style)),
        ],
      );
}

class ParticlesBackground extends StatefulWidget {
  final bool isDarkMode;
  const ParticlesBackground({super.key, required this.isDarkMode});
  @override
  State<ParticlesBackground> createState() => _ParticlesBackgroundState();
}

class _ParticlesBackgroundState extends State<ParticlesBackground> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<_Particle> _pts = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 40; i++) {
      _pts.add(_Particle(
        _rnd.nextDouble(),
        _rnd.nextDouble(),
        _rnd.nextDouble() * 2 + 1,
        (_rnd.nextDouble() - 0.5) * 0.001,
        (_rnd.nextDouble() - 0.5) * 0.001,
        _rnd.nextDouble() * 0.5 + 0.2,
      ));
    }
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (c, _) {
          for (var p in _pts) {
            p.x += p.dx;
            p.y += p.dy;
            if (p.x < 0 || p.x > 1) p.dx *= -1;
            if (p.y < 0 || p.y > 1) p.dy *= -1;
          }
          return CustomPaint(painter: _ParticlesPainter(_pts, widget.isDarkMode));
        },
      );
}

class _Particle {
  double x, y, r, dx, dy, o;
  _Particle(this.x, this.y, this.r, this.dx, this.dy, this.o);
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> pts;
  final bool dark;
  _ParticlesPainter(this.pts, this.dark);

  @override
  void paint(Canvas c, Size s) {
    final p = Paint();
    for (var pt in pts) {
      p.color = (dark ? AppColors.accentColor : const Color(0xFFD97706)).withOpacity(pt.o * 0.25);
      c.drawCircle(Offset(pt.x * s.width, pt.y * s.height), pt.r, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}