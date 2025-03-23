class TasksState {}

class TasksInitial extends TasksState {}

class DeadlineDateSelectedState extends TasksState {}

class LoadingCreateTaskState extends TasksState {}

class FailureCreateTaskState extends TasksState {}

class SuccessCreateTaskState extends TasksState {}

class ChangeIndexState extends TasksState {}
class GetAllTasksLoadedState extends TasksState {}
class GetAllTasksErrorState extends TasksState {}
class GetAllTasksLoadingState extends TasksState {}
class LoadingUpdateState extends TasksState {}
class FailureUpdateState extends TasksState {}
class SuccessUpdateState extends TasksState {}