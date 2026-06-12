abstract class StudentState {}

class InitStudent extends StudentState {}

class CreateStudent extends StudentState {}

class InsertStudent extends StudentState {}

class UpdateStudent extends StudentState {}

class DeleteStudent extends StudentState {}

class GetStudent extends StudentState {}

class UpdateRatings extends StudentState {}

class UpdateImage extends StudentState {}

class AddImageFile extends StudentState {}

class Refresh extends StudentState {}

class GetGenera extends StudentState {}

class InsertGeneral extends StudentState {}

class UpdatePassword extends StudentState {}

class UpdateCourses extends StudentState {}

class LoadingState extends StudentState {}

class ErrorState extends StudentState {
  final String message;
  ErrorState(this.message);
}
