import 'package:flutter/material.dart';

class ImportDataScreen extends StatefulWidget {
  const ImportDataScreen({super.key});

  @override
  State<ImportDataScreen> createState() => _ImportDataScreenState();
}

class _TypeOption {
  final IconData icon;
  final String label;
  const _TypeOption(this.icon, this.label);
}

class _HistEntry {
  final String datetime, filename, type, status;
  final int records;
  const _HistEntry({
    required this.datetime,
    required this.filename,
    required this.type,
    required this.records,
    required this.status,
  });
}

class _ImportDataScreenState extends State<ImportDataScreen> {
  int _selectedType = 0;
  bool _hasFile = false;
  bool _isImporting = false;
  double _progress = 0;
  String _progressText = 'Importing...';
  String? _successMsg;
  String? _errorMsg;
  String? _warningMsg;

  static const _typeOptions = [
    _TypeOption(Icons.school_outlined, 'Student Records'),
    _TypeOption(Icons.warning_amber_outlined, 'Violations'),
  ];

  final List<_HistEntry> _history = [
    const _HistEntry(
      datetime: 'Apr 22, 2025  10:34 AM',
      filename: 'students_batch_april.xlsx',
      type: 'Student Records',
      records: 142,
      status: 'Success',
    ),
    const _HistEntry(
      datetime: 'Apr 18, 2025  02:15 PM',
      filename: 'violations_q1.xlsx',
      type: 'Violations',
      records: 87,
      status: 'Partial',
    ),
    const _HistEntry(
      datetime: 'Apr 10, 2025  09:00 AM',
      filename: 'disc_actions_march.xlsx',
      type: 'Disciplinary Actions',
      records: 23,
      status: 'Success',
    ),
  ];

  Future<void> _startImport() async {
    if (!_hasFile) {
      setState(() => _errorMsg = 'Please upload a file before importing.');
      return;
    }

    setState(() {
      _isImporting = true;
      _progress = 0;
      _progressText = 'Starting...';
      _successMsg = null;
      _errorMsg = null;
      _warningMsg = null;
    });

    final steps = [
      (0.1, 'Validating file...'),
      (0.3, 'Parsing rows...'),
      (0.6, 'Processing records...'),
      (0.85, 'Writing to database...'),
      (1.0, 'Finalizing...'),
    ];

    for (final step in steps) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() {
        _progress = step.$1;
        _progressText = step.$2;
      });
    }

    if (!mounted) return;
    setState(() {
      _isImporting = false;
      _successMsg = 'Import completed! 138 record(s) imported successfully.';
      _warningMsg = '4 row(s) were skipped due to duplicate or missing required fields.';
      _history.insert(
        0,
        _HistEntry(
          datetime: 'May 20, 2026  Now',
          filename: 'students_batch_2025.xlsx',
          type: _typeOptions[_selectedType].label,
          records: 138,
          status: 'Partial',
        ),
      );
    });
  }

  void _reset() => setState(() {
        _hasFile = false;
        _isImporting = false;
        _progress = 0;
        _selectedType = 0;
        _successMsg = null;
        _errorMsg = null;
        _warningMsg = null;
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Import Type ───────────────────────────────────────────
            _ImportCard(
              icon: Icons.layers_outlined,
              title: 'Import Type',
              desc: 'Select what kind of data you are importing.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(_typeOptions.length, (i) {
                      final selected = _selectedType == i;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: i < _typeOptions.length - 1 ? 12 : 0),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedType = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFFeff6ff)
                                    : Colors.white,
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF3b82f6)
                                      : const Color(0xFFe2e8f0),
                                  width: selected ? 2 : 1.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _typeOptions[i].icon,
                                    size: 26,
                                    color: selected
                                        ? const Color(0xFF3b82f6)
                                        : const Color(0xFF64748b),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _typeOptions[i].label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: selected
                                          ? const Color(0xFF1d4ed8)
                                          : const Color(0xFF475569),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download_outlined, size: 14),
                    label:
                        const Text('Download Template for selected type'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF374151),
                      side: const BorderSide(color: Color(0xFFd1d5db)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontSize: 13),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Upload File ───────────────────────────────────────────
            _ImportCard(
              icon: Icons.upload_outlined,
              title: 'Upload Excel File',
              desc:
                  'Drag and drop your Excel file here, or click to browse. Accepts .xlsx and .xls files.',
              child: Column(
                children: [
                  if (!_hasFile)
                    InkWell(
                      onTap: () => setState(() => _hasFile = true),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 48, horizontal: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFf8fafc),
                          border: Border.all(
                              color: const Color(0xFFcbd5e1), width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFdbeafe),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 26,
                                  color: Color(0xFF3b82f6)),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Drag & drop your file here',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1e293b)),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'or click to browse from your computer',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF94a3b8)),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 9),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3b82f6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.folder_open,
                                      size: 14, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Browse Files',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Supported formats: .xlsx, .xls, .csv  |  Max size: 10 MB',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF94a3b8)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_hasFile)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf0fdf4),
                        border: Border.all(color: const Color(0xFFbbf7d0)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFdcfce7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.table_chart_outlined,
                                color: Color(0xFF16a34a), size: 20),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'students_batch_2025.xlsx',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF15803d)),
                                ),
                                Text(
                                  '142.4 KB',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748b)),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close,
                                size: 18, color: Color(0xFF94a3b8)),
                            onPressed: () => setState(() {
                              _hasFile = false;
                              _successMsg = null;
                              _errorMsg = null;
                              _warningMsg = null;
                            }),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Data Preview ──────────────────────────────────────────
            _ImportCard(
              icon: Icons.visibility_outlined,
              title: 'Data Preview',
              desc:
                  'Review the first few rows before committing the import.',
              child: _hasFile
                  ? _buildPreviewTable()
                  : Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: const [
                            Icon(Icons.table_chart_outlined,
                                size: 36, color: Color(0xFF94a3b8)),
                            SizedBox(height: 10),
                            Text(
                              'Upload a file above to preview your data here.',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF94a3b8)),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            // ── Run Import ────────────────────────────────────────────
            _ImportCard(
              icon: Icons.play_circle_outline,
              title: 'Run Import',
              desc:
                  "Once you're satisfied with the preview, click Import to begin processing.",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isImporting) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_progressText,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748b))),
                        Text(
                          '${(_progress * 100).toInt()}%',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF64748b)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: const Color(0xFFf1f5f9),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF3b82f6)),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  if (_successMsg != null)
                    _AlertBox(type: 'success', message: _successMsg!),
                  if (_errorMsg != null)
                    _AlertBox(type: 'error', message: _errorMsg!),
                  if (_warningMsg != null)
                    _AlertBox(type: 'warning', message: _warningMsg!),
                  if (_successMsg != null ||
                      _errorMsg != null ||
                      _warningMsg != null)
                    const SizedBox(height: 14),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isImporting ? null : _startImport,
                        icon: _isImporting
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white),
                              )
                            : const Icon(Icons.file_upload_outlined,
                                size: 16),
                        label: Text(_isImporting
                            ? 'Importing...'
                            : 'Import Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3b82f6),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color(0xFF93c5fd),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh, size: 15),
                        label: const Text('Reset'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF374151),
                          side: const BorderSide(
                              color: Color(0xFFd1d5db)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Import History ────────────────────────────────────────
            _ImportCard(
              icon: Icons.history,
              title: 'Import History',
              desc: 'Recent import activities for this system.',
              child: _buildHistoryTable(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Preview Table ───────────────────────────────────────────────────

  Widget _buildPreviewTable() {
    const headers = [
      'Student ID',
      'Full Name',
      'Course',
      'Year',
      'Department',
      'Risk Level'
    ];
    const rows = [
      [
        '223-09673',
        'Juan dela Cruz',
        'BSIT',
        '3rd Year',
        'School of Technology',
        'Low'
      ],
      [
        '223-10245',
        'Maria Santos',
        'BIT',
        '2nd Year',
        'School of Technology',
        'Medium'
      ],
      [
        '223-08831',
        'Carlos Reyes',
        'BSEd',
        '4th Year',
        'School of Education',
        'High'
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.table_chart_outlined,
                size: 14, color: Color(0xFF3b82f6)),
            SizedBox(width: 8),
            Text(
              'Preview — first 5 rows',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1e293b)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFe2e8f0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(const Color(0xFFf1f5f9)),
                headingTextStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569)),
                dataTextStyle: const TextStyle(
                    fontSize: 12.5, color: Color(0xFF374151)),
                columnSpacing: 20,
                columns: headers
                    .map((h) => DataColumn(label: Text(h)))
                    .toList(),
                rows: rows
                    .map((row) => DataRow(
                          cells: row
                              .map((c) => DataCell(Text(c)))
                              .toList(),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Showing 3 of 142 data rows (excluding header).',
          style: TextStyle(fontSize: 12, color: Color(0xFF94a3b8)),
        ),
      ],
    );
  }

  // ── History Table ───────────────────────────────────────────────────

  Widget _buildHistoryTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFe2e8f0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                WidgetStateProperty.all(const Color(0xFFf8fafc)),
            headingTextStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748b)),
            dataTextStyle:
                const TextStyle(fontSize: 13, color: Color(0xFF374151)),
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('Date & Time')),
              DataColumn(label: Text('File Name')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Records')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Imported By')),
            ],
            rows: _history
                .map((h) => DataRow(cells: [
                      DataCell(Text(h.datetime,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748b)))),
                      DataCell(Text(h.filename,
                          style: const TextStyle(
                              fontFamily: 'monospace', fontSize: 12))),
                      DataCell(Text(h.type)),
                      DataCell(Text('${h.records}')),
                      DataCell(_HistStatusBadge(h.status)),
                      DataCell(const Text('Admin')),
                    ]))
                .toList(),
          ),
        ),
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _ImportCard extends StatelessWidget {
  final IconData icon;
  final String title, desc;
  final Widget child;

  const _ImportCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFe2e8f0)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF3b82f6)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1e293b)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(desc,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF64748b))),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _AlertBox extends StatelessWidget {
  final String type, message;
  const _AlertBox({required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg, icon) = switch (type) {
      'success' => (
          const Color(0xFFf0fdf4),
          const Color(0xFFbbf7d0),
          const Color(0xFF15803d),
          Icons.check_circle_outline
        ),
      'error' => (
          const Color(0xFFfef2f2),
          const Color(0xFFfecaca),
          const Color(0xFFb91c1c),
          Icons.cancel_outlined
        ),
      _ => (
          const Color(0xFFfffbeb),
          const Color(0xFFfde68a),
          const Color(0xFF92400e),
          Icons.warning_amber_outlined
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style: TextStyle(fontSize: 13, color: fg))),
        ],
      ),
    );
  }
}

class _HistStatusBadge extends StatelessWidget {
  final String status;
  const _HistStatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon) = switch (status) {
      'Success' => (
          const Color(0xFFdcfce7),
          const Color(0xFF15803d),
          Icons.check_circle_outline
        ),
      'Partial' => (
          const Color(0xFFfef3c7),
          const Color(0xFF92400e),
          Icons.warning_amber_outlined
        ),
      _ => (
          const Color(0xFFfee2e2),
          const Color(0xFFb91c1c),
          Icons.cancel_outlined
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 5),
          Text(status,
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: fg)),
        ],
      ),
    );
  }
}
