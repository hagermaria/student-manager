import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/modelStudent.dart';
import 'package:student_app/final/screens/student_profile_screen.dart';
import 'package:student_app/final/screens/update_student_screen.dart';
import 'package:student_app/final/studentLogic.dart';
import 'package:student_app/final/studentState.dart';
import 'package:student_app/final/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BUG FIX: we receive the SAME StudentLogic from parent via BlocProvider.value
    // No more creating a new instance that loads separate data
    return BlocConsumer<StudentLogic, StudentState>(
      listener: (context, state) {},
      builder: (context, state) {
        final obj = BlocProvider.of<StudentLogic>(context);
        final filtered = obj.student
            .where((s) =>
                s.name.toLowerCase().contains(_query.toLowerCase()) ||
                s.id.toString().contains(_query))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Students'),
          ),
          body: Column(
            children: [
              // ── Search bar ─────────────────────────────────────────
              Container(
                color: AppTheme.primary,
                padding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search by name or ID...',
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 15),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Colors.white70),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded,
                                color: Colors.white70),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Colors.white54, width: 1.5),
                    ),
                  ),
                ),
              ),

              // ── Results count ──────────────────────────────────────
              if (obj.student.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        '${filtered.length} student${filtered.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // ── List ───────────────────────────────────────────────
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyState(hasStudents: obj.student.isNotEmpty)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (ctx, i) =>
                            _StudentTile(
                          student: filtered[i],
                          logic: obj,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StudentTile extends StatelessWidget {
  final ModelStudent student;
  final StudentLogic logic;

  const _StudentTile({required this.student, required this.logic});

  @override
  Widget build(BuildContext context) {
    final initials = student.name.isNotEmpty
        ? student.name
            .trim()
            .split(' ')
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join()
        : '?';

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: logic,
              child: StudentProfileScreen(student: student),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primary,
                backgroundImage: (student.image != '0' &&
                        student.image.isNotEmpty &&
                        File(student.image).existsSync())
                    ? FileImage(File(student.image))
                    : null,
                child: (student.image == '0' || student.image.isEmpty)
                    ? Text(initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14))
                    : null,
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        )),
                    const SizedBox(height: 3),
                    Text(
                      '${student.department} · ${_gradeLabel(student.grade)} · ${student.division}',
                      style: const TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _iconBtn(
                    icon: Icons.edit_rounded,
                    color: AppTheme.primary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: logic,
                          child: UpdateStudentScreen(myStudent: student),
                        ),
                      ),
                    ),
                  ),
                  _iconBtn(
                    icon: Icons.delete_outline_rounded,
                    color: AppTheme.danger,
                    onTap: () => _confirmDelete(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(
          {required IconData icon,
          required Color color,
          required VoidCallback onTap}) =>
      IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        padding: EdgeInsets.zero,
      );

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Student',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Remove "${student.name}" permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              logic.deleteStudent(id: student.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _gradeLabel(int g) {
    const labels = {1: 'First', 2: 'Second', 3: 'Third', 4: 'Fourth'};
    return labels[g] ?? '$g';
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasStudents;
  const _EmptyState({required this.hasStudents});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasStudents
                ? Icons.search_off_rounded
                : Icons.people_outline_rounded,
            size: 64,
            color: AppTheme.textSecondary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            hasStudents ? 'No results found' : 'No students yet',
            style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            hasStudents
                ? 'Try a different name or ID'
                : 'Add your first student from the home screen',
            style: TextStyle(
                color: AppTheme.textSecondary.withOpacity(0.7), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
