import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/core/widgets/decode_image.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/get_size.dart';
import '../../cubit/cubit.dart';
import '../../cubit/state.dart';

class AppbarHome extends StatefulWidget {
  const AppbarHome({super.key});
  @override
  State<AppbarHome> createState() => _AppbarHomeState();
}

class _AppbarHomeState extends State<AppbarHome> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<HomeCubit>().checkEmployeeOrUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CustomDecodedImage(
                    base64String: context.read<HomeCubit>().imageOfUser,
                    //  context: context,
                    height: getSize(context) / 8,
                    width: getSize(context) / 8,
                  ),
                ),
                //  CircleAvatar(backgroundImage: AssetImage(ImageAssets.logo2Image),),
                SizedBox(
                  width: getSize(context) / 33,
                ),
                Text(
                  "hi".tr() +
                      " " +
                      '${context.read<HomeCubit>().nameOfUser ?? ""}',
                  style: TextStyle(
                      color: AppColors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 20.sp,
          //   child: Stack(
          //     children: [
          //       //

          //       GestureDetector(
          //           onTap: () {
          //             Navigator.pushNamed(context, Routes.notificationRoute);
          //           },
          //           child: Icon(
          //             Icons.notifications_none,
          //             size: 25.sp,
          //             color: AppColors.black,
          //           )),
          //       Positioned(
          //         width: 13.sp,
          //         height: 13.sp,
          //         child: Container(
          //           width: 10.sp,
          //           height: 10.sp,
          //           decoration: BoxDecoration(
          //             color: AppColors.primaryColor,
          //             borderRadius: BorderRadius.circular(50.sp),
          //           ),
          //           child: Center(
          //               child: Text(
          //             "1",
          //             style: TextStyle(fontSize: 10.sp, color: AppColors.white),
          //           )),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      );
    });
  }
}
