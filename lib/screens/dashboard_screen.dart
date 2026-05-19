import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          w < 600 ? 16 : 28,
          w < 600 ? 16 : 28,
          w < 600 ? 16 : 28,
          48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SecurityHero(),
            const SizedBox(height: 28),
            const _SectionLabel('Overview'),
            const SizedBox(height: 14),
            _StatCardsGrid(width: w),
            const SizedBox(height: 32),
            const _SectionLabel('Violation Trends'),
            const SizedBox(height: 14),
            w < 820
                ? Column(
                    children: const [
                      _MonthlyViolationsPanel(),
                      SizedBox(height: 16),
                      _MinorMajorPanel(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(flex: 10, child: _MonthlyViolationsPanel()),
                      SizedBox(width: 14),
                      Expanded(flex: 14, child: _MinorMajorPanel()),
                    ],
                  ),
            const SizedBox(height: 16),
            const _DeptBarChart(),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }
}

class _SecurityHero extends StatelessWidget {
  const _SecurityHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D193F), Color(0xFF08142C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.shield, color: AppColors.accent, size: 32),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Security Operations Center',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Real-time incident visibility and campus compliance monitoring for safer student operations.',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: const [
              _HeroBadge(label: 'Threat Level', value: 'Moderate', color: AppColors.accent),
              _HeroBadge(label: 'Alerts', value: '12 active', color: Color(0xFFF59E0B)),
              _HeroBadge(label: 'Verified Cases', value: '87%', color: AppColors.success),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _HeroBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.muted,
      ),
    );
  }
}

class _StatCardsGrid extends StatelessWidget {
  final double width;
  const _StatCardsGrid({required this.width});

  static const _cards = [
    _StatData(Icons.school_outlined, '1,248', 'Total Students',
        Color(0xFF42A5F5), Color(0xFF112A5C)),
    _StatData(Icons.warning_amber_rounded, '376', 'Violations',
        Color(0xFFEF4444), Color(0xFF3F1B24)),
    _StatData(Icons.security, '54', 'Open Incidents',
        Color(0xFF4FD1C5), Color(0xFF0A2B2F)),
    _StatData(Icons.check_circle_outline, '298', 'Resolved Cases',
        Color(0xFF22C55E), Color(0xFF1C3A2D)),
  ];

  @override
  Widget build(BuildContext context) {
    if (width < 560) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.4,
        children: _cards.map((d) => _StatCard(d)).toList(),
      );
    }
    return Row(
      children: _cards
          .expand((d) => [
                Expanded(child: _StatCard(d)),
                if (d != _cards.last) const SizedBox(width: 14),
              ])
          .toList(),
    );
  }
}

class _StatData {
  final IconData icon;
  final String value, label;
  final Color color, bg;
  const _StatData(this.icon, this.value, this.label, this.color, this.bg);
}

class _StatCard extends StatelessWidget {
  final _StatData d;
  const _StatCard(this.d);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: d.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(d.icon, color: d.color, size: 22),
          ),
          const SizedBox(height: 18),
          Text(d.value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: d.color,
                height: 1,
              )),
          const SizedBox(height: 6),
          Text(d.label,
              style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.muted,
                  height: 1.4)),
        ],
      ),
    );
  }
}

class _ChartPanel extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const _ChartPanel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _MonthlyViolationsPanel extends StatelessWidget {
  const _MonthlyViolationsPanel();

  static const _data = [12, 19, 8, 24, 15, 31, 27, 18, 22, 14, 9, 16];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return const _ChartPanel(
      title: 'Monthly Violations',
      subtitle: 'Recorded violation events per month',
      child: const _BarChart(
        data: _data,
        labels: _months,
        barColor: Color(0xFF4FD1C5),
        chartHeight: 150,
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<int> data;
  final List<String> labels;
  final Color barColor;
  final double chartHeight;

  const _BarChart({
    required this.data,
    required this.labels,
    required this.barColor,
    required this.chartHeight,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final ceil = ((maxVal / 5).ceil() * 5).clamp(5, 999999);
    const gridLines = 5;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          height: chartHeight + 18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(gridLines + 1, (i) {
              final val = (ceil * (gridLines - i) / gridLines).round();
              return Text('$val',
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.muted));
            }),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: chartHeight + 18,
            child: Column(
              children: [
                SizedBox(
                  height: chartHeight,
                  child: Stack(
                    children: [
                      Column(
                        children: List.generate(gridLines + 1, (i) {
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: i == gridLines
                                        ? AppColors.border
                                        : const Color(0xFF102847),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(data.length, (i) {
                          final frac = data[i] / ceil;
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: chartHeight * frac,
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(data.length, (i) {
                    return Expanded(
                      child: Text(
                        labels[i].substring(0, 1),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.muted),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MinorMajorPanel extends StatelessWidget {
  const _MinorMajorPanel();

  @override
  Widget build(BuildContext context) {
    return const _ChartPanel(
      title: 'Minor vs Major',
      subtitle: 'Offense type breakdown — all recorded violations',
      child: const _DonutContent(),
    );
  }
}

class _DonutContent extends StatelessWidget {
  const _DonutContent();

  @override
  Widget build(BuildContext context) {
    const minorCount = 247;
    const majorCount = 129;
    const total = minorCount + majorCount;
    const minorFrac = minorCount / total;
    const chartSize = 140.0;

    return Row(
      children: [
        SizedBox(
          width: chartSize,
          height: chartSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(chartSize, chartSize),
                painter: _DonutPainter(minorFrac),
              ),
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '376',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  Text(
                    'Total',
                    style: TextStyle(
                        fontSize: 10, color: AppColors.muted),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _DonutLegendRow(
                color: Color(0xFF4FD1C5),
                label: 'Minor Offenses',
                count: minorCount,
                fraction: minorFrac,
              ),
              SizedBox(height: 18),
              _DonutLegendRow(
                color: Color(0xFFEF4444),
                label: 'Major Offenses',
                count: majorCount,
                fraction: 1 - minorFrac,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DonutLegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final double fraction;

  const _DonutLegendRow({
    required this.color,
    required this.label,
    required this.count,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Colors.white70)),
            const Spacer(),
            Text('$count',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(builder: (context, c) {
          return Stack(
            children: [
              Container(
                  height: 8,
                  width: c.maxWidth,
                  decoration: BoxDecoration(
                      color: const Color(0xFF0A203B),
                      borderRadius: BorderRadius.circular(6))),
              Container(
                  height: 8,
                  width: c.maxWidth * fraction,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6))),
            ],
          );
        }),
        const SizedBox(height: 6),
        Text('${(fraction * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 11, color: AppColors.muted)),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double minorFrac;
  const _DonutPainter(this.minorFrac);

  @override
  void paint(Canvas canvas, Size size) {
    const strokeW = 20.0;
    const gap = 0.04;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeW) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final minorPaint = Paint()
      ..color = const Color(0xFF4FD1C5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    final majorPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;

    const start = -math.pi / 2;
    final minorSweep = minorFrac * 2 * math.pi - gap;
    final majorSweep = (1 - minorFrac) * 2 * math.pi - gap;

    canvas.drawArc(rect, start, minorSweep, false, minorPaint);
    canvas.drawArc(rect, start + minorSweep + gap, majorSweep, false, majorPaint);
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.minorFrac != minorFrac;
}

class _DeptBarChart extends StatelessWidget {
  const _DeptBarChart();

  static const _sot = [8, 14, 6, 19, 11, 25, 20, 13, 17, 10, 7, 12];
  static const _sob = [5, 9, 4, 12, 8, 16, 14, 9, 11, 7, 4, 8];
  static const _soe = [3, 6, 2, 8, 5, 11, 9, 6, 8, 4, 2, 5];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return const _ChartPanel(
      title: 'Monthly by Department',
      subtitle: 'SOT · SOB · SOE violation breakdown per month',
      child: const _StackedBarChart(
        sot: _sot,
        sob: _sob,
        soe: _soe,
        labels: _months,
        chartHeight: 160,
      ),
    );
  }
}

class _StackedBarChart extends StatelessWidget {
  final List<int> sot, sob, soe;
  final List<String> labels;
  final double chartHeight;

  const _StackedBarChart({
    required this.sot,
    required this.sob,
    required this.soe,
    required this.labels,
    required this.chartHeight,
  });

  @override
  Widget build(BuildContext context) {
    final maxVals = List.generate(
        sot.length, (i) => sot[i] + sob[i] + soe[i]);
    final maxVal = maxVals.reduce((a, b) => a > b ? a : b);
    final ceil = ((maxVal / 5).ceil() * 5).clamp(5, 999999);
    const gridLines = 5;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          height: chartHeight + 18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(gridLines + 1, (i) {
              final val = (ceil * (gridLines - i) / gridLines).round();
              return Text('$val',
                  style: const TextStyle(fontSize: 9, color: AppColors.muted));
            }),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: chartHeight + 18,
            child: Column(
              children: [
                SizedBox(
                  height: chartHeight,
                  child: Stack(
                    children: [
                      Column(
                        children: List.generate(gridLines + 1, (i) {
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: i == gridLines
                                        ? AppColors.border
                                        : const Color(0xFF102847),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(sot.length, (i) {
                          final total = sot[i] + sob[i] + soe[i];
                          final totalFrac = total / ceil;
                          final sotFrac = sot[i] / total;
                          final sobFrac = sob[i] / total;
                          final soeFrac = soe[i] / total;
                          final barH = chartHeight * totalFrac;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: barH,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          height: barH * sotFrac,
                                          decoration: const BoxDecoration(
                                              color: Color(0xFF4FD1C5),
                                              borderRadius: BorderRadius.vertical(
                                                  top: Radius.circular(3)))),
                                      Container(
                                          height: barH * sobFrac,
                                          color: const Color(0xFF22C55E)),
                                      Container(
                                          height: barH * soeFrac,
                                          color: const Color(0xFFF59E0B)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(labels.length, (i) {
                    return Expanded(
                      child: Text(
                        labels[i].substring(0, 1),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.muted),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Removed unused _ChartLegend; consolidated legend UI is handled inline.

