import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view_models/portfolio_view_model.dart';
import 'views/main_screen.dart';
import 'views/admin/admin_login_view.dart';
import 'core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDA86LxiuUbMV5ZlF0-R94yjjKVKxPXm0",
        authDomain: "mohamed-sallam-portfolio.firebaseapp.com",
        projectId: "mohamed-sallam-portfolio",
        storageBucket: "mohamed-sallam-portfolio.appspot.com",
        messagingSenderId: "594905685587",
        appId: "1:594905685587:web:dc74e7f8679a805fd570a6",
      ),
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PortfolioViewModel()..fetchPortfolioData(),
        ),
      ],
      child: Consumer<PortfolioViewModel>(
        builder: (context, viewModel, child) {
          return MaterialApp(
            title: 'Mohamed Portfolio',
            debugShowCheckedModeBanner: false,

            // 1. الوضع النهاري (Light)
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              fontFamily: GoogleFonts.cairo().fontFamily,
              scaffoldBackgroundColor: const Color(0xFFF5F5F5),
              primaryColor: Colors.blue[800],
              cardColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
                surface: Colors.white,
              ),
            ),

            // 2. الوضع الليلي (Dark)
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              fontFamily: GoogleFonts.cairo().fontFamily,
              scaffoldBackgroundColor: AppColors.primaryBackground,
              primaryColor: AppColors.primaryColor,
              cardColor: AppColors.secondaryBackground,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryColor,
                brightness: Brightness.dark,
                surface: AppColors.secondaryBackground,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AppColors.textPrimary),
                bodyMedium: TextStyle(color: AppColors.textPrimary),
                displayLarge: TextStyle(color: AppColors.textPrimary),
                displayMedium: TextStyle(color: AppColors.textPrimary),
              ),
            ),

            themeMode: viewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),

            routes: {'/admin': (context) => const AdminLoginView()},
          );
        },
      ),
    );
  }
}
