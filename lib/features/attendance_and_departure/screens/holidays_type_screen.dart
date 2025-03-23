import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_cubit.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_state.dart';import 'package:top_sale/core/utils/circle_progress.dart';

import 'package:top_sale/features/attendance_and_departure/screens/widgets/build_data_filter.dart';
import 'package:top_sale/features/login/widget/textfield_with_text.dart';
import '../../../core/utils/app_fonts.dart';
import '../../../core/utils/get_size.dart';
import '../../details_order/screens/widgets/rounded_button.dart';

class HolidaysTypeScreen extends StatefulWidget {
  const HolidaysTypeScreen({super.key});

  @override
  State<HolidaysTypeScreen> createState() => _HolidaysTypeScreenState();
}

class _HolidaysTypeScreenState extends State<HolidaysTypeScreen> {
  @override
  void initState() {
    context.read<AttendanceAndDepartureCubit>().getTypeHolidays();
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
            "holidays_types".tr(),
            style: getBoldStyle(fontSize: 20.sp),
          ),
        ),
        body: BlocBuilder<AttendanceAndDepartureCubit,
            AttendanceAndDepartureState>(builder: (context, state) {
          var cubit = context.read<AttendanceAndDepartureCubit>();
          return (cubit.holidaysTypeModel == null)
              ? const Center(
                  child: CustomLoadingIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: cubit.holidaysTypeModel!.timeOffBalances!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showBottomSheet(context,
                            cubit: cubit,
                            timeOffTypeId: cubit.holidaysTypeModel!
                                .timeOffBalances![index].timeOffId
                                .toString());
                      },
                      child: LeaveRow(
                        normalDays: cubit.holidaysTypeModel!
                            .timeOffBalances![index].remainingDays
                            .toInt()
                            .toString(),
                        negativeDays: cubit
                            .holidaysTypeModel!.timeOffBalances![index].usedDays
                            .toInt()
                            .toString(),
                        leaveType: cubit.holidaysTypeModel!
                            .timeOffBalances![index].timeOffType
                            .toString(),
                      ),
                    );
                  });
        }));
  }
}

class LeaveRow extends StatelessWidget {
  final String normalDays;
  final String negativeDays;
  final String leaveType;

  const LeaveRow({
    super.key,
    required this.normalDays,
    required this.negativeDays,
    required this.leaveType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Leave Type on the right side
          Text(
            leaveType,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Days with negative number first (with strikethrough)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "  $normalDays  ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Negative days in red with strikethrough
                if (negativeDays.isNotEmpty)
                  TextSpan(
                    text: "$negativeDays ",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      decorationColor: AppColors.red,
                      decoration:
                          TextDecoration.lineThrough, // Strikethrough effect
                    ),
                  ),
                // Normal days in black
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showBottomSheet(BuildContext context,
    {required String timeOffTypeId,
    required AttendanceAndDepartureCubit cubit}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return BlocBuilder<AttendanceAndDepartureCubit,
          AttendanceAndDepartureState>(builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: getSize(context) / 20,
            right: getSize(context) / 20,
            top: getSize(context) / 20,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                getSize(context) / 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: cubit.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10.w, left: 10.w),
                              child: Text(
                                "from".tr(),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            BuildDataFilter(
                                onTap: () =>
                                    cubit.onSelectedDate(true, context),
                                selectedDate: cubit.selectedStartDate),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // "To" Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10.w, left: 10.w),
                              child: Text(
                                "to".tr(),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            BuildDataFilter(
                                onTap: () =>
                                    cubit.onSelectedDate(false, context),
                                selectedDate: cubit.selectedEndDate),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomTextFieldWithTitle(
                    maxLines: 5,
                    title: "reason".tr(),
                    controller: cubit.reasonController,
                    hint: "reason".tr(),
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: getSize(context) / 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(context) / 20,
                        right: getSize(context) / 20),
                    child: RoundedButton(
                      backgroundColor: AppColors.primaryColor,
                      text: 'add'.tr(),
                      onPressed: () {
                        cubit.addTimeOff(
                            context: context, timeOffTypeId: timeOffTypeId);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate,
                  style: TextStyle(fontSize: 16.sp),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
