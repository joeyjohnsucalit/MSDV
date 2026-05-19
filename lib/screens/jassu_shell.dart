import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'jassu_dashboard_screen.dart';

class JassuShell extends StatelessWidget {
  const JassuShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navbarBg,
        title: const Text('Jassu Dashboard'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(Icons.logout, color: Colors.white, size: 18),
            label: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: const JassuDashboardScreen(),
    );
  }
}
