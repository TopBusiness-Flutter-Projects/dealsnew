import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/core/widgets/decode_image.dart';
import 'package:top_sale/features/update_profile/cubit/update_profile_cubit.dart';
import 'package:top_sale/features/update_profile/cubit/update_profile_state.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_fonts.dart';
import '../../../core/utils/assets_manager.dart';
import '../../home_screen/cubit/cubit.dart';
import '../../login/widget/custom_button.dart';
import '../../login/widget/textfield_with_text.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<UpdateProfileCubit>().nameController.text =
        context.read<HomeCubit>().nameOfUser ?? "";
    context.read<UpdateProfileCubit>().phoneController.text =
        context.read<HomeCubit>().phoneOfUser ?? "";
    context.read<UpdateProfileCubit>().emailController.text =
        context.read<HomeCubit>().emailOfUser ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<UpdateProfileCubit>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
            builder: (context, state) {
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
                        child: cubit.profileImage == null
                            ? CustomDecodedImage(
                                base64String:
                                    context.read<HomeCubit>().imageOfUser,
                                // context: context,
                                height: 100.h,
                                width: 100.h,
                              )
                            : Image.file(
                                (File(cubit.profileImage!.path)),
                                fit: BoxFit.cover,
                                height: 100.h,
                                width: 100.h,
                              ),
                      ),
                      // CircleAvatar(
                      //   radius: 50.sp,
                      //   backgroundImage: cubit.profileImage == null
                      //       ? const AssetImage(ImageAssets.user)
                      //       : FileImage(File(cubit.profileImage!.path)) as ImageProvider,

                      // ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            cubit.showImageSourceDialog(context);
                            //cubit.pickImage(ImageSource.gallery);
                          },
                          child: Icon(
                            Icons.camera_alt,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: getSize(context) / 30,
              ),
              CustomTextFieldWithTitle(
                hint: "name".tr(),
                controller: cubit.nameController,
                title: "name".tr(),
                keyboardType: TextInputType.name,
              ),
              SizedBox(
                height: getSize(context) / 30,
              ),
              CustomTextFieldWithTitle(
                hint: "phone".tr(),
                controller: cubit.phoneController,
                title: "phone".tr(),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: getSize(context) / 30,
              ),
              CustomTextFieldWithTitle(
                hint: "email".tr(),
                controller: cubit.emailController,
                title: "email".tr(),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: getSize(context) / 8,
              ),
              CustomButton(
                title: "modify".tr(),
                onTap: () {
                  cubit.checkEmployeeOrUser(context);
                },
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
          "update_profile".tr(),
          style: getBoldStyle(
            fontSize: 20.sp,
          ),
        ),
      ),
    );
  }
}
