import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/config/routes/app_routes.dart';
import 'package:top_sale/core/models/get_all_promotions.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/core/widgets/custom_text_form_field.dart';
import 'package:top_sale/features/basket_screen/cubit/cubit.dart';
import 'package:top_sale/features/details_order/screens/widgets/order_attachments_bottomshet.dart';
import 'package:top_sale/features/details_order/screens/widgets/rounded_button.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';
import 'package:top_sale/features/login/widget/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:top_sale/core/utils/circle_progress.dart';
import '../../../core/models/all_partners_for_reports_model.dart';
import '../../../core/models/all_products_model.dart';
import '../../direct_sell/cubit/direct_sell_cubit.dart';
import '../../direct_sell/cubit/direct_sell_state.dart';
import '../cubit/state.dart';
import 'custom_basket_item.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({
    required this.partner,
    required this.currency,
    super.key,
  });
  final AllPartnerResults? partner;
  final String currency;
  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  TextEditingController copouneController = TextEditingController();
  @override
  void initState() {
    context.read<DirectSellCubit>().getAllShipping();
    context.read<DirectSellCubit>().getAllPromotions();
    context.read<DirectSellCubit>().getAllPromotions2();
    context.read<DirectSellCubit>().selectedPromotion = null;
    context.read<DirectSellCubit>().selectedShipping = null;
    context.read<DirectSellCubit>().priceController.clear();
    // if (context.read<DirectSellCubit>().basket.isEmpty) {
    //   if (widget.partner?.pricListId != null) {
    //     if (widget.partner?.pricListId.toString() != "false") {
    //       context.read<DirectSellCubit>().changePriceList(
    //           int.parse(widget.partner?.pricListId.toString() ?? "0"));
    //       print("ddddddddd1 " + "${widget.partner?.pricListId}");
    //       print("ddddddddd12 " +
    //           "${context.read<DirectSellCubit>().selectedPriceList}");
    //     }
    //   }
    //   Navigator.pushNamed(context, Routes.productsRoute,
    //       arguments: ["products".tr(), '-2']);
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectSellCubit, DirectSellState>(
      builder: (context, state) {
        var basketCubit = context.read<BasketCubit>();
        var directSellCubit = context.read<DirectSellCubit>();
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    print("ddddddddd0 " + "${widget.partner?.pricListId}");
                    if (widget.partner?.pricListId != null) {
                      if (widget.partner?.pricListId.toString() != "false") {
                        context.read<DirectSellCubit>().changePriceList(
                            int.parse(
                                widget.partner?.pricListId.toString() ?? "0"));
                        print("ddddddddd1 " + "${widget.partner?.pricListId}");
                        print("ddddddddd12 " +
                            "${context.read<DirectSellCubit>().selectedPriceList}");
                      }
                    }
                    Navigator.pushNamed(context, Routes.productsRoute,
                        arguments: ["products".tr(), '-2']);
                  },
                  child: Container(
                    height: 30.sp,
                    width: 30.sp,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadiusDirectional.circular(90),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 20.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            title: Text(
              'basket'.tr(),
              style: TextStyle(
                color: AppColors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: BlocBuilder<BasketCubit, BasketState>(
                builder: (context, state) {
              return Column(
                children: [
                  //! Cusomer name
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 14),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppColors.grey2Color,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          ImageAssets.profileIconPng,
                          width: getSize(context) / 8,
                          height: getSize(context) / 8,
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    widget.partner?.name ?? '',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                widget.partner?.phone.toString() == 'false'
                                    ? Container()
                                    : InkWell(
                                        onTap: () async {
                                          await launchPhoneDialer(
                                              widget.partner?.phone ?? '');
                                        },
                                        child: Text(
                                          widget.partner?.phone.toString() ??
                                              '_',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     //!total discount add discount
                        //     // customShowBottomSheet(context, cubit);
                        //   },
                        //   child: Image.asset(
                        //     ImageAssets.discount,
                        //     width: getSize(context) / 12,
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 5.0),
                          child: Column(
                            children: [
                              Text(
                                'total'.tr(),
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                '${calculateTotalDiscountedPrice(directSellCubit.basket)} ${directSellCubit.basket.isEmpty ? '' : context.read<HomeCubit>().currencyName}',
                                // '${calculateTotalDiscountedPrice(cubit2.basket)} ${cubit2.basket.isEmpty ? '' : cubit2.basket.first.currencyId?.name ?? ''}',
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                              directSellCubit.basket.isEmpty
                                  ? Container()
                                  : !context.read<HomeCubit>().isDiscountManager
                                      ? Container()
                                      : InkWell(
                                          onTap: () {
                                            directSellCubit
                                                .newAllDiscountController
                                                .text = '0.0'.toString();
                                            customShowBottomSheet(
                                                context,
                                                directSellCubit
                                                    .newAllDiscountController,
                                                onPressed: () {
                                              if (double.parse(directSellCubit
                                                      .newAllDiscountController
                                                      .text
                                                      .toString()) <
                                                  100) {
                                                directSellCubit
                                                    .onChnageAllDiscountOfUnit(
                                                        context);
                                              } else {
                                                errorGetBar(
                                                    'discount_validation'.tr());
                                              }
                                            });

                                            //! add discount

                                            // customShowBottomSheet(
                                            //   context,
                                            //   cubit.controllerPercent,
                                            //   onPressed: () {
                                            //     //! set dis count to model
                                            //     //! cal the new value of price
                                            //     //! case all discout remove discount of itms first then make all and loop on them
                                            //     //! clear controller
                                            //   },
                                            // );
                                          },
                                          child: Image.asset(
                                            ImageAssets.discount,
                                            width: getSize(context) / 14,
                                          ),
                                        ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )

                  //! Cusomer name
                  ,
                  SizedBox(
                    height: getSize(context) / 16,
                  ),
                  directSellCubit.basket.isEmpty
                      ? Center(child: Text("basket_embty".tr()))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: directSellCubit.basket.length,
                          itemBuilder: (context, index) {
                            var item = directSellCubit.basket[index];
                            return CustomBasketItem(
                              item: item,
                              isEditable:
                                  context.read<HomeCubit>().isDiscountManager,
                            );
                          },
                        ),
                  SizedBox(height: 32.h),
                  directSellCubit.basket.isEmpty
                      ? Container()
                      : BlocBuilder<DirectSellCubit, DirectSellState>(
                          builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: RoundedButton(
                                    text:
                                        directSellCubit.selectedShipping == null
                                            ? "add_charge".tr()
                                            : "change_charge".tr(),
                                    onPressed: () {
                                      // context
                                      //     .read<DirectSellCubit>()
                                      //     .priceController
                                      //     .clear();
                                      // context
                                      //     .read<DirectSellCubit>()
                                      //     .selectedShipping = null;
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return BlocBuilder<DirectSellCubit,
                                                  DirectSellState>(
                                              builder: (context, state) {
                                            return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "add_charge".tr(),
                                                      style: getMediumStyle(),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            context
                                                                .read<
                                                                    DirectSellCubit>()
                                                                .priceController
                                                                .clear();
                                                            context
                                                                .read<
                                                                    DirectSellCubit>()
                                                                .selectedShipping = null;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                                content: SizedBox(
                                                  width: getSize(context),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    12.0.sp),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              int>(
                                                            value: directSellCubit
                                                                .selectedShipping, // This will store the ID (not the name)
                                                            hint: Text(
                                                             "select_charge"
                                                                  .tr(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            icon: const Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                color: Colors
                                                                    .grey),
                                                            isExpanded: true,
                                                            onChanged: (int?
                                                                newValue) {
                                                              directSellCubit
                                                                  .changeShipping(
                                                                      newValue!); // Store the ID in cubit
                                                            },
                                                            items: directSellCubit
                                                                    .getAllShippingModel
                                                                    ?.shippingMethods
                                                                    ?.map<DropdownMenuItem<int>>(
                                                                        (resultItem) {
                                                                  return DropdownMenuItem<
                                                                      int>(
                                                                    value:
                                                                        resultItem
                                                                            .id,
                                                                    child: Text(
                                                                        resultItem.name ??
                                                                            ''), // Display the name
                                                                  );
                                                                }).toList() ??
                                                                [],
                                                          ),
                                                        ),
                                                      ),
                                                      CustomTextField(
                                                        labelText: "price".tr(),
                                                        controller:
                                                            directSellCubit
                                                                .priceController,
                                                        borderRadius: 8,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      CustomButton(
                                                          title: "add".tr(),
                                                          onTap: () {
                                                            if (directSellCubit
                                                                    .priceController
                                                                    .text
                                                                    .isEmpty ||
                                                                directSellCubit
                                                                        .selectedShipping ==
                                                                    null) {
                                                              errorGetBar(
                                                                  "please_enter_data".tr());
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          })
                                                    ],
                                                  ),
                                                ));
                                          });
                                        },
                                      );
                                    },
                                    backgroundColor: AppColors.blue,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: RoundedButton(
                                    text: directSellCubit
                                            .selectedPromotionsIds.isEmpty
                                        ? "add_copoune".tr()
                                        : "edit_copoune".tr(),
                                    onPressed: () {
                                      // context
                                      //     .read<DirectSellCubit>()
                                      //     .selectedCoupune = null;

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return BlocBuilder<DirectSellCubit,
                                                  DirectSellState>(
                                              builder: (context, state) {
                                            return AlertDialog(
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "add_copoune".tr(),
                                                      style: getMediumStyle(),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            context
                                                                .read<
                                                                    DirectSellCubit>()
                                                                .selectedPromotion = null;
                                                          });
                                                        },
                                                        child:
                                                            Icon(Icons.close))
                                                  ],
                                                ),
                                                content: SizedBox(
                                                  width: getSize(context),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    12.0.sp),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              int>(
                                                            value: directSellCubit
                                                                .selectedPromotion, // This will store the ID (not the name)
                                                            hint: Text(
"add_copoune"                                                                  .tr(),
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            icon: const Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                color: Colors
                                                                    .grey),
                                                            isExpanded: true,
                                                            onChanged: (int?
                                                                newValue) {
                                                              // directSellCubit
                                                              //     .changePromotion(
                                                              //         newValue!); // Store the ID in cubit
                                                              if (newValue !=
                                                                  null) {
                                                                if (directSellCubit
                                                                    .selectedPromotionsIds
                                                                    .any((user) =>
                                                                        user.id ==
                                                                        newValue)) {
                                                                  errorGetBar(
                                                                     "copoune_exist".tr());
                                                                } else {
                                                                  print(
                                                                      ':::::: remove from wrong button');
                                                                  directSellCubit
                                                                      .addOrRemoveUser(
                                                                    directSellCubit
                                                                            .getPromotionsModel
                                                                            ?.result
                                                                            ?.where((element) =>
                                                                                element.id ==
                                                                                newValue)
                                                                            .first ??
                                                                        PromotionModel(),
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            items: directSellCubit
                                                                    .getPromotionsModel
                                                                    ?.result
                                                                    ?.map<DropdownMenuItem<int>>(
                                                                        (resultItem) {
                                                                  return DropdownMenuItem<
                                                                      int>(
                                                                    value:
                                                                        resultItem
                                                                            .id,
                                                                    child: Text(
                                                                        resultItem.name ??
                                                                            ''), // Display the name
                                                                  );
                                                                }).toList() ??
                                                                [],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Wrap(
                                                                  children: directSellCubit
                                                                      .selectedPromotionsIds
                                                                      .map((promotion) => Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Chip(
                                                                              label: Text(promotion.name ?? ''),
                                                                              onDeleted: () {
                                                                                directSellCubit.addOrRemoveUser(promotion);
                                                                              })))
                                                                      .toList()),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      CustomButton(
                                                          title: "done".tr(),
                                                          onTap: () {
                                                           
                                                            Navigator.pop(
                                                                context);
                                                            // }
                                                          })
                                                    ],
                                                  ),
                                                ));
                                          });
                                        },
                                      );
                                    },
                                    backgroundColor: AppColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),

                  (state is LoadingCreateQuotation)
                      ? const Center(child: CustomLoadingIndicator())
                      : directSellCubit.basket.isEmpty
                          ? Container()
                          : CustomButton(
                              title: 'show_price'.tr(),
                              onTap: () {
                                showCreateAttachmentBottomSheet(
                                    widget.partner?.id ?? -1, context);
                                // cubit2.createQuotation(
                                //     warehouseId: '1',
                                //     context: context,
                                //     partnerId: widget.partner?.id ?? -1);
                                //!
                              })
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Future<void> launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(phoneUri)) {
      throw 'Could not launch phone dialer for $phoneNumber';
    }
  }

  String calculateTotalDiscountedPrice(List<ProductModelData> items) {
    double total = items.fold(0.0, (sum, item) {
      dynamic priceUnit = item.listPrice;
      dynamic quantity = item.userOrderedQuantity;
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
