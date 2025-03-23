// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:top_sale/core/preferences/preferences.dart';
import 'package:top_sale/features/Itinerary/cubit/cubit.dart';
import 'package:top_sale/features/clients/cubit/clients_cubit.dart';
import 'package:top_sale/features/delevery_order/cubit/delevery_orders_cubit.dart';
import 'package:top_sale/features/login/cubit/cubit.dart';
import 'package:top_sale/features/tasks/cubit/tasks_cubit.dart';
import '../../../core/utils/assets_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../core/utils/get_size.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Timer _timer;

  _goNext() {
    _getStoreUser2();
    // _getStoreUser();
  }

  _startDelay() async {
    // Check for internet connection
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    print(connectivityResult.toString());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        isConnected = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('No internet connection. Please check your connection.'),
        ),
      );
      return; // Exit the method
    } else {
      _timer = Timer(
        const Duration(seconds: 3, milliseconds: 500),
        () {
          _goNext();
        },
      );
    }
  }

  // Future<void> _getStoreUser2() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getBool('onBoarding') == true) {
  //     if (await Preferences.instance.getDataBaseName() == null ||
  //         await Preferences.instance.getOdooUrl() == null) {
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         Routes.registerScreen,
  //         (route) => false,
  //       );
  //     } else {
  //       if (await Preferences.instance.getEmployeeId() == null &&
  //           await Preferences.instance.getUserName() == null) {
  //         Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           Routes.loginRoute,
  //           (route) => false,
  //         );
  //       } else {
  //         if (await Preferences.instance.getMasterUserName() == null ||
  //             await Preferences.instance.getMasterUserPass() == null) {
  //           if (await Preferences.instance.getUserName() == null ||
  //               await Preferences.instance.getUserPass() == null) {
  //             Navigator.pushNamedAndRemoveUntil(
  //               context,
  //               Routes.loginRoute,
  //               (route) => false,
  //             );
  //           } else {
  //             String session = await context.read<LoginCubit>().setSessionId(
  //                 phoneOrMail: await Preferences.instance.getUserName() ?? '',
  //                 password: await Preferences.instance.getUserPass() ?? '',
  //                 baseUrl: await Preferences.instance.getOdooUrl() ?? '',
  //                 database: await Preferences.instance.getDataBaseName() ?? '');
  //             if (session != "error") {
  //               Navigator.pushReplacementNamed(context, Routes.mainRoute);
  //             } else {
  //               Navigator.pushReplacementNamed(context, Routes.loginRoute);
  //             }
  //           }
  //         } else {
  //           if (await Preferences.instance.getEmployeeId() != null) {
  //             String session = await context.read<LoginCubit>().setSessionId(
  //                 phoneOrMail:
  //                     await Preferences.instance.getMasterUserName() ?? '',
  //                 password:
  //                     await Preferences.instance.getMasterUserPass() ?? '',
  //                 baseUrl: await Preferences.instance.getOdooUrl() ?? '',
  //                 database: await Preferences.instance.getDataBaseName() ?? '');
  //             if (session != "error") {
  //               Navigator.pushReplacementNamed(context, Routes.mainRoute);
  //             } else {
  //               Navigator.pushReplacementNamed(context, Routes.loginRoute);
  //             }
  //           } else if (await Preferences.instance.getUserName() == null ||
  //               await Preferences.instance.getUserPass() == null) {
  //             Navigator.pushNamedAndRemoveUntil(
  //               context,
  //               Routes.loginRoute,
  //               (route) => false,
  //             );
  //           } else {
  //             String session = await context.read<LoginCubit>().setSessionId(
  //                 phoneOrMail: await Preferences.instance.getUserName() ?? '',
  //                 password: await Preferences.instance.getUserPass() ?? '',
  //                 baseUrl: await Preferences.instance.getOdooUrl() ?? '',
  //                 database: await Preferences.instance.getDataBaseName() ?? '');
  //             if (session != "error") {
  //               Navigator.pushReplacementNamed(context, Routes.mainRoute);
  //             } else {
  //               Navigator.pushReplacementNamed(context, Routes.loginRoute);
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } else {
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       Routes.onboardingPageScreenRoute,
  //       (route) => false,
  //     );
  //   }
  // }
  bool isConnected = true;
  Future<void> _getStoreUser2() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('onBoarding') == true) {
        if (await Preferences.instance.getDataBaseName() == null ||
            await Preferences.instance.getOdooUrl() == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.registerScreen,
            (route) => false,
          );
        } else {
          if (await Preferences.instance.getEmployeeId() == null &&
              await Preferences.instance.getUserName() == null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginRoute,
              (route) => false,
            );
          } else {
            if (await Preferences.instance.getMasterUserName() == null ||
                await Preferences.instance.getMasterUserPass() == null) {
              if (await Preferences.instance.getUserName() == null ||
                  await Preferences.instance.getUserPass() == null) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginRoute,
                  (route) => false,
                );
              } else {
                String session = await context.read<LoginCubit>().setSessionId(
                    phoneOrMail: await Preferences.instance.getUserName() ?? '',
                    password: await Preferences.instance.getUserPass() ?? '',
                    baseUrl: await Preferences.instance.getOdooUrl() ?? '',
                    database:
                        await Preferences.instance.getDataBaseName() ?? '');
                if (session != "error") {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.mainRoute , (route) => false);
                  context.read<DeleveryOrdersCubit>().getDraftOrders();
                  context.read<TasksCubit>().changeIndex("01_in_progress");
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.loginRoute , (route) => false);
                }
              }
            } else {
              if (await Preferences.instance.getEmployeeId() != null) {
                String session = await context.read<LoginCubit>().setSessionId(
                    phoneOrMail:
                        await Preferences.instance.getMasterUserName() ?? '',
                    password:
                        await Preferences.instance.getMasterUserPass() ?? '',
                    baseUrl: await Preferences.instance.getOdooUrl() ?? '',
                    database:
                        await Preferences.instance.getDataBaseName() ?? '');
                if (session != "error") {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.mainRoute , (route) => false);
                  
                  context.read<LoginCubit>().auth(
                    phoneOrMail:
                        await Preferences.instance.getMasterUserName() ?? '',
                    password:
                        await Preferences.instance.getMasterUserPass() ?? '',
                    baseUrl: await Preferences.instance.getOdooUrl() ?? '',
                    database:
                        await Preferences.instance.getDataBaseName() ?? '');
                  context.read<DeleveryOrdersCubit>().getDraftOrders();
                  context.read<TasksCubit>().changeIndex("01_in_progress");
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.loginRoute , (route) => false);
                }
              } else if (await Preferences.instance.getUserName() == null ||
                  await Preferences.instance.getUserPass() == null) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginRoute,
                  (route) => false,
                );
              } else {
                String session = await context.read<LoginCubit>().setSessionId(
                    phoneOrMail: await Preferences.instance.getUserName() ?? '',
                    password: await Preferences.instance.getUserPass() ?? '',
                    baseUrl: await Preferences.instance.getOdooUrl() ?? '',
                    database:
                        await Preferences.instance.getDataBaseName() ?? '');
                if (session != "error") {
                                    Navigator.pushNamedAndRemoveUntil(context, Routes.mainRoute , (route) => false);

                  context.read<LoginCubit>().auth(
                      phoneOrMail:
                          await Preferences.instance.getUserName() ?? '',
                      password: await Preferences.instance.getUserPass() ?? '',
                      baseUrl: await Preferences.instance.getOdooUrl() ?? '',
                      database:
                          await Preferences.instance.getDataBaseName() ?? '');

                  context.read<DeleveryOrdersCubit>().getDraftOrders();
                  context.read<TasksCubit>().changeIndex("01_in_progress");
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.loginRoute , (route) => false);
                }
              }
            }
          }
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.onboardingPageScreenRoute,
          (route) => false,
        );
      }
    } catch (e) {
      // Log the error for debugging
      print("Error: $e");

      // Navigate to registerScreen if an exception occurs
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.registerScreen,
        (route) => false,
      );
    }
  }

  // Future<void> _getStoreUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getBool('onBoarding') == true) {
  //     if (await Preferences.instance.getDataBaseName() == null ||
  //         await Preferences.instance.getOdooUrl() == null) {
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         Routes.registerScreen,
  //         (route) => false,
  //       );
  //     } else {
  //       if (await Preferences.instance.getEmployeeId() == null) {
  //         Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           Routes.loginRoute,
  //           (route) => false,
  //         );
  //       } else {
  //         if (await Preferences.instance.getMasterUserName() == null ||
  //             await Preferences.instance.getMasterUserPass() == null) {
  //           if (await Preferences.instance.getUserName() == null ||
  //               await Preferences.instance.getUserPass() == null) {
  //             Navigator.pushNamedAndRemoveUntil(
  //               context,
  //               Routes.loginRoute,
  //               (route) => false,
  //             );
  //           } else {
  //             String session = await context.read<LoginCubit>().setSessionId(
  //                 phoneOrMail: await Preferences.instance.getUserName() ?? '',
  //                 password: await Preferences.instance.getUserPass() ?? '',
  //                 baseUrl: await Preferences.instance.getOdooUrl() ?? '',
  //                 database: await Preferences.instance.getDataBaseName() ?? '');
  //             if (session != "error") {
  //               Navigator.pushReplacementNamed(context, Routes.mainRoute);
  //                context.read<DeleveryOrdersCubit>().getDraftOrders();                   context.read<TasksCubit>().changeIndex("01_in_progress");

  //             } else {
  //               Navigator.pushReplacementNamed(context, Routes.loginRoute);
  //             }
  //           }
  //         } else {
  //           String session = await context.read<LoginCubit>().setSessionId(
  //               phoneOrMail:
  //                   await Preferences.instance.getMasterUserName() ?? '',
  //               password: await Preferences.instance.getMasterUserPass() ?? '',
  //               baseUrl: await Preferences.instance.getOdooUrl() ?? '',
  //               database: await Preferences.instance.getDataBaseName() ?? '');
  //           if (session != "error") {
  //             Navigator.pushReplacementNamed(context, Routes.mainRoute);
  //              context.read<DeleveryOrdersCubit>().getDraftOrders();                   context.read<TasksCubit>().changeIndex("01_in_progress");

  //           } else {
  //             Navigator.pushReplacementNamed(context, Routes.loginRoute);
  //           }
  //         }
  //       }
  //     }
  //   } else {
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       Routes.onboardingPageScreenRoute,
  //       (route) => false,
  //     );
  //   }
  // }

  // void navigateToHome() async {
  //   Future.delayed(
  //     const Duration(seconds: 3),
  //     () {
  //       String userName = '';
  //       String userPass = '';

  //       Preferences.instance.getIsFirstTime(key: 'onBoarding').then((value) {
  //         if (value != null && value == true) {
  //           Preferences.instance.getUserName().then((value) async {
  //             if (value != null) {
  //               userName = value;

  //               Preferences.instance.getUserPass().then((value) async {
  //                 if (value != null) {
  //                   userPass = value;
  //                   String session = await context
  //                       .read<LoginCubit>()
  //                       .setSessionId(
  //                           phoneOrMail: userName, password: userPass);
  //                   if (session != "error") {
  //                     Navigator.pushReplacementNamed(context, Routes.mainRoute);
  //                   } else {
  //                     Navigator.pushReplacementNamed(
  //                         context, Routes.loginRoute);
  //                   }
  //                 }
  //               }).catchError((error) {
  //                 debugPrint("ffffffffff" + error.toString());
  //               });
  //             } else {
  //               Navigator.pushReplacementNamed(context, Routes.loginRoute);
  //             }
  //           }).catchError((error) {
  //             debugPrint("ffffffffff" + error.toString());
  //           });

  //           print('not first time');
  //         } else {
  //           Navigator.pushReplacementNamed(context, Routes.onBoarding);
  //           print('first time');
  //         }
  //       }).catchError((error) {
  //         print(error.toString());
  //       });
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    context.read<ItineraryCubit>().getInitialTrackingState().then((value) =>
        context
            .read<ClientsCubit>()
            .checkAndRequestLocationPermission(context));

    _startDelay();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: 'logo',
              child: SizedBox(
                child: Image.asset(
                  ImageAssets.logoImage,
                  height: 200.h,
                  // width: getSize(context) / 1.2,
                ),
              ),
            ),
          ),
          if (isConnected == false)
            GestureDetector(
              onTap: () {
                _getStoreUser2();
              },
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Icon(
                    Icons.refresh_rounded,
                    color: AppColors.primaryHint,
                    size: 40.sp,
                  ),
                  Text(
                    "retry",
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: AppColors.primaryHint,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
      // bottomSheet: Container(
      //   color: AppColors.white,
      //   height: getSize(context) / 10,
      //   child: Image.asset(ImageAssets.topbusinessImage),
      // ),
    );
    //   },
    // );
  }
}
