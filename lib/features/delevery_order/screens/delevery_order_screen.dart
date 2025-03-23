import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/config/routes/app_routes.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/delevery_order/screens/widgets/drop_down_widget.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import 'package:top_sale/features/delevery_order/screens/widgets/shipment_card_widget.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../cubit/delevery_orders_cubit.dart';
import '../cubit/delevery_orders_state.dart';

class DeleveryOrderScreen extends StatefulWidget {
  const DeleveryOrderScreen({super.key});

  @override
  State<DeleveryOrderScreen> createState() => _DeleveryOrderScreenState();
}

class _DeleveryOrderScreenState extends State<DeleveryOrderScreen> {
  @override
  initState() {
    context.read<DeleveryOrdersCubit>().getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleveryOrdersCubit, DeleveryOrdersState>(
        builder: (context, state) {
      var cubit = context.read<DeleveryOrdersCubit>();

      return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.mainRoute, (route) => false);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            centerTitle: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.mainRoute, (route) => false);
                },
                icon: const Icon(Icons.arrow_back)),
            title: Text(
              "delevery_order".tr(),
              style: TextStyle(
                  fontFamily: AppStrings.fontFamily,
                  color: AppColors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: AppColors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tab bar for filtering current, last, and canceled orders
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTab(context, cubit, "current_orders", 0),
                    _buildTab(context, cubit, "last_orders", 1),
                    _buildTab(context, cubit, "cancel_orders", 2),
                  ],
                ),
              ),

              SizedBox(height: getSize(context) / 20),

              // Drop-down filter for current orders (only visible for current orders tab)
              if (cubit.currentIndex == 0) ...[
                const DropDownMenuWidget(),
                SizedBox(height: getSize(context) / 20),
              ],

              // Orders List (Refreshable)
              Flexible(
                child: cubit.getOrdersModel.result == null ||
                        state is OrdersLoadingState
                    ? const Center(child: CustomLoadingIndicator())
                    : RefreshIndicator(
                        onRefresh: () async {
                          await cubit.getOrders();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: cubit.currentIndex == 0
                              ? _buildCurrentOrdersList(context, cubit)
                              : cubit.currentIndex == 1
                                  ? _buildLastOrdersList(context, cubit)
                                  : _buildCanceledOrdersList(context, cubit),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Widget to build a tab with styling based on current index
  Widget _buildTab(BuildContext context, DeleveryOrdersCubit cubit,
      String label, int index) {
    return GestureDetector(
      onTap: () {
        cubit.changeIndex(index);
      },
      child: Container(
        width: getSize(context) / 3.5,
        decoration: BoxDecoration(
          color:
              cubit.currentIndex == index ? AppColors.secondry : AppColors.gray1,
          borderRadius: BorderRadius.circular(getSize(context) / 20),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getSize(context) / 60,
                vertical: getSize(context) / 40),
            child: AutoSizeText(
              label.tr(),
              maxLines: 1,
              style: TextStyle(
                fontFamily: AppStrings.fontFamily,
                color: cubit.currentIndex == index
                    ? AppColors.white
                    : AppColors.grayLite,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds the list for current orders
  Widget _buildCurrentOrdersList(
      BuildContext context, DeleveryOrdersCubit cubit) {
    if (cubit.selectedValue == "all") {
      return cubit.currentOrders.isNotEmpty
          ? _buildOrderList(context, cubit.currentOrders)
          : Center(
              child: Text(
              "no_data".tr(),
              style: TextStyle(
                  fontFamily: AppStrings.fontFamily,
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp),
            ));
    } else if (cubit.selectedValue == "show_price") {
      return cubit.draftOrders.isNotEmpty
          ? _buildOrderList(context, cubit.draftOrders)
          : Center(child: Text("no_data".tr()));
    } else if (cubit.selectedValue == "new") {
      return cubit.newOrders.isNotEmpty
          ? _buildOrderList(context, cubit.newOrders)
          : Center(
              child: Text(
              "no_data".tr(),
              style: TextStyle(
                  fontFamily: AppStrings.fontFamily,
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp),
            ));
    } else {
      return cubit.deliveredOrders.isNotEmpty
          ? _buildOrderList(context, cubit.deliveredOrders)
          : Center(
              child: Text(
              "no_data".tr(),
              style: TextStyle(
                  fontFamily: AppStrings.fontFamily,
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp),
            ));
    }
  }

  // Builds the list for last orders
  Widget _buildLastOrdersList(BuildContext context, DeleveryOrdersCubit cubit) {
    return cubit.completeOrders.isNotEmpty
        ? _buildOrderList(context, cubit.completeOrders)
        : Center(
            child: Text(
            "no_data".tr(),
            style: TextStyle(
                fontFamily: AppStrings.fontFamily,
                color: AppColors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp),
          ));
  }

  // Builds the list for canceled orders
  Widget _buildCanceledOrdersList(
      BuildContext context, DeleveryOrdersCubit cubit) {
    return cubit.canceledOrders.isNotEmpty
        ? _buildOrderList(context, cubit.canceledOrders)
        : Center(child: Text("no_data".tr()));
  }

  // Builds a list of orders using ShipmentCardWidget
  Widget _buildOrderList(BuildContext context, List orders) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(getSize(context) / 50),
          child: ShipmentCardWidget(order: orders[index]),
        );
      },
    );
  }
}
