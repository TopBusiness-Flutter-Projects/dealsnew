abstract class ItineraryState {}

class ItineraryInitial extends ItineraryState {}

class ProfileUserLoading extends ItineraryState {}

class ProfileUserLoaded extends ItineraryState {
  String error;
  ProfileUserLoaded({required this.error});
}

class ProfileUserError extends ItineraryState {}

//employee
class ProfileEmployeeLoading extends ItineraryState {}

class ProfileEmployeeError extends ItineraryState {
  String error;
  ProfileEmployeeError({required this.error});
}

class ProfileEmployeeLoaded extends ItineraryState {}

class checkLoaded extends ItineraryState {}

class checkClearLoaded extends ItineraryState {}

class ProfileClientLoading extends ItineraryState {}

class ProfileClientError extends ItineraryState {}

class ProfileClientLoaded extends ItineraryState {}

class LoadingCheckEmployeeState extends ItineraryState {}

class FailureCheckEmployeeState extends ItineraryState {}

class SuccessCheckEmployeeState extends ItineraryState {}

class EmployeeNumberAdded extends ItineraryState {}
class ChangeTrackingState extends ItineraryState {}
