import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/core/widgets/decode_image.dart';
import 'package:top_sale/features/clients/cubit/clients_cubit.dart';
import 'package:top_sale/features/clients/cubit/clients_state.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';
import 'package:top_sale/features/login/widget/custom_button.dart';
import 'package:top_sale/features/login/widget/textfield_with_text.dart';

class EditAccountScreen extends StatefulWidget {
  EditAccountScreen({super.key, required this.id});
  final int id;
  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ClientsCubit>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<ClientsCubit, ClientsState>(builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getSize(context) / 10,
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
                                base64String: context
                                    .read<ClientsCubit>()
                                    .selectedBase64String,
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
                            // cubit.pickImage(ImageSource.gallery);
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
                height: getSize(context) / 8,
              ),
              CustomButton(
                title: "modify".tr(),
                onTap: () {
                  cubit.updatePartenerDetails(
                    context,
                    id: widget.id!,
                  );
                },
              )
            ],
          ),
        );
      }),
    );
  }
}
