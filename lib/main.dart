import 'package:flutter/material.dart';
import 'screens/jassu_shell.dart';
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
        scaffoldBackgroundColor: const Color(0xFFF1F4F9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF030357)),
        fontFamily: 'Arial',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/main': (context) => const MainShell(),
        '/jassu': (context) => const JassuShell(),
      },
    );
  }
}
