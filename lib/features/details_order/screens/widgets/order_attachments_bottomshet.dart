import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/models/get_orders_model.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/details_order/cubit/details_orders_cubit.dart';
import 'package:top_sale/features/details_order/cubit/details_orders_state.dart';
import 'package:top_sale/features/details_order/screens/widgets/rounded_button.dart';
import 'package:top_sale/features/direct_sell/cubit/direct_sell_cubit.dart';
import 'package:top_sale/features/direct_sell/cubit/direct_sell_state.dart';
import 'package:top_sale/features/login/widget/textfield_with_text.dart';
import 'package:path/path.dart' as path;

void showCancelAttachmentBottomSheet(
  int orderId,
  OrderModel orderModel,
  BuildContext context,
) {
  var cubit = context.read<DetailsOrdersCubit>();
  TextEditingController noteController = TextEditingController();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return BlocBuilder<DetailsOrdersCubit, DetailsOrdersState>(
          builder: (context, state) {
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
                      cubit.cancelOrder(
                          orderId: orderId,
                          orderModel: orderModel,
                          note: noteController.text,
                          context: context);
                    
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

void showCreateAttachmentBottomSheet(
  int partnerId,
  BuildContext context,
) {
  var cubit = context.read<DirectSellCubit>();
  TextEditingController noteController = TextEditingController();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return BlocBuilder<DirectSellCubit, DirectSellState>(
          builder: (context, state) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          cubit.showAttachImageSourceDialog(context);
                        }, // Use the passed camera function
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: cubit.attachImage == null
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
                                    File(cubit.attachImage!.path),
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
                            cubit.removeAttachImage();
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
                CustomTextFieldWithTitle(
                  title: "notes".tr(),
                  controller: noteController,
                  maxLines: 5,
                  hint:  "enter_notes".tr(),
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
                      cubit.createQuotation(
                          warehouseId: '1',
                          note: noteController.text,
                          context: context,
                          partnerId: partnerId);
                      
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
