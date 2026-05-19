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
  final AppPage currentPage;
  final ValueChanged<AppPage> onPageChange;
  final VoidCallback onLogout;

  const SidebarWidget({
    super.key,
    required this.currentPage,
    required this.onPageChange,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const _SidebarHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _SectionLabel('Overview'),
                  _SidebarItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    page: AppPage.dashboard,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.dashboard),
                  ),
                  _SectionLabel('Students'),
                  _SidebarItem(
                    icon: Icons.school_outlined,
                    label: 'Student Records',
                    page: AppPage.studentRecords,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.studentRecords),
                  ),
                  _SidebarItem(
                    icon: Icons.history_edu,
                    label: 'Violation History',
                    page: AppPage.violationHistory,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.violationHistory),
                  ),
                  _SectionLabel('Discipline'),
                  _SidebarItem(
                    icon: Icons.gavel_outlined,
                    label: 'Disciplinary Actions',
                    page: AppPage.disciplinaryAction,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.disciplinaryAction),
                  ),
                  _SidebarItem(
                    icon: Icons.shield_rounded,
                    label: 'Risk Level Indicator',
                    page: AppPage.riskLevel,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.riskLevel),
                  ),
                  _SectionLabel('Backup & Reports'),
                  _SidebarItem(
                    icon: Icons.backup_outlined,
                    label: 'Data Backup',
                    page: AppPage.dataBackup,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.dataBackup),
                  ),
                  _SidebarItem(
                    icon: Icons.upload_file_outlined,
                    label: 'Import Data',
                    page: AppPage.importData,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.importData),
                  ),
                  _SectionLabel('System'),
                  _SidebarItem(
                    icon: Icons.person_outline,
                    label: 'Jassu Users',
                    page: AppPage.jassuUsers,
                    currentPage: currentPage,
                    onTap: () => onPageChange(AppPage.jassuUsers),
                  ),
                  const SizedBox(height: 20),
                  _LogoutItem(onTap: onLogout),
                  const SizedBox(height: 20),
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
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.sidebarHeaderBg,
        border: Border(bottom: BorderSide(color: AppColors.accent, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: ClipOval(
              child: Image.asset(
                'images/mccLogo.png',
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) =>
                    const Icon(Icons.shield, size: 32, color: AppColors.accent),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Security HQ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'MCC Violation Control',
                  style: TextStyle(color: AppColors.muted, fontSize: 11),
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.muted,
          letterSpacing: 1.2,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(color: AppColors.accent.withOpacity(0.6), width: 1)
              : Border.all(color: Colors.transparent),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? AppColors.accent : AppColors.muted,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isActive ? Colors.white : AppColors.muted,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
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
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: const [
            Icon(Icons.logout, size: 18, color: AppColors.redAccent),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(fontSize: 14, color: AppColors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
