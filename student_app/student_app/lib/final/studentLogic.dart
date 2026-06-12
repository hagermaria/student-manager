import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:student_app/final/addCourses.dart';
import 'package:student_app/final/modelStudent.dart';
import 'package:student_app/final/studentState.dart';

class StudentLogic extends Cubit<StudentState> {
  StudentLogic() : super(InitStudent());

  late Database db;
  List students = [];
  List<ModelStudent> student = [];
  List<Map> general = [];
  Map courses = {};

  File? imageFile;
  Uint8List? bytes;
  String? img64;

  // ─── Database Setup ────────────────────────────────────────────────────────

  Future<void> createDatabaseAndTable() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'final.db');

    await openDatabase(
      path,
      version: 3,
      onCreate: (d, i) async {
        await d.execute(
          "CREATE TABLE student ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "name TEXT, email TEXT, password TEXT, gender TEXT, "
          "dateOFbirth TEXT, maritalStatus TEXT, nationalID TEXT, "
          "religion TEXT, nationality TEXT, placeOFbirth TEXT, "
          "yearOfadmission TEXT, healthCare TEXT, department TEXT, "
          "grade INTEGER, division TEXT, ratings TEXT, image TEXT"
          ")",
        );
        await d.execute(
          "CREATE TABLE general (password TEXT, courses TEXT)",
        );
        // Seed default data
        await d.rawInsert(
          "INSERT INTO general (password, courses) VALUES ('admin123', ?)",
          [
            jsonEncode({
              'Chemistry': {
                'First': {'Special': {}, 'General': {}},
                'Second': {'Special': {}, 'General': {}},
                'Third': {'Special': {}, 'General': {}},
                'Fourth': {'Special': {}, 'General': {}},
              },
              'Physics': {
                'First': {'Special': {}, 'General': {}},
                'Second': {'Special': {}, 'General': {}},
                'Third': {'Special': {}, 'General': {}},
                'Fourth': {'Special': {}, 'General': {}},
              },
              'Biology': {
                'First': {'Special': {}, 'General': {}},
                'Second': {'Special': {}, 'General': {}},
                'Third': {'Special': {}, 'General': {}},
                'Fourth': {'Special': {}, 'General': {}},
              },
              'Mathematics': {
                'First': {'Special': {}, 'General': {}},
                'Second': {'Special': {}, 'General': {}},
                'Third': {'Special': {}, 'General': {}},
                'Fourth': {'Special': {}, 'General': {}},
              },
              'Geology': {
                'First': {'Special': {}, 'General': {}},
                'Second': {'Special': {}, 'General': {}},
                'Third': {'Special': {}, 'General': {}},
                'Fourth': {'Special': {}, 'General': {}},
              },
            })
          ],
        );
      },
      onUpgrade: (d, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await d.execute(
              "CREATE TABLE IF NOT EXISTS general (password TEXT, courses TEXT)");
        }
      },
      onOpen: (data) => print('Database opened'),
    ).then((onValue) {
      db = onValue;
      emit(CreateStudent());
    });

    await _loadAll();
  }

  Future<void> _loadAll() async {
    final s = await getStudent();
    students = s;
    student.clear();
    for (int i = 0; i < students.length; i++) {
      student.add(_mapToModel(students[i]));
    }
    emit(GetStudent());

    final g = await getGeneral();
    general = g;
    if (general.isNotEmpty) {
      courses = jsonDecode(general[0]['courses']);
    }
    emit(GetGenera());
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  ModelStudent _mapToModel(Map row) => ModelStudent(
        id: row['id'],
        grade: row['grade'],
        name: row['name'],
        email: row['email'],
        password: row['password'],
        gender: row['gender'],
        dateOFbirth: row['dateOFbirth'],
        maritalStatus: row['maritalStatus'],
        nationalID: row['nationalID'],
        religion: row['religion'],
        nationality: row['nationality'],
        placeOFbirth: row['placeOFbirth'],
        yearOfadmission: row['yearOfadmission'],
        healthCare: row['healthCare'],
        department: row['department'],
        division: row['division'],
        image: row['image'] ?? '0',
        ratings: jsonDecode(row['ratings'] ?? '[]'),
      );

  // ─── CRUD ──────────────────────────────────────────────────────────────────

  void insertStudent({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dateOFbirth,
    required String maritalStatus,
    required String nationalID,
    required String religion,
    required String nationality,
    required String placeOFbirth,
    required String yearOfadmission,
    required String healthCare,
    required String department,
    required int grade,
    required String division,
    required List ratings,
  }) {
    addCourses(
        ratings: ratings,
        department: department,
        grade: grade,
        division: division);
    final ratingsJson = jsonEncode(ratings);

    db.transaction((txn) async {
      final id = await txn.rawInsert(
        "INSERT INTO student (name,email,password,gender,dateOFbirth,"
        "maritalStatus,nationalID,religion,nationality,placeOFbirth,"
        "yearOfadmission,healthCare,department,grade,division,ratings,image)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'0')",
        [
          name, email, password, gender, dateOFbirth,
          maritalStatus, nationalID, religion, nationality, placeOFbirth,
          yearOfadmission, healthCare, department, grade, division, ratingsJson
        ],
      );
      print("Inserted student id=$id");
      emit(InsertStudent());
      await _loadAll();
    });
  }

  void insertGeneral({required String password, required Map courses}) {
    final json = jsonEncode(courses);
    db.transaction((txn) async {
      await txn.rawInsert(
          "INSERT INTO general (password,courses) VALUES (?,?)",
          [password, json]);
      emit(InsertGeneral());
    });
  }

  Future<List<Map>> getStudent() async =>
      await db.rawQuery("SELECT * FROM student");

  Future<List<Map>> getGeneral() async =>
      await db.rawQuery("SELECT * FROM general");

  // BUG FIX: was adding a new model instead of replacing the existing one
  Future<void> updateStudent({
    required int id,
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dateOFbirth,
    required String maritalStatus,
    required String nationalID,
    required String religion,
    required String nationality,
    required String placeOFbirth,
    required String yearOfadmission,
    required String healthCare,
    required String department,
    required int grade,
    required String division,
  }) async {
    await db.rawUpdate(
      "UPDATE student SET name=?, email=?, password=?, gender=?, "
      "dateOFbirth=?, maritalStatus=?, nationalID=?, religion=?, "
      "nationality=?, placeOFbirth=?, yearOfadmission=?, healthCare=?, "
      "department=?, grade=?, division=? WHERE id=?",
      [
        name, email, password, gender, dateOFbirth, maritalStatus,
        nationalID, religion, nationality, placeOFbirth, yearOfadmission,
        healthCare, department, grade, division, id
      ],
    );
    print("Updated student id=$id");
    emit(UpdateStudent());
    await _loadAll();
  }

  Future<void> updatePassword({required String password}) async {
    await db.rawUpdate("UPDATE general SET password=?", [password]);
    emit(UpdatePassword());
    final g = await getGeneral();
    general = g;
    courses = jsonDecode(general[0]['courses']);
    emit(GetGenera());
  }

  Future<void> updateCourses({required Map course}) async {
    final json = jsonEncode(course);
    await db.rawUpdate("UPDATE general SET courses=?", [json]);
    emit(UpdateCourses());
    final g = await getGeneral();
    general = g;
    courses = jsonDecode(general[0]['courses']);
    emit(GetGenera());
  }

  Future<void> deleteStudent({required int id}) async {
    await db.rawDelete("DELETE FROM student WHERE id=?", [id]);
    print('Deleted student id=$id');
    emit(DeleteStudent());
    await _loadAll();
  }

  Future<void> updateRatings({required int id, required List ratings}) async {
    final json = jsonEncode(ratings);
    await db.rawUpdate(
        "UPDATE student SET ratings=? WHERE id=?", [json, id]);
    emit(UpdateRatings());
    // Update in-memory list
    for (int i = 0; i < student.length; i++) {
      if (student[i].id == id) {
        student[i].ratings = jsonDecode(json);
        break;
      }
    }
    emit(GetStudent());
  }

  // BUG FIX: updateImage now correctly stores image path
  Future<void> updateImage({required int id, required String image}) async {
    await db.rawUpdate(
        "UPDATE student SET image=? WHERE id=?", [image, id]);
    emit(UpdateImage());
    for (int i = 0; i < student.length; i++) {
      if (student[i].id == id) {
        student[i].image = image;
        break;
      }
    }
    emit(GetStudent());
  }

  // BUG FIX: was modifying a local parameter, now correctly sets the field
  void addImageFile(File? file, dynamic image) {
    if (image != null) {
      imageFile = File(image.path);
      emit(AddImageFile());
    }
  }

  void refresh() => emit(Refresh());
}
