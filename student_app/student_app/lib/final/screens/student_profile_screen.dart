import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/modelStudent.dart';
import 'package:student_app/final/screens/update_student_screen.dart';
import 'package:student_app/final/studentLogic.dart';
import 'package:student_app/final/studentState.dart';
import 'package:student_app/final/theme.dart';

class StudentProfileScreen extends StatelessWidget {
  final ModelStudent student;
  const StudentProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentLogic, StudentState>(
      listener: (context, state) {},
      builder: (context, state) {
        final obj = BlocProvider.of<StudentLogic>(context);
        // Get the up-to-date student from logic (in case it was updated)
        final current = obj.student.firstWhere(
          (s) => s.id == student.id,
          orElse: () => student,
        );

        final initials = current.name.isNotEmpty
            ? current.name
                .trim()
                .split(' ')
                .take(2)
                .map((w) => w[0].toUpperCase())
                .join()
            : '?';

        final hasImage = current.image != '0' &&
            current.image.isNotEmpty &&
            File(current.image).existsSync();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Student Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: obj,
                      child: UpdateStudentScreen(myStudent: current),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ── Hero section ────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar with camera button
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.white24,
                            backgroundImage:
                                hasImage ? FileImage(File(current.image)) : null,
                            child: !hasImage
                                ? Text(initials,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700))
                                : null,
                          ),
                          GestureDetector(
                            onTap: () => _pickImage(context, obj, current),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppTheme.accent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        current.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'ID: ${current.id}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Dept/Grade/Division chips
                      Wrap(
                        spacing: 8,
                        children: [
                          _chip(current.department),
                          _chip(_gradeLabel(current.grade)),
                          _chip(current.division),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Info sections ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoCard(
                        title: 'Contact',
                        icon: Icons.contact_mail_rounded,
                        children: [
                          infoRow(label: 'Email', value: current.email),
                          infoRow(label: 'Password', value: '••••••••'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: 'Personal',
                        icon: Icons.person_outline_rounded,
                        children: [
                          infoRow(label: 'Gender', value: current.gender),
                          infoRow(
                              label: 'Date of Birth', value: current.dateOFbirth),
                          infoRow(
                              label: 'Marital Status',
                              value: current.maritalStatus),
                          infoRow(label: 'National ID', value: current.nationalID),
                          infoRow(label: 'Religion', value: current.religion),
                          infoRow(
                              label: 'Nationality', value: current.nationality),
                          infoRow(
                              label: 'Place of Birth',
                              value: current.placeOFbirth),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: 'Academic',
                        icon: Icons.school_outlined,
                        children: [
                          infoRow(label: 'Department', value: current.department),
                          infoRow(
                              label: 'Grade',
                              value: _gradeLabel(current.grade)),
                          infoRow(label: 'Division', value: current.division),
                          infoRow(
                              label: 'Year of Admission',
                              value: current.yearOfadmission),
                          infoRow(
                              label: 'Health Care', value: current.healthCare),
                        ],
                      ),

                      // ── Ratings/courses ──────────────────────────
                      if (current.ratings.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _RatingsCard(student: current, logic: obj),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 12)),
      );

  String _gradeLabel(int g) {
    const m = {1: 'First', 2: 'Second', 3: 'Third', 4: 'Fourth'};
    return m[g] ?? '$g';
  }

  Future<void> _pickImage(
      BuildContext context, StudentLogic obj, ModelStudent s) async {
    showModalBottomSheet(
      context: context,
      shape:
          const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library_rounded,
                    color: AppTheme.primary),
              ),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(ctx);
                final img = await ImagePicker()
                    .pickImage(source: ImageSource.gallery);
                if (img != null) {
                  obj.addImageFile(File(img.path), img);
                  obj.updateImage(id: s.id, image: img.path);
                }
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    color: AppTheme.primary),
              ),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(ctx);
                final img =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (img != null) {
                  obj.addImageFile(File(img.path), img);
                  obj.updateImage(id: s.id, image: img.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard(
      {required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppTheme.divider),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _RatingsCard extends StatelessWidget {
  final ModelStudent student;
  final StudentLogic logic;

  const _RatingsCard({required this.student, required this.logic});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.grade_rounded, color: AppTheme.accent, size: 18),
                SizedBox(width: 8),
                Text(
                  'Course Ratings',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accent,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppTheme.divider),
            const SizedBox(height: 12),
            for (int year = 0; year < student.ratings.length; year++) ...[
              Text(
                'Year ${year + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              if ((student.ratings[year] as Map).isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('No courses assigned yet',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),
                )
              else
                for (final entry
                    in (student.ratings[year] as Map).entries)
                  _CourseRatingRow(
                    courseName: entry.key,
                    score: entry.value,
                    onScoreChanged: (newScore) {
                      final updatedRatings = List.from(student.ratings);
                      (updatedRatings[year] as Map)[entry.key] = newScore;
                      logic.updateRatings(
                          id: student.id, ratings: updatedRatings);
                    },
                  ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _CourseRatingRow extends StatefulWidget {
  final String courseName;
  final dynamic score;
  final void Function(double) onScoreChanged;

  const _CourseRatingRow({
    required this.courseName,
    required this.score,
    required this.onScoreChanged,
  });

  @override
  State<_CourseRatingRow> createState() => _CourseRatingRowState();
}

class _CourseRatingRowState extends State<_CourseRatingRow> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.score}');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.courseName,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textPrimary)),
          ),
          SizedBox(
            width: 70,
            child: TextFormField(
              controller: _ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppTheme.divider)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppTheme.divider)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: AppTheme.primary, width: 2)),
              ),
              onFieldSubmitted: (v) {
                final parsed = double.tryParse(v);
                if (parsed != null) widget.onScoreChanged(parsed);
              },
            ),
          ),
        ],
      ),
    );
  }
}
