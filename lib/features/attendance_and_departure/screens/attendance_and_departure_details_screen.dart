import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/features/clients/cubit/clients_cubit.dart';
import 'package:top_sale/features/details_order/cubit/details_orders_cubit.dart';
import '../../../core/models/get_all_attendance_model.dart';
import '../cubit/attendance_and_departure_cubit.dart';
import '../cubit/attendance_and_departure_state.dart';

class AttendanceAndDepartureDetailsScreen extends StatefulWidget {
  const AttendanceAndDepartureDetailsScreen({super.key});

  @override
  State<AttendanceAndDepartureDetailsScreen> createState() =>
      _AttendanceAndDepartureDetailsScreenState();
}

class _AttendanceAndDepartureDetailsScreenState
    extends State<AttendanceAndDepartureDetailsScreen> {
  @override
  initState() {
    context.read<AttendanceAndDepartureCubit>().getAllAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AttendanceAndDepartureCubit>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        titleTextStyle: getBoldStyle(fontSize: 20.sp),
        title: Text('attendance_and_departure_details'.tr()),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: BlocBuilder<AttendanceAndDepartureCubit,
            AttendanceAndDepartureState>(builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date pickers
              // Row(
              //   children: [
              //     Expanded(
              //         child: DatePickerField(
              //             label: 'from'.tr(),
              //             selectedDate: cubit.fromDate.toString())),
              //     SizedBox(width: 20.w),
              //     Expanded(
              //       child: DatePickerField(
              //           label: 'to'.tr(),
              //           selectedDate: cubit.toDate.toString()),
              //     )
              //   ],
              // ),
              SizedBox(height: 20.h),
              cubit.getAllAttendanceModel.attendances == null
                  ? const Center(
                      child: CustomLoadingIndicator(),
                    )
                  : Expanded(
                      child: cubit.getAllAttendanceModel.attendances == null ||
                              cubit
                                  .getAllAttendanceModel.attendances!.isEmpty ||
                              cubit.getAllAttendanceModel.attendances == []
                          ? Text("no_data".tr())
                          : RefreshIndicator(
                              onRefresh: () async {
                                cubit.getAllAttendance();
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) => AttendanceCard(
                                  attendance: cubit.getAllAttendanceModel
                                      .attendances![index],
                                ),
                                itemCount: cubit
                                    .getAllAttendanceModel.attendances!.length,
                              ),
                            ),
                    ),
            ],
          );
        }),
      ),
    );
  }
}

class DatePickerField extends StatefulWidget {
  final String label;
  final String selectedDate;

  const DatePickerField(
      {super.key, required this.label, required this.selectedDate});

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late String _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate; // Initialize with the default value
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date is today
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2100), // Maximum date
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0.sp, right: 8.0.sp),
          child: Text(widget.label,
              style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () => _selectDate(context), // Call the date picker on tap
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(
                  _selectedDate,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AttendanceCard extends StatelessWidget {
  Attendance attendance;

  AttendanceCard({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              attendance.checkIn.toString().substring(0, 10) ?? "",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AttendanceInfoRow(
                  label: "attendance_time".tr(),
                  value: attendance.checkIn == null
                      ? ""
                      : attendance.checkIn!.toString().substring(11, 16),
                ),
                AttendanceInfoRow(
                  label: "dismissal_time".tr(),
                  value: attendance.checkOut == null
                      ? ""
                      : attendance.checkOut!.toString().substring(11, 16),
                ),
                AttendanceInfoRow(
                  label: "work_time".tr(),
                  value: attendance.workedHours.toString(),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AttendanceInfoRow(
                  label: "additional_time".tr(),
                  value: attendance.overtimeHours == null
                      ? ""
                      : attendance.overtimeHours.toString(),
                ),
                AttendanceInfoRow(
                  onTap: () {
                    if (attendance.inCity != false) {
                      context.read<DetailsOrdersCubit>().openGoogleMapsRoute(
                            context
                                    .read<ClientsCubit>()
                                    .currentLocation
                                    ?.latitude ??
                                0.0,
                            context
                                    .read<ClientsCubit>()
                                    .currentLocation
                                    ?.longitude ??
                                0.0,
                            attendance.inLatitude ?? 0.0,
                            attendance.inLongitude ?? 0.0,
                          );
                    }
                  },
                  label: "attendance_place".tr(),
                  isBold: true,
                  value: (attendance.inCity == false)
                      ? ""
                      : attendance.inCity.toString(),
                ),
                AttendanceInfoRow(
                  onTap: () {
                    context.read<DetailsOrdersCubit>().openGoogleMapsRoute(
                          context
                                  .read<ClientsCubit>()
                                  .currentLocation
                                  ?.latitude ??
                              0.0,
                          context
                                  .read<ClientsCubit>()
                                  .currentLocation
                                  ?.longitude ??
                              0.0,
                          attendance.outLatitude ?? 0.0,
                          attendance.outLongitude ?? 0.0,
                        );
                  },
                  label: "leave_place".tr(),
                  isBold: true,
                  value: (attendance.outCity == false)
                      ? ""
                      : attendance.outCity ?? '',
                ),
              ],
            ),
            // Row(
            //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,

            //   children: [
            //     Flexible(
            //       child: Center(
            //         child: SizedBox(
            //           width: 20.w,
            //         ),
            //       ),
            //     ),
            //     Flexible(
            //       child: Center(
            //         child: Image.asset(
            //           ImageAssets.addressIcon,
            //           width: 15.w,
            //         ),
            //       ),
            //     ),
            //     Flexible(
            //       child: Center(
            //         child: Image.asset(
            //           ImageAssets.addressIcon,
            //           width: 25.w,
            //         ),
            //       ),
            //     )
            //   ],
            // ),

            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

class AttendanceInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final void Function()? onTap;
  final bool isBold;

  const AttendanceInfoRow(
      {super.key,
      required this.label,
      required this.value,
      this.onTap,
      this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(label + "\n",
                maxLines: 2,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: isBold ? AppColors.secondry : Colors.grey[700],
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
