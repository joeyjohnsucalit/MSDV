import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const MsdvApp());
}

class MsdvApp extends StatelessWidget {
  const MsdvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MSDV | MCC Student Violation System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          background: AppColors.background,
          surface: AppColors.surface,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white70,
          onSurface: Colors.white70,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navbarBg,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: AppColors.muted),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        ),
        fontFamily: 'Arial',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/main': (context) => const MainShell(),
      },
    );
  }
}
