import 'package:flutter/material.dart';

class StudentRecordsScreen extends StatefulWidget {
  const StudentRecordsScreen({super.key});

  @override
  State<StudentRecordsScreen> createState() => _StudentRecordsScreenState();
}

class _StudentRecordsScreenState extends State<StudentRecordsScreen> {
  String _search = '';
  String _dept = '';
  String _year = '';

  static const _students = [
    _Student('223-09673', 'Juan dela Cruz', 'BSIT', '3rd Year', 'A', 'School of Technology', 'Low'),
    _Student('223-10245', 'Maria Santos', 'BIT', '2nd Year', 'B', 'School of Technology', 'Medium'),
    _Student('223-08831', 'Carlos Reyes', 'BSEd', '4th Year', 'C', 'School of Education', 'High'),
    _Student('223-11402', 'Ana Gonzales', 'BEEd', '1st Year', 'A', 'School of Education', 'Low'),
    _Student('223-07758', 'Mark Villanueva', 'BSBA', '3rd Year', 'B', 'School of Business', 'Medium'),
    _Student('223-09014', 'Liza Fernandez', 'BSIT', '4th Year', 'A', 'School of Technology', 'Low'),
    _Student('223-12387', 'Rico Mendoza', 'BSMA', '1st Year', 'C', 'School of Business', 'High'),
    _Student('223-10561', 'Claire Pascual', 'BEEd', '2nd Year', 'B', 'School of Education', 'Medium'),
    _Student('223-08190', 'Dennis Bautista', 'BSBA', '3rd Year', 'A', 'School of Business', 'Low'),
    _Student('223-11729', 'Patricia Ramos', 'BSEd', '4th Year', 'C', 'School of Education', 'High'),
  ];

  List<_Student> get _filtered => _students.where((s) {
        final q = _search.toLowerCase();
        final matchQ = q.isEmpty ||
            s.id.toLowerCase().contains(q) ||
            s.name.toLowerCase().contains(q);
        final matchD = _dept.isEmpty || s.dept == _dept;
        final matchY = _year.isEmpty || s.year == _year;
        return matchQ && matchD && matchY;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final mobile = constraints.maxWidth < 600;
      return SingleChildScrollView(
        padding: EdgeInsets.all(mobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FilterBar(
              onSearch: (v) => setState(() => _search = v),
              onDept: (v) => setState(() => _dept = v),
              onYear: (v) => setState(() => _year = v),
              onReset: () => setState(() {
                _search = '';
                _dept = '';
                _year = '';
              }),
            ),
            const SizedBox(height: 20),
            _TableCard(students: _filtered, availableWidth: constraints.maxWidth - (mobile ? 32 : 48)),
          ],
        ),
      );
    });
  }
}

class _Student {
  final String id, name, course, year, section, dept, risk;
  const _Student(
      this.id, this.name, this.course, this.year, this.section, this.dept, this.risk);
}

// ── Filter Bar ───────────────────────────────────────────────────────────────

class _FilterBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onDept;
  final ValueChanged<String> onYear;
  final VoidCallback onReset;

  const _FilterBar({
    required this.onSearch,
    required this.onDept,
    required this.onYear,
    required this.onReset,
  });

  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  final _ctrl = TextEditingController();
  String _dept = '';
  String _year = '';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 220,
          height: 38,
          child: TextField(
            controller: _ctrl,
            onChanged: widget.onSearch,
            decoration: InputDecoration(
              hintText: 'Search Student...',
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
        _DropdownField(
          value: _dept,
          hint: 'All Departments',
          items: const ['School of Technology', 'School of Education', 'School of Business'],
          onChanged: (v) {
            setState(() => _dept = v);
            widget.onDept(v);
          },
        ),
        _DropdownField(
          value: _year,
          hint: 'All Year Levels',
          items: const ['1st Year', '2nd Year', '3rd Year', '4th Year'],
          onChanged: (v) {
            setState(() => _year = v);
            widget.onYear(v);
          },
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _ctrl.clear();
              _dept = '';
              _year = '';
            });
            widget.onReset();
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            side: const BorderSide(color: Color(0xFFd1d5db)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
          child: const Text('Reset',
              style: TextStyle(fontSize: 13, color: Color(0xFF374151))),
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

class _DropdownField extends StatelessWidget {
  final String value;
  final String hint;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

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
          value: value.isEmpty ? null : value,
          hint: Text(hint, style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
          style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v ?? ''),
        ),
      ),
    );
  }
}

// ── Table Card ───────────────────────────────────────────────────────────────

class _TableCard extends StatelessWidget {
  final List<_Student> students;
  final double availableWidth;
  const _TableCard({required this.students, required this.availableWidth});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Text(
              'Student Records',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827)),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFe5e7eb)),
          SingleChildScrollView(
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
              dataTextStyle:
                  const TextStyle(fontSize: 13, color: Color(0xFF374151)),
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('STUDENT ID')),
                DataColumn(label: Text('FULL NAME')),
                DataColumn(label: Text('COURSE')),
                DataColumn(label: Text('YEAR')),
                DataColumn(label: Text('SECTION')),
                DataColumn(label: Text('DEPARTMENT')),
                DataColumn(label: Text('RISK LEVEL')),
                DataColumn(label: Text('ACTIONS')),
              ],
              rows: students.map((s) {
                return DataRow(cells: [
                  DataCell(Text(s.id,
                      style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Color(0xFF6b7280),
                          fontWeight: FontWeight.w600))),
                  DataCell(Text(s.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827)))),
                  DataCell(Text(s.course)),
                  DataCell(Text(s.year)),
                  DataCell(Text(s.section)),
                  DataCell(Text(s.dept)),
                  DataCell(_RiskBadge(s.risk)),
                  DataCell(
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility, size: 14),
                      label: const Text('View', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF030357),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskBadge extends StatelessWidget {
  final String risk;
  const _RiskBadge(this.risk);

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = switch (risk) {
      'Low' => (
          const Color(0xFFf0fdf4),
          const Color(0xFF166534),
          const Color(0xFFbbf7d0)
        ),
      'Medium' => (
          const Color(0xFFfffbeb),
          const Color(0xFF92400e),
          const Color(0xFFfde68a)
        ),
      _ => (
          const Color(0xFFfef2f2),
          const Color(0xFF991b1b),
          const Color(0xFFfecaca)
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(risk,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}
