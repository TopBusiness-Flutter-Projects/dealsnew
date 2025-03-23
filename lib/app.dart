import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:top_sale/features/Itinerary/cubit/cubit.dart';
import 'package:top_sale/features/direct_sell/cubit/direct_sell_cubit.dart';
import 'package:top_sale/features/profile/cubit/profile_cubit.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';
import 'core/utils/app_strings.dart';
import 'package:top_sale/injector.dart' as injector;
import 'features/attendance_and_departure/cubit/attendance_and_departure_cubit.dart';
import 'features/contact_us/cubit/contact_us_cubit.dart';
import 'features/basket_screen/cubit/cubit.dart';
import 'features/clients/cubit/clients_cubit.dart';
import 'features/create_receipt_coucher/cubit/create_receipt_coucher_cubit.dart';
import 'features/delevery_order/cubit/delevery_orders_cubit.dart';
import 'features/details_order/cubit/details_orders_cubit.dart';
import 'features/exchange_permission/cubit/exchange_permission_cubit.dart';
import 'features/home_screen/cubit/cubit.dart';
import 'features/login/cubit/cubit.dart';
import 'features/main/cubit/main_cubit.dart';
import 'features/notification_screen/cubit/notification_cubit.dart';
import 'features/on_boarding/cubit/onboarding_cubit.dart';
import 'features/returns/cubit/returns_cubit.dart';
import 'features/splash/cubit/cubit.dart';
import 'features/update_profile/cubit/update_profile_cubit.dart';
import 'features/tasks/cubit/tasks_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(text);

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => injector.serviceLocator<SplashCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<LoginCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<HomeCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<OnboardingCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<DeleveryOrdersCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<MainCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<DirectSellCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<ContactUsCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<UpdateProfileCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<BasketCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<NotificationCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<ClientsCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<DetailsOrdersCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<ProfileCubit>(),
          ),
          BlocProvider(
            create: (_) =>
                injector.serviceLocator<AttendanceAndDepartureCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<CreateReceiptCoucherCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<ReturnsCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<ItineraryCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<ExchangePermissionCubit>(),
          ),
          BlocProvider(
            create: (_) => injector.serviceLocator<TasksCubit>(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(430, 932),
          minTextAdapt: true,
          splitScreenMode: true,
          child: GetMaterialApp(
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: appTheme(),
            themeMode: ThemeMode.light,
            darkTheme: ThemeData.light(useMaterial3: true),
            // standard dark theme
            localizationsDelegates: context.localizationDelegates,
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          ),
        ));
  }
}
