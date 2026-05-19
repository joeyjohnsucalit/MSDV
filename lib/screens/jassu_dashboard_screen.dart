import 'package:flutter/material.dart';
import '../app_colors.dart';

class JassuDashboardScreen extends StatefulWidget {
  const JassuDashboardScreen({super.key});

  @override
  State<JassuDashboardScreen> createState() => _JassuDashboardScreenState();
}

class _JassuDashboardScreenState extends State<JassuDashboardScreen> {
  final _studentIdCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _violationCtrl = TextEditingController();
  String _violationType = 'Minor';
  final List<_ViolationEntry> _submissions = [];

  void _submitViolation() {
    if (_studentIdCtrl.text.isEmpty || _fullNameCtrl.text.isEmpty || _violationCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Color(0xFFb40404),
        ),
      );
      return;
    }

    setState(() {
      _submissions.insert(
        0,
        _ViolationEntry(
          studentId: _studentIdCtrl.text,
          fullName: _fullNameCtrl.text,
          violation: _violationCtrl.text,
          type: _violationType,
          timestamp: DateTime.now(),
        ),
      );
      _studentIdCtrl.clear();
      _fullNameCtrl.clear();
      _violationCtrl.clear();
      _violationType = 'Minor';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Violation recorded successfully'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

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
          const Text('Welcome, Security Guard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              )),
          const SizedBox(height: 6),
          const Text('Report student violations and monitor compliance.',
              style: TextStyle(fontSize: 14, color: AppColors.muted)),
          const SizedBox(height: 28),
          // ── Violation Input Form ──────────────────────────────────────────────
          Container(
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Report Student Violation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 6),
                const Text('Enter the student details and violation information',
                    style: TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 18),
                // Student ID
                const Text('Student ID Number',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 8),
                TextField(
                  controller: _studentIdCtrl,
                  decoration: InputDecoration(
                    hintText: 'e.g., 223-09673',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 16),
                // Full Name
                const Text('Student Full Name',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 8),
                TextField(
                  controller: _fullNameCtrl,
                  decoration: InputDecoration(
                    hintText: 'e.g., Juan dela Cruz',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 16),
                // Violation Type
                const Text('Violation Type',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _violationType,
                  onChanged: (value) {
                    setState(() => _violationType = value ?? 'Minor');
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Minor', child: Text('Minor Violation')),
                    DropdownMenuItem(value: 'Major', child: Text('Major Violation')),
                  ],
                ),
                const SizedBox(height: 16),
                // Violation Description
                const Text('Violation Description',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 8),
                TextField(
                  controller: _violationCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe the violation in detail...',
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitViolation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF030357),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Submit Violation Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // ── Quick Stats ───────────────────────────────────────────────────────
          const Text('Quick Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              )),
          const SizedBox(height: 12),
          Wrap(
            runSpacing: 12,
            spacing: 12,
            children: const [
              _StatCard(
                title: 'Violations Today',
                value: '12',
                color: Color(0xFF3B82F6),
              ),
              _StatCard(
                title: 'Pending Review',
                value: '5',
                color: Color(0xFFF59E0B),
              ),
              _StatCard(
                title: 'Resolved',
                value: '3',
                color: Color(0xFF10B981),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // ── Recent Submissions ────────────────────────────────────────────────
          if (_submissions.isNotEmpty) ...[
            const Text('Recent Submissions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                )),
            const SizedBox(height: 12),
            Column(
              children: _submissions.map((entry) => _SubmissionCard(entry: entry)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _studentIdCtrl.dispose();
    _fullNameCtrl.dispose();
    _violationCtrl.dispose();
    super.dispose();
  }
}

class _ViolationEntry {
  final String studentId;
  final String fullName;
  final String violation;
  final String type;
  final DateTime timestamp;

  _ViolationEntry({
    required this.studentId,
    required this.fullName,
    required this.violation,
    required this.type,
    required this.timestamp,
  });
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              )),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: color,
              )),
        ],
      ),
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  final _ViolationEntry entry;

  const _SubmissionCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${entry.fullName} (${entry.studentId})',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        )),
                    const SizedBox(height: 4),
                    Text(entry.violation,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: entry.type == 'Major'
                      ? const Color(0xFFEF4444).withOpacity(0.1)
                      : const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  entry.type,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: entry.type == 'Major'
                        ? const Color(0xFFEF4444)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Submitted: ${entry.timestamp.toString().substring(0, 16)}',
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
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
