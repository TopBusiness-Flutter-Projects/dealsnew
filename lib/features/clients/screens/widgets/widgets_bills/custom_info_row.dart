import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_fonts.dart';

class CustomInfoRow extends StatelessWidget {
  const CustomInfoRow({
    super.key,
    required this.path,
    required this.text,
  });
  final String path;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SvgPicture.asset(
        path,
        color: AppColors.primary,

        // width: 24.w,
        // height: 24.w,
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Text(
          text,
          style: getRegularStyle(
            color: AppColors.primary,
          ),
        ),
      )
    ]);
  }
}

class TotalRow extends StatelessWidget {
  const TotalRow({
    super.key,
    required this.path,
    required this.text,
  });

  final String path;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SvgPicture.asset(
        path,
        color: AppColors.primary,
        // width: 22.w,
        // height: 22.w,
      ),
      const SizedBox(
        width: 10,
      ),
      RichText(
        maxLines: 1,
        text: TextSpan(
          children: [
            TextSpan(
                text: "total".tr() + ":",
                style: getRegularStyle(
                  color: AppColors.primary,
                )),
            TextSpan(
                text: text,
                style: getBoldStyle(
                  color: AppColors.primary,
                )),
            TextSpan(
                text: ' ',
                style: getBoldStyle(
                  fontSize: 15.sp,
                )),
            TextSpan(
                text: context.read<HomeCubit>().currencyName + "\n",
                // text: "currency".tr() + "\n",
                style: getRegularStyle(
                  color: AppColors.primary,
                )),
          ],
        ),
      )
    ]);
  }
}

class OrderStatusRow extends StatelessWidget {
  const OrderStatusRow({
    super.key,
    required this.isCurrent,
    required this.withPrice,
  });

  final bool isCurrent;
  final bool withPrice;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          color: isCurrent ? AppColors.secondPrimary : AppColors.secondPrimary),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isCurrent ? ImageAssets.moneyIcon : ImageAssets.moneyIcon,
                color: AppColors.secondry,
                width: 22.w,
                height: 22.w,
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  withPrice
                      ?
// the service is with offerd price

                      isCurrent
                          ? "waitingTechniciansAccept".tr()
                          : "techniciansArrive".tr()
                      : // the service is without offerd price

                      isCurrent
                          ? "waitingInspectionFromTechnicians".tr()
                          : "inspectionDone".tr(),
                  style: getRegularStyle(
                    color: AppColors.secondPrimary,
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
