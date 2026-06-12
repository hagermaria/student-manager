import 'package:flutter/material.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/theme.dart';

class StudentForm extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController gender;
  final TextEditingController dateOFbirth;
  final TextEditingController maritalStatus;
  final TextEditingController nationalID;
  final TextEditingController religion;
  final TextEditingController nationality;
  final TextEditingController placeOFbirth;
  final TextEditingController yearOfadmission;
  final TextEditingController healthCare;
  final TextEditingController department;
  final TextEditingController grade;
  final TextEditingController division;
  final String submitLabel;
  final VoidCallback onSubmit;

  const StudentForm({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.dateOFbirth,
    required this.maritalStatus,
    required this.nationalID,
    required this.religion,
    required this.nationality,
    required this.placeOFbirth,
    required this.yearOfadmission,
    required this.healthCare,
    required this.department,
    required this.grade,
    required this.division,
    required this.submitLabel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Contact info ────────────────────────────────────────
          _sectionCard(
            title: 'Contact',
            icon: Icons.contact_mail_outlined,
            children: [
              appTextField(
                label: 'Full Name',
                controller: name,
                prefix: const Icon(Icons.person_outline_rounded, size: 20),
              ),
              appTextField(
                label: 'Email',
                controller: email,
                keyboardType: TextInputType.emailAddress,
                prefix: const Icon(Icons.email_outlined, size: 20),
              ),
              appTextField(
                label: 'Password',
                controller: password,
                obscure: true,
                prefix: const Icon(Icons.lock_outline_rounded, size: 20),
              ),
            ],
          ),

          // ── Personal info ────────────────────────────────────────
          _sectionCard(
            title: 'Personal Information',
            icon: Icons.person_outline_rounded,
            children: [
              _genderRow(),
              appTextField(
                label: 'Date of Birth',
                controller: dateOFbirth,
                hint: 'e.g. 01/01/2000',
                prefix: const Icon(Icons.cake_outlined, size: 20),
              ),
              appTextField(
                label: 'Marital Status',
                controller: maritalStatus,
                prefix: const Icon(Icons.favorite_outline_rounded, size: 20),
              ),
              appTextField(
                label: 'National ID',
                controller: nationalID,
                keyboardType: TextInputType.number,
                prefix: const Icon(Icons.badge_outlined, size: 20),
              ),
              appTextField(
                label: 'Religion',
                controller: religion,
                prefix: const Icon(Icons.church_outlined, size: 20),
              ),
              appTextField(
                label: 'Nationality',
                controller: nationality,
                prefix: const Icon(Icons.flag_outlined, size: 20),
              ),
              appTextField(
                label: 'Place of Birth',
                controller: placeOFbirth,
                prefix: const Icon(Icons.location_on_outlined, size: 20),
              ),
            ],
          ),

          // ── Academic info ────────────────────────────────────────
          _sectionCard(
            title: 'Academic',
            icon: Icons.school_outlined,
            children: [
              appTextField(
                label: 'Year of Admission',
                controller: yearOfadmission,
                keyboardType: TextInputType.number,
                prefix: const Icon(Icons.calendar_today_outlined, size: 20),
              ),
              appTextField(
                label: 'Health Care',
                controller: healthCare,
                prefix: const Icon(Icons.health_and_safety_outlined, size: 20),
              ),
              const SizedBox(height: 4),
              readOnlyChipField(label: 'Department', controller: department),
              _chipRow(
                items: [
                  'Chemistry', 'Physics', 'Biology', 'Mathematics', 'Geology'
                ],
                onSelect: (v) => department.text = v,
                selected: department.text,
              ),
              const SizedBox(height: 8),
              readOnlyChipField(label: 'Grade', controller: grade),
              _chipRow(
                items: ['First', 'Second', 'Third', 'Fourth'],
                onSelect: (v) => grade.text = v,
                selected: grade.text,
              ),
              const SizedBox(height: 8),
              readOnlyChipField(label: 'Division', controller: division),
              _chipRow(
                items: ['Special', 'General'],
                onSelect: (v) => division.text = v,
                selected: division.text,
              ),
            ],
          ),

          const SizedBox(height: 8),
          primaryButton(text: submitLabel, onTap: onSubmit),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _genderRow() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gender',
                style: TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            Row(
              children: ['Male', 'Female'].map((g) {
                final selected = gender.text == g;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: chipButton(
                    text: g,
                    selected: selected,
                    onTap: () {
                      gender.text = g;
                      // trigger rebuild
                      (context as Element).markNeedsBuild();
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _chipRow({
    required List<String> items,
    required void Function(String) onSelect,
    required String selected,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return chipButton(
              text: item,
              selected: selected == item,
              onTap: () {
                onSelect(item);
                (context as Element).markNeedsBuild();
              },
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 16),
            const SizedBox(width: 6),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
