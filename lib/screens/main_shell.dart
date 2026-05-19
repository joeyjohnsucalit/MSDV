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
const double _kTabletBreak = 1080;
const double _kSidebarWidth = 280;
const double _kCompactSidebarWidth = 240;

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppPage _currentPage = AppPage.dashboard;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String get _pageTitle => switch (_currentPage) {
        AppPage.dashboard => 'Dashboard',
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
    final isTablet = width >= _kMobileBreak && width < _kTabletBreak;
    final sidebar = SidebarWidget(
      width: isMobile ? 270 : (isTablet ? _kCompactSidebarWidth : _kSidebarWidth),
      currentPage: _currentPage,
      onPageChange: _navigate,
      onLogout: () {
        _scaffoldKey.currentState?.closeDrawer();
        Navigator.pushReplacementNamed(context, '/');
      },
    );

    Widget contentArea = Column(
      children: [
        _TopNavbar(
          title: _pageTitle,
          showMenu: isMobile,
          onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        Expanded(child: _pageContent),
      ],
    );

    if (isMobile) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: Drawer(
          width: 270,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: sidebar,
        ),
        body: SafeArea(child: contentArea),
      );
    }

    if (isTablet) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Row(
            children: [
              SizedBox(width: _kCompactSidebarWidth, child: sidebar),
              const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              Expanded(child: contentArea),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(width: _kSidebarWidth, child: sidebar),
            Expanded(child: contentArea),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.navbarBg,
        border: Border(
          bottom: BorderSide(color: AppColors.redAccent, width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showMenu) ...[
            GestureDetector(
              onTap: onMenuTap,
              child: const Icon(Icons.menu,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
          ],
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
