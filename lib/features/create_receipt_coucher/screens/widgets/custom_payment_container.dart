import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/api/end_points.dart';
import 'package:top_sale/core/models/all_payments_model.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/app_strings.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/features/details_order/screens/pdf.dart';

class CustomPaymentContainer extends StatelessWidget {
  const CustomPaymentContainer({
    super.key,
    required this.paymentModel,
  });
  final PaymentModel paymentModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0.sp, right: 10.0.sp, bottom: 10.0.sp),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return PdfViewerPage(
                baseUrl:
                    '${EndPoints.printPayment}${paymentModel.paymentId.toString()}',
              );
              // return PaymentWebViewScreen(url: "",);
            },
          ));
        },
        child: Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.1),
                spreadRadius: 1, 
                blurRadius: 1,
                offset: const Offset(0, 1), 
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        paymentModel.name.toString(),
                     
                        style: TextStyle(
                            fontFamily: AppStrings.fontFamily,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                            fontSize: 16.sp),
                      ),
                    ),
                    Text(
                      paymentModel.paymentDate.toString(),
                      style: getBoldStyle(
                          color: AppColors.orangeThirdPrimary, fontSize: 13.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Row(
                        children: [
                          Image.asset(
                            ImageAssets.userPayment,
                            color: AppColors.secondry,
                            width: 30.w,
                            height: 30.w,
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Flexible(
                            child: Text(
                              paymentModel.partnerName.toString(),
                              style: getBoldStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(
                          "${paymentModel.amount} ${paymentModel.currency}",
                          style: getMediumStyle(fontSize: 14.sp)),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(paymentModel.journalName.toString(),
                          style: getMediumStyle(fontSize: 14.sp)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
