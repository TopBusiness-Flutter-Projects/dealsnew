import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_cubit.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_state.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/utils/app_fonts.dart';import 'package:top_sale/core/utils/circle_progress.dart';


class HolidaysScreen extends StatefulWidget {
  const HolidaysScreen({super.key});

  @override
  State<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  @override
  void initState() {
    context.read<AttendanceAndDepartureCubit>().getAllHolidays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AttendanceAndDepartureCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "Holidays".tr(),
          style: getBoldStyle(fontSize: 20.sp),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.holidayTypesRoute);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primary),
          height: 50.h,
          width: 130.w,
          child: Center(
            child: Text(
              "holiday_request".tr(),
              style: getBoldStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: BlocBuilder<AttendanceAndDepartureCubit,
            AttendanceAndDepartureState>(builder: (context, state) {
          return cubit.holidaysModel.timeOffRequests == null
              ? Center(
                  child: CustomLoadingIndicator(
                    backgroundColor: AppColors.black,
                    color: AppColors.primary,
                  ),
                )
              : cubit.holidaysModel.timeOffRequests!.length == 0
                  ? Center(child: Text("no_data".tr()))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: cubit.holidaysModel.timeOffRequests!.length,
                      itemBuilder: (context, index) => HolidayRequestCard(
                        status: cubit.holidaysModel.timeOffRequests![index]
                            .status, // Approved
                        statusColor: Colors.black,
                        requestDate: cubit.holidaysModel.timeOffRequests![index]
                                .dateCreated ??
                            "",
                        leaveType: cubit.holidaysModel.timeOffRequests![index]
                                .timeOffType ??
                            "", // Sick leave
                        startDate: cubit.holidaysModel.timeOffRequests![index]
                                .dateFrom ??
                            "",
                        endDate: cubit
                                .holidaysModel.timeOffRequests![index].dateTo ??
                            "",
                        notes: (cubit.holidaysModel.timeOffRequests![index]
                                    .description
                                    .toString() ==
                                "false")
                            ? ""
                            : cubit.holidaysModel.timeOffRequests![index]
                                .description
                                .toString(), // Notes
                        leaveDays: cubit.holidaysModel.timeOffRequests![index]
                                .duration ??
                            "0",
                      ),
                    );
        }),
      ),
    );
  }
}

class HolidayRequestCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final String requestDate;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String notes;
  final String leaveDays;

  const HolidayRequestCard({
    super.key,
    required this.status,
    required this.statusColor,
    required this.requestDate,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    this.notes = "",
    this.leaveDays = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadiusDirectional.circular(8),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: Colors.black.withOpacity(0.1), 
            spreadRadius: 1, 
            blurRadius: 4, 
            offset: const Offset(0, 1), 
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'holiday_request'.tr(), // Holiday Request
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                StatusBadge(status: status, color: statusColor),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              requestDate,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            Text(
              '$leaveType ${"from".tr()} $startDate ${"to".tr()} $endDate',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  notes,
                  style: TextStyle(
                      fontSize: 16.sp, color: AppColors.black.withOpacity(0.8)),
                ),
              ],
            ),
            SizedBox(
              height: 10.sp,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${"number_of_leave_days".tr()} : $leaveDays',
                  style: TextStyle(
                      fontSize: 16.sp, color: AppColors.black.withOpacity(0.8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const StatusBadge({super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
