import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/config/routes/app_routes.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/direct_sell/screens/widgets/custom_category_widget.dart';
import 'package:top_sale/features/direct_sell/screens/widgets/custom_product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/models/all_products_model.dart';
import '../../cubit/direct_sell_cubit.dart';

class CustomProductSection extends StatefulWidget {
  CustomProductSection(
      {super.key, required this.result, required this.isSearch});
  List<ProductModelData>? result;
  final bool isSearch;

  @override
  State<CustomProductSection> createState() => _CustomProductSectionState();
}

class _CustomProductSectionState extends State<CustomProductSection> {
  @override
  Widget build(BuildContext context) {
    // String testImage =
    //     'https://img.freepik.com/free-photo/organic-cosmetic-product-with-dreamy-aesthetic-fresh-background_23-2151382816.jpg';

    return Column(
      children: [
        widget.isSearch
            ? Container()
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print(context.read<DirectSellCubit>().basket.length);
                        },
                        child: Text(
                          "products".tr(),
                          style: getBoldStyle(
                              color: AppColors.secondry, fontSize: 20.sp),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.productsRoute,
                                arguments: ["products".tr(), '-1']);
                          },
                          child: Text(
                            "all".tr(),
                            style: getRegularStyle(
                                color: AppColors.orangeThirdPrimary,
                                fontSize: 18.sp),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
        StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            children: List.generate(
              widget.result!.length,
              (index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: CustomProductWidget(
                  product: widget.result![index],
                ),
              ),
            ))
       
      ],
    );
  }
}
