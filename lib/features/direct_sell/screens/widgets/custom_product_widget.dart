import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/models/all_products_model.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/details_order/screens/widgets/custom_order_details_item.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';

import '../../../../core/widgets/decode_image_with_text.dart';
import '../../cubit/direct_sell_cubit.dart';
import '../../cubit/direct_sell_state.dart';

class CustomProductWidget extends StatelessWidget {
  const CustomProductWidget({super.key, required this.product});
  final ProductModelData product;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectSellCubit, DirectSellState>(
      builder: (context, state) {
        var cubit = context.read<DirectSellCubit>();
        return Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        // height: getSize(context) / 3,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18.r)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.r),
                            child: product.image1920.toString() == "false"
                                ? Center(
                                    child: Stack(
                                    children: [
                                      Image.asset(
                                        ImageAssets.backgroundProduct,
                                        color: AppColors.primary,
                                      ),
                                      Text(
                                          product.name!.length > 5
                                              ? product.name!.substring(0, 4)
                                              : product.name ?? '',
                                          style: getBoldStyle(
                                              color: AppColors.white,
                                              fontSize: 18.sp)),
                                    ],
                                  ))
                                :
                                // Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYHcZPvy01X61yORcPE1zIvf7xnqkxS0-b8g&s")
                                CustomDecodedImageWithText(
                                    // context: context,
                                    character: product.name!
                                        .trimLeft() // Remove only leading whitespace
                                        .substring(
                                            0,
                                            product.name!.length >= 4
                                                ? 4
                                                : product.name!.length)
                                        .toString(),
                                    // base64String: AppStrings.base64image,
                                    base64String: product.image1920,
                                  )),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text("${product.name ?? ''}",
                                // child: Text("${product.name ?? ''}\n",
                                // maxLines: 2,
                                textAlign: TextAlign.start,
                                //  overflow: TextOverflow.ellipsis,
                                style:
                                    getBoldStyle(color: AppColors.primaryGrey)),
                          ),
                        ],
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Flexible(
                      //       child: Text("${product.name ?? ''}",
                      //       // child: Text("${product.name ?? ''}\n",
                      //          // maxLines: 2,
                      //           textAlign: TextAlign.start,
                      //         //  overflow: TextOverflow.ellipsis,
                      //           style:
                      //               getBoldStyle(color: AppColors.primaryGrey)),
                      //     ),
                      //     SizedBox(
                      //       width: 8.w,
                      //     ),
                      //     Text("${product.listPrice.toString()}${ context.read<HomeCubit>().currencyName}",
                      //         // "${product.listPrice.toString()}${product.currencyId?.name ?? ''}",
                      //         // maxLines: 2,
                      //         // textAlign: TextAlign.center,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: getRegularStyle(
                      //             color: AppColors.orangeThirdPrimary)),
                      //   ],
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                          "${product.listPrice.toString()}${context.read<HomeCubit>().currencyName}",
                          // "${product.listPrice.toString()}${product.currencyId?.name ?? ''}",
                          // maxLines: 2,
                          // textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                              color: AppColors.orangeThirdPrimary)),
                      SizedBox(
                        height: 10.h,
                      ),
                      InkWell(
                        onTap: () {
                          cubit.newQtyController.text =
                              product.userOrderedQuantity.toString();
                          customQtyShowBottomSheet(
                              context, cubit.newQtyController, () {
                            cubit.onChnageProductQuantity(product, context);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(
                                color: AppColors.orangeThirdPrimary,
                                width: 1.8),
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    cubit.addAndRemoveToBasket(
                                        product: product, isAdd: true);
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.orangeThirdPrimary,
                                    size: 30.w,
                                  ),
                                ),
                                Text(product.userOrderedQuantity.toString(),
                                    style: getBoldStyle(
                                        color: AppColors.primary,
                                        fontHeight: 1.3)),
                                GestureDetector(
                                  onTap: () {
                                    cubit.addAndRemoveToBasket(
                                        product: product, isAdd: false);
                                    // Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    color: AppColors.orangeThirdPrimary,
                                    size: 30.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
            Positioned(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(getSize(context) / 44),
                  color: AppColors.secondry,
                ),
                child: Text(
                  product.stockQuantity.toInt().toString(),
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
