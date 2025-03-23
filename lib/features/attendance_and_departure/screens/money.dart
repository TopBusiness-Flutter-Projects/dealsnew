import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_cubit.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_state.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import '../../../config/routes/app_routes.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  @override
  void initState() {
    context.read<AttendanceAndDepartureCubit>().getMyExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceAndDepartureCubit,
        AttendanceAndDepartureState>(builder: (context, state) {
      var cubit = context.read<AttendanceAndDepartureCubit>();
      return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            titleTextStyle:
                getBoldStyle(color: AppColors.black, fontSize: 20.sp),
            centerTitle: false,
            title: Text("the_money".tr()),
          ),
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.moneyTypeRoute);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary),
              height: 50.h,
              width: 130.w,
              child: Center(
                child: Text(
                  "add_money".tr(),
                  style: getBoldStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ),
          body: cubit.getMyExpensesModel.expenses == null
              ? Center(child: CustomLoadingIndicator())
              : cubit.getMyExpensesModel.expenses!.isEmpty
                  ? Text("no_data".tr())
                  : ListView.builder(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.getMyExpensesModel.expenses!.length,
                      itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                                left: 8.0.sp, right: 8.0.sp, bottom: 2.0.sp),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8.sp,
                                  right: 8.sp,
                                  top: 10.sp,
                                  bottom: 10.sp),
                              margin: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurStyle: BlurStyle.outer,
                                    color: Colors.black.withOpacity(
                                        0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(
                                        0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppColors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.sp, vertical: 5.sp),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.green.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(16.sp),
                                        ),
                                        child: Text(
                                          cubit.getMyExpensesModel
                                              .expenses![index].state
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        cubit.getMyExpensesModel
                                            .expenses![index].date
                                            .toString()
                                            .substring(0, 11),
                                        style: TextStyle(
                                          color: AppColors.secondry,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.sp),
                                  Text(
                                    cubit.getMyExpensesModel.expenses![index]
                                        .name
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10.sp),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                    
                                      Text(
                                        cubit.getMyExpensesModel
                                            .expenses![index].unitAmount
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        cubit.getMyExpensesModel
                                            .expenses![index].productName
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )));
    });
  }
}
