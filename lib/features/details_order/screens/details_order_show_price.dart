import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/core/widgets/custom_text_form_field.dart';
import 'package:top_sale/features/details_order/screens/pdf.dart';
import 'package:top_sale/features/details_order/screens/widgets/card_from_details_order.dart';
import 'package:top_sale/features/details_order/screens/widgets/order_attachments_bottomshet.dart';
import 'package:top_sale/features/details_order/screens/widgets/product_card.dart';
import 'package:top_sale/core/utils/circle_progress.dart';
import 'package:top_sale/features/details_order/screens/widgets/rounded_button.dart';

import 'package:top_sale/features/login/widget/custom_button.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/models/get_orders_model.dart';
import 'package:easy_localization/easy_localization.dart' as tr;
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/dialogs.dart';
import '../cubit/details_orders_cubit.dart';
import '../cubit/details_orders_state.dart';
import 'widgets/custom_order_details_item.dart';

class DetailsOrderShowPrice extends StatefulWidget {
  DetailsOrderShowPrice(
      {super.key, required this.orderModel, required this.isClientOrder});
  bool isDelivered = false;
  bool isClientOrder;
  final OrderModel orderModel;
  @override
  State<DetailsOrderShowPrice> createState() => _DetailsOrderShowPriceState();
}

class _DetailsOrderShowPriceState extends State<DetailsOrderShowPrice> {
  @override
  void initState() {
    context
        .read<DetailsOrdersCubit>()
        .getDetailsOrders(orderId: widget.orderModel.id ?? -1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsOrdersCubit, DetailsOrdersState>(
      builder: (context, state) {
        var cubit = context.read<DetailsOrdersCubit>();

        return WillPopScope(
          onWillPop: () async {
            cubit.onClickBack(context);
            return false;
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              actions: [
                (widget.orderModel.state == 'draft' && !widget.isClientOrder)
                    ? IconButton(
                        onPressed: () {
                          cubit.profileImage = null;
                          cubit.selectedBase64String = '';
                          showCancelAttachmentBottomSheet(
                              cubit.getDetailsOrdersModel!.id ?? -1,
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
                          print("ssssssssssssssssssssss");
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
              leading: IconButton(
                  onPressed: () {
                    cubit.onClickBack(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              backgroundColor: AppColors.white,
              centerTitle: false,
              //leadingWidth: 20,
              title: Text(
                'details_order'.tr(),
                style: TextStyle(
                    fontFamily: AppStrings.fontFamily,
                    color: AppColors.black,
                    fontWeight: FontWeight.w700),
              ),
            ),
            body: Column(
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
                              isShowPrice: !widget.isClientOrder,
                              onTap: () {
                                cubit.newAllDiscountController.text =
                                    '0.0'.toString();
                                customShowBottomSheet(
                                    context, cubit.newAllDiscountController,
                                    onPressed: () {
                                  if (double.parse(cubit
                                          .newAllDiscountController.text
                                          .toString()) <
                                      100) {
                                    cubit.onChnageAllDiscountOfUnit(context);
                                  } else {
                                    errorGetBar('discount_validation'.tr());
                                  }
                                });
                              },
                              orderModel: widget.orderModel,
                              orderDetailsModel: cubit.getDetailsOrdersModel!,
                            ),
                            SizedBox(height: getSize(context) / 12),
                            Flexible(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: cubit.getDetailsOrdersModel!
                                      .orderLines!.length,
                                  itemBuilder: (context, index) {
                                    return widget.isClientOrder == true
                                        ? ProductCard(
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
                                          )
                                        : CustomOrderDetailsShowPriceItem(
                                            isReturned: false,
                                            onPressed: () {
                                              //! on delete add item tp list to send it kat reqiesu of update
                                              setState(() {
                                                cubit.removeItemFromOrderLine(
                                                    index);
                                              });
                                            },
                                            item: cubit.getDetailsOrdersModel!
                                                .orderLines![index]);
                                  }),
                            ),
                          ],
                        ),
                )),
                (state is LoadingUpdateQuotation ||
                        state is LoadingConfirmQuotation)
                    ? const Center(
                        child: CustomLoadingIndicator(),
                      )
                    : Row(
                        children: [
                          cubit.getDetailsOrdersModel?.orderLines?.length == 0
                              ? Container()
                              : widget.isClientOrder == true
                                  ? SizedBox()
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: RoundedButton(
                                          text: 'make_order'.tr(),
                                          onPressed: () {
                                            setState(() {
                                              cubit.updateQuotation(
                                                  orderModel: widget.orderModel,
                                                  context: context,
                                                  partnerId: widget.orderModel
                                                          .partnerId?.id ??
                                                      -1);
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
                                                 if (cubit.getDetailsOrdersModel!.id != null) {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return PdfViewerPage(
                                          baseUrl:
                                              '/report/pdf/sale.report_saleorder/${cubit.getDetailsOrdersModel!.id.toString()}',
                                        );
                                        // return PaymentWebViewScreen(url: "",);
                                      },
                                    ));
                                  }
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
                                                        "show_price".tr(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16.sp,
                                                            color: AppColors
                                                                .secondry),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            
                                                ),
                                          ))
                          
                        ],
                      ),
                Container(
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
                      height: 90.w,
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
                              // widget.isClientOrder==true?
                              //     SizedBox():
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
                                page: 0,
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
            ),
          ),
        );
      },
    );
  }
}
