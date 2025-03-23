import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/assets_manager.dart';
import '../utils/get_size.dart';

class SharedAppBarApp extends StatelessWidget {
  const SharedAppBarApp({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getSize(context) / 20),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Directionality.of(context) == TextDirection.RTL
                ? Image.asset(ImageAssets.arrowAr)
                : Icon(Icons.arrow_back, color: AppColors.primary,),
            SizedBox(width: getSize(context) / 50),
            Padding(
              padding: EdgeInsets.only(top: getSize(context) / 55),
              child: Text(
                title,
                style: TextStyle(
                    fontFamily: "cairo",
                    color: AppColors.primary,
                    fontSize: getSize(context) / 21,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
