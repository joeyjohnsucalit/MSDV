import 'package:flutter/material.dart';
import '../widgets/sidebar_widget.dart';
import '../app_colors.dart';
import 'dashboard_screen.dart';
import 'student_records_screen.dart';
import 'violation_history_screen.dart';
import 'disciplinary_action_screen.dart';
import 'risk_level_screen.dart';
import 'data_backup_screen.dart';
import 'import_data_screen.dart';
import 'jassu_users_screen.dart';

const double _kMobileBreak = 768;

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppPage _currentPage = AppPage.dashboard;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _pageTitle => switch (_currentPage) {
    AppPage.dashboard => 'Security Dashboard',
    AppPage.studentRecords => 'Student Records',
    AppPage.violationHistory => 'Violation History',
    AppPage.disciplinaryAction => 'Disciplinary Actions',
    AppPage.riskLevel => 'Risk Level Indicator',
    AppPage.dataBackup => 'Data Backup',
    AppPage.importData => 'Import Data',
    AppPage.jassuUsers => 'Jassu Users',
  };

  Widget get _pageContent => switch (_currentPage) {
    AppPage.dashboard => const DashboardScreen(),
    AppPage.studentRecords => const StudentRecordsScreen(),
    AppPage.violationHistory => const ViolationHistoryScreen(),
    AppPage.disciplinaryAction => const DisciplinaryActionScreen(),
    AppPage.riskLevel => const RiskLevelScreen(),
    AppPage.dataBackup => const DataBackupScreen(),
    AppPage.importData => const ImportDataScreen(),
    AppPage.jassuUsers => const JassuUsersScreen(),
  };

  void _navigate(AppPage page) {
    setState(() => _currentPage = page);
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < _kMobileBreak;

    final sidebar = SidebarWidget(
      currentPage: _currentPage,
      onPageChange: _navigate,
      onLogout: () {
        _scaffoldKey.currentState?.closeDrawer();
        Navigator.pushReplacementNamed(context, '/');
      },
    );

    if (isMobile) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: Drawer(
          width: 280,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: sidebar,
        ),
        body: Column(
          children: [
            _TopNavbar(
              title: _pageTitle,
              showMenu: true,
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(child: _pageContent),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          sidebar,
          Expanded(
            child: Column(
              children: [
                _TopNavbar(title: _pageTitle),
                Expanded(child: _pageContent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNavbar extends StatelessWidget {
  final String title;
  final bool showMenu;
  final VoidCallback? onMenuTap;

  const _TopNavbar({
    required this.title,
    this.showMenu = false,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navbarBg, AppColors.surface],
        ),
        border: Border(bottom: BorderSide(color: AppColors.accent, width: 2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showMenu) ...[
            GestureDetector(
              onTap: onMenuTap,
              child: const Icon(Icons.menu, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                Icon(Icons.lock_outline, size: 18, color: AppColors.accent),
                SizedBox(width: 8),
                Text('Protected', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
