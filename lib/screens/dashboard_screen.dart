import 'dart:math' as math;
import 'package:flutter/material.dart';

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
            _SectionLabel('Overview'),
            const SizedBox(height: 14),
            _StatCardsGrid(width: w),
            const SizedBox(height: 32),
            _SectionLabel('Violation Trends'),
            const SizedBox(height: 14),
            w < 820
                ? Column(
                    children: [
                      _MonthlyViolationsPanel(),
                      const SizedBox(height: 16),
                      _MinorMajorPanel(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 10, child: _MonthlyViolationsPanel()),
                      const SizedBox(width: 14),
                      Expanded(flex: 14, child: _MinorMajorPanel()),
                    ],
                  ),
            const SizedBox(height: 16),
            _DeptBarChart(),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────

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
        color: Color(0xFF94a3b8),
      ),
    );
  }
}

// ── Stat Cards ────────────────────────────────────────────────────────────────

class _StatCardsGrid extends StatelessWidget {
  final double width;
  const _StatCardsGrid({required this.width});

  static const _cards = [
    _StatData(Icons.school_outlined, '1,248', 'Total Students',
        Color(0xFF3b82f6), Color(0xFFdbeafe)),
    _StatData(Icons.warning_amber_rounded, '376', 'Total Violations',
        Color(0xFFef4444), Color(0xFFfee2e2)),
    _StatData(Icons.access_time_rounded, '54', 'Pending Actions',
        Color(0xFFf59e0b), Color(0xFFfef3c7)),
    _StatData(Icons.check_circle_outline, '298', 'Completed Cases',
        Color(0xFF22c55e), Color(0xFFdcfce7)),
  ];

  @override
  Widget build(BuildContext context) {
    if (width < 560) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.55,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFe2e8f0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: d.bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(d.icon, color: d.color, size: 19),
          ),
          const SizedBox(height: 12),
          Text(d.value,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: d.color,
                  height: 1)),
          const SizedBox(height: 4),
          Text(d.label,
              style: const TextStyle(
                  fontSize: 11.5, color: Color(0xFF64748b))),
        ],
      ),
    );
  }
}

// ── Chart Panel Shell ─────────────────────────────────────────────────────────

class _ChartPanel extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const _ChartPanel(
      {required this.title,
      required this.subtitle,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFe2e8f0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(9),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1a1d2e))),
          const SizedBox(height: 2),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF94a3b8))),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

// ── Monthly Violations Bar Chart ──────────────────────────────────────────────

class _MonthlyViolationsPanel extends StatelessWidget {
  static const _data = [12, 19, 8, 24, 15, 31, 27, 18, 22, 14, 9, 16];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return _ChartPanel(
      title: 'Monthly Violations',
      subtitle: 'Recorded violation events per month',
      child: _BarChart(
        data: _data,
        labels: _months,
        barColor: const Color(0xFF3b5bdb),
        chartHeight: 140,
      ),
    );
  }
}

// ── Reusable Bar Chart with Grid Lines ────────────────────────────────────────

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
        // Y-axis labels
        SizedBox(
          width: 28,
          height: chartHeight + 18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(gridLines + 1, (i) {
              final val = (ceil * (gridLines - i) / gridLines).round();
              return Text('$val',
                  style: const TextStyle(
                      fontSize: 8.5, color: Color(0xFF94a3b8)));
            }),
          ),
        ),
        const SizedBox(width: 4),
        // Chart area
        Expanded(
          child: SizedBox(
            height: chartHeight + 18,
            child: Column(
              children: [
                // Bars + grid
                SizedBox(
                  height: chartHeight,
                  child: Stack(
                    children: [
                      // Grid lines
                      Column(
                        children: List.generate(gridLines + 1, (i) {
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: i == gridLines
                                        ? const Color(0xFFcbd5e1)
                                        : const Color(0xFFf1f5f9),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      // Bars
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(data.length, (i) {
                          final frac = data[i] / ceil;
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: chartHeight * frac,
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(3)),
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
                // X-axis labels
                const SizedBox(height: 4),
                Row(
                  children: List.generate(data.length, (i) {
                    return Expanded(
                      child: Text(
                        labels[i].substring(0, 1),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 9, color: Color(0xFF94a3b8)),
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

// ── Minor vs Major Donut Chart ────────────────────────────────────────────────

class _MinorMajorPanel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return _ChartPanel(
      title: 'Minor vs Major',
      subtitle: 'Offense type breakdown — all recorded violations',
      child: _DonutContent(),
    );
  }
}

class _DonutContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const minorCount = 247;
    const majorCount = 129;
    const total = minorCount + majorCount;
    const minorFrac = minorCount / total;
    const chartSize = 130.0;

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
                    '$total',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1e293b)),
                  ),
                  Text(
                    'Total',
                    style: TextStyle(
                        fontSize: 10, color: Color(0xFF94a3b8)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DonutLegendRow(
                color: Color(0xFF2563eb),
                label: 'Minor Offenses',
                count: minorCount,
                fraction: minorFrac,
              ),
              SizedBox(height: 16),
              _DonutLegendRow(
                color: Color(0xFFdc2626),
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
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF374151))),
            const Spacer(),
            Text('$count',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(builder: (context, c) {
          return Stack(
            children: [
              Container(
                  height: 7,
                  width: c.maxWidth,
                  decoration: BoxDecoration(
                      color: const Color(0xFFf1f5f9),
                      borderRadius: BorderRadius.circular(4))),
              Container(
                  height: 7,
                  width: c.maxWidth * fraction,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4))),
            ],
          );
        }),
        const SizedBox(height: 3),
        Text('${(fraction * 100).toStringAsFixed(1)}%',
            style: const TextStyle(
                fontSize: 10, color: Color(0xFF94a3b8))),
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
      ..color = const Color(0xFF2563eb)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    final majorPaint = Paint()
      ..color = const Color(0xFFdc2626)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    const start = -math.pi / 2;
    final minorSweep = minorFrac * 2 * math.pi - gap;
    final majorSweep = (1 - minorFrac) * 2 * math.pi - gap;

    canvas.drawArc(rect, start, minorSweep, false, minorPaint);
    canvas.drawArc(
        rect, start + minorSweep + gap, majorSweep, false, majorPaint);
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.minorFrac != minorFrac;
}

// ── Department Stacked Bar Chart ──────────────────────────────────────────────

class _DeptBarChart extends StatelessWidget {
  static const _sot = [8, 14, 6, 19, 11, 25, 20, 13, 17, 10, 7, 12];
  static const _sob = [5, 9, 4, 12, 8, 16, 14, 9, 11, 7, 4, 8];
  static const _soe = [3, 6, 2, 8, 5, 11, 9, 6, 8, 4, 2, 5];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return _ChartPanel(
      title: 'Monthly by Department',
      subtitle: 'SOT · SOB · SOE violation breakdown per month',
      child: Column(
        children: [
          _StackedBarChart(
            sot: _sot,
            sob: _sob,
            soe: _soe,
            labels: _months,
            chartHeight: 140,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _ChartLegend(color: Color(0xFF3b5bdb), label: 'SOT'),
              SizedBox(width: 20),
              _ChartLegend(color: Color(0xFF10b981), label: 'SOB'),
              SizedBox(width: 20),
              _ChartLegend(color: Color(0xFFf59e0b), label: 'SOE'),
            ],
          ),
        ],
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
        // Y-axis
        SizedBox(
          width: 28,
          height: chartHeight + 18,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(gridLines + 1, (i) {
              final val =
                  (ceil * (gridLines - i) / gridLines).round();
              return Text('$val',
                  style: const TextStyle(
                      fontSize: 8.5, color: Color(0xFF94a3b8)));
            }),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: SizedBox(
            height: chartHeight + 18,
            child: Column(
              children: [
                SizedBox(
                  height: chartHeight,
                  child: Stack(
                    children: [
                      // Grid lines
                      Column(
                        children: List.generate(gridLines + 1, (i) {
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: i == gridLines
                                        ? const Color(0xFFcbd5e1)
                                        : const Color(0xFFf1f5f9),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      // Stacked bars
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(sot.length, (i) {
                          final total =
                              sot[i] + sob[i] + soe[i];
                          final totalFrac = total / ceil;
                          final sotFrac = sot[i] / total;
                          final sobFrac = sob[i] / total;
                          final soeFrac = soe[i] / total;
                          final barH = chartHeight * totalFrac;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: barH,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          height: barH * sotFrac,
                                          decoration: BoxDecoration(
                                              color: const Color(
                                                  0xFF3b5bdb),
                                              borderRadius:
                                                  const BorderRadius
                                                      .vertical(
                                                      top: Radius
                                                          .circular(
                                                              2)))),
                                      Container(
                                          height: barH * sobFrac,
                                          color: const Color(
                                              0xFF10b981)),
                                      Container(
                                          height: barH * soeFrac,
                                          color: const Color(
                                              0xFFf59e0b)),
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
                const SizedBox(height: 4),
                Row(
                  children: List.generate(labels.length, (i) {
                    return Expanded(
                      child: Text(
                        labels[i].substring(0, 1),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF94a3b8)),
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

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF6b7280))),
      ],
    );
  }
}
