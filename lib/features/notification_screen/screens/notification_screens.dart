import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/shard_appbar_app.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import 'custom_notificaton_widget.dart';import 'package:top_sale/core/utils/circle_progress.dart';

import 'notification_dialog.dart';

class NotificationScreens extends StatefulWidget {
  NotificationScreens({super.key, this.data});
  final String? data;
  @override
  State<NotificationScreens> createState() => _NotificationScreensState();
}

class _NotificationScreensState extends State<NotificationScreens> {
  @override
  void initState() {
    //   context.read<NotificationCubit>().getNotificationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<NotificationCubit>();
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: [
              // AppBarWidget(
              //   text: "notifications".tr(),
              // ),
              SharedAppBarApp(
                title: 'notification'.tr(),
              ),
              BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                // print("the model ${cubit.notificationModel!.data!.toString()}");
                return (state is LoadingNotificationState)
                    ? const Expanded(
                        child: Center(
                          child: CustomLoadingIndicator(),
                        ),
                      )
                    :
                    // (cubit.notificationModel!.data!.isEmpty)
                    //        ?
                    //     Expanded(
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Image.asset(
                    //                   ImageAssets.noNotificationIcon,
                    //                   width: getSize(context) / 6,
                    //                   height: getSize(context) / 6,
                    //                 )
                    //               ],
                    //             ),
                    //           )
                    //         :
                    Expanded(
                        child: ListView.builder(
                          //  itemCount: cubit.notificationModel?.data?.length,
                          itemCount: 6,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      // NotificationDialog(
                                      //   notificationModel: cubit
                                      //       .notificationModel
                                      //       ?.data?[index],
                                      // ));
                                      //
                                      NotificationDialog());
                            },
                            child: NotificationWidget(),
                          ),
                        ),
                      );
              })
            ])));
  }
}
