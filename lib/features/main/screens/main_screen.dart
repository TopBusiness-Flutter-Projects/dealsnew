import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/details_order/screens/widgets/rounded_button.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';
import 'package:top_sale/features/login/widget/textfield_with_text.dart';
import 'package:top_sale/features/main/cubit/main_states.dart';
import 'package:top_sale/features/main/widget/menu_screen_widget.dart';
import '../../../core/utils/app_colors.dart';
import '../cubit/main_cubit.dart';

ZoomDrawerController z = ZoomDrawerController();
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainCubit cubit = context.read<MainCubit>();
    HomeCubit cubitHome = context.read<HomeCubit>();
    Future<void> showExitDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("are_you_sure".tr()),
            content: Text("app_will_close".tr()),
            actions: <Widget>[
              TextButton(
                child: Text("cancel".tr()),
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
              ),
              TextButton(
                child: Text("exit".tr()),
                onPressed: () {
                  Navigator.of(context).pop(); 
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await showExitDialog(context);
        return false;
      },
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            BlocBuilder<MainCubit, MainStates>(builder: (context, state) {
              return Scaffold(
                  key: _scaffoldKey,
                  resizeToAvoidBottomInset: true,
                  extendBody: true,
                  body: WillPopScope(
                    onWillPop: () async {
                      if (cubit.currentIndex != 0) {
                        setState(() {
                          cubit.currentIndex = 0;
                        });
                        return false;
                      } else {
                        SystemNavigator.pop();
                        return true;
                      }
                    },
                    child: cubit.navigationBarViews[cubit.currentIndex],
                  ),
                  //  textDirection: TextDirection.ltr,
                  bottomNavigationBar: Material(
                    elevation: 50,
                    shadowColor: Colors.grey,
                    child: SalomonBottomBar(
                      items: [
                        /// Home
                        SalomonBottomBarItem(
                          icon: Image.asset(
                            'assets/images/home1.png',
                            width: getSize(context) / 22,
                            color: cubit.currentIndex == 0
                                ? AppColors.primaryColor
                                : Colors.black,
                          ),
                          title: Text('home'.tr()),
                          selectedColor: AppColors.primaryColor,
                        ),

                        /// Likes
                        SalomonBottomBarItem(
                          icon: Image.asset(
                            'assets/images/basket1.png',
                            width: getSize(context) / 22,
                            color: cubit.currentIndex == 1
                                ? AppColors.primaryColor
                                : Colors.black,
                          ),
                          title: Text('basket'.tr()),
                          selectedColor: AppColors.primaryColor,
                        ),

                        /// Search
                        SalomonBottomBarItem(
                          icon: Image.asset(
                            'assets/images/hr1.png',
                            width: getSize(context) / 22,
                            color: cubit.currentIndex == 2
                                ? AppColors.primaryColor
                                : Colors.black,
                          ),
                          title: Text('hr'.tr()),
                          selectedColor: AppColors.primaryColor,
                        ),

                        /// Profile
                        SalomonBottomBarItem(
                          icon: Image.asset(
                            'assets/images/menu1.png',
                            width: getSize(context) / 22,
                            color: cubit.currentIndex == 3
                                ? AppColors.primaryColor
                                : Colors.black,
                          ),
                          title: Text('menu'.tr()),
                          selectedColor: AppColors.primaryColor,
                        ),
                      ],
                      backgroundColor: Colors.white70,
                      currentIndex: cubit.currentIndex,
                      onTap: (index) {
                        setState(() {
                          if (index == 3) {
                            z.toggle!.call();
                          } else if (index == 2) {
                            context.read<HomeCubit>().isEmployeeAdded
                                ? cubit.changeNavigationBar(2)
                                : showEmployeeBottomSheet(
                                    context, cubitHome, true);
                          } else {
                            cubit.changeNavigationBar(index);
                          }
                        });
                      },
                    ),
                  ));
            }),
          ],
        ),
      ),
    );
  }
}

void showEmployeeBottomSheet(BuildContext context, HomeCubit cubit, bool isHr) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: getSize(context) / 20,
          right: getSize(context) / 20,
          top: getSize(context) / 20,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + getSize(context) / 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: cubit.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFieldWithTitle(
                  // maxLines: 5,
                  title: "emplyee_number".tr(),
                  controller: cubit.reasonController,
                  hint: "emplyee_number".tr(),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: getSize(context) / 30,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: getSize(context) / 20,
                      right: getSize(context) / 20),
                  child: RoundedButton(
                    backgroundColor: AppColors.primaryColor,
                    text: 'add'.tr(),
                    onPressed: () {
                      cubit.checkEmployeeNumber(context,
                          isHR: isHr, employeeId: cubit.reasonController.text);
                    },
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

class ZoomDrawerScreen extends StatefulWidget {
  const ZoomDrawerScreen({super.key});

  @override
  _ZoomDrawerScreenState createState() => _ZoomDrawerScreenState();
}

class _ZoomDrawerScreenState extends State<ZoomDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: z,
      isRtl: false,
      borderRadius: 25,
      style: DrawerStyle.defaultStyle,
      openCurve: Curves.linearToEaseOut,
      slideWidth: MediaQuery.of(context).size.width * 0.80,
      duration: const Duration(milliseconds: 400),
      angle: 0.0,
      drawerShadowsBackgroundColor: AppColors.primary,
      shadowLayer1Color: AppColors.transparent,
      shadowLayer2Color: AppColors.black.withOpacity(0.1),
      showShadow: true,
      overlayBlur: 0,
      moveMenuScreen: false,
      mainScreenTapClose: true,
      menuScreenOverlayColor: AppColors.primary,
      menuBackgroundColor: AppColors.white,
      mainScreen: const MainScreen(),
      menuScreen: MenuScreenWidget(closeClick: () => z.close?.call()),
    );
  }
}
