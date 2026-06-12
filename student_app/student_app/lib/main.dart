import 'package:flutter/material.dart';
import 'package:student_app/final/admin.dart';
import 'package:student_app/final/theme.dart';

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Manager',
      theme: AppTheme.theme,
      home: const Admin(),
    );
  }
}
