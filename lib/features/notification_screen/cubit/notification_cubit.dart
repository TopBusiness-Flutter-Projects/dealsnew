import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/remote/service.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.api) : super(NotificationInitial());
  ServiceApi api;
//  NotificationModel? notificationModel;

  // void getNotificationData() async {
  //   emit(LoadingNotificationState());
  //   final result = await api.getNotificationData();
  //   result.fold(
  //     (failure) =>
  //         emit(ErrorNotificationState(error: 'Error loading data: $failure')),
  //     (r) {
  //       notificationModel = r;
  //       debugPrint("the model : ${notificationModel?.data?.length.toString()}");
  //       emit(LoadedNotificationState());
  //     },
  //   );
  // }
}
