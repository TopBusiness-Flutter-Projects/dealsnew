import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_fonts.dart';
import '../../../core/utils/assets_manager.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 5.h,
            top: 5.h),
        child: Container(
          height: 75.h,
          padding: EdgeInsets.symmetric(
              vertical:
              8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                  color: AppColors.gray2.withOpacity(.3),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 4.sp,
                  offset: const Offset(1, 1)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment:
            //     MainAxisAlignment
            //         .spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 10.w, right: 10.w),
                child:   SvgPicture.asset(
                  ImageAssets.notification,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     
                      "طلب جديد",
                      style:getBoldStyle(fontweight: FontWeight.w700,fontSize: 16.sp,color:AppColors.secondPrimary),
                      maxLines: 1,
                     
                    ),
                    Flexible(
                      child: Text(
                     
                          'تم اضافة طلب جديد للتوصيل يمكنك الاطلاع عليه فى الطالبات الحالية'.tr(),
                          overflow:
                          TextOverflow.ellipsis,
                          maxLines: 2,
                          style:  getRegularStyle(fontSize: 12.sp,color:AppColors.primary)
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("الان",style: getBoldStyle(fontSize: 12.sp,fontweight: FontWeight.w700,color:AppColors.orange),),
              )
            ],
          ),
        ));
  }
}
