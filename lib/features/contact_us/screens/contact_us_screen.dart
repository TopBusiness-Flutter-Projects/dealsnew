import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_strings.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/contact_us/cubit/contact_us_cubit.dart';
import 'package:top_sale/features/contact_us/cubit/contact_us_state.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_fonts.dart';
import '../../../core/utils/assets_manager.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});
  // final String phoneNumber = '01011827324'; // replace with actual phone number
  // final String email = 'info@topbusiness.io'; // replace with actual email
  // final String whatsAppNumber = '01011827324';
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ContactUsCubit>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: BlocBuilder<ContactUsCubit, ContactUsState>(
            builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageAssets.topBusinessLogo,
                scale: 4,
              ),
              SizedBox(height: 60.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Unlock Your Business Full Potential",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily:
                          AppStrings.fontFamily2, // Example: making it bold
                      color: AppColors.primary,
                      fontSize: 20.sp // Example: changing color to blue
                      ),
                ),
              ),
              SizedBox(height: getSize(context) / 10),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        cubit.launchURL(
                            'tel:${cubit.phoneNumber}'); // Call functionality
                      } else if (index == 1) {
                        cubit.launchEmail(); // Email functionality
                      } else if (index == 2) {
                        cubit.launchURL(
                            'https://wa.me/${cubit.whatsAppNumber}'); // WhatsApp functionality
                      }
                    },
                    child: ListTile(
                      leading: Image.asset(
                        cubit.Images[index],
                        width: 25.w,
                        height: 25.h,
                      ),
                      title: Text(
                        cubit.Texts[index],
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            fontFamily: AppStrings.fontFamily),
                      ),
                    ),
                  );
                },
                itemCount: 3,
              ),
              SizedBox(
                height: 70.h,
              ),
              InkWell(
                onTap: () {
                  cubit.launchURL(
                    "https://www.odoo.com/partners/top-business-1314088?grade_id=2&country_id=64",
                  );
                },
                child: Image.asset(
                  ImageAssets.odoo,
                  scale: 4,
                ),
              ),
              SizedBox(
                height: 70.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GestureDetector(
                  //     onTap: () => cubit.launchURL(cubit.links['youtube']!),
                  //     child: Image.asset(ImageAssets.youtubeIcon,height: 40.h,width: 40.w,)),
                  // SizedBox(
                  //   width: 4.w,
                  // ),
                  GestureDetector(
                      onTap: () => cubit.launchURL(cubit.links['web']!),
                      child: Image.asset(
                        ImageAssets.webIcon,
                        height: 40.h,
                        width: 40.w,
                      )),
                  SizedBox(
                    width: 4.w,
                  ),
                  // GestureDetector(
                  //     onTap: () => cubit.launchURL(cubit.links['instagram']!),
                  //     child: Image.asset(ImageAssets.instgramIcon,height: 40.h,width: 40.w,)),
                  // SizedBox(
                  //   width: 4.w,
                  // ),
                  // GestureDetector(
                  //     onTap: () => cubit.launchURL(cubit.links['twitter']!),
                  //     child: Image.asset(ImageAssets.twitterIcon,height: 40.h,width: 40.w,)),
                  // SizedBox(
                  //   width: 4.w,
                  // ),
                  GestureDetector(
                      onTap: () => cubit.launchURL(cubit.links['facebook']!),
                      child: Image.asset(
                        ImageAssets.facebookIcon,
                        height: 40.h,
                        width: 40.w,
                      )),
                ],
              )
            ],
          );
        }),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_outlined,
            size: 25.w,
          ),
        ),
        // //leadingWidth: 20,
        title: Text(
          "contact".tr(),
          style: getBoldStyle(
            fontSize: 20.sp,
          ),
        ),
      ),
    );
  }
}
