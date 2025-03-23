abstract class HomeState {}

class MainInitial extends HomeState {}

class ProfileUserLoading extends HomeState {}

class ProfileUserLoaded extends HomeState {
  String error;
  ProfileUserLoaded({required this.error});
}

class ProfileUserError extends HomeState {}

//employee
class ProfileEmployeeLoading extends HomeState {}

class ProfileEmployeeError extends HomeState {
  String error;
  ProfileEmployeeError({required this.error});
}

class ProfileEmployeeLoaded extends HomeState {}

class checkLoaded extends HomeState {}

class checkClearLoaded extends HomeState {}

class ProfileClientLoading extends HomeState {}

class ProfileClientError extends HomeState {}

class ProfileClientLoaded extends HomeState {}

class LoadingCheckEmployeeState extends HomeState {}

class FailureCheckEmployeeState extends HomeState {}

class SuccessCheckEmployeeState extends HomeState {}

class EmployeeNumberAdded extends HomeState {}

class GetCurrencyNameLoaded extends HomeState {}
