import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_cubit.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_state.dart';
import '../../../core/api/end_points.dart';
import '../../../core/utils/app_fonts.dart';
import '../../details_order/screens/pdf.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

class SalariesScreen extends StatefulWidget {
  const SalariesScreen({super.key});

  @override
  State<SalariesScreen> createState() => _SalariesScreenState();
}

class _SalariesScreenState extends State<SalariesScreen> {
  @override
  void initState() {
    context.read<AttendanceAndDepartureCubit>().getAllSalary();
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
          "salaries".tr(),
          style: getBoldStyle(fontSize: 20.sp),
        ),
      ),
      body:
          BlocBuilder<AttendanceAndDepartureCubit, AttendanceAndDepartureState>(
              builder: (context, state) {
        var cubit = context.read<AttendanceAndDepartureCubit>();
        return Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Column(children: [
            // CustomTextField(
            //   controller: cubit.searchController,
            //   // onChanged: cubit.onChangeSearch,
            //   labelText: "search_month".tr(),
            //   prefixIcon: Icon(
            //     Icons.search_rounded,
            //     size: 35,
            //     color: AppColors.gray2,
            //   ),
            // ),
            SizedBox(height: 20.h),
            (cubit.allSalaryModel == null)
                ? const Center(
                    child: CustomLoadingIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: cubit.allSalaryModel?.payslipHistory?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return PdfViewerPage(
                                    baseUrl:
                                        '${EndPoints.printPaySlip}${cubit.allSalaryModel?.payslipHistory?[index].payslipId.toString()}',
                                  );
                                  // return PaymentWebViewScreen(url: "",);
                                },
                              ));
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      padding: EdgeInsets.all(8.0.sp),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            blurStyle: BlurStyle.outer,
                                            color: Colors.black.withOpacity(
                                                0.1),
                                            spreadRadius: 1,
                                            blurRadius: 4,
                                            offset: const Offset(0,
                                                1),
                                          ),
                                        ],
                                        color: AppColors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.sp),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            (cubit
                                                        .allSalaryModel
                                                        ?.payslipHistory?[index]
                                                        .patch ==
                                                    false)
                                                ? " "
                                                : cubit
                                                    .allSalaryModel!
                                                    .payslipHistory![index]
                                                    .patch!,
                                            style: getBoldStyle(
                                              color: AppColors.primary,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Row(
                                            children: [
                                              AutoSizeText("salary".tr(),
                                                  style: getBoldStyle(
                                                      color: AppColors.black
                                                          .withOpacity(0.8),
                                                      fontSize: 14.sp)),
                                              const Spacer(),
                                              AutoSizeText(
                                                  cubit
                                                      .allSalaryModel!
                                                      .payslipHistory![index]
                                                      .amountTotal
                                                      .toString(),
                                                  style: getBoldStyle(
                                                      color: AppColors.black
                                                          .withOpacity(0.7),
                                                      fontSize: 14.sp)),
                                              const Spacer(),
                                              Container(
                                                padding: EdgeInsets.all(8.0.sp),
                                                decoration: BoxDecoration(
                                                  color: AppColors.green
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.sp),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      cubit
                                                          .allSalaryModel!
                                                          .payslipHistory![
                                                              index]
                                                          .state
                                                          .toString(),
                                                      style: getBoldStyle(
                                                          color:
                                                              AppColors.green,
                                                          fontSize: 14.sp)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
          ]),
        );
      }),
    );
  }
}
