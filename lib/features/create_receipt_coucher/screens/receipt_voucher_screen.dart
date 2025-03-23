import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import 'package:top_sale/config/routes/app_routes.dart';
import 'package:top_sale/core/api/end_points.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/features/clients/cubit/clients_cubit.dart';
import 'package:top_sale/features/create_receipt_coucher/cubit/create_receipt_coucher_cubit.dart';
import 'package:top_sale/features/create_receipt_coucher/cubit/create_receipt_coucher_state.dart';
import 'package:top_sale/features/create_receipt_coucher/screens/widgets/custom_payment_container.dart';
import 'package:top_sale/features/details_order/screens/pdf.dart';

import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text_form_field.dart';

class ReceiptVoucherScreen extends StatefulWidget {
  const ReceiptVoucherScreen({super.key});

  @override
  State<ReceiptVoucherScreen> createState() => _ReceiptVoucherScreenState();
}

class _ReceiptVoucherScreenState extends State<ReceiptVoucherScreen> {
  @override
  void initState() {
    if (context
        .read<CreateReceiptCoucherCubit>()
        .searchController
        .text
        .isNotEmpty) {
      context.read<CreateReceiptCoucherCubit>().searchController.clear();
      context.read<CreateReceiptCoucherCubit>().getAllReceiptVoucher();
    } else {
      if (context.read<CreateReceiptCoucherCubit>().allPaymentsModel.result ==
          null) {
        context.read<CreateReceiptCoucherCubit>().getAllReceiptVoucher();
      }
    }
    if (context.read<CreateReceiptCoucherCubit>().getAllJournalsModel == null) {
      context.read<CreateReceiptCoucherCubit>().getAllJournals();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: false,
        title: Text(
          'receipt_voucher'.tr(),
          style: TextStyle(
              fontFamily: AppStrings.fontFamily,
              color: AppColors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, Routes.clientsRoute,
              arguments: ClientsRouteEnum.receiptVoucher);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: 30.sp,
              color: AppColors.white,
            ),
          ),
        ),
      ),
      body: BlocBuilder<CreateReceiptCoucherCubit, CreateReceiptCoucherState>(
          builder: (context, state) {
        var cubit = context.read<CreateReceiptCoucherCubit>();
        return Padding(
          padding: EdgeInsets.only(left: 10.0.sp, right: 10.0.sp),
          child: Column(
            children: [
              CustomTextField(
                controller: cubit.searchController,
                onChanged: (keyValue) {
                  if (keyValue.isEmpty) {
                    cubit.getAllReceiptVoucher();
                  } else {
                    EasyDebounce.debounce(
                        'search', // <-- An ID for this particular debouncer
                        const Duration(seconds: 1), // <-- The debounce duration
                        () => cubit.getAllReceiptVoucher(
                            searchKey: keyValue) // <-- The target method
                        );
                  }
                },
                labelText: "search".tr(),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 35,
                  color: AppColors.secondry,
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              Expanded(
                child: cubit.allPaymentsModel.result == null ||
                        state is GetPaymentsLoading
                    ? const Center(child: CustomLoadingIndicator())
                    : ListView.builder(
                        itemCount:
                            cubit.allPaymentsModel.result!.payments!.length,
                        itemBuilder: (context, index) {
                          return CustomPaymentContainer(
                            paymentModel:
                                cubit.allPaymentsModel.result!.payments![index],
                          );
                        }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
