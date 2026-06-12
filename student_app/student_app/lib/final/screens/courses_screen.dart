import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/final/material/coursesTools.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/studentLogic.dart';
import 'package:student_app/final/studentState.dart';
import 'package:student_app/final/theme.dart';

class CoursesScreen extends StatefulWidget {
  final String department;
  final String grade;
  final String division;
  final StudentLogic? logic;

  const CoursesScreen({
    super.key,
    required this.department,
    required this.grade,
    required this.division,
    this.logic,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final _addCtrl = TextEditingController();
  final _degreeCtrl = TextEditingController();

  @override
  void dispose() {
    _addCtrl.dispose();
    _degreeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentLogic, StudentState>(
      listener: (context, state) {},
      builder: (context, state) {
        final obj = widget.logic ?? BlocProvider.of<StudentLogic>(context);
        final mymap = CoursesTools(obj.courses);

        Map? divMap;
        try {
          divMap = obj.courses[widget.department][widget.grade][widget.division]
              as Map?;
        } catch (_) {
          divMap = null;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.division} · ${widget.grade}'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: Colors.white12),
            ),
          ),
          body: Column(
            children: [
              // ── Add course bar ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _addCtrl,
                        style: const TextStyle(
                            fontSize: 14, color: AppTheme.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'New course name...',
                          prefixIcon: const Icon(Icons.add_circle_outline,
                              color: AppTheme.primary, size: 20),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppTheme.divider)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppTheme.divider)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppTheme.primary, width: 2)),
                          filled: true,
                          fillColor: AppTheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_addCtrl.text.trim().isEmpty) return;
                          // BUG FIX: CoursesTools.addCourse now actually assigns = 0
                          obj.courses = mymap.addCourse(
                            department: widget.department,
                            grade: widget.grade,
                            division: widget.division,
                            courseName: _addCtrl.text.trim(),
                          );
                          obj.updateCourses(course: obj.courses);
                          _addCtrl.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Course list ──────────────────────────────────────
              Expanded(
                child: divMap == null || divMap.isEmpty
                    ? _emptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: divMap.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (ctx, i) {
                          final courseName = divMap!.keys.elementAt(i);
                          final maxDegree = divMap.values.elementAt(i);
                          return _CourseTile(
                            index: i + 1,
                            courseName: courseName,
                            maxDegree: maxDegree,
                            onDelete: () {
                              obj.courses = mymap.removeCourse(
                                department: widget.department,
                                grade: widget.grade,
                                division: widget.division,
                                courseName: courseName,
                              );
                              obj.updateCourses(course: obj.courses);
                            },
                            onDegreeUpdate: (deg) {
                              obj.courses = mymap.updateDegree(
                                department: widget.department,
                                grade: widget.grade,
                                division: widget.division,
                                courseName: courseName,
                                maxDegree: deg,
                              );
                              obj.updateCourses(course: obj.courses);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _emptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined,
                size: 56,
                color: AppTheme.textSecondary.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text('No courses yet',
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 15)),
            const SizedBox(height: 6),
            const Text('Add a course using the field above',
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 12)),
          ],
        ),
      );
}

class _CourseTile extends StatefulWidget {
  final int index;
  final String courseName;
  final dynamic maxDegree;
  final VoidCallback onDelete;
  final void Function(double) onDegreeUpdate;

  const _CourseTile({
    required this.index,
    required this.courseName,
    required this.maxDegree,
    required this.onDelete,
    required this.onDegreeUpdate,
  });

  @override
  State<_CourseTile> createState() => _CourseTileState();
}

class _CourseTileState extends State<_CourseTile> {
  late TextEditingController _degCtrl;

  @override
  void initState() {
    super.initState();
    _degCtrl = TextEditingController(text: '${widget.maxDegree}');
  }

  @override
  void dispose() {
    _degCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${widget.index}',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.courseName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            // Max degree field
            SizedBox(
              width: 60,
              child: TextField(
                controller: _degCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  hintText: 'Max',
                  hintStyle: const TextStyle(fontSize: 11),
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
                  filled: true,
                  fillColor: AppTheme.surface,
                ),
                onSubmitted: (v) {
                  final deg = double.tryParse(v);
                  if (deg != null) widget.onDegreeUpdate(deg);
                },
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppTheme.danger, size: 20),
              onPressed: widget.onDelete,
              constraints:
                  const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
