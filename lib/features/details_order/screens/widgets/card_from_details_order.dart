import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/models/get_orders_model.dart';
import 'package:top_sale/features/clients/cubit/clients_cubit.dart';
import 'package:top_sale/features/details_order/cubit/details_orders_cubit.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';
import '../../../../core/models/order_details_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/get_size.dart';

class CardDetailsOrders extends StatelessWidget {
  CardDetailsOrders(
      {super.key,
      required this.orderDetailsModel,
      required this.orderModel,
      this.isShowPrice = false,
      this.onTap,
      this.printWidget});
  OrderDetailsModel orderDetailsModel;
  bool isShowPrice;
  final Widget? printWidget;
  OrderModel orderModel;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      Expanded(
                        child: Row(
                          children: [
                            AutoSizeText(
                              "shipment_number".tr(),
                              style: TextStyle(
                                fontFamily: "cairo",
                                color: AppColors.blue,
                                fontSize: getSize(context) / 25,
                              ),
                            ),
                            SizedBox(width: getSize(context) / 60),
                            AutoSizeText(
                              orderDetailsModel.name ?? '',
                              maxLines: 1,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontFamily: "cairo",
                                color: AppColors.black,
                                fontSize: getSize(context) / 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      printWidget ?? const SizedBox(),
                      GestureDetector(
                          onTap: () {
                            context
                                .read<DetailsOrdersCubit>()
                                .openGoogleMapsRoute(
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
                                  context
                                          .read<DetailsOrdersCubit>()
                                          .getDetailsOrdersModel
                                          ?.partnerLatitude ??
                                      0.0,
                                  context
                                          .read<DetailsOrdersCubit>()
                                          .getDetailsOrdersModel
                                          ?.partnerLongitude ??
                                      0.0,
                                );
                          },
                          child: Image.asset(
                            ImageAssets.addressIcon,
                            width: 25.w,
                          ))
                    ],
                  ),
                ),
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
                        orderDetailsModel.dateOrder.substring(0, 10) ?? '',
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
                        // "${context.read<DetailsOrdersCubit>().getDetailsOrdersModel?.amountTotal} ${orderModel.currencyId?.name ?? ''}"
                        // "\n"
                        "${calculateTotalDiscountedPrice(orderDetailsModel.orderLines ?? [])} ${orderModel.currencyId?.name ?? ''}",

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
                // orderModel.partnerModel?.image1920.toString()=='false'?
                //
                //     Center(
                //       child: Image.asset(ImageAssets.user),
                //     )
                //     :   CustomDecodedImage(
                //   context: context,
                //   base64String: orderModel.partnerModel!.image1920,
                //   height: 50.w,
                //   width: 50.w,
                // )             ,   // Image.asset(ImageAssets.user),
                Center(
                    child: Image.asset(
                  ImageAssets.user,
                  width: getSize(context) / 12,
                  height: getSize(context) / 12,
                )),
                SizedBox(width: getSize(context) / 60),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        orderModel.partnerId!.name ?? '',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: getSize(context) / 25,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      AutoSizeText(
                        (orderModel.partnerId?.phone.toString() == "false")
                            ? ''
                            : orderModel.partnerId?.phone ?? '',
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
                ),
                isShowPrice
                    ?
                    !context.read<HomeCubit>().isDiscountManager ?Container():
                     InkWell(
                        onTap: onTap,
                        child: Image.asset(
                          ImageAssets.discount,
                          width: getSize(context) / 14,
                        ),
                      )
                    : Container(),
              ],
            )
          ]),
        ),
      ),
    );
  }

  String calculateTotalDiscountedPrice(List<OrderLine> items) {
    double total = items.fold(0.0, (sum, item) {
      dynamic priceUnit = item.priceUnit;
      dynamic quantity = item.productUomQty;
      dynamic discount = item.discount;

      // Calculate the total price with the discount applied for the current item
      double totalPrice = (priceUnit * quantity) * (1 - discount / 100);

      // Add to the running total
      return sum + totalPrice;
    });

    // Return the total formatted to 2 decimal places
    return total.toStringAsFixed(2);
  }
}
