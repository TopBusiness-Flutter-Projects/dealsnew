import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';

class AdvanceAndSalariesWidget extends StatelessWidget {
  AdvanceAndSalariesWidget({
    super.key,
  });
  List<String> titles = [
    "work_contract".tr(),
    "attendance_and_departure".tr(),
    "monthly_salaries".tr(),
    "available_holidays".tr(),
    "expenses".tr()
  ];
  List<String> subTitles = [
    "",
    "",
    "months".tr(),
    "Holidays".tr(),
    "expenses".tr()
  ];
  List<String> images = [
    ImageAssets.documentIcon,
    ImageAssets.attendanceIcon,
    ImageAssets.salafIcon,
    ImageAssets.instructionsIcon,
    ImageAssets.moneyRedIcon,
  ];
  List<Color> colors = [
    AppColors.orange,
    AppColors.primary,
    AppColors.green,
    AppColors.purpelColor,
    AppColors.red
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,

            mainAxisExtent: 150),
        itemCount: titles.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            if (index == 0) {
              Navigator.pushNamed(context, Routes.contractRoute);
            } else if (index == 1) {
              Navigator.pushNamed(context, Routes.attendanceAndDepartureDetailsRoute);
            } else if (index == 2) {
              Navigator.pushNamed(context, Routes.salariesRoute);
            } else if (index == 3) {
              Navigator.pushNamed(context, Routes.holidayRoute);

            }else if (index == 4) {
              Navigator.pushNamed(context, Routes.moneyRoute);

            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(
                right: BorderSide(color: colors[index], width: 4),
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: Colors.black
                      .withOpacity(0.1),
                  spreadRadius: 1, 
                  blurRadius: 4, 
                  offset: const Offset(0, 1), 
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                                0.1), 
                            spreadRadius: 1, 
                            blurRadius: 1, 
                            offset: const Offset(
                                0, 1),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          images[index],
                          color: AppColors.secondry,
                        ),
                      )),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subTitles[index],
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black)),
                      SizedBox(
                        height: 10.w,
                      ),
                      Text(titles[index],
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black.withOpacity(0.5))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
