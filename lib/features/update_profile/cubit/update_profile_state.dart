abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}
class UpdateProfileImagePicked extends UpdateProfileState {}
class UpdateProfileError extends UpdateProfileState {
  String? error;UpdateProfileError({required this.error});
}
class CheckIfUserOrEmployee extends UpdateProfileState {}
//post user
class UpdateProfileUserLoading extends UpdateProfileState {}
class UpdateProfileUserLoaded extends UpdateProfileState {}
class UpdateProfileUserError extends UpdateProfileState {}
//post Update employee
class UpdateProfileEmployeeLoading extends UpdateProfileState {}
class UpdateProfileEmployeeLoaded extends UpdateProfileState {}
class UpdateProfileEmployeeError extends UpdateProfileState {}

