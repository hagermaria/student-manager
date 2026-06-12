import 'package:flutter/material.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/theme.dart';
import 'grade_screen.dart';

const _deptIcons = <String, IconData>{
  'Chemistry': Icons.science_outlined,
  'Physics': Icons.bolt_outlined,
  'Biology': Icons.eco_outlined,
  'Mathematics': Icons.calculate_outlined,
  'Geology': Icons.terrain_outlined,
};

class DepartmentScreen extends StatelessWidget {
  final Map mymap;
  final dynamic logic; // StudentLogic passed through to avoid new BlocProvider

  const DepartmentScreen(this.mymap, {super.key, this.logic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: mymap.isEmpty
          ? _empty('No departments configured')
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: mymap.length,
              itemBuilder: (ctx, i) {
                final key = mymap.keys.elementAt(i);
                return departmentTile(
                  text: key,
                  icon: _deptIcons[key] ?? Icons.school_outlined,
                  onTap: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => GradeScreen(
                        department: key,
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

  Widget _empty(String msg) => Center(
        child: Text(msg,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 15)),
      );
}
