import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/models/get_all_users_model.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/basket_screen/cubit/cubit.dart';
import 'package:top_sale/features/basket_screen/cubit/state.dart';
import 'package:top_sale/features/details_order/screens/widgets/rounded_button.dart';
import 'package:top_sale/features/direct_sell/cubit/direct_sell_cubit.dart';
import 'package:top_sale/features/login/widget/textfield_with_text.dart';

void showAttachmentBottomSheet(
  BuildContext context,
) {
  var cubit = context.read<BasketCubit>();
  var cubit2 = context.read<DirectSellCubit>();
  TextEditingController noteController = TextEditingController();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return BlocBuilder<BasketCubit, BasketState>(builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: getSize(context) / 20,
            right: getSize(context) / 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: getSize(context) / 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          cubit.showImageSourceDialog(context);
                        }, // Use the passed camera function
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: cubit.profileImage == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload_outlined,
                                          size: 40, color: AppColors.primary),
                                      SizedBox(height: 5.sp),
                                       Text(
                                        "upload_pic_or_file".tr(),
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    // Display the image using Image.file
                                    File(cubit.profileImage!.path),
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          ImageAssets.pdfImage,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            cubit.removeImage();
                          },
                          icon: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 30,
                              )))
                    ],
                  ),
                ),
                if (cubit.getAllUsersModel != null) UsersWidget(cubit: cubit),
                CustomTextFieldWithTitle(
                  title: "notes".tr(),
                  controller: noteController,
                  maxLines: 5,
                  hint: "enter_notes".tr(),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: getSize(context) / 20,
                      right: getSize(context) / 20),
                  child: RoundedButton(
                    backgroundColor: AppColors.primaryColor,
                    text: 'confirm'.tr(),
                    onPressed: () {
                      cubit2.createPicking(
                        context: context,
                        users: cubit.selectedUsers,
                        image: cubit.selectedBase64String,
                        note: noteController.text,
                        imagePath: cubit.profileImage == null
                            ? ""
                            : cubit.profileImage!.path.split('/').last,
                        partnerId: cubit.partner?.id,
                        sourceWarehouseId: cubit.selectedFromWareHouseId ?? -1,
                        destinationWareHouseId: cubit.selectedToWareHouseId,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      });
    },
  );
}

class UsersWidget extends StatefulWidget {
  const UsersWidget({
    super.key,
    required this.cubit,
  });

  final BasketCubit cubit;

  @override
  State<UsersWidget> createState() => _UsersWidgetState();
}

class _UsersWidgetState extends State<UsersWidget> {
  int? selectedUserId;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketCubit, BasketState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.sp),
            Text("refer_to".tr(), style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 10.sp),
            Wrap(
                children: widget.cubit.selectedUsers
                    .map((user) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(
                            label: Text(user.name ?? ''),
                            onDeleted: () {
                              widget.cubit.addOrRemoveUser(user);
                            })))
                    .toList()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value:
                      selectedUserId, // This will store the ID (not the name)
                  hint: Text(
                    'Select User',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  isExpanded: true,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedUserId = newValue;
                    });
                    if (newValue != null) {
                      if (widget.cubit.selectedUsers
                          .any((user) => user.id == newValue)) {
                        errorGetBar("user_exist".tr());
                      } else {
                        widget.cubit.addOrRemoveUser(widget
                                .cubit.getAllUsersModel?.result
                                ?.where((element) => element.id == newValue)
                                .first ??
                            UserModel());
                      }
                    }
                  },
                  items: widget.cubit.getAllUsersModel?.result
                          ?.map<DropdownMenuItem<int>>((resultItem) {
                        return DropdownMenuItem<int>(
                          value: resultItem.id,
                          child:
                              Text(resultItem.name ?? ''), // Display the name
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
