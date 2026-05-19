import 'package:flutter/material.dart';
import '../app_colors.dart';

class JassuDashboardScreen extends StatelessWidget {
  const JassuDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('JASSU DASHBOARD',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.muted,
              )),
          const SizedBox(height: 14),
          const Text('Welcome, Jassu Officer',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              )),
          const SizedBox(height: 6),
          const Text('Your assigned cases and quick actions.',
              style: TextStyle(fontSize: 14, color: AppColors.muted)),
          const SizedBox(height: 24),
          Wrap(
            runSpacing: 16,
            spacing: 16,
            children: const [
              _MetricCard(
                title: 'Assigned Cases',
                value: '12',
                subtitle: 'Active violation reports assigned to you',
                color: Color(0xFF3B82F6),
              ),
              _MetricCard(
                title: 'Pending Review',
                value: '5',
                subtitle: 'Reports waiting for your feedback',
                color: Color(0xFFF59E0B),
              ),
              _MetricCard(
                title: 'Resolved Today',
                value: '3',
                subtitle: 'Cases you closed today',
                color: Color(0xFF10B981),
              ),
              _MetricCard(
                title: 'Compliance',
                value: '87%',
                subtitle: 'Student conduct compliance rate',
                color: Color(0xFF6366F1),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text('Recent Activities',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87)),
          const SizedBox(height: 12),
          Column(
            children: const [
              _ActivityTile(
                title: 'Reviewed case #214',
                subtitle: 'Updated report status to Pending Review.',
                icon: Icons.edit,
              ),
              _ActivityTile(
                title: 'Added note to case #198',
                subtitle: 'Recorded follow-up actions with student.',
                icon: Icons.note_add,
              ),
              _ActivityTile(
                title: 'Closed case #172',
                subtitle: 'Resolved incident after mediation.',
                icon: Icons.check_circle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted)),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: color)),
          const SizedBox(height: 10),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 12)),
      ),
    );
  }
}
