import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_fonts.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/get_size.dart';


class SharedAppBarApp extends StatelessWidget {
   SharedAppBarApp({super.key,required this.title});
String ?title;
  @override
  Widget build(BuildContext context) {
    return     Padding(
      padding: EdgeInsets.all(getSize(context) / 30),
      child: Row(
        children: [
          Directionality.of(context) == TextDirection.RTL
              ? InkWell( onTap:(){Navigator.pop(context);},child: Image.asset(ImageAssets.arrowAr))
              : InkWell( onTap:(){Navigator.pop(context);},child: Icon(Icons.arrow_back, color: AppColors.primary)),
          SizedBox(width: getSize(context) / 50),
          Text(
            title!.tr(),
            style:getBoldStyle()
          ),
        ],
      ),
    );
  }
}
