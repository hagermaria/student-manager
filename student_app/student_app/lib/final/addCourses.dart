/// Initializes rating slots for a new student based on their grade level.
/// Each grade year gets a map of course-name → 0 (starting score).
/// Course names are generated as placeholders; real courses come from the
/// courses map managed by the admin.
void addCourses({
  required List ratings,
  required String department,
  required int grade,
  required String division,
}) {
  for (int i = 0; i < grade; i++) {
    ratings.add({});
  }
}
