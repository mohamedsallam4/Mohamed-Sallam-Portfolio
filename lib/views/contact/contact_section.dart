import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 👈 مكتبة الفايربيس لتخزين الرسائل
import '../../view_models/portfolio_view_model.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/section_title.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // دالة إرسال الرسالة وحفظها في فايربيس
  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      try {
        // حفظ الرسالة في مجموعة 'messages' في الـ Firestore
        await FirebaseFirestore.instance.collection('messages').add({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'message': _messageController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(), // وقت إرسال الرسالة
        });

        // تفريغ الحقول بعد الإرسال الناجح
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Message sent successfully! Thank you. 🚀"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to send message: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<PortfolioViewModel>().isDarkMode; 
    final contact = context.read<PortfolioViewModel>().portfolioData?.contact;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: isDarkMode ? AppColors.secondaryBackground : Colors.grey[50],
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              SectionTitle(title: "Get In Touch", isDarkMode: isDarkMode),
              const SizedBox(height: 40),

              Text(
                "I'm currently looking for new opportunities, my inbox is always open.\nWhether you have a question or just want to say hi, drop a message below!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? AppColors.textSecondary : Colors.grey[700],
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 50),

              // 📝 نموذج إرسال الرسائل (Contact Form)
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.primaryBackground : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDarkMode ? AppColors.primaryColor : Colors.grey[300]!),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(color: isDarkMode ? AppColors.textPrimary : Colors.black),
                        decoration: _inputDecoration("Your Name", isDarkMode),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: isDarkMode ? AppColors.textPrimary : Colors.black),
                        decoration: _inputDecoration("Your Email", isDarkMode),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter your email';
                          if (!value.contains('@') || !value.contains('.')) return 'Please enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        style: TextStyle(color: isDarkMode ? AppColors.textPrimary : Colors.black),
                        decoration: _inputDecoration("Your Message", isDarkMode),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your message' : null,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _isSending ? null : _sendMessage,
                          child: _isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  "Send Message 🚀",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              if (contact != null)
                Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildContactItem(
                      iconWidget: const FaIcon(FontAwesomeIcons.envelope, size: 30, color: AppColors.accentColor),
                      title: "Email",
                      value: contact.email,
                      onTap: () => _launchUrl('mailto:${contact.email}'),
                      isDarkMode: isDarkMode,
                    ),
                    _buildContactItem(
                      iconWidget: const FaIcon(FontAwesomeIcons.phone, size: 30, color: AppColors.accentColor),
                      title: "Phone",
                      value: contact.phone,
                      onTap: () => _launchUrl('tel:${contact.phone}'),
                      isDarkMode: isDarkMode,
                    ),
                    _buildContactItem(
                      iconWidget: const FaIcon(FontAwesomeIcons.mapMarkerAlt, size: 30, color: AppColors.accentColor),
                      title: "Location",
                      value: contact.location,
                      onTap: () {},
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, bool isDarkMode) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDarkMode ? AppColors.textSecondary : Colors.grey[600]),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.accentColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildContactItem({
    required Widget iconWidget,
    required String title,
    required String value,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.primaryBackground : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDarkMode ? AppColors.primaryColor : Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            iconWidget,
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                color: isDarkMode ? AppColors.textPrimary : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(color: isDarkMode ? AppColors.textSecondary : Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}