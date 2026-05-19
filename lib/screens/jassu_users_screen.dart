import 'package:flutter/material.dart';

class JassuUsersScreen extends StatefulWidget {
  const JassuUsersScreen({super.key});

  @override
  State<JassuUsersScreen> createState() => _JassuUsersScreenState();
}

class _JassuUser {
  int id;
  String first, last, username, email, role;
  _JassuUser(this.id, this.first, this.last, this.username, this.email, this.role);
}

class _JassuUsersScreenState extends State<JassuUsersScreen> {
  final List<_JassuUser> _users = [
    _JassuUser(1, 'Admin', 'User', 'admin', 'admin@mcc.edu.ph', 'Admin'),
    _JassuUser(2, 'Maria', 'Santos', 'msantos', 'msantos@mcc.edu.ph', 'Jassu'),
    _JassuUser(3, 'Carlos', 'Reyes', 'creyes', 'creyes@mcc.edu.ph', 'Jassu'),
    _JassuUser(4, 'Ana', 'Lim', 'alim', 'alim@mcc.edu.ph', 'Admin'),
  ];
  int _nextId = 5;
  String _search = '';
  String _roleFilter = '';

  static const _avatarColors = [
    [Color(0xFF3b5bdb), Color(0xFFdbe4ff)],
    [Color(0xFF6d28d9), Color(0xFFede9fe)],
    [Color(0xFF0891b2), Color(0xFFcffafe)],
    [Color(0xFF059669), Color(0xFFd1fae5)],
    [Color(0xFFd97706), Color(0xFFfef3c7)],
    [Color(0xFFdc2626), Color(0xFFfee2e2)],
  ];

  List<Color> _avatarColor(int idx) =>
      _avatarColors[idx % _avatarColors.length];

  List<_JassuUser> get _filtered => _users.where((u) {
        final q = _search.toLowerCase();
        final mQ = q.isEmpty ||
            '${u.first} ${u.last} ${u.username}'.toLowerCase().contains(q);
        final mR = _roleFilter.isEmpty || u.role == _roleFilter;
        return mQ && mR;
      }).toList();

  // ── Add / Edit Dialog ──────────────────────────────────────────────────────

  Future<void> _showUserDialog({_JassuUser? existing}) async {
    final firstCtrl = TextEditingController(text: existing?.first ?? '');
    final lastCtrl = TextEditingController(text: existing?.last ?? '');
    final userCtrl = TextEditingController(text: existing?.username ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final passCtrl = TextEditingController();
    String role = existing?.role ?? 'Jassu';
    final isEdit = existing != null;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDlg) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(isEdit ? 'Edit User' : 'Add New User',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: _DialogField(
                                label: 'First Name',
                                ctrl: firstCtrl,
                                hint: 'e.g. Juan')),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _DialogField(
                                label: 'Last Name',
                                ctrl: lastCtrl,
                                hint: 'e.g. dela Cruz')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _DialogField(
                        label: 'Username',
                        ctrl: userCtrl,
                        hint: 'e.g. jdelacruz'),
                    const SizedBox(height: 12),
                    _DialogField(
                        label: 'Email Address',
                        ctrl: emailCtrl,
                        hint: 'e.g. jdelacruz@mcc.edu.ph'),
                    const SizedBox(height: 12),
                    _RoleDropdown(
                      value: role,
                      onChanged: (v) => setDlg(() => role = v),
                    ),
                    if (!isEdit) ...[
                      const SizedBox(height: 12),
                      _DialogField(
                          label: 'Password',
                          ctrl: passCtrl,
                          hint: 'Enter password',
                          obscure: true),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final first = firstCtrl.text.trim();
                  final last = lastCtrl.text.trim();
                  final username = userCtrl.text.trim();
                  final email = emailCtrl.text.trim();

                  if (first.isEmpty || last.isEmpty || username.isEmpty || email.isEmpty) {
                    _showSnack('Please fill in all required fields.', isError: true);
                    return;
                  }
                  if (!email.contains('@')) {
                    _showSnack('Please enter a valid email address.', isError: true);
                    return;
                  }
                  final dupUser = _users.any(
                      (u) => u.username == username && u.id != (existing?.id ?? -1));
                  if (dupUser) {
                    _showSnack('Username already exists.', isError: true);
                    return;
                  }
                  if (!isEdit) {
                    if (passCtrl.text.isEmpty) {
                      _showSnack('Password is required.', isError: true);
                      return;
                    }
                    if (passCtrl.text.length < 6) {
                      _showSnack('Password must be at least 6 characters.', isError: true);
                      return;
                    }
                  }

                  setState(() {
                    final target = existing;
                    if (target != null) {
                      target
                        ..first = first
                        ..last = last
                        ..username = username
                        ..email = email
                        ..role = role;
                    } else {
                      _users.add(_JassuUser(
                          _nextId++, first, last, username, email, role));
                    }
                  });
                  Navigator.pop(ctx);
                  _showSnack(
                      isEdit
                          ? '$first $last updated successfully.'
                          : '$first $last added successfully.',
                      isError: false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3b5bdb),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(isEdit ? 'Save Changes' : 'Add User',
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _showDeleteDialog(_JassuUser user) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0x1Adc2626),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.delete_outline,
                  color: Color(0xFFdc2626), size: 26),
            ),
            const SizedBox(height: 16),
            const Text('Delete Account?',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              "This will permanently remove ${user.first} ${user.last}'s account. This action cannot be undone.",
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 12, color: Color(0xFF4b5568)),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() => _users.removeWhere((u) => u.id == user.id));
              Navigator.pop(ctx);
              _showSnack(
                  '${user.first} ${user.last} has been deleted.',
                  isError: false);
            },
            icon: const Icon(Icons.delete_outline, size: 14),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFdc2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? const Color(0xFFdc2626) : const Color(0xFF059669),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MANAGE ACCOUNTS',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: Color(0xFF9099b5))),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFe2e6f0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 4,
                    offset: const Offset(0, 1))
              ],
            ),
            child: Column(
              children: [
                // Panel header
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jassu User Accounts',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1a1d2e))),
                          SizedBox(height: 2),
                          Text(
                              'Add, edit, change passwords, or remove system users',
                              style: TextStyle(
                                  fontSize: 11, color: Color(0xFF9099b5))),
                        ],
                      ),
                    ),
                    _SearchField(
                        onChanged: (v) => setState(() => _search = v)),
                    const SizedBox(width: 8),
                    _RoleFilterDropdown(
                        onChanged: (v) =>
                            setState(() => _roleFilter = v)),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showUserDialog(),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Add User',
                          style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3b5bdb),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(Colors.transparent),
                    headingTextStyle: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Color(0xFF9099b5)),
                    dataTextStyle: const TextStyle(
                        fontSize: 12, color: Color(0xFF4b5568)),
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text('FULL NAME')),
                      DataColumn(label: Text('USERNAME')),
                      DataColumn(label: Text('EMAIL')),
                      DataColumn(label: Text('ROLE')),
                      DataColumn(label: Text('ACTIONS')),
                    ],
                    rows: filtered.isEmpty
                        ? [
                            DataRow(cells: [
                              DataCell(
                                SizedBox(
                                  width: 600,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Center(
                                      child: Column(
                                        children: const [
                                          Icon(Icons.people_outline,
                                              size: 34,
                                              color: Color(0xFF9099b5)),
                                          SizedBox(height: 8),
                                          Text(
                                              'No users match the current filters.',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      Color(0xFF9099b5))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const DataCell(SizedBox.shrink()),
                              const DataCell(SizedBox.shrink()),
                              const DataCell(SizedBox.shrink()),
                              const DataCell(SizedBox.shrink()),
                            ]),
                          ]
                        : filtered.map((u) {
                            final idx = _users.indexOf(u);
                            final colors = _avatarColor(idx);
                            final initials =
                                '${u.first[0]}${u.last[0]}'.toUpperCase();
                            return DataRow(cells: [
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: colors[1],
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(initials,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: colors[0])),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${u.first} ${u.last}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1a1d2e))),
                                ],
                              )),
                              DataCell(Text(u.username,
                                  style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 11))),
                              DataCell(Text(u.email,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF9099b5)))),
                              DataCell(_RoleBadge(u.role)),
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _IconBtn(
                                    icon: Icons.edit,
                                    tooltip: 'Edit',
                                    onTap: () =>
                                        _showUserDialog(existing: u),
                                  ),
                                  const SizedBox(width: 6),
                                  _IconBtn(
                                    icon: Icons.key,
                                    tooltip: 'Change Password',
                                    onTap: () => _showSnack(
                                        'Change password for ${u.first} ${u.last}.',
                                        isError: false),
                                  ),
                                  const SizedBox(width: 6),
                                  _IconBtn(
                                    icon: Icons.delete_outline,
                                    tooltip: 'Delete',
                                    isDanger: true,
                                    onTap: () => _showDeleteDialog(u),
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 34,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search name or username…',
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9099b5)),
          prefixIcon:
              const Icon(Icons.search, size: 14, color: Color(0xFF9099b5)),
          filled: true,
          fillColor: const Color(0xFFf7f8fc),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFe2e6f0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFe2e6f0)),
          ),
        ),
      ),
    );
  }
}

class _RoleFilterDropdown extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const _RoleFilterDropdown({required this.onChanged});

  @override
  State<_RoleFilterDropdown> createState() => _RoleFilterDropdownState();
}

class _RoleFilterDropdownState extends State<_RoleFilterDropdown> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFf7f8fc),
        border: Border.all(color: const Color(0xFFe2e6f0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _value,
          hint: const Text('All Roles',
              style: TextStyle(fontSize: 11, color: Color(0xFF4b5568))),
          style: const TextStyle(fontSize: 11, color: Color(0xFF4b5568)),
          items: const [
            DropdownMenuItem(value: '', child: Text('All Roles')),
            DropdownMenuItem(value: 'Admin', child: Text('Admin')),
            DropdownMenuItem(value: 'Jassu', child: Text('Jassu')),
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

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge(this.role);

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'Admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: isAdmin
            ? const Color(0x173b5bdb)
            : const Color(0x176d28d9),
        border: Border.all(
            color: isAdmin
                ? const Color(0x333b5bdb)
                : const Color(0x336d28d9)),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(role,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: isAdmin
                  ? const Color(0xFF3b5bdb)
                  : const Color(0xFF6d28d9))),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isDanger;

  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isDanger
                ? const Color(0x15dc2626)
                : const Color(0xFFf7f8fc),
            border: Border.all(
                color: isDanger
                    ? const Color(0x33dc2626)
                    : const Color(0xFFe2e6f0)),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon,
              size: 14,
              color: isDanger
                  ? const Color(0xFFdc2626)
                  : const Color(0xFF4b5568)),
        ),
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  final String label, hint;
  final TextEditingController ctrl;
  final bool obscure;

  const _DialogField({
    required this.label,
    required this.ctrl,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4b5568),
                letterSpacing: 0.4)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(fontSize: 13, color: Color(0xFF9099b5)),
            filled: true,
            fillColor: const Color(0xFFf7f8fc),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFe2e6f0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFe2e6f0)),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _RoleDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ROLE',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4b5568),
                letterSpacing: 0.4)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFf7f8fc),
            border: Border.all(color: const Color(0xFFe2e6f0)),
            borderRadius: BorderRadius.circular(9),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1a1d2e)),
              items: const [
                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                DropdownMenuItem(value: 'Jassu', child: Text('Jassu')),
              ],
              onChanged: (v) => onChanged(v ?? 'Jassu'),
            ),
          ),
        ),
      ],
    );
  }
}
