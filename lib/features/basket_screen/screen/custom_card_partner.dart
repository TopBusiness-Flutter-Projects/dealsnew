import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/widgets/decode_image.dart';
import 'package:top_sale/features/contact_us/cubit/contact_us_cubit.dart';
import '../../../../core/models/all_partners_for_reports_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/get_size.dart';

class CustomCardPartner extends StatelessWidget {
  const CustomCardPartner({this.partner, super.key});
  final AllPartnerResults? partner;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        partner?.image.toString() != 'false'
            ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CustomDecodedImage(
                  base64String: partner?.image,
                  // context: context,
                  height: 70.h,
                  width: 70.h,
                ),
              )
            : CircleAvatar(
                radius: 35.h,
                backgroundImage: AssetImage(ImageAssets.user),
              ),
        SizedBox(
          width: 10.w,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                partner?.name.toString() ?? '',
                style: TextStyle(
                    fontFamily: AppStrings.fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: getSize(context) / 30),
              ),
              Text(
                partner?.phone.toString() == 'false'
                    ? '_'
                    : partner?.phone.toString() ?? '',
                style: TextStyle(
                    fontFamily: AppStrings.fontFamily,
                    fontSize: getSize(context) / 30),
              ),
             
            ],
          ),
        ),
        // Spacer(),
      ],
    );
  }
}
