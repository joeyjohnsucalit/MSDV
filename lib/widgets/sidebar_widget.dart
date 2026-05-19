import 'package:flutter/material.dart';
import '../app_colors.dart';

enum AppPage {
  dashboard,
  studentRecords,
  violationHistory,
  disciplinaryAction,
  riskLevel,
  dataBackup,
  importData,
  jassuUsers,
}

class SidebarWidget extends StatelessWidget {
  final double width;
  final AppPage currentPage;
  final ValueChanged<AppPage> onPageChange;
  final VoidCallback onLogout;

  const SidebarWidget({
    super.key,
    this.width = 270,
    required this.currentPage,
    required this.onPageChange,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _SidebarHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel('Overview'),
                  _SidebarItem(
                    icon: Icons.show_chart,
                    label: 'Dashboard',
                    page: AppPage.dashboard,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.dashboard),
                  ),
                  _SectionLabel('Students'),
                  _SidebarItem(
                    icon: Icons.school,
                    label: 'Student Records',
                    page: AppPage.studentRecords,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.studentRecords),
                  ),
                  _SidebarItem(
                    icon: Icons.history,
                    label: 'Violation History',
                    page: AppPage.violationHistory,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.violationHistory),
                  ),
                  _SectionLabel('Discipline'),
                  _SidebarItem(
                    icon: Icons.gavel,
                    label: 'Disciplinary Actions',
                    page: AppPage.disciplinaryAction,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.disciplinaryAction),
                  ),
                  _SidebarItem(
                    icon: Icons.warning_amber_rounded,
                    label: 'Risk Level Indicator',
                    page: AppPage.riskLevel,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.riskLevel),
                  ),
                  _SectionLabel('Backup & Reports'),
                  _SidebarItem(
                    icon: Icons.cloud_download,
                    label: 'Data Backup',
                    page: AppPage.dataBackup,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.dataBackup),
                  ),
                  _SidebarItem(
                    icon: Icons.upload_file,
                    label: 'Import Data',
                    page: AppPage.importData,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.importData),
                  ),
                  _SectionLabel('System'),
                  _SidebarItem(
                    icon: Icons.person,
                    label: 'Jassu User',
                    page: AppPage.jassuUsers,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.jassuUsers),
                  ),
                  _LogoutItem(onTap: onLogout),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.sidebarHeaderBg,
        border: Border(
          bottom: BorderSide(color: AppColors.redAccent, width: 5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.asset(
                'images/mccLogo.png',
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => const Icon(
                  Icons.school,
                  size: 32,
                  color: Color(0xFF030357),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'MCC Student Violation System',
                  style: TextStyle(color: Color(0xFF959799), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF796d00),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppPage page;
  final AppPage currentPage;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.page,
    required this.currentPage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = page == currentPage;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isActive ? const Color(0x22383838) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: isActive
              ? const Border(
                  left: BorderSide(color: Color(0xFFbd0505), width: 4),
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(isActive ? 12 : 16, 13, 16, 13),
          child: Row(
            children: [
              Icon(icon, size: 17, color: Colors.black87),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutItem extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          child: Row(
            children: const [
              Icon(Icons.logout, size: 17, color: Colors.black87),
              SizedBox(width: 8),
              Text('Log Out', style: TextStyle(fontSize: 14, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
