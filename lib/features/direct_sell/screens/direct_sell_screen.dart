import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/features/direct_sell/cubit/direct_sell_state.dart';
import 'package:top_sale/features/direct_sell/screens/widgets/custom_category_section.dart';
import 'package:top_sale/features/direct_sell/screens/widgets/custom_product_section.dart';
import 'package:top_sale/features/direct_sell/screens/widgets/scanner.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/models/category_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import 'package:top_sale/core/utils/circle_progress.dart';

import '../../../core/utils/get_size.dart';
import '../../clients/cubit/clients_cubit.dart';
import '../cubit/direct_sell_cubit.dart';

class DirectSellScreen extends StatefulWidget {
  const DirectSellScreen({super.key});

  @override
  State<DirectSellScreen> createState() => _DirectSellScreenState();
}

class _DirectSellScreenState extends State<DirectSellScreen> {
  List<CategoryModelData>? result;

  void initState() {
    super.initState();

    context.read<DirectSellCubit>().getAllProducts(isHome: true);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectSellCubit, DirectSellState>(
        builder: (context, state) {
      // if (state is LoadingCatogries) {
      //   return Scaffold(body: const Center(child: CustomLoadingIndicator()));
      // }

      var cubit = context.read<DirectSellCubit>();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.clientsRoute,
                    arguments: ClientsRouteEnum.cart);
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'assets/images/basket1.png',
                  width: getSize(context) / 15,
                  color:
                      cubit.currentIndex == 1 ? AppColors.orange : Colors.black,
                ),
              ),
            ),
          ],
          centerTitle: false,
          title: Text(
            "direct_sell".tr(),
            style: TextStyle(
                fontFamily: AppStrings.fontFamily,
                color: AppColors.black,
                fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: AppColors.white,
        body: state is LoadingCatogries
            ? Center(
                child: CustomLoadingIndicator(
                color: AppColors.primary,
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  // Ensure both methods are awaited for proper refresh functionality
                  await cubit.getCategries();
                  await cubit.getAllProducts(isHome: true);
                },
                child: cubit.allProductsModel == null ||
                        cubit.catogriesModel == null
                    ? Center(
                        child: CustomLoadingIndicator(color: AppColors.primary))
                    : cubit.searchController.text.isEmpty
                        ? SingleChildScrollView(
                            physics:
                                const AlwaysScrollableScrollPhysics(), // Ensures the RefreshIndicator works even if the list is not scrollable
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6),
                              child: Column(
                                children: [
                                  const CustomSearchWidget(),
                                  SizedBox(height: 10.h),
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        if (context
                                            .read<HomeCubit>()
                                            .ispriceListManager) ...[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0.sp),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<int>(
                                                  value: cubit
                                                      .selectedPriceList, // This will store the ID (not the name)
                                                  hint: Text(
                                                   "price_list".tr(),
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.grey),
                                                  isExpanded: true,

                                                  onChanged: (int? newValue) {
                                                    if (context
                                                        .read<HomeCubit>()
                                                        .ispriceListManager) {
                                                      cubit.changePriceList(
                                                          newValue!);
                                                      context
                                                          .read<
                                                              DirectSellCubit>()
                                                          .getAllProducts(
                                                              isHome:
                                                                  true); // Store the ID in cubit
                                                    }
                                                  },
                                                  items: cubit
                                                          .getAllPriceListtsModel
                                                          ?.pricelists
                                                          ?.map<
                                                                  DropdownMenuItem<
                                                                      int>>(
                                                              (resultItem) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: resultItem
                                                              .pricelistId,
                                                          child: Text(
                                                            resultItem
                                                                    .pricelistName ??
                                                                '',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    16.sp),
                                                          ), // Display the name
                                                        );
                                                      }).toList() ??
                                                      [],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10)
                                        ] else if (cubit.selectedPriceList !=
                                            null) ...[
                                          Expanded(
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.0.sp),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      cubit.getAllPriceListtsModel
                                                              ?.pricelists
                                                              ?.firstWhere((element) =>
                                                                  element
                                                                      .pricelistId ==
                                                                  cubit
                                                                      .selectedPriceList)
                                                              .pricelistName ??
                                                          '',
                                                      style: TextStyle(
                                                          fontSize: 16.sp),
                                                    ),
                                                  ))),
                                          SizedBox(width: 10),
                                        ],
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0.sp),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: cubit
                                                    .selectedProducsStockType, // This will store the ID (not the name)
                                                hint: Text(
                                                  "select_warehouse".tr(),
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.grey),
                                                isExpanded: true,
                                                onChanged: (String? newValue) {
                                                  cubit.changeProductsStockType(
                                                      newValue!); // Store the ID in cubit
                                                  context
                                                      .read<DirectSellCubit>()
                                                      .getAllProducts(
                                                          isHome: true);
                                                },
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value: 'stock',
                                                    child: Text(
                                                     "warehouse".tr(),
                                                      style: TextStyle(
                                                          fontSize: 16.sp),
                                                    ),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: 'nonStock',
                                                    child: Text(
                                                      'all'.tr(),
                                                      style: TextStyle(
                                                          fontSize: 16.sp),
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
                                 
                                  state == LoadingCatogries
                                      ? Center(
                                          child: CustomLoadingIndicator(
                                              color: AppColors.primary))
                                      : CustomCategorySection(
                                          result:
                                              cubit.catogriesModel?.result ??
                                                  [],
                                        ),
                                  SizedBox(height: 25.h),
                                  cubit.homeProductsModel.result == null
                                      ? const Center(
                                          child: CustomLoadingIndicator())
                                      : CustomProductSection(
                                          isSearch: false,
                                          result: cubit.homeProductsModel
                                                  .result!.products ??
                                              []),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const CustomSearchWidget(),
                                  SizedBox(height: 25.h),
                                  CustomProductSection(
                                      isSearch: true,
                                      result: cubit.searchedProductsModel!
                                              .result!.products ??
                                          []),
                                ],
                              ),
                            ),
                          ),
              ),
      );
    });
  }
}
