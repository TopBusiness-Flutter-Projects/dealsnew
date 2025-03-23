abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
//user
class ProfileUserLoading extends ProfileState {}
class ProfileUserLoaded extends ProfileState {
  String error;
  ProfileUserLoaded({ required this.error});
}
class ProfileUserError extends ProfileState {}
//employee
class ProfileEmployeeLoading extends ProfileState {}
class ProfileEmployeeLoaded extends ProfileState {
  String error;
  ProfileEmployeeLoaded({ required this.error});
}
class ProfileEmployeeError extends ProfileState {}
