import 'package:flutter/material.dart';

class RiskLevelScreen extends StatelessWidget {
  const RiskLevelScreen({super.key});

  static const _students = [
    _RiskStudent('2024-0001', 'Alcantara, Maria Joy T.', 0, 0),
    _RiskStudent('2024-0042', 'Bautista, Carlo Miguel R.', 2, 0),
    _RiskStudent('2023-0118', 'Cruz, Angelica F.', 3, 1),
    _RiskStudent('2023-0205', 'Dela Rosa, John Paul V.', 5, 2),
    _RiskStudent('2022-0310', 'Fernandez, Kristine Mae A.', 1, 0),
    _RiskStudent('2022-0447', 'Garcia, Renz Oliver B.', 4, 3),
    _RiskStudent('2021-0503', 'Herrera, Sofia Isabelle L.', 2, 1),
    _RiskStudent('2024-0089', 'Ilagan, Luis Rafael C.', 0, 0),
    _RiskStudent('2023-0612', 'Jimenez, Patricia Ann D.', 6, 4),
    _RiskStudent('2022-0731', 'Lim, Kenneth Bryan O.', 3, 0),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            w < 600 ? 16 : 28, w < 600 ? 16 : 28, w < 600 ? 16 : 28, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryRow(students: _students, width: w),
            const SizedBox(height: 24),
            _Legend(),
            const SizedBox(height: 16),
            _RiskTable(students: _students),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }
}

class _RiskStudent {
  final String id, name;
  final int minor, major;
  const _RiskStudent(this.id, this.name, this.minor, this.major);

  String get riskLevel {
    if (major >= 3 || minor >= 5) return 'Critical';
    if (major >= 1 || minor >= 3) return major >= 1 ? 'High' : 'Medium';
    if (minor >= 2) return 'Medium';
    return 'Low';
  }
}

// ── Summary Row ──────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final List<_RiskStudent> students;
  final double width;
  const _SummaryRow({required this.students, required this.width});

  @override
  Widget build(BuildContext context) {
    final low = students.where((s) => s.riskLevel == 'Low').length;
    final medium = students.where((s) => s.riskLevel == 'Medium').length;
    final high = students.where((s) => s.riskLevel == 'High').length;
    final critical = students.where((s) => s.riskLevel == 'Critical').length;

    final cards = [
      _SummaryCard(
        icon: Icons.shield,
        iconBg: const Color(0xFFdde8ff),
        iconColor: const Color(0xFF0000ff),
        value: '$low',
        valueColor: const Color(0xFF0000ff),
        label: 'Low Risk',
      ),
      _SummaryCard(
        icon: Icons.error_outline,
        iconBg: const Color(0xFFd4edda),
        iconColor: const Color(0xFF008000),
        value: '$medium',
        valueColor: const Color(0xFF008000),
        label: 'Medium Risk',
      ),
      _SummaryCard(
        icon: Icons.warning_amber_rounded,
        iconBg: const Color(0xFFfafad2),
        iconColor: const Color(0xFF9b9b00),
        value: '$high',
        valueColor: const Color(0xFF9b9b00),
        label: 'High Risk',
      ),
      _SummaryCard(
        icon: Icons.dangerous,
        iconBg: const Color(0xFFfde8e8),
        iconColor: const Color(0xFFff0303),
        value: '$critical',
        valueColor: const Color(0xFFff0303),
        label: 'Critical',
      ),
    ];

    if (width < 560) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.4,
        children: cards,
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 14),
        Expanded(child: cards[1]),
        const SizedBox(width: 14),
        Expanded(child: cards[2]),
        const SizedBox(width: 14),
        Expanded(child: cards[3]),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor, valueColor;
  final String value, label;

  const _SummaryCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.valueColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFe8edf3)),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                  height: 1)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748b))),
        ],
      ),
    );
  }
}

// ── Legend ───────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: const [
        _LegendItem(color: Color(0xFF0000ff), label: 'Low'),
        _LegendItem(color: Color(0xFF008000), label: 'Medium'),
        _LegendItem(color: Color(0xFFcfcf49), label: 'High'),
        _LegendItem(color: Color(0xFFff0303), label: 'Critical'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 9,
            height: 9,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748b))),
      ],
    );
  }
}

// ── Table ────────────────────────────────────────────────────────────────────

class _RiskTable extends StatelessWidget {
  final List<_RiskStudent> students;
  const _RiskTable({required this.students});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFe8edf3)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
            headingRowColor:
                WidgetStateProperty.all(const Color(0xFFf1f5f9)),
            headingTextStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748b),
                letterSpacing: 0.6),
            dataTextStyle:
                const TextStyle(fontSize: 14, color: Color(0xFF334155)),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('STUDENT ID')),
              DataColumn(label: Text('FULL NAME')),
              DataColumn(label: Text('MINOR TALLY')),
              DataColumn(label: Text('MAJOR TALLY')),
              DataColumn(label: Text('RISK LEVEL')),
            ],
            rows: students.map((s) {
              return DataRow(cells: [
                DataCell(Text(s.id,
                    style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Color(0xFF6366f1),
                        fontWeight: FontWeight.w600))),
                DataCell(Text(s.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1e293b)))),
                DataCell(_TallyBadge(count: s.minor, isMajor: false)),
                DataCell(_TallyBadge(count: s.major, isMajor: true)),
                DataCell(_RiskPill(s.riskLevel)),
              ]);
            }).toList(),
          ),
              ),
            ),
        ),
      );
    });
  }
}

class _TallyBadge extends StatelessWidget {
  final int count;
  final bool isMajor;
  const _TallyBadge({required this.count, required this.isMajor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isMajor ? const Color(0xFFfee2e2) : const Color(0xFFfef9c3),
        border: Border.all(
            color: isMajor
                ? const Color(0xFFfca5a5)
                : const Color(0xFFfde047)),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text('$count',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isMajor
                  ? const Color(0xFFb91c1c)
                  : const Color(0xFFa16207))),
    );
  }
}

class _RiskPill extends StatelessWidget {
  final String level;
  const _RiskPill(this.level);

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border, dot) = switch (level) {
      'Low' => (
          const Color(0xFFdde8ff),
          const Color(0xFF0000cc),
          const Color(0xFF99aaff),
          const Color(0xFF0000ff)
        ),
      'Medium' => (
          const Color(0xFFd4edda),
          const Color(0xFF005700),
          const Color(0xFF6dbf7e),
          const Color(0xFF008000)
        ),
      'High' => (
          const Color(0xFFfafad2),
          const Color(0xFF7a7a00),
          const Color(0xFFcfcf49),
          const Color(0xFFcfcf49)
        ),
      _ => (
          const Color(0xFFfde8e8),
          const Color(0xFFcc0000),
          const Color(0xFFff8080),
          const Color(0xFFff0303)
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 7,
              height: 7,
              decoration:
                  BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(level.toUpperCase(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: fg)),
        ],
      ),
    );
  }
}
