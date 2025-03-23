abstract class LoginState {}

class LoginStateInitial extends LoginState {}

class ChnageStatusOfEmplyeeAndUser extends LoginState {}
class SuccessLoginState extends LoginState {}
class FailureLoginState extends LoginState {}
class LoadingLoginState extends LoginState {}
class SuccessCheckEmployeeState extends LoginState {}
class FailureCheckEmployeeState extends LoginState {}
class LoadingCheckEmployeeState extends LoginState {}