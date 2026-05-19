import 'package:flutter/material.dart';

class DataBackupScreen extends StatefulWidget {
  const DataBackupScreen({super.key});

  @override
  State<DataBackupScreen> createState() => _DataBackupScreenState();
}

class _BRecord {
  final String id, name, dept, riskLevel, status;
  final int minorCount, majorCount;
  final bool hasSig;
  const _BRecord(this.id, this.name, this.dept, this.minorCount,
      this.majorCount, this.riskLevel, this.status, this.hasSig);
}

class _DataBackupScreenState extends State<DataBackupScreen> {
  String _search = '';
  String _dept = '';
  String _risk = '';
  Set<String> _selected = {};

  static const _records = [
    _BRecord('223-09673', 'Juan dela Cruz', 'SOT', 2, 0, 'Low', 'Resolved', true),
    _BRecord('223-10245', 'Maria Santos', 'SOT', 3, 1, 'Medium', 'Sanctioned', true),
    _BRecord('223-08831', 'Carlos Reyes', 'SOE', 3, 3, 'High', 'Sanctioned', false),
    _BRecord('223-11402', 'Ana Gonzales', 'SOE', 1, 0, 'Low', 'Resolved', true),
    _BRecord('223-07758', 'Mark Villanueva', 'SOB', 2, 1, 'Medium', 'Pending', false),
    _BRecord('223-09014', 'Liza Fernandez', 'SOT', 1, 0, 'Low', 'Resolved', true),
    _BRecord('223-12387', 'Rico Mendoza', 'SOB', 3, 3, 'High', 'Pending', false),
    _BRecord('223-10561', 'Claire Pascual', 'SOE', 2, 1, 'Medium', 'Pending', false),
    _BRecord('223-08190', 'Dennis Bautista', 'SOB', 1, 0, 'Low', 'Resolved', true),
    _BRecord('223-11729', 'Patricia Ramos', 'SOE', 3, 3, 'High', 'Sanctioned', true),
  ];

  List<_BRecord> get _filtered => _records.where((r) {
        final q = _search.toLowerCase();
        final mQ = q.isEmpty ||
            r.id.toLowerCase().contains(q) ||
            r.name.toLowerCase().contains(q);
        final mD = _dept.isEmpty || r.dept == _dept;
        final mR = _risk.isEmpty || r.riskLevel == _risk;
        return mQ && mD && mR;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final mobile = constraints.maxWidth < 600;
      final pad = mobile ? 16.0 : 28.0;
      final tableWidth = constraints.maxWidth - pad * 2;
      final filtered = _filtered;
      final selCount = _selected.length;

      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(pad, pad, pad, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionLabel(
              icon: Icons.cloud_download_outlined,
              label: 'Violation Records',
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFe2e8f0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 4,
                      offset: const Offset(0, 1))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 13, 18, 13),
                    child: LayoutBuilder(builder: (context, bc) {
                      final filters = Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _SearchInput(
                              onChanged: (v) =>
                                  setState(() => _search = v)),
                          _SmallDropdown(
                            hint: 'All Depts',
                            items: const ['SOT', 'SOE', 'SOB'],
                            value: _dept,
                            onChanged: (v) =>
                                setState(() => _dept = v),
                          ),
                          _SmallDropdown(
                            hint: 'All Risk',
                            items: const ['Low', 'Medium', 'High'],
                            value: _risk,
                            onChanged: (v) =>
                                setState(() => _risk = v),
                          ),
                        ],
                      );
                      const title = Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_download_outlined,
                              size: 14, color: Color(0xFF3b82f6)),
                          SizedBox(width: 8),
                          Text(
                            'Violation Records',
                            style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1e293b)),
                          ),
                        ],
                      );
                      if (bc.maxWidth < 640) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [title, const SizedBox(height: 10), filters],
                        );
                      }
                      return Row(
                        children: [
                          title,
                          const Spacer(),
                          filters,
                        ],
                      );
                    }),
                  ),
                  const Divider(height: 1, color: Color(0xFFf1f5f9)),
                  filtered.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.inbox_outlined,
                                    size: 32, color: Color(0xFF94a3b8)),
                                SizedBox(height: 10),
                                Text('No records match the current filters.',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF94a3b8))),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: tableWidth),
                            child: DataTable(
                              onSelectAll: (val) => setState(() {
                                _selected = val == true
                                    ? filtered.map((r) => r.id).toSet()
                                    : {};
                              }),
                              headingRowColor:
                                  WidgetStateProperty.all(const Color(0xFFf8fafc)),
                              headingTextStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748b),
                                  letterSpacing: 0.6),
                              dataTextStyle: const TextStyle(
                                  fontSize: 13, color: Color(0xFF1e293b)),
                              columnSpacing: 18,
                              dividerThickness: 1,
                              columns: const [
                                DataColumn(label: Text('STUDENT ID')),
                                DataColumn(label: Text('FULL NAME')),
                                DataColumn(label: Text('DEPT')),
                                DataColumn(label: Text('MINOR')),
                                DataColumn(label: Text('MAJOR')),
                                DataColumn(label: Text('RISK LEVEL')),
                                DataColumn(label: Text('STATUS')),
                                DataColumn(label: Text('E-SIGNATURE')),
                              ],
                              rows: filtered.map((r) {
                                return DataRow(
                                  selected: _selected.contains(r.id),
                                  onSelectChanged: (val) => setState(() {
                                    val == true
                                        ? _selected.add(r.id)
                                        : _selected.remove(r.id);
                                  }),
                                  cells: [
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFf1f5f9),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(r.id,
                                            style: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 11.5,
                                                color: Color(0xFF475569),
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ),
                                    DataCell(Text(r.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF0f172a)))),
                                    DataCell(_DeptPill(r.dept)),
                                    DataCell(_TallyDots(
                                        filled: r.minorCount,
                                        max: 5,
                                        isMajor: false)),
                                    DataCell(_TallyDots(
                                        filled: r.majorCount,
                                        max: 3,
                                        isMajor: true)),
                                    DataCell(_RiskBadge(r.riskLevel)),
                                    DataCell(_StatusBadge(r.status)),
                                    DataCell(r.hasSig
                                        ? const _SigCheck()
                                        : const Text('—',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFFcbd5e1),
                                                fontStyle: FontStyle.italic))),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                  const Divider(height: 1, color: Color(0xFFf1f5f9)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 11, 18, 11),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Wrap(
                          spacing: 7,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFeff6ff),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$selCount',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2563eb)),
                              ),
                            ),
                            const Text('records selected',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF64748b))),
                            if (selCount == 0)
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 13,
                                      color: Color(0xFFef4444)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Select at least one record',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFef4444)),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: selCount > 0 ? () {} : null,
                              icon: const Icon(Icons.download, size: 14),
                              label: const Text('Export CSV',
                                  style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFf3f4f6),
                                foregroundColor: const Color(0xFF374151),
                                disabledBackgroundColor:
                                    const Color(0xFFf3f4f6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9)),
                                textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                                elevation: 0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: selCount > 0 ? () {} : null,
                              icon: const Icon(Icons.download, size: 14),
                              label: const Text('Export XLSX',
                                  style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF22c55e),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                    const Color(0xFF86efac),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9)),
                                textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF3b82f6)),
        const SizedBox(width: 8),
        Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: Color(0xFF94a3b8))),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 8),
              height: 1,
              color: const Color(0xFFe2e8f0)),
        ),
      ],
    );
  }
}

class _SearchInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const _SearchInput({required this.onChanged});

  @override
  State<_SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<_SearchInput> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 32,
      child: TextField(
        controller: _ctrl,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFb0bac7)),
          prefixIcon: const Icon(Icons.search, size: 14, color: Color(0xFFb0bac7)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Color(0xFF3b82f6)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _SmallDropdown extends StatelessWidget {
  final String hint, value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _SmallDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFe2e8f0)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          hint: Text(hint, style: const TextStyle(fontSize: 12)),
          style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v ?? ''),
        ),
      ),
    );
  }
}

class _DeptPill extends StatelessWidget {
  final String dept;
  const _DeptPill(this.dept);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFeff6ff),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(dept,
          style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2563eb))),
    );
  }
}

class _TallyDots extends StatelessWidget {
  final int filled, max;
  final bool isMajor;
  const _TallyDots({
    required this.filled,
    required this.max,
    required this.isMajor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < max; i++) ...[
          if (i > 0) const SizedBox(width: 3),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: i < filled
                  ? (isMajor ? const Color(0xFFef4444) : const Color(0xFFf59e0b))
                  : (isMajor ? const Color(0xFFfee2e2) : const Color(0xFFfef3c7)),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}

class _RiskBadge extends StatelessWidget {
  final String level;
  const _RiskBadge(this.level);

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (level) {
      'Low' => (const Color(0xFFf0fdf4), const Color(0xFF166534)),
      'Medium' => (const Color(0xFFfffbeb), const Color(0xFF92400e)),
      _ => (const Color(0xFFfef2f2), const Color(0xFF991b1b)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(level,
          style:
              TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'Pending' => (
          const Color(0xFff0f9ff),
          const Color(0xFF0369a1)
        ),
      'Resolved' => (
          const Color(0xFFf0fdf4),
          const Color(0xFF15803d)
        ),
      _ => (const Color(0xFFfdf4ff), const Color(0xFF7e22ce)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(status,
          style:
              TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _SigCheck extends StatelessWidget {
  const _SigCheck();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFdcfce7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 13, color: Color(0xFF22c55e)),
          SizedBox(width: 4),
          Text('Signed',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF15803d))),
        ],
      ),
    );
  }
}
