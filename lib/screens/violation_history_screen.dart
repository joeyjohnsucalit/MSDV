import 'package:flutter/material.dart';

class ViolationHistoryScreen extends StatefulWidget {
  const ViolationHistoryScreen({super.key});

  @override
  State<ViolationHistoryScreen> createState() => _ViolationHistoryScreenState();
}

class _ViolationHistoryScreenState extends State<ViolationHistoryScreen> {
  String _search = '';
  String _type = '';
  String _status = '';

  static const _records = [
    _VRecord('223-09673', 'Juan dela Cruz', 'Minor', 'Failure to wear ID', '2025-01-08', 2, 5, false, 'Completed'),
    _VRecord('223-09673', 'Juan dela Cruz', 'Minor', 'Late to class', '2025-02-19', 2, 5, false, 'Completed'),
    _VRecord('223-10245', 'Maria Santos', 'Minor', 'Improper uniform', '2025-01-10', 3, 5, false, 'Completed'),
    _VRecord('223-10245', 'Maria Santos', 'Minor', 'Using phone during class', '2025-02-03', 3, 5, false, 'Ongoing'),
    _VRecord('223-10245', 'Maria Santos', 'Minor', 'Noisy in hallway', '2025-03-15', 3, 5, false, 'Pending'),
    _VRecord('223-10245', 'Maria Santos', 'Major', 'Cheating / academic dishonesty', '2025-04-02', 1, 3, false, 'Ongoing'),
    _VRecord('223-08831', 'Carlos Reyes', 'Major', 'Fighting / physical altercation', '2025-01-22', 3, 3, true, 'Completed'),
    _VRecord('223-08831', 'Carlos Reyes', 'Major', 'Threats or intimidation', '2025-02-28', 3, 3, true, 'Ongoing'),
    _VRecord('223-08831', 'Carlos Reyes', 'Major', 'Bullying', '2025-04-10', 3, 3, true, 'Pending'),
    _VRecord('223-11402', 'Ana Gonzales', 'Minor', 'Littering', '2025-03-04', 1, 5, false, 'Completed'),
    _VRecord('223-07758', 'Mark Villanueva', 'Minor', 'Absence without excuse', '2025-01-17', 2, 5, false, 'Completed'),
    _VRecord('223-07758', 'Mark Villanueva', 'Minor', 'Disrespectful language', '2025-02-25', 2, 5, false, 'Ongoing'),
    _VRecord('223-07758', 'Mark Villanueva', 'Major', 'Vandalism of school property', '2025-03-30', 1, 3, false, 'Pending'),
    _VRecord('223-09014', 'Liza Fernandez', 'Minor', 'Running in corridors', '2025-02-11', 1, 5, false, 'Completed'),
    _VRecord('223-12387', 'Rico Mendoza', 'Major', 'Possession of prohibited items', '2025-01-30', 3, 3, true, 'Ongoing'),
    _VRecord('223-12387', 'Rico Mendoza', 'Major', 'Substance use or possession', '2025-03-07', 3, 3, true, 'Pending'),
    _VRecord('223-12387', 'Rico Mendoza', 'Major', 'Theft', '2025-04-18', 3, 3, true, 'Pending'),
    _VRecord('223-10561', 'Claire Pascual', 'Minor', 'Vandalism (minor)', '2025-02-06', 2, 5, false, 'Completed'),
    _VRecord('223-10561', 'Claire Pascual', 'Minor', 'Late to class', '2025-03-21', 2, 5, false, 'Ongoing'),
    _VRecord('223-10561', 'Claire Pascual', 'Major', 'Sexual harassment', '2025-04-14', 1, 3, false, 'Pending'),
    _VRecord('223-08190', 'Dennis Bautista', 'Minor', 'Failure to wear ID', '2025-01-29', 1, 5, false, 'Completed'),
    _VRecord('223-11729', 'Patricia Ramos', 'Major', 'Threats or intimidation', '2025-01-15', 3, 3, true, 'Completed'),
    _VRecord('223-11729', 'Patricia Ramos', 'Major', 'Bullying', '2025-02-20', 3, 3, true, 'Ongoing'),
    _VRecord('223-11729', 'Patricia Ramos', 'Major', 'Fighting / physical altercation', '2025-04-05', 3, 3, true, 'Pending'),
  ];

  List<_VRecord> get _filtered => _records.where((r) {
        final q = _search.toLowerCase();
        final mQ = q.isEmpty ||
            r.id.toLowerCase().contains(q) ||
            r.name.toLowerCase().contains(q);
        final mT = _type.isEmpty || r.type == _type;
        final mS = _status.isEmpty || r.status == _status;
        return mQ && mT && mS;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _FilterBar(
            onSearch: (v) => setState(() => _search = v),
            onType: (v) => setState(() => _type = v),
            onStatus: (v) => setState(() => _status = v),
          ),
          const SizedBox(height: 16),
          _ViolationTable(records: _filtered),
        ],
      ),
    );
  }
}

class _VRecord {
  final String id, name, type, violation, date, status;
  final int tally, maxTally;
  final bool isMax;

  const _VRecord(this.id, this.name, this.type, this.violation, this.date,
      this.tally, this.maxTally, this.isMax, this.status);
}

// ── Filter Bar ───────────────────────────────────────────────────────────────

class _FilterBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onType;
  final ValueChanged<String> onStatus;

  const _FilterBar({
    required this.onSearch,
    required this.onType,
    required this.onStatus,
  });

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
                  fontSize: 13, color: Color(0xFFb0bac7)),
              prefixIcon: const Icon(Icons.search,
                  size: 16, color: Color(0xFFb0bac7)),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          hint: 'All Types',
          items: const ['Minor', 'Major'],
          onChanged: widget.onType,
        ),
        _InlineDropdown(
          hint: 'All Status',
          items: const ['Pending', 'Ongoing', 'Completed'],
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
          hint: Text(widget.hint,
              style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
          style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
          items: [
            DropdownMenuItem(value: '', child: Text(widget.hint)),
            ...widget.items.map(
                (e) => DropdownMenuItem(value: e, child: Text(e))),
          ],
          onChanged: (v) {
            setState(() => _value = v?.isEmpty == true ? null : v);
            widget.onChanged(v ?? '');
          },
        ),
      ),
    );
  }
}

// ── Table ────────────────────────────────────────────────────────────────────

class _ViolationTable extends StatelessWidget {
  final List<_VRecord> records;
  const _ViolationTable({required this.records});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFe5e7eb)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 4,
              offset: const Offset(0, 1))
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFf9fafb)),
          headingTextStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6b7280),
              letterSpacing: 0.5),
          dataTextStyle:
              const TextStyle(fontSize: 13, color: Color(0xFF374151)),
          columnSpacing: 16,
          columns: const [
            DataColumn(label: Text('STUDENT ID')),
            DataColumn(label: Text('FULL NAME')),
            DataColumn(label: Text('TYPE')),
            DataColumn(label: Text('VIOLATION')),
            DataColumn(label: Text('DATE')),
            DataColumn(label: Text('TALLY')),
            DataColumn(label: Text('STATUS')),
            DataColumn(label: Text('ACTIONS')),
          ],
          rows: records.map((r) {
            return DataRow(cells: [
              DataCell(Text(r.id,
                  style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Color(0xFF6b7280),
                      fontWeight: FontWeight.w600))),
              DataCell(Text(r.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFF111827)))),
              DataCell(_TypeBadge(r.type)),
              DataCell(SizedBox(
                  width: 180,
                  child: Text(r.violation,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13)))),
              DataCell(Text(r.date,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF6b7280)))),
              DataCell(_TallyPips(
                  tally: r.tally,
                  max: r.maxTally,
                  isMax: r.isMax,
                  isMajor: r.type == 'Major')),
              DataCell(_StatusBadge(r.status)),
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility, size: 13),
                    label: const Text('View',
                        style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF030357),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      side: const BorderSide(color: Color(0xFFe5e7eb)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Icon(Icons.delete_outline,
                        size: 14, color: Color(0xFF9ca3af)),
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge(this.type);

  @override
  Widget build(BuildContext context) {
    final isMinor = type == 'Minor';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isMinor ? const Color(0xFFdbeafe) : const Color(0xFFfee2e2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(type,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isMinor
                  ? const Color(0xFF1e40af)
                  : const Color(0xFF991b1b))),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'Completed' => (const Color(0xFFd1fae5), const Color(0xFF065f46)),
      'Ongoing' => (const Color(0xFFdbeafe), const Color(0xFF1e40af)),
      _ => (const Color(0xFFfef3c7), const Color(0xFF92400e)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _TallyPips extends StatelessWidget {
  final int tally;
  final int max;
  final bool isMax;
  final bool isMajor;

  const _TallyPips({
    required this.tally,
    required this.max,
    required this.isMax,
    required this.isMajor,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor =
        isMajor ? const Color(0xFFdc2626) : const Color(0xFF2563eb);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(max, (i) {
          final filled = i < tally;
          return Container(
            width: 13,
            height: 13,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: filled ? activeColor : const Color(0xFFe5e7eb),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
        const SizedBox(width: 4),
        Text('$tally/$max',
            style: const TextStyle(fontSize: 11, color: Color(0xFF6b7280))),
        if (isMax) ...[
          const SizedBox(width: 3),
          const Text('MAX',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFdc2626))),
        ],
      ],
    );
  }
}
