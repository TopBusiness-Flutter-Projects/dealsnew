import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/details_order/cubit/details_orders_cubit.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import 'package:top_sale/features/details_order/cubit/details_orders_state.dart';
import 'package:top_sale/features/details_order/screens/pdf.dart';
import 'package:top_sale/features/details_order/screens/widgets/card_from_details_order.dart';
import 'package:top_sale/features/details_order/screens/widgets/custom_total_price.dart';
import 'package:top_sale/features/details_order/screens/widgets/order_attachments_bottomshet.dart';
import 'package:top_sale/features/details_order/screens/widgets/product_card.dart';
import 'package:top_sale/features/details_order/screens/widgets/rounded_button.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/api/end_points.dart';
import '../../../core/models/get_orders_model.dart';
import '../../../core/models/order_details_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';

class DetailsOrder extends StatefulWidget {
  DetailsOrder(
      {super.key, required this.orderModel, required this.isClientOrder});
  bool isDelivered = false;
  bool isClientOrder;
  final OrderModel orderModel;
  @override
  State<DetailsOrder> createState() => _DetailsOrderState();
}

class _DetailsOrderState extends State<DetailsOrder> {
  @override
  void initState() {
    context
        .read<DetailsOrdersCubit>()
        .getDetailsOrders(orderId: widget.orderModel.id ?? -1);

    context.read<DetailsOrdersCubit>().changePage(
        // Delivered
        widget.orderModel.state == 'sale' &&
                widget.orderModel.invoiceStatus == 'to invoice' &&
                (widget.orderModel.deliveryStatus == 'done' ||
                    widget.orderModel.deliveryStatus == 'full')
            ? 2
            : widget.orderModel.state == 'sale' &&
                    widget.orderModel.invoiceStatus == 'invoiced' &&
                    (widget.orderModel.deliveryStatus == 'done' ||
                        widget.orderModel.deliveryStatus == 'full')
                ? 3
                : widget.orderModel.state == 'sale' &&
                        widget.orderModel.invoiceStatus == 'to invoice' &&
                        (widget.orderModel.deliveryStatus == 'assigned' ||
                            widget.orderModel.deliveryStatus == 'pending')
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
          actions: [
            (widget.orderModel.state == 'sale' &&
                    widget.orderModel.invoiceStatus == 'to invoice' &&
                    (widget.orderModel.deliveryStatus == 'assigned' ||
                        widget.orderModel.deliveryStatus == 'pending'))
                ? IconButton(
                    onPressed: () {
                      cubit.profileImage = null;
                      cubit.selectedBase64String = '';

                      showCancelAttachmentBottomSheet(
                          cubit.getDetailsOrdersModel?.id ?? -1,
                          widget.orderModel,
                          context);
                    },
                    icon: Text("cancel".tr(),
                        style: TextStyle(
                          fontFamily: AppStrings.fontFamily,
                          color: AppColors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        )))
                : IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, Routes.detailsOrderShowPriceReturns,
                          arguments: {
                            'isClientOrder': false,
                            'orderModel': widget.orderModel
                          });
                    },
                    icon: Text("return_order".tr(),
                        style: TextStyle(
                          fontFamily: AppStrings.fontFamily,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        )))
          ],
          backgroundColor: AppColors.white,
          centerTitle: false,
          leading: IconButton(
              onPressed: () {
                cubit.onClickBack(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: Text(
            'details_order'.tr(),
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
              //Delivered
              widget.orderModel.state = 'sale';
              widget.orderModel.invoiceStatus = 'to invoice';
              widget.orderModel.deliveryStatus = 'done';
              // widget.orderModel.deliveryStatus = 'full';
            });
            cubit.changePage(2);
          }
          if (state is CreateAndValidateInvoiceLoadedState) {
            // completed
            setState(() {
              widget.orderModel.state = 'sale';
              widget.orderModel.invoiceStatus = 'invoiced';
              widget.orderModel.deliveryStatus = 'done';
              // widget.orderModel.deliveryStatus = 'full';
            });
            cubit.changePage(3);
          }
          if (state is RegisterPaymentLoadedState) {
            setState(() {
              widget.orderModel.state = 'sale';
              widget.orderModel.invoiceStatus = 'invoiced';
              widget.orderModel.deliveryStatus = 'done';
              // widget.orderModel.deliveryStatus = 'full';
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
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: getheightSize(context) / 33,
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
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(children: [
                                      CardDetailsOrders(
                                        orderModel: widget.orderModel,
                                        orderDetailsModel:
                                            cubit.getDetailsOrdersModel!,
                                        printWidget: PopupMenuButton<int>(
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                end: 10.0),
                                            child: Icon(
                                              Icons.print_outlined,
                                              size: 30,
                                              color:
                                                  AppColors.orangeThirdPrimary,
                                            ),
                                          ),
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            // sale order
                                            if (cubit.getDetailsOrdersModel!
                                                    .id !=
                                                null)
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return PdfViewerPage(
                                                            baseUrl:
                                                                '/report/pdf/sale.report_saleorder/${cubit.getDetailsOrdersModel!.id.toString()}',
                                                          );
                                                          // return PaymentWebViewScreen(url: "",);
                                                        },
                                                      ));
                                                    },
                                                    child: Text(
                                                        "print_sale_order".tr())),
                                              ),
                                            // delivery order
                                            if (cubit.getDetailsOrdersModel!
                                                .pickings!.isNotEmpty)
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return PdfViewerPage(
                                                            baseUrl:
                                                                '${EndPoints.printPicking}${cubit.getDetailsOrdersModel!.pickings![0].pickingId.toString()}',
                                                          );
                                                          // return PaymentWebViewScreen(url: "",);
                                                        },
                                                      ));
                                                    },
                                                    child: Text(
                                                        "print_delivery".tr())),
                                              ),
                                            // invoice
                                            if (cubit.getDetailsOrdersModel!
                                                .invoices!.isNotEmpty)
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _showInvoicesBottomSheet(
                                                          context,
                                                          invoiceId: cubit
                                                              .getDetailsOrdersModel!
                                                              .invoices![0]
                                                              .invoiceId
                                                              .toString());
                                                    },
                                                    child:
                                                        Text("print_invoice".tr())),
                                              ),

                                            // payment
                                            if (cubit.getDetailsOrdersModel!
                                                .payments!.isNotEmpty)
                                              PopupMenuItem<int>(
                                                value: 1,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _showPaymentBottomSheet(
                                                          context,
                                                          paymentId: cubit
                                                              .getDetailsOrdersModel!
                                                              .payments![0]
                                                              .paymentId
                                                              .toString());
                                                      // Navigator.push(context,
                                                      //     MaterialPageRoute(
                                                      //   builder: (context) {
                                                      //     return PdfViewerPage(
                                                      //       baseUrl:
                                                      //           '${EndPoints.printPayment}${cubit.getDetailsOrdersModel!.payments![0].paymentId.toString()}',
                                                      //     );
                                                      //     // return PaymentWebViewScreen(url: "",);
                                                      //   },
                                                      // ));
                                                    },
                                                    child: Text(
                                                        "print_payment".tr())),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: getSize(context) / 12,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
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
                                                      .priceSubtotal
                                                      .toString() ??
                                                  '',
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
                                    ]),
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
                                if (cubit.getDetailsOrdersModel!.invoices!
                                    .isNotEmpty)
                                  CustomTotalPriceDue(
                                    currency:
                                        widget.orderModel.currencyId?.name ??
                                            '',
                                    price: cubit.getDetailsOrdersModel
                                            ?.invoices!.first.amountDue
                                            .toString() ??
                                        '',
                                    state: cubit.getDetailsOrdersModel
                                            ?.invoices!.first.paymentState
                                            .toString() ??
                                        '',
                                  ),

                               
                                //    delivered
                                widget.orderModel.state == 'sale' &&
                                        widget.orderModel.invoiceStatus ==
                                            'to invoice' &&
                                        (widget.orderModel.deliveryStatus ==
                                                'done' ||
                                            widget.orderModel.deliveryStatus ==
                                                'full')
                                    ? Row(
                                        children: [
                                          widget.isClientOrder == true
                                              ? const Expanded(
                                                  child: SizedBox(),
                                                )
                                              : Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: RoundedButton(
                                                      text: 'Create_an_invoice'
                                                          .tr(),
                                                      onPressed: () {
                                                        setState(() {
                                                          cubit.createAndValidateInvoice(
                                                              context,
                                                              orderId: widget
                                                                      .orderModel
                                                                      .id ??
                                                                  -1);
                                                        });
                                                      },
                                                      backgroundColor:
                                                          AppColors.blue,
                                                    ),
                                                  ),
                                                ),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (cubit
                                                        .getDetailsOrdersModel!
                                                        .pickings!
                                                        .isNotEmpty) {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                        builder: (context) {
                                                          return PdfViewerPage(
                                                            baseUrl:
                                                                '${EndPoints.printPicking}${cubit.getDetailsOrdersModel!.pickings![0].pickingId.toString()}',
                                                          );
                                                          // return PaymentWebViewScreen(url: "",);
                                                        },
                                                      ));
                                                    }
                                                  });
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
                                                        'delivery_order'.tr(),
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
                                    :
                                    // new
                                    (widget.orderModel.state == 'sale' &&
                                                widget.orderModel.invoiceStatus ==
                                                    'to invoice' &&
                                                widget.orderModel
                                                        .deliveryStatus ==
                                                    'pending' ||
                                            widget.orderModel.deliveryStatus ==
                                                'assigned')
                                        ? Row(
                                            children: [
                                              widget.isClientOrder == true
                                                  ? const Expanded(
                                                      child: SizedBox())
                                                  : Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: RoundedButton(
                                                          text:
                                                              'delivery_confirmation'
                                                                  .tr(),
                                                          onPressed: () {
                                                            setState(() {
                                                              cubit.confirmDelivery(
                                                                  context,
                                                                  orderId: widget
                                                                          .orderModel
                                                                          .id ??
                                                                      -1,
                                                                  pickingId: cubit
                                                                          .getDetailsOrdersModel
                                                                          ?.pickings?[
                                                                              0]
                                                                          .pickingId ??
                                                                      -1);
                                                            });
                                                          },
                                                          backgroundColor:
                                                              AppColors
                                                                  .secondry,
                                                        ),
                                                      ),
                                                    ),
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (cubit
                                                                .getDetailsOrdersModel!
                                                                .id !=
                                                            null) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (context) {
                                                              return PdfViewerPage(
                                                                baseUrl:
                                                                    '/report/pdf/sale.report_saleorder/${cubit.getDetailsOrdersModel!.id.toString()}',
                                                              );
                                                              // return PaymentWebViewScreen(url: "",);
                                                            },
                                                          ));
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .secondry,
                                                            width: 1.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
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
                                                            color: AppColors
                                                                .secondry,
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          AutoSizeText(
                                                            'order_sales'.tr(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                        : widget.orderModel.state == 'sale' &&
                                                widget.orderModel
                                                        .invoiceStatus ==
                                                    'invoiced' &&
                                                (widget.orderModel
                                                            .deliveryStatus ==
                                                        'done' ||
                                                    widget.orderModel
                                                            .deliveryStatus ==
                                                        'full')
                                            ?
                                            // completed
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  (cubit.getDetailsOrdersModel!
                                                          .invoices!.isNotEmpty)
                                                      ? widget.isClientOrder ==
                                                              true
                                                          ? const Expanded(
                                                              child: SizedBox())
                                                          : (cubit
                                                                          .getDetailsOrdersModel!
                                                                          .invoices!
                                                                          .first
                                                                          .amountDue <=
                                                                      cubit
                                                                          .getDetailsOrdersModel!
                                                                          .invoices!
                                                                          .first
                                                                          .amountTotal &&
                                                                  cubit
                                                                          .getDetailsOrdersModel!
                                                                          .invoices!
                                                                          .first
                                                                          .amountDue >
                                                                      0)
                                                              ? Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                    child:
                                                                        RoundedButton(
                                                                      text: 'payment'
                                                                          .tr(),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          Navigator.pushNamed(
                                                                              context,
                                                                              Routes.paymentRoute,
                                                                              arguments: false);
                                                                          // cubit.createAndValidateInvoice(
                                                                          //     orderId: widget.orderModel.id ?? -1);
                                                                        });
                                                                      },
                                                                      backgroundColor:
                                                                          AppColors
                                                                              .blue,
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox()
                                                      : const Expanded(
                                                          child: SizedBox()),
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: InkWell(
                                                        onTap: () {
                                                          _showInvoicesBottomSheet(
                                                              context,
                                                              invoiceId: cubit
                                                                  .getDetailsOrdersModel!
                                                                  .invoices![0]
                                                                  .invoiceId
                                                                  .toString());
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .secondry,
                                                                width: 1.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      8.0),
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
                                                                color: AppColors
                                                                    .secondry,
                                                              ),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              AutoSizeText(
                                                                'invoice'.tr(),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: AppColors
                                                                        .secondry),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ))
                                                ],
                                              )
                                            :
                                            // no invoices
                                            const SizedBox(),

                                // const Expanded(child: SizedBox()),
                              ],
                            ),
                    ))
                  ],
                ),
              ),
              cubit.getDetailsOrdersModel?.state == 'cancel'
                  ? const SizedBox()
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.sp),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 80.w,
                          padding: EdgeInsets.only(
                              left: 10.w, right: 10.w, top: 15.h, bottom: 10.h),
                          width: double.maxFinite,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Column(
                                // alignment: Alignment.center,

                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AutoSizeText('show_price'.tr(),
                                            style: TextStyle(
                                                color: AppColors.secondry,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600)),
                                        AutoSizeText('new'.tr(),
                                            style: TextStyle(
                                                color: AppColors.secondry,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600)),
                                        AutoSizeText('delivered'.tr(),
                                            style: TextStyle(
                                                color: AppColors.secondry,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600)),
                                        AutoSizeText('complete'.tr(),
                                            style: TextStyle(
                                                color: AppColors.secondry,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  FlutterStepIndicator(
                                    division: 3,
                                    height: 28.h,
                                    positiveColor: AppColors.secondry,
                                    progressColor: AppColors.secondry,
                                    negativeColor:
                                        const Color.fromRGBO(213, 213, 213, 1),
                                    list: cubit.list,
                                    onChange: (i) {},
                                    positiveCheck: const Icon(
                                      Icons.check_rounded,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    page: cubit.page,
                                    disableAutoScroll: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
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

void _showInvoicesBottomSheet(
  BuildContext context, {
  required String invoiceId,
}) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: getSize(context) / 20,
            right: getSize(context) / 20,
            top: getSize(context) / 20,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                getSize(context) / 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "print_invoice".tr(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PdfViewerPage(
                          baseUrl: '${EndPoints.printInvoice}${invoiceId}',
                        );
                        // return PaymentWebViewScreen(url: "",);
                      },
                    ));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageAssets.invoicedIcon,
                          height: 35.h,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "print_a4".tr(),
                          style: TextStyle(
                            // color: AppColors.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PdfViewerPage(
                          baseUrl: '${EndPoints.printposInvoice}${invoiceId}',
                        );
                        // return PaymentWebViewScreen(url: "",);
                      },
                    ));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageAssets.receiptIcon,
                          height: 35.h,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "print_recipt".tr(),
                          style: TextStyle(
                            // color: AppColors.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
              ],
            ),
          ),
        );
      });
}

void _showPaymentBottomSheet(
  BuildContext context, {
  required String paymentId,
}) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: getSize(context) / 20,
            right: getSize(context) / 20,
            top: getSize(context) / 20,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                getSize(context) / 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "print_invoice".tr(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PdfViewerPage(
                          baseUrl: '${EndPoints.printPayment}${paymentId}',
                        );
                        // return PaymentWebViewScreen(url: "",);
                      },
                    ));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageAssets.invoicedIcon,
                          height: 35.h,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                         "print_a4".tr(),
                          style: TextStyle(
                            // color: AppColors.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return PdfViewerPage(
                          baseUrl: '${EndPoints.printPosPayment}${paymentId}',
                        );
                        // return PaymentWebViewScreen(url: "",);
                      },
                    ));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    child: Row(
                      children: [
                        Image.asset(
                          ImageAssets.receiptIcon,
                          height: 35.h,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          "print_recipt".tr(),
                          style: TextStyle(
                            // color: AppColors.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
              ],
            ),
          ),
        );
      });
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















