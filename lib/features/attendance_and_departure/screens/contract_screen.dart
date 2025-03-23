import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import '../../../core/utils/app_colors.dart';
import '../../home_screen/cubit/cubit.dart';
import '../cubit/attendance_and_departure_cubit.dart';import 'package:top_sale/core/utils/circle_progress.dart';

import '../cubit/attendance_and_departure_state.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  List<String> titles = [
    "start_date".tr(),
    "end_date".tr(),
    "number_of_working_hours".tr(),
    "section".tr(),
    "jop".tr(),
    "salary".tr(),
  ];

  @override
  void initState() {
    context.read<AttendanceAndDepartureCubit>().getContract();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AttendanceAndDepartureCubit>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "contract".tr(),
          style: TextStyle(color: AppColors.black),
        ),
        centerTitle: false,
        backgroundColor: AppColors.white,
        elevation: 0.0,
      ),
      body:
          BlocBuilder<AttendanceAndDepartureCubit, AttendanceAndDepartureState>(
              builder: (context, state) {
        return (cubit.contractDetails == null)
            ? const Center(
                child: CustomLoadingIndicator(),
              )
            : cubit.contractDetails!.contractDetails == null
                ? Text("no_data".tr())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        "${"contract_number".tr()} ${cubit.contractDetails?.contractDetails?.displayName}",
                        style: getBoldStyle(color: AppColors.primary),
                      ),
                      SizedBox(height: 20.h),
                      ListView.builder(
                        itemBuilder: (context, index) => customRowContract(
                          title: titles[index],
                          description: (index == 0)
                              ? (cubit.contractDetails?.contractDetails
                                      ?.dateStart
                                      ?.toString() ??
                                  "")
                              : (index == 1)
                                  ? (cubit.contractDetails?.contractDetails
                                          ?.dateEnd
                                          ?.toString() ??
                                      "")
                                  : (index == 2)
                                      ? (cubit.contractDetails?.contractDetails
                                              ?.workingHours
                                              ?.toString() ??
                                          "")
                                      : (index == 3)
                                          ? (cubit.contractDetails
                                                  ?.contractDetails?.department
                                                  ?.toString() ??
                                              "")
                                          : (index == 4)
                                              ? ((cubit
                                                          .contractDetails
                                                          ?.contractDetails
                                                          ?.jobTitle !=
                                                      false)
                                                  ? cubit
                                                      .contractDetails
                                                      ?.contractDetails
                                                      ?.jobTitle
                                                  : "")
                                              : (index == 5)
                                                  ? ("${context.read<HomeCubit>().currencyName} ${cubit.contractDetails?.contractDetails?.wage.toString()} " ??
                                                      "")
                                                  : "",
                        ),
                        itemCount: titles.length,
                        shrinkWrap: true,
                      ),
                    ],
                  );
      }),
    );
  }

  Column customRowContract({
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.only(left: 10.0.sp, right: 20.0.sp),
          child: Row(
            children: [
              AutoSizeText(
                " $title  :",
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Expanded(
                child: AutoSizeText(
                  description,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Divider(
          color: AppColors.black.withOpacity(0.5),
          endIndent: 30.sp,
          indent: 30.sp,
          thickness: 1,
        ),
      ],
    );
  }
}
