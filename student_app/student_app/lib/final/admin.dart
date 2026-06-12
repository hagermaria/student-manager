import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/screens/add_student_screen.dart';
import 'package:student_app/final/screens/department_screen.dart';
import 'package:student_app/final/screens/search_screen.dart';
import 'package:student_app/final/studentLogic.dart';
import 'package:student_app/final/studentState.dart';
import 'package:student_app/final/theme.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentLogic()..createDatabaseAndTable(),
      child: BlocConsumer<StudentLogic, StudentState>(
        listener: (context, state) {},
        builder: (context, state) {
          final obj = BlocProvider.of<StudentLogic>(context);
          final studentCount = obj.student.length;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Student Manager'),
              actions: [
                IconButton(
                  tooltip: 'Search students',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                            value: obj, child: const SearchScreen())),
                  ),
                  icon: const Icon(Icons.search_rounded),
                ),
                const SizedBox(width: 4),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats card ──────────────────────────────────────
                  _StatsCard(studentCount: studentCount),
                  const SizedBox(height: 28),

                  // ── Quick actions ───────────────────────────────────
                  sectionHeader('Quick Actions'),
                  const SizedBox(height: 4),
                  _ActionCard(
                    icon: Icons.person_add_alt_1_rounded,
                    title: 'Add New Student',
                    subtitle: 'Register a student with full details',
                    color: AppTheme.primary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                              value: obj, child: const AddStudentScreen())),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ActionCard(
                    icon: Icons.school_rounded,
                    title: 'Manage Classes',
                    subtitle: 'Add or remove courses by dept & grade',
                    color: AppTheme.accent,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DepartmentScreen(obj.courses,
                              logic: obj)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int studentCount;
  const _StatsCard({required this.studentCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dashboard_rounded,
                  color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Overview',
                style:
                    TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$studentCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Students enrolled',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        )),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        )),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
