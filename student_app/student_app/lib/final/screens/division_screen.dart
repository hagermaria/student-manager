import 'package:flutter/material.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/theme.dart';
import 'courses_screen.dart';

class DivisionScreen extends StatelessWidget {
  final String department;
  final String grade;
  final Map mymap;
  final dynamic logic;

  const DivisionScreen({
    super.key,
    required this.department,
    required this.grade,
    required this.mymap,
    this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$grade Year')),
      body: mymap.isEmpty
          ? const Center(
              child: Text('No divisions configured',
                  style: TextStyle(color: AppTheme.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: mymap.length,
              itemBuilder: (ctx, i) {
                final key = mymap.keys.elementAt(i);
                return departmentTile(
                  text: key,
                  icon: key == 'Special'
                      ? Icons.star_outline_rounded
                      : Icons.people_outline_rounded,
                  onTap: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => CoursesScreen(
                        department: department,
                        grade: grade,
                        division: key,
                        logic: logic,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
