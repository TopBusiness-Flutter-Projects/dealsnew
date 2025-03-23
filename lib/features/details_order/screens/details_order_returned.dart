import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/details_order/cubit/details_orders_cubit.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import 'package:top_sale/features/details_order/cubit/details_orders_state.dart';
import 'package:top_sale/features/details_order/screens/pdf.dart';
import 'package:top_sale/features/details_order/screens/widgets/card_from_details_order.dart';
import 'package:top_sale/features/details_order/screens/widgets/custom_total_price.dart';
import 'package:top_sale/features/details_order/screens/widgets/product_card.dart';
import 'package:top_sale/features/details_order/screens/widgets/rounded_button.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/api/end_points.dart';
import '../../../core/models/get_orders_model.dart';
import '../../../core/models/order_details_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';

class DetailsOrderReturns extends StatefulWidget {
  DetailsOrderReturns(
      {super.key, required this.orderModel, required this.isClientOrder});
  bool isDelivered = false;
  bool isClientOrder;
  final OrderModel orderModel;
  @override
  State<DetailsOrderReturns> createState() => _DetailsOrderReturnsState();
}

class _DetailsOrderReturnsState extends State<DetailsOrderReturns> {
  @override
  void initState() {
    // context
    //     .read<DetailsOrdersCubit>()
    //     .getDetailsOrders(orderId: widget.orderModel.id ?? -1);
    context.read<DetailsOrdersCubit>().changePage(
        // Delivered 
        widget.orderModel.state == 'sale' &&
                widget.orderModel.invoiceStatus == 'to invoice' &&
                widget.orderModel.deliveryStatus == 'full'
            ? 2
            : widget.orderModel.state == 'sale' &&
                    widget.orderModel.invoiceStatus == 'invoiced' &&
                    widget.orderModel.deliveryStatus == 'full'
                ? 3
                : widget.orderModel.state == 'sale' &&
                        widget.orderModel.invoiceStatus == 'to invoice' &&
                        widget.orderModel.deliveryStatus == 'pending'
                    ? 1
                    : 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<DetailsOrdersCubit>();
    return WillPopScope(
      onWillPop: () async {
        cubit.onClickBack(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: false,
          leading: IconButton(
              onPressed: () {
                cubit.onClickBack(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: Text(
            'returns_details'.tr(),
            style: TextStyle(
                fontFamily: AppStrings.fontFamily,
                color: AppColors.black,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: BlocConsumer<DetailsOrdersCubit, DetailsOrdersState>(
            listener: (context, state) {
          if (state is ConfirmDeliveryLoadedState) {
            setState(() {
              // Dellivered 
              widget.orderModel.state = 'sale';
              widget.orderModel.invoiceStatus = 'to invoice';
              widget.orderModel.deliveryStatus = 'full';
            });
            cubit.changePage(2);
          }
          if (state is CreateAndValidateInvoiceLoadedState) {
            // complete
            setState(() {
              widget.orderModel.state = 'sale';
              widget.orderModel.invoiceStatus = 'invoiced';
              widget.orderModel.deliveryStatus = 'full';
            });
            cubit.changePage(3);
          }
          if (state is RegisterPaymentLoadedState) {
            setState(() {
              widget.orderModel.state = 'sale';
              widget.orderModel.invoiceStatus = 'invoiced';
              widget.orderModel.deliveryStatus = 'full';
            });
            cubit.changePage(4);
          }
          if (state is LoadingCancel) {
            setState(() {
              widget.orderModel.state = 'cancel';
            });
            //cubit.changePage(4);
          }
          if (state is CreateAndValidateInvoiceLoadingState) {
            setState(() {
              const CustomLoadingIndicator();
            });
          }
          if (state is ConfirmDeliveryLoadingState) {
            setState(() {
              const CustomLoadingIndicator();
            });
          }
        }, builder: (context, state) {
          return Column(
            children: [
              Flexible(
                child: Column(
                  children: [
                    SizedBox(
                      height: getSize(context) / 33,
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          left: getSize(context) / 30,
                          right: getSize(context) / 30),
                      child: (cubit.getDetailsOrdersModel == null)
                          ? const Center(
                              child: CustomLoadingIndicator(),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CardDetailsOrders(
                                  orderModel: widget.orderModel,
                                  orderDetailsModel:
                                      cubit.getDetailsOrdersModel!,
                                ),
                                SizedBox(
                                  height: getSize(context) / 12,
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      await cubit.getDetailsOrders(
                                          orderId: widget.orderModel.id ?? -1);
                                    },
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: cubit.getDetailsOrdersModel
                                            ?.orderLines!.length,
                                        itemBuilder: (context, index) {
                                          return ProductCard(
                                            order: widget.orderModel,
                                            title: cubit
                                                .getDetailsOrdersModel
                                                ?.orderLines?[index]
                                                .productName,
                                            price: cubit
                                                    .getDetailsOrdersModel
                                                    ?.orderLines?[index]
                                                    .productUomQty *
                                                cubit
                                                    .getDetailsOrdersModel
                                                    ?.orderLines?[index]
                                                    .priceUnit,
                                            text: cubit
                                                    .getDetailsOrdersModel
                                                    ?.orderLines?[index]
                                                    .productName ??
                                                '',
                                            number: cubit
                                                    .getDetailsOrdersModel
                                                    ?.orderLines?[index]
                                                    .productUomQty
                                                    .toString() ??
                                                '',
                                          );
                                        }),
                                  ),
                                ),

                                CustomTotalPrice(
                                  currency:
                                      widget.orderModel.currencyId?.name ?? '',
                                  price: cubit
                                          .getDetailsOrdersModel?.amountTotal
                                          .toString() ??
                                      '',
                                  //  calculateTotalDiscountedPrice(
                                  //     cubit.getDetailsOrdersModel?.orderLines ??
                                  //         [])
                                ),
                              
                                //     Delivered
                                 Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: RoundedButton(
                                                text: 'payment'.tr(),
                                                onPressed: () {
                                                  cubit
                                                          .getDetailsOrdersModel
                                                          ?.invoices
                                                          ?.first
                                                          .amountDue =
                                                      cubit
                                                          .getDetailsOrdersModel
                                                          ?.amountTotal;
                                                  setState(() {
                                                    Navigator.pushNamed(context,
                                                        Routes.paymentRoute,
                                                        arguments: true);
                                                    // cubit.createAndValidateInvoice(
                                                    //     orderId: widget.orderModel.id ?? -1);
                                                  });
                                                },
                                                backgroundColor: AppColors.blue,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return PdfViewerPage(
                                                        baseUrl:
                                                            '${EndPoints.printInvoice}${cubit.returnOrderModel?.result?.creditNoteId ?? 0}',
                                                      );
                                                    },
                                                  ));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            AppColors.secondry,
                                                        width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.print,
                                                        color:
                                                            AppColors.secondry,
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      AutoSizeText(
                                                        'return_invoice'.tr(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16.sp,
                                                            color: AppColors
                                                                .secondry),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ))
                                        ],
                                      )
                                    
                                 
                              ],
                            ),
                    ))
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
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
