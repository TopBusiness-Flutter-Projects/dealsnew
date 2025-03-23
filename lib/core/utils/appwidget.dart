import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:top_sale/app.dart';
import 'app_colors.dart';
class AppWidget{
  static createProgressDialog(BuildContext context,) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            content: Row(
              children: [
                 CircularProgressIndicator(
                  color: AppColors.primary,

                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(
                  "loading".tr(),
                  style: TextStyle(color: AppColors.black, fontSize: 15.0),
                )
              ],
            ),
          );
        });
  }

}