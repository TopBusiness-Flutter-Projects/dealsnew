abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class LoadedNotificationState extends NotificationState {}

class ErrorNotificationState extends NotificationState {
  final String error;

  ErrorNotificationState({required this.error});
}

class LoadingNotificationState extends NotificationState {}
