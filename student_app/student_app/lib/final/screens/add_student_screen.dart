import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/screens/student_form.dart';
import 'package:student_app/final/studentLogic.dart';
import 'package:student_app/final/studentState.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final name = TextEditingController();
  final email = TextEditingController(text: '@gmail.com');
  final password = TextEditingController();
  final gender = TextEditingController();
  final dateOFbirth = TextEditingController();
  final maritalStatus = TextEditingController();
  final nationalID = TextEditingController();
  final religion = TextEditingController();
  final nationality = TextEditingController();
  final placeOFbirth = TextEditingController();
  final yearOfadmission = TextEditingController();
  final healthCare = TextEditingController();
  final department = TextEditingController();
  final grade = TextEditingController();
  final division = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      name, email, password, gender, dateOFbirth, maritalStatus,
      nationalID, religion, nationality, placeOFbirth, yearOfadmission,
      healthCare, department, grade, division
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _clear() {
    name.clear();
    email.text = '@gmail.com';
    password.clear();
    gender.clear();
    dateOFbirth.clear();
    maritalStatus.clear();
    nationalID.clear();
    religion.clear();
    nationality.clear();
    placeOFbirth.clear();
    yearOfadmission.clear();
    healthCare.clear();
    department.clear();
    grade.clear();
    division.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentLogic, StudentState>(
      listener: (context, state) {
        if (state is InsertStudent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Student added successfully'),
              backgroundColor: Colors.green[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          _clear();
          setState(() {});
        }
      },
      builder: (context, state) {
        final obj = BlocProvider.of<StudentLogic>(context);
        return Scaffold(
          appBar: AppBar(title: const Text('Add Student')),
          body: StudentForm(
            name: name,
            email: email,
            password: password,
            gender: gender,
            dateOFbirth: dateOFbirth,
            maritalStatus: maritalStatus,
            nationalID: nationalID,
            religion: religion,
            nationality: nationality,
            placeOFbirth: placeOFbirth,
            yearOfadmission: yearOfadmission,
            healthCare: healthCare,
            department: department,
            grade: grade,
            division: division,
            submitLabel: 'Add Student',
            onSubmit: () {
              if (name.text.isEmpty || department.text.isEmpty ||
                  grade.text.isEmpty || division.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please fill all required fields'),
                    backgroundColor: Colors.red[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
                return;
              }
              obj.insertStudent(
                name: name.text,
                email: email.text,
                password: password.text,
                gender: gender.text,
                dateOFbirth: dateOFbirth.text,
                maritalStatus: maritalStatus.text,
                nationalID: nationalID.text,
                religion: religion.text,
                nationality: nationality.text,
                placeOFbirth: placeOFbirth.text,
                yearOfadmission: yearOfadmission.text,
                healthCare: healthCare.text,
                department: department.text,
                grade: toInt(grade.text),
                division: division.text,
                ratings: [],
              );
            },
          ),
        );
      },
    );
  }
}
