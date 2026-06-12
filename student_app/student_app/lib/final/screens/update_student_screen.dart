import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/final/material/widgets.dart';
import 'package:student_app/final/modelStudent.dart';
import 'package:student_app/final/screens/student_form.dart';
import 'package:student_app/final/studentLogic.dart';
import 'package:student_app/final/studentState.dart';

class UpdateStudentScreen extends StatefulWidget {
  final ModelStudent myStudent;
  const UpdateStudentScreen({super.key, required this.myStudent});

  @override
  State<UpdateStudentScreen> createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController gender;
  late TextEditingController dateOFbirth;
  late TextEditingController maritalStatus;
  late TextEditingController nationalID;
  late TextEditingController religion;
  late TextEditingController nationality;
  late TextEditingController placeOFbirth;
  late TextEditingController yearOfadmission;
  late TextEditingController healthCare;
  late TextEditingController department;
  late TextEditingController grade;
  late TextEditingController division;

  @override
  void initState() {
    super.initState();
    final s = widget.myStudent;
    name = TextEditingController(text: s.name);
    email = TextEditingController(text: s.email);
    password = TextEditingController(text: s.password);
    gender = TextEditingController(text: s.gender);
    dateOFbirth = TextEditingController(text: s.dateOFbirth);
    maritalStatus = TextEditingController(text: s.maritalStatus);
    nationalID = TextEditingController(text: s.nationalID);
    religion = TextEditingController(text: s.religion);
    nationality = TextEditingController(text: s.nationality);
    placeOFbirth = TextEditingController(text: s.placeOFbirth);
    yearOfadmission = TextEditingController(text: s.yearOfadmission);
    healthCare = TextEditingController(text: s.healthCare);
    department = TextEditingController(text: s.department);
    grade = TextEditingController(text: toStr(s.grade));
    division = TextEditingController(text: s.division);
  }

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentLogic, StudentState>(
      listener: (context, state) {
        if (state is UpdateStudent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Student updated successfully'),
              backgroundColor: Colors.green[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          // BUG FIX: was doing 3x Navigator.pop + push(Admin) which broke the stack
          // Now just pop once to go back naturally
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final obj = BlocProvider.of<StudentLogic>(context);
        return Scaffold(
          appBar: AppBar(title: const Text('Edit Student')),
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
            submitLabel: 'Save Changes',
            onSubmit: () {
              obj.updateStudent(
                id: widget.myStudent.id,
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
              );
            },
          ),
        );
      },
    );
  }
}
