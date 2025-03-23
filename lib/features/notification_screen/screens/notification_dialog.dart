import 'package:flutter/material.dart';

// import '../../../core/models/notification_model.dart';
// import '../../../core/utils/custom_themes.dart';
// import '../../../core/utils/dimensions.dart';

class NotificationDialog extends StatelessWidget {
 // final NotificationModelData? notificationModel;
 // const NotificationDialog({this.notificationModel});
  const NotificationDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10),
            child: Text(
             // notificationModel?.title ?? '',
              "تمت النوتيفيكشن بنجاح",
              textAlign: TextAlign.center,
              // style: titilliumSemiBold.copyWith(
              //   color: Theme.of(context).primaryColor,
              //   fontSize: Dimensions.FONT_SIZE_LARGE,
              ),
            ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              "ديي النوتيفيكشن",
             // notificationModel?.body ?? '',
              textAlign: TextAlign.center,
            //  style: titilliumRegular,
            ),
          ),
        ],
      ),
    );
  }
}
