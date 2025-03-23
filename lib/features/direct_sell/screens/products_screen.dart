import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/direct_sell/cubit/direct_sell_state.dart';
import 'package:top_sale/features/direct_sell/screens/widgets/custom_product_section.dart';
import 'package:top_sale/features/direct_sell/screens/widgets/scanner.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';
import '../../../config/routes/app_routes.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import '../../../core/models/all_products_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/assets_manager.dart';
import '../../clients/cubit/clients_cubit.dart';
import '../cubit/direct_sell_cubit.dart';
import 'widgets/custom_product_widget.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen(
      {super.key, required this.categoryName, required this.catId});
  final String categoryName;
  final String catId;
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    //! listen pangination
    scrollController.addListener(_scrollListener);
    if (widget.catId == '0') {
      context.read<DirectSellCubit>().selectedPriceList = null;
    }

    ///!
    context.read<DirectSellCubit>().currentIndex = -1;

    /// if catId not -1 or 0 get products by cat id
    if (widget.catId != '-1' && widget.catId != '0' && widget.catId != '-2') {
      context
          .read<DirectSellCubit>()
          .getAllProductsByCatogrey(id: int.parse(widget.catId));
    } else {
      context.read<DirectSellCubit>().getAllProducts();
      context.read<DirectSellCubit>().currentIndex == -1;
    }
  }

  _scrollListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      print('bottom');
      print(context.read<DirectSellCubit>().allProductsModel.result!.page);
      //! pagination
      if (context.read<DirectSellCubit>().allProductsModel.result!.page !=
              null &&
          context.read<DirectSellCubit>().allProductsModel.result!.page <
              context
                  .read<DirectSellCubit>()
                  .allProductsModel
                  .result!
                  .totalPages) {
        context.read<DirectSellCubit>().getAllProducts(
            isGetMore: true,
            pageId:
                context.read<DirectSellCubit>().allProductsModel.result!.page +
                        1 ??
                    1);
        debugPrint('new posts');
      }
    } else {
      print('dddddddddtop');
    }
  }

  @override
  Widget build(BuildContext context) {
    // String testImage =
    //     'https://img.freepik.com/free-photo/organic-cosmetic-product-with-dreamy-aesthetic-fresh-background_23-2151382816.jpg';
    return BlocBuilder<DirectSellCubit, DirectSellState>(
        builder: (context, state) {
      var cubit = context.read<DirectSellCubit>();
      return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            centerTitle: false,
            actions: [
              GestureDetector(
                onTap: () {
                  // catId == 0 go to despense basket else go to client page
                  widget.catId == '0'
                      ? Navigator.pushNamed(
                          context, Routes.dispensingBasketScreenRoute)
                      : widget.catId == '-2'
                          ? Navigator.pop(context)
                          : Navigator.pushNamed(context, Routes.clientsRoute,
                              arguments: ClientsRouteEnum.cart);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    'assets/images/basket1.png',
                    width: getSize(context) / 15,
                    color: cubit.currentIndex == 1
                        ? AppColors.orange
                        : Colors.black,
                  ),
                ),
              ),
            ],
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_outlined,
                size: 25.w,
              ),
            ),
            // //leadingWidth: 20,
            title: Text(
              widget.categoryName,
              style: getBoldStyle(
                fontSize: 20.sp,
              ),
            ),
          ),
          backgroundColor: AppColors.white,
          body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Column(children: [
                const CustomSearchWidget(),
                SizedBox(
                  height: 10,
                ),
                if (widget.catId != '0')
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        if (context.read<HomeCubit>().ispriceListManager) ...[
                          Expanded(
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 12.0.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: cubit
                                      .selectedPriceList, // This will store the ID (not the name)
                                  hint: Text(
                                    "price_list".tr(),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.grey),
                                  isExpanded: true,
                                  onChanged: (int? newValue) {
                                    if (context
                                        .read<HomeCubit>()
                                        .ispriceListManager) {
                                      cubit.changePriceList(newValue!);
                                      if (widget.catId != '-1' &&
                                          widget.catId != '0' &&
                                          widget.catId != '-2') {
                                        context
                                            .read<DirectSellCubit>()
                                            .getAllProductsByCatogrey(
                                                id: int.parse(widget.catId));
                                      } else {
                                        context
                                            .read<DirectSellCubit>()
                                            .getAllProducts();
                                        context
                                                .read<DirectSellCubit>()
                                                .currentIndex ==
                                            -1;
                                      } // Store the ID in cubit
                                    }
                                  },
                                  items: cubit
                                          .getAllPriceListtsModel?.pricelists
                                          ?.map<DropdownMenuItem<int>>(
                                              (resultItem) {
                                        return DropdownMenuItem<int>(
                                          value: resultItem.pricelistId,
                                          child: Text(
                                            resultItem.pricelistName ?? '',
                                            style: TextStyle(fontSize: 16.sp),
                                          ), // Display the name
                                        );
                                      }).toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ] else if (cubit.selectedPriceList != null) ...[
                          Expanded(
                              child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0.sp),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Center(
                                    child: Text(
                                      cubit.getAllPriceListtsModel?.pricelists
                                              ?.firstWhere((element) =>
                                                  element.pricelistId ==
                                                  cubit.selectedPriceList)
                                              .pricelistName ??
                                          '',
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ))),
                          SizedBox(width: 10),
                        ],
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: cubit
                                    .selectedProducsStockType, // This will store the ID (not the name)
                                hint: Text(
                                  "select_warehouse".tr(),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: Colors.grey),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  cubit.changeProductsStockType(
                                      newValue!); // Store the ID in cubit
                                  if (widget.catId != '-1' &&
                                      widget.catId != '0' &&
                                      widget.catId != '-2') {
                                    context
                                        .read<DirectSellCubit>()
                                        .getAllProductsByCatogrey(
                                            id: int.parse(widget.catId));
                                  } else {
                                    context
                                        .read<DirectSellCubit>()
                                        .getAllProducts();
                                    context
                                            .read<DirectSellCubit>()
                                            .currentIndex ==
                                        -1;
                                  }
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'stock',
                                    child: Text(
                                      "warehouse".tr(),
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'nonStock',
                                    child: Text(
                                      'all'.tr(),
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
              
                cubit.searchController.text.isNotEmpty
                    ? Expanded(
                        child: ListView(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomProductSection(
                                isSearch: true,
                                result: cubit.searchedProductsModel?.result
                                        ?.products ??
                                    []),
                          ),
                        ]),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            if (widget.categoryName == "products".tr() ||
                                widget.categoryName == "create_expense".tr())
                              cubit.catogriesModel == null
                                  ? SizedBox(
                                      height: 2,
                                    )
                                  : SizedBox(
                                      height: 50.h,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              cubit.changeIndex(-1, 0);
                                            },
                                            child: CustomCategoryText(
                                                text: "all".tr(),
                                                isSelected:
                                                    cubit.currentIndex == -1),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Flexible(
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: cubit.catogriesModel!
                                                  .result!.length,
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                width: 10.w,
                                              ),
                                              itemBuilder: (context, index) =>
                                                  GestureDetector(
                                                onTap: () {
                                                  cubit.changeIndex(
                                                      index,
                                                      cubit.catogriesModel
                                                          ?.result?[index].id);
                                                },
                                                child: CustomCategoryText(
                                                    text: cubit
                                                            .catogriesModel
                                                            ?.result?[index]
                                                            .name ??
                                                        "",
                                                    isSelected:
                                                        cubit.currentIndex ==
                                                            index),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            if (cubit.allProductsModel.result == [] ||
                                cubit.allProductsModel == AllProductsModel())
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      ImageAssets.nodata,
                                      color: AppColors.secondry,
                                      width: getSize(context) / 8,
                                    ),
                                    Text("no_data".tr()),
                                    SizedBox(height: 20.h),
                                  ],
                                ),
                              )
                            else
                              state is LoadingProduct
                                  ? const Center(
                                      child: CustomLoadingIndicator())
                                  : Expanded(
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: cubit.allProductsModel.result ==
                                                null
                                            ? Container()
                                            : StaggeredGrid.count(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 10.h,
                                                crossAxisSpacing: 10.w,
                                                children: List.generate(
                                                  cubit.allProductsModel.result!
                                                      .products!.length,
                                                  (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: CustomProductWidget(
                                                        product: cubit
                                                            .allProductsModel
                                                            .result!
                                                            .products![index]),
                                                  ),
                                                )),
                                      ),
                                    )
                          ],
                        ),
                      )
              ])));
    });
  }
}

class CustomCategoryText extends StatelessWidget {
  const CustomCategoryText(
      {super.key, required this.text, required this.isSelected});
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: getMediumStyle(
              fontSize: 18.sp,
              color: isSelected ? AppColors.primary : AppColors.primaryText),
        ),
        // IntrinsicHeight(
        //   child: Container(
        //     height: 4.h,
        //     //  width: double.maxFinite,
        //     decoration: BoxDecoration(
        //       color: AppColors.red,
        //       borderRadius: BorderRadius.circular(15.sp),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
