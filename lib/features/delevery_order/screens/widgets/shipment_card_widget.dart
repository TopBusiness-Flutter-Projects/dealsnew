import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/models/get_orders_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/get_size.dart';

class ShipmentCardWidget extends StatelessWidget {
  ShipmentCardWidget({super.key, required this.order});
  OrderModel order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        order.state == 'draft'
            ? Navigator.pushNamed(context, Routes.detailsOrderShowPrice,
                arguments: {'isClientOrder': false, 'orderModel': order})
            : Navigator.pushNamed(context, Routes.detailsOrder,
                arguments: {'isClientOrder': false, 'orderModel': order});
      },
      child: Container(
        width: getSize(context),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1, 
              offset: const Offset(0, 1), 
            ),
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.circular(getSize(context) / 30),
        ),
        child: Padding(
          padding: EdgeInsets.all(getSize(context) / 25),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "shipment_number".tr(),
                        style: TextStyle(
                          fontFamily: "cairo",
                          color: AppColors.blue,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(width: getSize(context) / 60),
                      Expanded(
                        child: Text(
                          order.displayName ?? '',
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: "cairo",
                              color: AppColors.black,
                              fontSize: 20.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.0.sp,
                        vertical:
                            4.0.sp), // Adjust the padding values as needed(),
                    decoration: BoxDecoration(
                        // color: order.state == "sale" &&
                        //         order.invoiceStatus == "to invoice" &&
                        //         (order.deliveryStatus == "done" ||
                        //             order.deliveryStatus == "full")
                        //     ? AppColors.blue.withOpacity(0.5)
                        //     : order.state == "sale" &&
                        //             order.invoiceStatus == "invoiced" &&
                        //             (order.deliveryStatus == "done" ||
                        //                 order.deliveryStatus == "full")
                        //         ? AppColors.green.withOpacity(0.5)
                        //         : order.state == "sale" &&
                        //                 order.invoiceStatus == "to invoice" &&
                        //                 (order.deliveryStatus == "assigned" ||
                        //                     order.deliveryStatus == "pending")
                        //             ? AppColors.orange.withOpacity(0.5)
                        //             : order.state == "cancel"
                        //                 ? AppColors.red.withOpacity(0.5)
                        //                 : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(getSize(context) / 20)),
                    child: Center(
                        child: Text(
                      maxLines: 1,
                      order.state == "sale" &&
                              order.invoiceStatus == "to invoice" &&
                              (order.deliveryStatus == "full" ||
                                  order.deliveryStatus == "done")
                          ? "delivered".tr()
                          : order.state.toString() == "sale" &&
                                  order.invoiceStatus == "invoiced" &&
                                  (order.deliveryStatus == "full" ||
                                      order.deliveryStatus == "done")
                              ? "complete".tr()
                              : order.state == "sale" &&
                                      order.invoiceStatus == "to invoice" &&
                                      (order.deliveryStatus == "assigned" ||
                                          order.deliveryStatus == "pending")
                                  ? "new".tr()
                                  : order.state == "draft"
                                      ? "show_price".tr()
                                      : order.state == "cancel"
                                          ? "cancel".tr()
                                          : "",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: order.state == "sale" &&
                                order.invoiceStatus == "to invoice" &&
                                (order.deliveryStatus == "done" ||
                                    order.deliveryStatus == "full")
                            ? AppColors.blue
                            : order.state == "sale" &&
                                    order.invoiceStatus == "invoiced" &&
                                    (order.deliveryStatus == "done" ||
                                        order.deliveryStatus == "full")
                                ? AppColors.green
                                : order.state == "sale" &&
                                        order.invoiceStatus == "to invoice" &&
                                        (order.deliveryStatus == "assigned" ||
                                            order.deliveryStatus == "pending")
                                    ? AppColors.secondry
                                    : order.state == "cancel"
                                        ? AppColors.red
                                        : AppColors.secondry,
                      ),
                    )))
              ],
            ),
            SizedBox(
              height: getSize(context) / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        ImageAssets.dateIcon,
                        color: AppColors.secondry,
                        fit: BoxFit.contain,
                        width: getSize(context) / 14,
                        height: getSize(context) / 14,
                      ),
                      SizedBox(width: getSize(context) / 60),
                      AutoSizeText(
                        order.writeDate!.substring(0, 10) ?? '',
                        style: TextStyle(
                          fontFamily: "cairo",
                          color: AppColors.black,
                          fontSize: getSize(context) / 28,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "total".tr(),
                        style: TextStyle(
                          fontFamily: "cairo",
                          color: AppColors.blue,
                          fontSize: getSize(context) / 25,
                        ),
                      ),
                      SizedBox(width: getSize(context) / 60),
                      AutoSizeText(
                        "${order.amountTotal} ${order.currencyId?.name}",
                        style: TextStyle(
                          fontFamily: "cairo",
                          color: AppColors.black,
                          fontSize: getSize(context) / 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getSize(context) / 20,
            ),
            Row(
              children: [
                Center(
                    child: Image.asset(
                  ImageAssets.user,
                  width: getSize(context) / 12,
                  height: getSize(context) / 12,
                )),
                SizedBox(width: getSize(context) / 60),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        order.partnerId!.name ?? '',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: getSize(context) / 25,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      AutoSizeText(
                        (order.partnerId?.phone.toString() == "false")
                            ? '000000001/100000000'
                            : order.partnerId?.phone ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "cairo",
                          color: AppColors.black.withOpacity(0.8),
                          fontSize: getSize(context) / 28,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
