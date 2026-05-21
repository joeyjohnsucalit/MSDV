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
  final _descriptionCtrl = TextEditingController();

  String? _selectedCourse;
  String? _selectedYear;
  String? _selectedDepartment;
  bool _hasSignature = false;
  final Set<String> _selectedViolations = {};

  final List<String> _courses = [
    'BSIT',
    'BSCS',
    'BSBA',
    'BSECE',
    'BSCE',
    'BSN',
    'BSED',
    'BSHM',
    'Other',
  ];

  final List<String> _yearLevels = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  final List<String> _departments = [
    'School of Technology',
    'College of Information Technology',
    'College of Business and Management',
    'College of Health Sciences',
    'College of Education',
    'College of Hospitality and Tourism',
    'Other',
  ];

  final List<String> _violationTypes = [
    'Academic Dishonesty',
    'Insubordination',
    'Attendance Issue',
    'Disruptive Behavior',
    'Harassment',
    'Policy Violation',
    'Other (please specify in description)',
  ];

  void _toggleViolation(String violation) {
    setState(() {
      if (_selectedViolations.contains(violation)) {
        _selectedViolations.remove(violation);
      } else {
        _selectedViolations.add(violation);
      }
    });
  }

  void _clearSignature() {
    setState(() {
      _hasSignature = false;
    });
  }

  void _captureSignature() {
    setState(() {
      _hasSignature = true;
    });
  }

  void _submitViolation() {
    final missingFields = <String>[];
    if (_studentIdCtrl.text.trim().isEmpty) {
      missingFields.add('Student ID');
    }
    if (_fullNameCtrl.text.trim().isEmpty) {
      missingFields.add('Full Name');
    }
    if (_selectedCourse == null) {
      missingFields.add('Course');
    }
    if (_selectedYear == null) {
      missingFields.add('Year Level');
    }
    if (_selectedDepartment == null) {
      missingFields.add('Department');
    }
    if (_selectedViolations.isEmpty) {
      missingFields.add('Violation Type');
    }
    if (!_hasSignature) {
      missingFields.add('Signature');
    }

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete: ${missingFields.join(', ')}'),
          backgroundColor: const Color(0xFFb40404),
        ),
      );
      return;
    }

    setState(() {
      _studentIdCtrl.clear();
      _fullNameCtrl.clear();
      _descriptionCtrl.clear();
      _selectedCourse = null;
      _selectedYear = null;
      _selectedDepartment = null;
      _selectedViolations.clear();
      _hasSignature = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Violation report submitted successfully'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, Color background) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: background.withOpacity(0.18),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: background),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
            letterSpacing: 0.08,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String label, {bool required = false}) {
    return Text.rich(
      TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.muted,
          letterSpacing: 0.06,
          height: 1.4,
        ),
        children: required
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFCC0000)),
                )
              ]
            : [],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFF4F5F8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 480;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 24, bottom: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: 60,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.04),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 32, 30, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _BannerLabel(),
                          SizedBox(height: 14),
                          Text(
                            'Violation Report',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Complete all required fields to submit a student violation.',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFCC0000),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(18)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Column(
                        children: [
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.border,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.border,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCC0000),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.border,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 26, 30, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SectionBlock(
                            header: _sectionHeader(Icons.person, 'Student Information', AppColors.primary),
                            child: Column(
                              children: [
                                _FieldRow(
                                  isMobile: isMobile,
                                  children: [
                                    _FieldGroup(
                                      label: _fieldLabel('Student ID', required: true),
                                      child: TextField(
                                        controller: _studentIdCtrl,
                                        decoration: _inputDecoration(hintText: 'e.g. 2024001'),
                                      ),
                                    ),
                                    _FieldGroup(
                                      label: _fieldLabel('Full Name', required: true),
                                      child: TextField(
                                        controller: _fullNameCtrl,
                                        decoration: _inputDecoration(hintText: 'e.g. Juan Dela Cruz'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _SectionBlock(
                            header: _sectionHeader(Icons.school, 'Academic Information', AppColors.primary),
                            child: Column(
                              children: [
                                _FieldRow(
                                  isMobile: isMobile,
                                  children: [
                                    _FieldGroup(
                                      label: _fieldLabel('Course', required: true),
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedCourse,
                                        decoration: _inputDecoration(hintText: 'Select course'),
                                        onChanged: (value) => setState(() => _selectedCourse = value),
                                        items: _courses.map((course) {
                                          return DropdownMenuItem(value: course, child: Text(course));
                                        }).toList(),
                                      ),
                                    ),
                                    _FieldGroup(
                                      label: _fieldLabel('Year Level', required: true),
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedYear,
                                        decoration: _inputDecoration(hintText: 'Select year'),
                                        onChanged: (value) => setState(() => _selectedYear = value),
                                        items: _yearLevels.map((year) {
                                          return DropdownMenuItem(value: year, child: Text(year));
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                _FieldRow(
                                  isMobile: true,
                                  children: [
                                    _FieldGroup(
                                      label: _fieldLabel('Department', required: true),
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedDepartment,
                                        decoration: _inputDecoration(hintText: 'Select department'),
                                        onChanged: (value) => setState(() => _selectedDepartment = value),
                                        items: _departments.map((department) {
                                          return DropdownMenuItem(value: department, child: Text(department));
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _SectionBlock(
                            header: _sectionHeader(Icons.warning_amber_rounded, 'Violation Details', AppColors.redAccent),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _fieldLabel('Violation Type', required: true),
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _violationTypes.map((type) {
                                    final selected = _selectedViolations.contains(type);
                                    return SizedBox(
                                      width: isMobile ? double.infinity : (screenWidth - 120) / 2 - 12,
                                      child: _ViolationCheckItem(
                                        label: type,
                                        selected: selected,
                                        onTap: () => _toggleViolation(type),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          _SectionBlock(
                            header: _sectionHeader(Icons.list_alt, 'Additional Details', AppColors.primary),
                            child: _FieldGroup(
                              label: _fieldLabel('Description'),
                              child: TextField(
                                controller: _descriptionCtrl,
                                maxLines: 4,
                                decoration: _inputDecoration(hintText: 'Provide a brief description of the violation...'),
                              ),
                            ),
                          ),
                          _SectionBlock(
                            header: _sectionHeader(Icons.edit, 'Student\'s E-Signature', AppColors.redAccent),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _FieldGroup(
                                  label: _fieldLabel('Signature', required: true),
                                  child: GestureDetector(
                                    onTap: _captureSignature,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F5F8),
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 140,
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.edit_note,
                                                  size: 28,
                                                  color: AppColors.muted.withOpacity(0.6),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  _hasSignature ? 'Signature captured' : 'Draw your signature here',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.muted.withOpacity(0.8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFF0F1F6),
                                              border: Border(top: BorderSide(color: AppColors.border)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.touch_app, size: 16, color: AppColors.muted),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      'Tap to sign',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: AppColors.muted,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                TextButton.icon(
                                                  onPressed: _clearSignature,
                                                  icon: const Icon(Icons.rotate_left, color: Color(0xFFCC0000), size: 16),
                                                  label: const Text(
                                                    'Clear',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFFCC0000),
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                              border: Border.all(color: const Color(0xFFCC0000)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(Icons.info, size: 14, color: Color(0xFF7A1010)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'By submitting this report, you confirm that all information provided is accurate and truthful.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF7A1010),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitViolation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Submit Report',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.07,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 26),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _studentIdCtrl.dispose();
    _fullNameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }
}

class _BannerLabel extends StatelessWidget {
  const _BannerLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.shield, size: 12, color: Colors.white70),
          SizedBox(width: 6),
          Text(
            'MCC Discipline Office',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.08,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final Widget header;
  final Widget child;

  const _SectionBlock({required this.header, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final List<Widget> children;
  final bool isMobile;

  const _FieldRow({required this.children, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: child,
                ))
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map((child) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: child,
                ),
              ))
          .toList(),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  final Widget label;
  final Widget child;

  const _FieldGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        label,
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _ViolationCheckItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ViolationCheckItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F8),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.7 : 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: selected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

