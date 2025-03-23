import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/get_size.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_fonts.dart';
import '../../../core/utils/assets_manager.dart';
import '../../../core/widgets/decode_image.dart';
import '../../home_screen/cubit/cubit.dart';
import '../../login/widget/textfield_with_text.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<ProfileCubit>().nameController.text =
        context.read<HomeCubit>().nameOfUser.toString() ?? "";
    context.read<ProfileCubit>().phoneController.text =
        context.read<HomeCubit>().phoneOfUser.toString() ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ProfileCubit>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child:
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: getSize(context) / 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CustomDecodedImage(
                          base64String: context.read<HomeCubit>().imageOfUser,
                          // context: context,
                          height: 100.h,
                          width: 100.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: getSize(context) / 30,
              ),
              CustomTextFieldWithTitle(
                hint: "name".tr(),
                isModify: true,
                controller: cubit.nameController,
                title: "name".tr(),
                keyboardType: TextInputType.name,
                readonly: true,
              ),
              SizedBox(
                height: getSize(context) / 30,
              ),
              CustomTextFieldWithTitle(
                hint: "phone".tr(),
                controller: cubit.phoneController,
                title: "phone".tr(),
                readonly: true,
                isModify: true,
                keyboardType: TextInputType.name,
              ),
              SizedBox(
                height: getSize(context) / 30,
              ),
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
          "profile".tr(),
          style: getBoldStyle(
            fontSize: 20.sp,
          ),
        ),
      ),
    );
  }
}
