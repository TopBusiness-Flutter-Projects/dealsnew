import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/models/all_journals_model.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/features/details_order/cubit/details_orders_state.dart';
import 'package:top_sale/features/details_order/screens/widgets/rounded_button.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/get_size.dart';
import '../../../login/widget/textfield_with_text.dart';
import '../../cubit/details_orders_cubit.dart';
import '../../cubit/details_orders_state.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({super.key, required this.isReturn});
  final bool isReturn;
  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  String? selectedOption;

  @override
  void initState() {
    context.read<DetailsOrdersCubit>().moneyController.text = context
            .read<DetailsOrdersCubit>()
            .getDetailsOrdersModel
            ?.invoices!
            .first
            .amountDue
            .toString() ??
        "";
    context.read<DetailsOrdersCubit>().getAllJournals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<DetailsOrdersCubit>();
    return BlocBuilder<DetailsOrdersCubit, DetailsOrdersState>(
      builder: (context, state) {
        if (state is GetAllJournalsLoadingState) {
          // Show a single CustomLoadingIndicator for loading state
          return Center(
            child: CustomLoadingIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        // After loading, display the list of payment methods
        final List<Result>? paymentMethods = cubit.getAllJournalsModel?.result;

        if (paymentMethods != null && paymentMethods.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: paymentMethods.map((method) {
              return RadioListTile<String>(
                title: Text(method.displayName!,
                    style: getBoldStyle()), // Display payment method name
                value: method.id!.toString(),
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                  if (selectedOption != null) {
                    _showBottomSheet(context, cubit, value, widget.isReturn);
                  }
                },
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text("No payment methods available"));
        }
      },
    );
  }
}

void _showBottomSheet(BuildContext context, DetailsOrdersCubit cubit,
    String? value, bool isReturn) {
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
                Text(
                    "${"total_invoice".tr()}${cubit.getDetailsOrdersModel?.invoices?.first.amountDue ?? 0} ",
                    style: TextStyle(fontSize: getSize(context) / 20)),
                SizedBox(
                  height: 20.h,
                ),
                Stack(
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
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        ImageAssets.pdfImage,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  // Display the image using Image.file
                                  File(cubit.profileImage!.path),
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
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomTextFieldWithTitle(
                    title: "Paid_in_full".tr(),
                    controller: cubit.moneyController,
                    hint: "Enter_the_amount".tr(),
                    keyboardType: TextInputType.text,
                  ),
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
                      if (
                          // cubit.selectedBase64String.isNotEmpty &&
                          cubit.moneyController.text.isNotEmpty) {
                        isReturn
                            ? cubit.registerPaymentReturn(
                                context,
                                journalId: int.parse(value!),
                              )
                            : cubit.registerPayment(
                                context,
                                orderId: cubit.getDetailsOrdersModel?.id ?? -1,
                                journalId: int.parse(value!),
                                invoiceId: cubit.getDetailsOrdersModel?.invoices
                                        ?.first.invoiceId ??
                                    -1,
                              );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("please_enter_fields".tr()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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
