import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_cubit.dart';
import 'package:top_sale/features/attendance_and_departure/screens/widgets/advence_and_salaries_widget.dart';
import 'package:top_sale/features/attendance_and_departure/screens/widgets/attendance_and_departure_widget.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_fonts.dart';
import '../../home_screen/cubit/cubit.dart';

class AttendanceAndDepartureScreen extends StatefulWidget {
  const AttendanceAndDepartureScreen({super.key});

  @override
  State<AttendanceAndDepartureScreen> createState() =>
      _AttendanceAndDepartureScreenState();
}

class _AttendanceAndDepartureScreenState
    extends State<AttendanceAndDepartureScreen> {
  @override
  void initState() {
    context.read<AttendanceAndDepartureCubit>().getLastAttendance();
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
            "attendance_and_departure".tr(),
            style: getBoldStyle(fontSize: 20.sp),
          ),
        ),
        body: context.read<HomeCubit>().isEmployeeAdded
            ? ListView(
                children: [
                  const ContainerTimesFromUserInHomeScreen(),
                  SizedBox(height: 20.h),
                  AdvanceAndSalariesWidget(),
                ],
              )
            : const SizedBox());
  }
}
