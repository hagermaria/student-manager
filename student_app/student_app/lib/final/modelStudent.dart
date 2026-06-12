class ModelStudent {
  int id, grade;
  String name,
      email,
      password,
      gender,
      dateOFbirth,
      maritalStatus,
      nationalID,
      religion,
      nationality,
      placeOFbirth,
      yearOfadmission,
      healthCare,
      department,
      division,
      image;
  List ratings;

  ModelStudent({
    required this.id,
    required this.grade,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.dateOFbirth,
    required this.maritalStatus,
    required this.nationalID,
    required this.religion,
    required this.nationality,
    required this.placeOFbirth,
    required this.yearOfadmission,
    required this.healthCare,
    required this.department,
    required this.division,
    required this.image,
    required this.ratings,
  });
}
