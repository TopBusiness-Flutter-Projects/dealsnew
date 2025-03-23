import 'package:flutter/material.dart';
import 'package:top_sale/features/attendance_and_departure/screens/attendance_and_departure_details_screen.dart';
import 'package:top_sale/features/attendance_and_departure/screens/holidays_screen.dart';
import 'package:top_sale/features/attendance_and_departure/screens/holidays_type_screen.dart';
import 'package:top_sale/features/attendance_and_departure/screens/money.dart';
import 'package:top_sale/features/basket_screen/screen/dispensing_basket_screen.dart';
import 'package:top_sale/features/clients/cubit/clients_cubit.dart';
import 'package:top_sale/features/clients/screens/edit_account.dart';
import 'package:top_sale/features/contact_us/screens/contact_us_screen.dart';
import 'package:top_sale/features/create_receipt_coucher/screens/create_receipt_coucher_screen.dart';
import 'package:top_sale/features/details_order/screens/details_order_returned.dart';
import 'package:top_sale/features/details_order/screens/details_order_show_price_returned%20.dart';
import 'package:top_sale/features/direct_sell/cubit/direct_sell_cubit.dart';
import 'package:top_sale/features/direct_sell/screens/all_categories_screen.dart';
import 'package:top_sale/features/direct_sell/screens/direct_sell_screen.dart';
import 'package:top_sale/features/direct_sell/screens/products_screen.dart';
import 'package:top_sale/features/clients/screens/clients_screen.dart';
import 'package:top_sale/features/login/screens/system_info_screen.dart';
import 'package:top_sale/features/home_screen/screens/home_screen.dart';
import 'package:top_sale/features/main/screens/main_screen.dart';
import 'package:top_sale/features/notification_screen/screens/notification_screens.dart';
import 'package:top_sale/features/attendance_and_departure/screens/salaries_screen.dart';
import 'package:top_sale/features/returns/screens/returns_screen.dart';
import 'package:top_sale/features/splash/screens/splash_screen.dart';
import 'package:top_sale/features/tasks/screens/tasks_screen.dart';
import 'package:top_sale/features/update_profile/screens/update_profile_screen.dart';
import '../../core/models/all_partners_for_reports_model.dart';
import '../../core/models/get_orders_model.dart';
import '../../core/utils/app_strings.dart';
import 'package:page_transition/page_transition.dart';
import '../../features/Itinerary/screens/Itinerary.dart';
import '../../features/attendance_and_departure/screens/money_type_screen.dart';
import '../../features/basket_screen/screen/basket_screen.dart';
import '../../features/clients/screens/my_bills.dart';
import '../../features/clients/screens/profile_client.dart';
import '../../features/attendance_and_departure/screens/contract_screen.dart';
import '../../features/details_order/screens/details_order.dart';
import '../../features/details_order/screens/details_order_show_price.dart';
import '../../features/details_order/screens/widgets/payment.dart';
import '../../features/delevery_order/screens/delevery_order_screen.dart';
import '../../features/exchange_permission/screens/exchange_permission_screen.dart';
import '../../features/login/screens/login_screen.dart';
import '../../features/on_boarding/screen/onboarding_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/clients/screens/sales_screen.dart';
import '../../features/create_receipt_coucher/screens/receipt_voucher_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String mainRoute = '/main';
  static const String clientsRoute = '/clients';
  static const String homeRoute = '/home';
  static const String detailsOrder = '/orderDetails';
  static const String detailsOrderShowPrice = '/detailsOrderShowPrice';
  static const String detailsOrderReturns = '/orderDetailsReturns';
  static const String detailsOrderShowPriceReturns = '/detailsOrderShowPriceReturns';
  static const String paymentRoute = '/payment';
  static const String deleveryOrderRoute = '/deleveryOrderRoute';
  static const String onboardingPageScreenRoute = '/onboardingPageScreenRoute';
  static const String registerScreen = '/registerScreen';
  static const String directSellRoute = '/directSellRoute';
  static const String contactRoute = '/contactRoute';
  static const String categoriesRoute = '/categoriesRoute';
  static const String productsRoute = '/productsRoute';
  static const String updateProfileRoute = '/updateProfileRoute';
  static const String contactUsRoute = '/contactUsRoute';
  static const String notificationRoute = '/notificationRoute';
  static const String basketScreenRoute = '/basketScreen';
  static const String dispensingBasketScreenRoute = '/dispensingbasketScreen';
  static const String updateprofileRoute = '/updateprofile';
  static const String profileRoute = '/profileRoute';
  static const String profileClientRoute = '/profileClientRoute';
  static const String billsRoute = '/billsRoute';
  static const String salesRoute = '/salesRoute';
  static const String receiptVoucherRoute = '/receiptVoucherRoute';
  static const String attendanceAndDepartureRoute = '/attendanceAndDepartureRoute';
  static const String createReceiptVoucherRoute = '/createReceiptVoucherRoute';
  static const String salariesRoute = '/salariesRoute';
  static const String contractRoute = '/contractRoute';
  static const String attendanceAndDepartureDetailsRoute = '/attendanceAndDepartureDetailsRoute';
  static const String holidayRoute = '/holidayRoute';
  static const String holidayTypesRoute = '/holidayTypesRoute';
  static const String moneyRoute = '/moneyRoute';
  static const String moneyTypeRoute = '/moneyTypeRoute';
  static const String returnsRoute = '/returnsRoute';
  static const String itineraryRoute = '/itineraryRoute';
  static const String editProfileRoute = '/editProfileRoute';
  static const String tasksRoute = '/tasksRoute';
  static const String exchangePermissionRoute = '/exchangePermissionRoute';

}

class AppRoutes {
  static String route = '';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case Routes.loginRoute:
        return PageTransition(
          child: const LoginScreen(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 800),
        );
      case Routes.profileRoute:
        return PageTransition(
          child: ProfileScreen(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 800),
        );
      case Routes.updateprofileRoute:
        return PageTransition(
          child: const UpdateProfileScreen(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 800),
        );
      case Routes.contactRoute:
        return PageTransition(
          child: const ContactUsScreen(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 800),
        );
      case Routes.salesRoute:
        return PageTransition(
          child: const SalesScreen(),
          type: PageTransitionType.fade,
          alignment: Alignment.center,
          duration: const Duration(milliseconds: 800),
        );

      case Routes.deleveryOrderRoute:
        return MaterialPageRoute(
          builder: (context) => const DeleveryOrderScreen(),
        );
      case Routes.paymentRoute:
        bool isReturned = settings.arguments as bool;

        return MaterialPageRoute(
          builder: (context) =>  PaymentScreen(isReturn: isReturned,),
        );
      case Routes.detailsOrder:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final OrderModel orderModel = arguments['orderModel'] as OrderModel;
        final bool isClientOrder = arguments['isClientOrder'] as bool;
        // final OrderModel orderModel = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (context) => DetailsOrder(
              orderModel: orderModel, isClientOrder: isClientOrder),
        );
      case Routes.detailsOrderShowPrice:
        //  final OrderModel orderModel = settings.arguments as OrderModel;
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final OrderModel orderModel = arguments['orderModel'] as OrderModel;
        final bool isClientOrder = arguments['isClientOrder'] as bool;
        return MaterialPageRoute(
          builder: (context) => DetailsOrderShowPrice(
              orderModel: orderModel, isClientOrder: isClientOrder),
        );
      case Routes.detailsOrderReturns:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final OrderModel orderModel = arguments['orderModel'] as OrderModel;
        final bool isClientOrder = arguments['isClientOrder'] as bool;
        // final OrderModel orderModel = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (context) => DetailsOrderReturns(
              orderModel: orderModel, isClientOrder: isClientOrder),
        );
      case Routes.detailsOrderShowPriceReturns:
        //  final OrderModel orderModel = settings.arguments as OrderModel;
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final OrderModel orderModel = arguments['orderModel'] as OrderModel;
        final bool isClientOrder = arguments['isClientOrder'] as bool;
        return MaterialPageRoute(
          builder: (context) => DetailsOrderShowPriceReturns(
              orderModel: orderModel, isClientOrder: isClientOrder),
        );
      case Routes.onboardingPageScreenRoute:
        return MaterialPageRoute(
          builder: (context) => const OnBoardinScreen(),
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case Routes.mainRoute:
        return MaterialPageRoute(
          builder: (context) => const ZoomDrawerScreen(),
        );
      case Routes.clientsRoute:
        ClientsRouteEnum clientsRouteEnum =
            settings.arguments as ClientsRouteEnum;
        return MaterialPageRoute(
          builder: (context) =>
              ClientScreen(clientsRouteEnum: clientsRouteEnum),
        );
      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        );
      case Routes.directSellRoute:
        return MaterialPageRoute(
          builder: (context) => const DirectSellScreen(),
        );
      case Routes.productsRoute:
        List<String> categoryName = settings.arguments as List<String>;
        // if catId = -1 or 0 get all products
        // else get products by cat id
        // if catId = 0 the basket icon go to expenses screen , else go to client screen
        // categoryName  => AppBar title
        return MaterialPageRoute(
          builder: (context) => ProductsScreen(
            categoryName: categoryName[0],
            catId: categoryName[1],
          ),
        );
      case Routes.updateProfileRoute:
        return MaterialPageRoute(
            builder: (context) => const UpdateProfileScreen());
      case Routes.categoriesRoute:
        return MaterialPageRoute(
          builder: (context) => AllCategoriesScreen(),
        );
      case Routes.profileClientRoute:
        return MaterialPageRoute(
          builder: (context) => const ProfileClient(),
        );
      case Routes.billsRoute:
        return MaterialPageRoute(
          builder: (context) => const MyBillsScreen(),
        );
      case Routes.basketScreenRoute:
        // List<dynamic>data = [];
        AllPartnerResults? partner = settings.arguments as AllPartnerResults?;
        return MaterialPageRoute(
            builder: (context) => BasketScreen(
                  partner: partner,
                  currency: 'EGP',
                ));
      case Routes.dispensingBasketScreenRoute:
        return MaterialPageRoute(
            builder: (context) => DispensingBasketScreen(
                  // partner: partner,
                  // currency: 'EGP',
                ));
      case Routes.notificationRoute:
        return MaterialPageRoute(
          builder: (context) => NotificationScreens(),
        );
      case Routes.receiptVoucherRoute:
        return MaterialPageRoute(
          builder: (context) => const ReceiptVoucherScreen(),
        );  case Routes.holidayTypesRoute:
        return MaterialPageRoute(
          builder: (context) => const HolidaysTypeScreen(),
        );
        case Routes.itineraryRoute:
        return MaterialPageRoute(
          builder: (context) => const ItineraryScreen(),
        );
      case Routes.createReceiptVoucherRoute:
        int partnerId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => CreateReceiptCoucherScreen(
            partnerId: partnerId,
          ),
        );
      // case Routes.attendanceAndDepartureRoute:
      // AttendanceAndDepartureEnum attendanceAndDeparture = settings.arguments as AttendanceAndDepartureEnum;
      //   return MaterialPageRoute(
      //     builder: (context) =>  AttendanceAndDepartureScreen(
      //       attendanceAndDepartureEnum: attendanceAndDeparture,
      //     ),
      //   );
      case Routes.salariesRoute:
        return MaterialPageRoute(
          builder: (context) => const SalariesScreen(),
        );
      case Routes.contractRoute:
        return MaterialPageRoute(
          builder: (context) =>  const ContractScreen(),
        ); case Routes.tasksRoute:
        return MaterialPageRoute(
          builder: (context) =>  const TasksScreen(),
        );
        case Routes.exchangePermissionRoute:
        return MaterialPageRoute(
          builder: (context) =>  const ExchangePermissionScreen(),
        );    case Routes.attendanceAndDepartureDetailsRoute:
        return MaterialPageRoute(
          builder: (context) =>   const AttendanceAndDepartureDetailsScreen(),
        );  case Routes.holidayRoute:
        return MaterialPageRoute(
          builder: (context) =>   const HolidaysScreen(),
        );case Routes.moneyRoute:
        return MaterialPageRoute(
          builder: (context) =>   const MoneyScreen(),
        );case Routes.moneyTypeRoute:
        return MaterialPageRoute(
          builder: (context) =>   const MoneyTypeScreen(),
        );case Routes.returnsRoute:
        return MaterialPageRoute(
          builder: (context) =>   const ReturnsScreen(),
        );
        case Routes.editProfileRoute:
         int id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) =>    EditAccountScreen(
            id: id,
          ),
        );
      //
      // case Routes.resultOfLessonExam:
      //   ResponseOfApplyLessonExmamData model =
      //       settings.arguments as ResponseOfApplyLessonExmamData;
      //   return PageTransition(
      //     child: ResultExamLessonScreen(model: model),
      //     type: PageTransitionType.fade,
      //     alignment: Alignment.center,
      //     duration: const Duration(milliseconds: 800),
      //   );

      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
