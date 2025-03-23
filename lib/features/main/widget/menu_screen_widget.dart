import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_sale/core/preferences/preferences.dart';
import 'package:top_sale/core/utils/app_strings.dart';
import 'package:top_sale/core/utils/assets_manager.dart';
import 'package:top_sale/core/utils/restart_app_class.dart';
import 'package:top_sale/core/widgets/decode_image.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';
import 'package:top_sale/features/main/screens/main_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/get_size.dart';
import '../../home_screen/cubit/state.dart';
import 'list_tile_menu_widget.dart';

class MenuScreenWidget extends StatefulWidget {
  const MenuScreenWidget({super.key, required this.closeClick});

  final VoidCallback closeClick;

  @override
  State<MenuScreenWidget> createState() => _MenuScreenWidgetState();
}

class _MenuScreenWidgetState extends State<MenuScreenWidget> {
  @override
  Widget build(BuildContext context) {
    String lang = EasyLocalization.of(context)!.locale.languageCode;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomRight: lang == 'en' ? const Radius.circular(60) : Radius.zero,
        bottomLeft: lang == 'ar' ? const Radius.circular(60) : Radius.zero,
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.secondry,
            body: SafeArea(
              child:
                  BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(height: getSize(context) / 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: getSize(context) / 66),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CustomDecodedImage(
                            base64String: context.read<HomeCubit>().imageOfUser,
                            // context: context,
                            height: 60.h,
                            width: 60.h,
                          ),
                        ),
                        SizedBox(width: getSize(context) / 66),
                        Container(
                            alignment: lang == 'ar'
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            padding: EdgeInsets.only(
                              left: lang == 'ar' ? getSize(context) / 5 : 0,
                            ),
                            child: Text(
                              context.read<HomeCubit>().nameOfUser.toString() ??
                                  "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold),
                            )),
                        SizedBox(height: getSize(context) / 4),
                      ],
                    ),
                    MenuListTileWidget(
                      iconPath: ImageAssets.profileIcon,
                      onclick: () {
                        Navigator.pushNamed(context, Routes.profileRoute);
                      },
                      title: 'profile'.tr(),
                    ),
                    MenuListTileWidget(
                      iconPath: ImageAssets.editIcon,
                      onclick: () {
                        context.read<HomeCubit>().isEmployeeAdded
                            ? Navigator.pushNamed(context, Routes.tasksRoute)
                            : showEmployeeBottomSheet(
                                context, context.read<HomeCubit>(), false);
                      },
                      title: 'tasks'.tr(),
                    ),
                    MenuListTileWidget(
                      iconPath: ImageAssets.languageIcon,
                      onclick: () async {
                         if (EasyLocalization.of(context)!
                                              .locale
                                              .languageCode ==
                                          'ar') {
                                        EasyLocalization.of(context)!
                                            .setLocale(Locale('en', ''));
                                        Preferences.instance
                                            .savedLang(AppStrings.englishCode);
                                        Preferences.instance.getSavedLang();
                                        HotRestartController.performHotRestart(
                                            context);
                                      } else {
                                        EasyLocalization.of(context)!
                                            .setLocale(Locale('ar', ''));
                                        Preferences.instance
                                            .savedLang(AppStrings.arabicCode);
                                        Preferences.instance.getSavedLang();
                                        HotRestartController.performHotRestart(
                                            context);
                                      }
                      },
                      title: 'lang'.tr(),
                    ),
                    MenuListTileWidget(
                      iconPath: ImageAssets.shareIcon,
                      onclick: () async {
                        PackageInfo packageInfo =
                            await PackageInfo.fromPlatform();
                        String url = '';
                        String packageName = packageInfo.packageName;
                        if (Platform.isAndroid) {
                          url =
                              "https://play.google.com/store/apps/details?id=$packageName";
                        } else if (Platform.isIOS) {
                          url = 'https://apps.apple.com/us/app/$packageName';
                        }
                        await Share.share(url);
                      },
                      title: 'share_app'.tr(),
                    ),
                    MenuListTileWidget(
                      iconPath: ImageAssets.evaluate,
                      onclick: () async {
                        PackageInfo packageInfo =
                            await PackageInfo.fromPlatform();
                        String url = '';
                        String packageName = packageInfo.packageName;

                        if (Platform.isAndroid) {
                          url =
                              "https://play.google.com/store/apps/details?id=$packageName";
                        } else if (Platform.isIOS) {
                          url = 'https://apps.apple.com/us/app/$packageName';
                        }
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      title: 'evaluate_the_application'.tr(),
                    ),
                    MenuListTileWidget(
                      iconPath: ImageAssets.contactIcon,
                      onclick: () {
                        Navigator.pushNamed(context, Routes.contactRoute);
                      },
                      title: 'contact'.tr(),
                    ),
                    MenuListTileWidget(
                      iconPath: ImageAssets.editIcon,
                      onclick: () {
                        Navigator.pushNamed(context, Routes.updateprofileRoute);
                      },
                      title: 'edit'.tr(),
                    ),
                    MenuListTileWidget(
                      iconPath: ImageAssets.deleteIcon,
                      onclick: () {
                        context
                            .read<HomeCubit>()
                            .checkClearUserOrEmplyee(context, false);
                      },
                      title: 'delete'.tr(),
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return MenuListTileWidget(
                          iconPath: ImageAssets.logoutIcon,
                          onclick: () {
                            context
                                .read<HomeCubit>()
                                .checkClearUserOrEmplyee(context, true);
                          },
                          title: 'logout'.tr(),
                        );
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 7,
            right: lang == 'en' ? -40 : null,
            left: lang == 'ar' ? -40 : null,
            child: Container(
              width: getSize(context) / 2.8,
              height: getSize(context) / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(getSize(context) / 8),
                color: AppColors.white,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.closeClick,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: Container(
                          width: getSize(context) / 6.2,
                          height: getSize(context) / 6.2,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(getSize(context) / 6.2),
                            color: AppColors.primary,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back

                              // lang == 'ar'
                              //     ? Icons.arrow_back
                              //     : Icons.arrow_forward
                              ,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
