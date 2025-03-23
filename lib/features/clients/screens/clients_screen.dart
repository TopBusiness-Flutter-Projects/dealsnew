import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_sale/core/utils/circle_progress.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:top_sale/core/utils/get_size.dart';
import 'package:top_sale/features/basket_screen/cubit/cubit.dart';
import 'package:top_sale/features/clients/cubit/clients_state.dart';
import 'package:top_sale/features/clients/screens/widgets/custom_card_client.dart';
import 'package:top_sale/features/contact_us/cubit/contact_us_cubit.dart';
import 'package:top_sale/features/home_screen/cubit/cubit.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/assets_manager.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../details_order/screens/widgets/rounded_button.dart';
import '../../login/widget/textfield_with_text.dart';
import '../cubit/clients_cubit.dart';

// ignore: must_be_immutable
class ClientScreen extends StatefulWidget {
  ClientScreen({required this.clientsRouteEnum, super.key});
  ClientsRouteEnum clientsRouteEnum;

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    // if (context.read<ClientsCubit>().allPartnersModel == null) {
    context.read<ClientsCubit>().getAllPartnersForReport(isUserOnly: true);
    context.read<ClientsCubit>().changeProductsStockType('stock');
    // }

    super.initState();
  }

  //
  late final ScrollController scrollController = ScrollController();

  _scrollListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      print('dddddddddbottom');
      if (context.read<ClientsCubit>().allPartnersModel!.next != null) {
        context.read<ClientsCubit>().getAllPartnersForReport(
            isGetMore: true,
            page: context.read<ClientsCubit>().allPartnersModel?.next ?? 1);
        debugPrint('new posts');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ClientsCubit>();
    return BlocBuilder<ClientsCubit, ClientsState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.white,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (cubit.currentLocation != null) {
                        cubit.clientNameController.clear();
                        cubit.phoneController.clear();
                        cubit.emailController.clear();
                        cubit.addressController.clear();
                        cubit.vatController.clear();
                        cubit.profileImage = null;

                        cubit.attachImage = null;
                        cubit.selectedBase64String = '';
                        cubit.selectedAttachBase64String = '';
                        _showBottomSheet(context, cubit);
                      } else {
                        cubit.checkAndRequestLocationPermission(context);
                      }
                    },
                    child: Container(
                      height: 30.sp,
                      width: 30.sp,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadiusDirectional.circular(90),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 20.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              backgroundColor: AppColors.white,
              centerTitle: false,
              //leadingWidth: 20,
              title: Text(
                'clients'.tr(),
                style: TextStyle(
                  fontFamily: AppStrings.fontFamily,
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  if (context.read<HomeCubit>().isAdmin)
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text('my_clients'.tr()),
                            leading: Radio<String>(
                              value: 'stock',
                              groupValue: cubit.selectedProducsStockType,
                              onChanged: (value) {
                                // setState(() {
                                cubit.changeProductsStockType(value!);
                                context
                                    .read<ClientsCubit>()
                                    .getAllPartnersForReport(isUserOnly: true);
                                // });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text('all'.tr()),
                            leading: Radio<String>(
                              value: 'nonStock',
                              groupValue: cubit.selectedProducsStockType,
                              onChanged: (value) {
                                // setState(() {
                                cubit.changeProductsStockType(value!);
                                context
                                    .read<ClientsCubit>()
                                    .getAllPartnersForReport(isUserOnly: false);

                                // });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  CustomTextField(
                    controller: cubit.searchController,
                    onChanged: cubit.onChangeSearch,
                    labelText: "search_client".tr(),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 35,
                      color: AppColors.gray2,
                    ),
                  ),
                  Flexible(
                    child: (state is LoadingGetPartnersState)
                        ? const Center(
                            child: CustomLoadingIndicator(),
                          )
                        : (cubit.allPartnersModel == null ||
                                cubit.allPartnersModel?.result == [])
                            ? Center(
                                child: Text('no_data'.tr()),
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  await cubit.getAllPartnersForReport();
                                },
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount:
                                      cubit.allPartnersModel!.result!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    //! we will padd partner data
                                    //! cubit.allPartnersModel!.result![index]
                                    return GestureDetector(
                                        onTap: () {
                                          if (widget.clientsRouteEnum ==
                                              ClientsRouteEnum.cart) {
                                            Navigator.pushNamed(context,
                                                Routes.basketScreenRoute,
                                                arguments: cubit
                                                    .allPartnersModel!
                                                    .result![index]);
                                          }
                                          if (widget.clientsRouteEnum ==
                                              ClientsRouteEnum.receiptVoucher) {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.createReceiptVoucherRoute,
                                              arguments: cubit.allPartnersModel!
                                                  .result![index].id,
                                            );
                                          }
                                          if (widget.clientsRouteEnum ==
                                              ClientsRouteEnum.details) {
                                            context
                                                .read<ClientsCubit>()
                                                .getPartenerDetails(
                                                    id: cubit
                                                            .allPartnersModel!
                                                            .result![index]
                                                            .id ??
                                                        1);
                                            Navigator.pushNamed(
                                              context,
                                              Routes.profileClientRoute,
                                            );
                                          }
                                          if (widget.clientsRouteEnum ==
                                              ClientsRouteEnum
                                                  .dispensingBasket) {
                                            setState(() {});
                                            context
                                                .read<BasketCubit>()
                                                .setPartner(cubit
                                                    .allPartnersModel!
                                                    .result![index]);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Dismissible(
                                          key: Key(cubit.allPartnersModel!
                                              .result![index].id
                                              .toString()),
                                          background: Container(
                                            color: AppColors
                                                .orangeThirdPrimary, // Background color when swiping
                                            child: Icon(
                                              Icons.phone,
                                              color: Colors.white,
                                              size: 36,
                                            ),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(right: 20),
                                          ),
                                          confirmDismiss: (direction) async {
                                            // Trigger the phone call action without dismissing the widget
                                            print(
                                                "Calling: ${cubit.allPartnersModel!.result![index].phone}");
                                            if (cubit.allPartnersModel!
                                                    .result![index].phone
                                                    .toString() !=
                                                'false') {
                                              context
                                                  .read<ContactUsCubit>()
                                                  .launchURL(
                                                      'tel:${cubit.allPartnersModel!.result![index].phone}');
                                            } else {
                                              errorGetBar( "wrong_number".tr());
                                            }
                                            return false;
                                          },
                                          child: CustomCardClient(
                                            partner: cubit.allPartnersModel!
                                                .result![index],
                                          ),
                                        ));
                                  },
                                ),
                              ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _showBottomSheet(BuildContext context, ClientsCubit cubit) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<ClientsCubit, ClientsState>(
          builder: (context, state) {
            return Padding(
              // Adjust bottom padding to avoid keyboard overlap
              padding: EdgeInsets.only(
                left: getSize(context) / 20,
                right: getSize(context) / 20,
                top: getSize(context) / 20,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    getSize(context) / 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.red,
                        size: 30.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: cubit.formKey,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: cubit.profileImage == null
                                    ? Image.asset(
                                        ImageAssets.user,
                                        height: 100.sp,
                                        width: 100.sp,
                                      )
                                    : Image.file(
                                        (File(cubit.profileImage!.path)),
                                        fit: BoxFit.cover,
                                        height: 100.h,
                                        width: 100.h,
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    cubit.showImageSourceDialog(context);
                                    // cubit.pickImage(ImageSource.gallery);
                                  },
                                  child: const Icon(
                                    Icons.camera_alt,
                                  ),
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: 10.h,
                          // ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text("company".tr()),
                                  leading: Radio<String>(
                                    value: 'Company',
                                    groupValue: cubit.selectedClientType,
                                    onChanged: (value) {
                                      setState(() {
                                        cubit.changeClientType(value);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text("individual".tr()),
                                  leading: Radio<String>(
                                    value: 'Indivalal',
                                    groupValue: cubit.selectedClientType,
                                    onChanged: (value) {
                                      setState(() {
                                        cubit.changeClientType(value);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: 10.h,
                          // ),
                          CustomTextFieldWithTitle(
                            title: "name".tr(),
                            controller: cubit.clientNameController,
                            hint: "enter_name".tr(),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "enter_name".tr();
                              }
                             
                              return null;
                            },
                          ),
                          // SizedBox(
                          //   height: 10.h,
                          // ),
                          CustomTextFieldWithTitle(
                            title: "phone".tr(),
                            controller: cubit.phoneController,
                            hint: "enter_phone".tr(),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "enter_phone".tr();
                              }
                             
                              return null;
                            },
                          ),
                          // SizedBox(
                          //   height: getSize(context) / 30,
                          // ),
                          CustomTextFieldWithTitle(
                            title: "email".tr(),
                            isRequired: false,
                            controller: cubit.emailController,
                            hint: "enter_email".tr(),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                               
                              }
                           
                              return null;
                            },
                          ),
                          // SizedBox(
                          //   height: getSize(context) / 30,
                          // ),

                          CustomTextFieldWithTitle(
                            title: "address".tr(),
                            controller: cubit.addressController,
                            isRequired: false,
                            hint: "enter_address".tr(),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                          // SizedBox(
                          //   height: 10.h,
                          // ),

                          cubit.selectedClientType == 'Company'
                              ? CustomTextFieldWithTitle(
                                  title:  "vat".tr(),
                                  controller: cubit.vatController,
                                  hint:  "vat".tr(),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "enter_vat".tr();
                                    }
                                    
                                    return null;
                                  },
                                )
                              : const SizedBox(),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "facilities".tr(),
                                style: TextStyle(
                                  fontFamily: AppStrings.fontFamily,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    cubit.showAttachImageSourceDialog(context);
                                  }, // Use the passed camera function
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: cubit.attachImage == null
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons.cloud_upload_outlined,
                                                    size: 40,
                                                    color: AppColors.primary),
                                                SizedBox(height: 5.sp),
                                                Text(
                                        "upload_pic_or_file".tr(),
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                              ],
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              // Display the image using Image.file
                                              File(cubit.attachImage!.path),
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Image.asset(
                                                    ImageAssets.pdfImage,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      cubit.removeAttachImage();
                                    },
                                    icon: CircleAvatar(
                                        backgroundColor: AppColors.primary,
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 30,
                                        )))
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getSize(context) / 20,
                        right: getSize(context) / 20),
                    child: RoundedButton(
                      backgroundColor: AppColors.primaryColor,
                      text: 'confirm'.tr(),
                      onPressed: () {
                        if (cubit.formKey.currentState!.validate()) {
                          print("Validated");
                          cubit.createClient(context);
                        } else {
                          // Handle validation failure
                          print("Validation failed");
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
