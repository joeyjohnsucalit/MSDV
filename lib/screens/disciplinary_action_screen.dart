import 'package:flutter/material.dart';

class DisciplinaryActionScreen extends StatefulWidget {
  const DisciplinaryActionScreen({super.key});

  @override
  State<DisciplinaryActionScreen> createState() =>
      _DisciplinaryActionScreenState();
}

class _DisciplinaryActionScreenState extends State<DisciplinaryActionScreen> {
  String _search = '';
  String _status = '';

  static const _actions = [
    _DARecord(
      '223-08831',
      'Carlos Reyes',
      'Suspension — 5 days',
      '2025-01-27',
      '2025-01-31',
      'Completed',
    ),
    _DARecord(
      '223-08831',
      'Carlos Reyes',
      'Written Warning & Parent Meeting',
      '2025-03-03',
      '2025-03-03',
      'Completed',
    ),
    _DARecord(
      '223-08831',
      'Carlos Reyes',
      'Suspension — 10 days (pending expulsion review)',
      '2025-04-14',
      '2025-04-25',
      'Active',
    ),
    _DARecord(
      '223-12387',
      'Rico Mendoza',
      'Confiscation & Written Warning',
      '2025-02-03',
      '2025-02-03',
      'Completed',
    ),
    _DARecord(
      '223-12387',
      'Rico Mendoza',
      'Suspension — 7 days',
      '2025-03-10',
      '2025-03-17',
      'Completed',
    ),
    _DARecord(
      '223-12387',
      'Rico Mendoza',
      'Suspension — 10 days & Counseling',
      '2025-04-21',
      '2025-05-02',
      'Pending',
    ),
    _DARecord(
      '223-11729',
      'Patricia Ramos',
      'Written Warning & Counseling',
      '2025-01-20',
      '2025-01-20',
      'Completed',
    ),
    _DARecord(
      '223-11729',
      'Patricia Ramos',
      'Suspension — 5 days',
      '2025-02-24',
      '2025-02-28',
      'Active',
    ),
    _DARecord(
      '223-11729',
      'Patricia Ramos',
      'Suspension — 10 days & Parent Conference',
      '2025-04-07',
      '2025-04-17',
      'Pending',
    ),
    _DARecord(
      '223-10245',
      'Maria Santos',
      'Academic Integrity Warning & Zero on Exam',
      '2025-04-05',
      '2025-04-05',
      'Active',
    ),
    _DARecord(
      '223-07758',
      'Mark Villanueva',
      'Community Service — 8 hours & Repair of Damages',
      '2025-04-02',
      '2025-04-09',
      'Pending',
    ),
    _DARecord(
      '223-10561',
      'Claire Pascual',
      'Suspension — 3 days & Mandatory Counseling',
      '2025-04-16',
      '2025-04-18',
      'Pending',
    ),
  ];

  List<_DARecord> get _filtered => _actions.where((r) {
    final q = _search.toLowerCase();
    final mQ =
        q.isEmpty ||
        r.id.toLowerCase().contains(q) ||
        r.student.toLowerCase().contains(q);
    final mS = _status.isEmpty || r.status == _status;
    return mQ && mS;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 600;
        return SingleChildScrollView(
          padding: EdgeInsets.all(mobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FilterBar(
                onSearch: (v) => setState(() => _search = v),
                onStatus: (v) => setState(() => _status = v),
              ),
              const SizedBox(height: 16),
              _DATable(
                records: _filtered,
                availableWidth: constraints.maxWidth - (mobile ? 32 : 48),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DARecord {
  final String id, student, sanction, start, end, status;
  const _DARecord(
    this.id,
    this.student,
    this.sanction,
    this.start,
    this.end,
    this.status,
  );
}

// ── Filter Bar ───────────────────────────────────────────────────────────────

class _FilterBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onStatus;

  const _FilterBar({required this.onSearch, required this.onStatus});

  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 260,
          height: 38,
          child: TextField(
            controller: _ctrl,
            onChanged: widget.onSearch,
            decoration: InputDecoration(
              hintText: 'Search by name or student ID...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFFb0bac7),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 16,
                color: Color(0xFFb0bac7),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFF3b82f6)),
              ),
            ),
          ),
        ),
        _InlineDropdown(
          hint: 'All Status',
          items: const ['Active', 'Completed', 'Pending', 'Lifted'],
          onChanged: widget.onStatus,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}

class _InlineDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _InlineDropdown({
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  State<_InlineDropdown> createState() => _InlineDropdownState();
}

class _InlineDropdownState extends State<_InlineDropdown> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFd1d5db)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _value,
          hint: Text(
            widget.hint,
            style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
          ),
          style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
          items: [
            DropdownMenuItem(value: '', child: Text(widget.hint)),
            ...widget.items.map(
              (e) => DropdownMenuItem(value: e, child: Text(e)),
            ),
          ],
          onChanged: (v) {
            setState(() => _value = (v?.isEmpty == true) ? null : v);
            widget.onChanged(v ?? '');
          },
        ),
      ),
    );
  }
}

// ── Table ────────────────────────────────────────────────────────────────────

class _DATable extends StatelessWidget {
  final List<_DARecord> records;
  final double availableWidth;
  const _DATable({required this.records, required this.availableWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFe5e7eb)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: availableWidth),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFf9fafb)),
            headingTextStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6b7280),
              letterSpacing: 0.5,
            ),
            dataTextStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
            ),
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text('STUDENT ID')),
              DataColumn(label: Text('STUDENT')),
              DataColumn(label: Text('SANCTION')),
              DataColumn(label: Text('START DATE')),
              DataColumn(label: Text('END DATE')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('UPDATE')),
            ],
            rows: records.map((r) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      r.id,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Color(0xFF6b7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      r.student,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 260,
                      child: Text(
                        r.sanction,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      r.start,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6b7280),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      r.end,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6b7280),
                      ),
                    ),
                  ),
                  DataCell(_StatusBadge(r.status)),
                  DataCell(
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, size: 13),
                      label: const Text(
                        'Update',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF030357),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (status) {
      'Active' => (
        const Color(0xFFdbeafe),
        const Color(0xFF1e40af),
        const Color(0xFFbfdbfe),
      ),
      'Completed' => (
        const Color(0xFFd1fae5),
        const Color(0xFF065f46),
        const Color(0xFFa7f3d0),
      ),
      'Lifted' => (
        const Color(0xFFf3f4f6),
        const Color(0xFF6b7280),
        const Color(0xFFe5e7eb),
      ),
      _ => (
        const Color(0xFFfef3c7),
        const Color(0xFF92400e),
        const Color(0xFFfde68a),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
