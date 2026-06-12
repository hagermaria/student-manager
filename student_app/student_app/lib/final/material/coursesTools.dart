class CoursesTools {
  Map mymap;

  CoursesTools(this.mymap);

  Map addDepartment({required String department}) {
    mymap[department] = {};
    return mymap;
  }

  Map removeDepartment({required String department}) {
    mymap.remove(department);
    return mymap;
  }

  Map addGrade({required String department, required String grade}) {
    mymap[department]?[grade] = {};
    return mymap;
  }

  Map removeGrade({required String department, required String grade}) {
    mymap[department]?.remove(grade);
    return mymap;
  }

  Map addDivision({
    required String department,
    required String grade,
    required String division,
  }) {
    mymap[department]![grade]?[division] = {};
    return mymap;
  }

  Map removeDivision({
    required String department,
    required String grade,
    required String division,
  }) {
    mymap[department]?[grade]?.remove(division);
    return mymap;
  }

  /// BUG FIX: was `mymap[...][courseName];` (read-only) — now correctly assigns 0
  Map addCourse({
    required String department,
    required String grade,
    required String division,
    required String courseName,
  }) {
    mymap[department]![grade]![division]?[courseName] = 0;
    return mymap;
  }

  Map removeCourse({
    required String department,
    required String grade,
    required String division,
    required String courseName,
  }) {
    mymap[department]![grade]![division]?.remove(courseName);
    return mymap;
  }

  Map updateDegree({
    required String department,
    required String grade,
    required String division,
    required String courseName,
    required double maxDegree,
  }) {
    mymap[department]![grade]![division]?[courseName] = maxDegree;
    return mymap;
  }
}
