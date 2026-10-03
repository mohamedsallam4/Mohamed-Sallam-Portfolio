import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'admin_dashboard_view.dart';

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // كلمة السر الخاصة بك (يمكنك تغييرها لاحقاً أو ربطها بـ Firebase)
  final String _adminPassword = "admin123_sallam";

  void _login() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_passwordController.text == _adminPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardView()),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Incorrect Password!";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Admin Portal",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your password to manage portfolio.",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.accentColor),
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13)),
              ],
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}