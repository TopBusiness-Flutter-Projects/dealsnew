import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';

class DailyOrders extends StatefulWidget {
  const DailyOrders({super.key});
  @override
  State<DailyOrders> createState() => _DailyOrdersState();
}

class _DailyOrdersState extends State<DailyOrders> {
  @override
  void initState() {
    context.read<HomeCubit>().selectedDate = DateTime.now();
    // context.read<HomeCubit>().getReturned();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text("planninig".tr()),
        centerTitle: false,
        titleTextStyle: getBoldStyle(
          fontSize: 20.sp,
          color: AppColors.black,
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 10.0.sp, right: 10.0.sp),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  setState(() {
                    cubit.selectedDate = pickedDate!;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0.sp),
                    border: Border.all(color: Colors.grey),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.0.sp, vertical: 12.0.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${cubit.selectedDate.day}/${cubit.selectedDate.month}/${cubit.selectedDate.year}",
                        style: getRegularStyle(
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.calendar_today,
                          size: 25.sp, color: AppColors.primaryText),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: false
                    // ? const Center(child: CustomLoadingIndicator())
                    // : cubit.returnOrderModel!.result!.data!.isEmpty
                    ? Center(child: Text("no_data".tr()))
                    : ListView.builder(
                        itemCount: 10,
                        //  cubit.returnOrderModel?.result
                        //         ?.data?.length ??
                        //     0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: Container(
                                padding: EdgeInsets.only(
                                  left: 8.0.sp,
                                  right: 8.0.sp,
                                  top: 10.0.sp,
                                  bottom: 10.0.sp,
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurStyle: BlurStyle.outer,
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10.sp),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10.sp,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "cubdex).name" ?? "",
                                          style: getBoldStyle(
                                              color: AppColors.black,
                                              fontSize: 14.sp),
                                        ),
                                        SizedBox(
                                          width: 10.sp,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "cubit.amountTotedamountTotedamountToted(0)" +
                                                "  ${context.read<HomeCubit>().currencyName}",
                                            style: getBoldStyle(
                                                color: AppColors.blue,
                                                fontSize: 14.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.sp,
                                    ),
                                  ],
                                )),
                          );
                        }),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }
}
