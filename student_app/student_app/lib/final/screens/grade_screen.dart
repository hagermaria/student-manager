import 'package:flutter/material.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/theme.dart';
import 'division_screen.dart';

const _gradeIcons = <String, IconData>{
  'First': Icons.looks_one_outlined,
  'Second': Icons.looks_two_outlined,
  'Third': Icons.looks_3_outlined,
  'Fourth': Icons.looks_4_outlined,
};

class GradeScreen extends StatelessWidget {
  final String department;
  final Map mymap;
  final dynamic logic;

  const GradeScreen(
      {super.key,
      required this.department,
      required this.mymap,
      this.logic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(department)),
      body: mymap.isEmpty
          ? const Center(
              child: Text('No grades configured',
                  style: TextStyle(color: AppTheme.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: mymap.length,
              itemBuilder: (ctx, i) {
                final key = mymap.keys.elementAt(i);
                return departmentTile(
                  text: '$key Year',
                  icon: _gradeIcons[key] ?? Icons.school_outlined,
                  onTap: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => DivisionScreen(
                        department: department,
                        grade: key,
                        mymap: mymap[key],
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
