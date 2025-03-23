import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/attendance_and_departure/cubit/attendance_and_departure_cubit.dart';
import 'package:top_sale/features/clients/cubit/clients_state.dart';
import 'package:top_sale/features/direct_sell/cubit/direct_sell_cubit.dart';
import 'package:top_sale/features/home_screen/screens/widgets/appbar_home.dart';
import 'package:top_sale/features/home_screen/screens/widgets/card_home.dart';
import 'package:top_sale/features/main/screens/main_screen.dart';
import '../../../config/routes/app_routes.dart';
import '../../clients/cubit/clients_cubit.dart';
import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'daily_orders.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<DirectSellCubit>().getCategries();
    context.read<HomeCubit>(). getCurrencyName();
    context.read<DirectSellCubit>().getAllPricelists();
    context.read<AttendanceAndDepartureCubit>().getIp();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Padding(
              padding: EdgeInsets.only(
                  top: getSize(context) / 33,
                  left: getSize(context) / 33,
                  right: getSize(context) / 33),
              child: Column(
                children: [
                  const AppbarHome(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        SizedBox(height: 20.h),
                        GridView(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  crossAxisCount: 2),
                          shrinkWrap: true,
                          children: [
                            CardHome(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.deleveryOrderRoute);
                                },
                                text: "delevey_order".tr(),
                                image: ImageAssets.deleveryOrder),
                            CardHome(
                                onPressed: () {
                                  context
                                      .read<DirectSellCubit>()
                                      .changeProductsStockType("stock");
                                  Navigator.pushNamed(
                                      context, Routes.directSellRoute);
                                },
                                text: "direct_sales".tr(),
                                image: ImageAssets.directSale),
                            BlocBuilder<ClientsCubit, ClientsState>(
                                builder: (context, state) {
                              return CardHome(
                                  onPressed: () {
                                    if (context
                                        .read<HomeCubit>()
                                        .isEmployeeAdded) {
                                      if (context
                                              .read<ClientsCubit>()
                                              .currentLocation ==
                                          null) {
                                        context
                                            .read<ClientsCubit>()
                                            .checkAndRequestLocationPermission(
                                                context);
                                      } else {
                                        Navigator.pushNamed(
                                            context, Routes.itineraryRoute);
                                      }
                                    } else {
                                      showEmployeeBottomSheet(context,
                                          context.read<HomeCubit>(), false);
                                    }
                                  },
                                  text: "serali_line".tr(),
                                  image: ImageAssets.line);
                            }),
                            CardHome(
                                text: "clients".tr(),
                                image: ImageAssets.clients,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.clientsRoute,
                                      arguments: ClientsRouteEnum.details);
                                }),
                            CardHome(
                                text: "receipt_voucher".tr(),
                                image: ImageAssets.receiptVoucherIcon,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.receiptVoucherRoute,
                                      arguments: false);
                                }),
                            CardHome(
                                text: "returns".tr(),
                                image: ImageAssets.cartIcon,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.returnsRoute);
                                }),
                            CardHome(
                                text: "exchange_permission".tr(),
                                image: ImageAssets.sarfIcon,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.exchangePermissionRoute);
                                }),
                            // CardHome(
                            //     text: "planninig".tr(),
                            //     image: ImageAssets.dailyorders,
                            //     onPressed: () {
                            //       Navigator.push(context, MaterialPageRoute(
                            //         builder: (context) {
                            //           return const DailyOrders();
                            //         },
                            //       ));
                            //     }),
                          ],
                        ),
                        SizedBox(height: 30.h),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
