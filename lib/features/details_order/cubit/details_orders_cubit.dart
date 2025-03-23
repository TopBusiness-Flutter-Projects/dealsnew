import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_sale/config/routes/app_routes.dart';
import 'package:top_sale/core/models/get_shippind.dart';
import 'package:top_sale/core/models/return_model.dart';
import 'package:top_sale/core/models/rigister_payment_model.dart';
import 'package:top_sale/core/remote/service.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/appwidget.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:top_sale/features/clients/cubit/clients_cubit.dart';
import 'package:top_sale/features/delevery_order/cubit/delevery_orders_cubit.dart';
import 'package:top_sale/features/details_order/cubit/details_orders_state.dart';
import 'package:top_sale/features/direct_sell/cubit/direct_sell_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/all_journals_model.dart';
import '../../../core/models/create_order_model.dart';
import '../../../core/models/get_orders_model.dart';
import '../../../core/models/order_details_model.dart';

class DetailsOrdersCubit extends Cubit<DetailsOrdersState> {
  DetailsOrdersCubit(this.api) : super(DetailsOrdersInitial());
  ServiceApi api;
  OrderDetailsModel? getDetailsOrdersModel;
  OrderDetailsModel? getDetailsOrdersModelReturned;
  List list = [0, 1, 2, 3]; // 0 show price
  // new

  int page = 1;
  void changePage(int index) {
    page = index;
    emit(ChangePageState());
  }

  double? lat;
  double? lang;
  Future<void> getLatLong() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude;
      lang = position.longitude;
    } catch (e) {
      print(e);
    }
    emit(GetLatLongSuccess());
  }

  DateTime convertTimestampToDateTime(int timestamp) {
    if (timestamp.toString().length > 11) {
      var dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return dt;
    } else {
      var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return dt;
    }
  }

  void openGoogleMapsRoute(double originLat, double originLng,
      double destinationLat, double destinationLng) async {
    print('origin=$originLat,$originLng');

    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLng&destination=$destinationLat,$destinationLng';
    try {
      launchUrl(Uri.parse(url));
    } catch (e) {
      errorGetBar("error from map");
    }
  }

  TextEditingController moneyController = TextEditingController();
  Future<void> getDetailsOrders(
      {required int orderId, bool isReturned = false}) async {
    emit(GetDetailsOrdersLoadingState());
    final result = await api.getOrderDetails(orderId: orderId);
    result.fold(
      (failure) =>
          emit(GetDetailsOrdersErrorState('Error loading  data: $failure')),
      (r) {
        isReturned
            ? getDetailsOrdersModelReturned = r
            : getDetailsOrdersModel = r;

        if (r.payments!.isNotEmpty) page = 4;
        emit(GetDetailsOrdersLoadedState());
      },
    );
  }

  CreateOrderModel? createOrderModel;
  void confirmDelivery(BuildContext context,
      {required int pickingId, required int orderId}) async {
        AppWidget.createProgressDialog(context);

    emit(ConfirmDeliveryLoadingState());
    final result = await api.confirmDelivery(pickingId: pickingId);
    result.fold((failure) {
      Navigator.pop(context);
      emit(ConfirmDeliveryErrorState('Error loading  data: $failure'));
    }, (r) {
      Navigator.pop(context);
      if (r.result != null) {
        if (r.result!.message != null) {
          successGetBar(r.result!.message);
          emit(ConfirmDeliveryLoadedState());

          context.read<DeleveryOrdersCubit>().getOrders();
          context.read<DirectSellCubit>().getAllProducts(isHome: true);
          context.read<DirectSellCubit>().getAllProducts(isHome: false);
          getDetailsOrders(orderId: orderId);
        } else {
          emit(ConfirmDeliveryErrorState('Error loading  data: '));
          errorGetBar("error_confirm_delivery".tr());
        }
      } else {
        emit(ConfirmDeliveryErrorState('Error loading  data: '));

        errorGetBar("error_confirm_delivery".tr());
      }
    });
  }

  File? profileImage;
  String selectedBase64String = "";
  removeImage() {
    profileImage = null;
    emit(FileRemovedSuccessfully());
  }

  void showImageSourceDialog(
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'select_image'.tr(),
            style: getMediumStyle(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                pickFile(context, true);
              },
              child: Text(
                'gallery'.tr(),
                style:
                    getRegularStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () async {
                pickImage(context, false);
            
              },
              child: Text(
                "camera".tr(),
                style:
                    getRegularStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Future pickImage(BuildContext context, bool isGallery) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        maxWidth: 1024,
        maxHeight: 1024,
        source: isGallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      selectedBase64String = await fileToBase64String(pickedFile.path);
      emit(UpdateProfileImagePicked()); // Emit state for image picked
      Navigator.pop(context);
    } else {
      emit(UpdateProfileError());
    }
  }

  Future pickFile(BuildContext context, bool isGallery) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      selectedBase64String = await fileToBase64String(pickedFile.path);
      emit(UpdateProfileImagePicked()); // Emit state for image picked
      Navigator.pop(context);
    } else {
      emit(UpdateProfileError());
    }
  }

  //photo transfer
  Future<String> fileToBase64String(String filePath) async {
    File file = File(filePath);
    Uint8List bytes = await file.readAsBytes();
    String base64String = base64Encode(bytes);
    return base64String;
  }

  void registerPayment(BuildContext context,
      {required int journalId,
      required int invoiceId,
      required int orderId}) async {
    emit(RegisterPaymentLoadingState());
          AppWidget.createProgressDialog(context);

    final result = await api.registerPayment(
        image: selectedBase64String,
        imagePath:
            profileImage == null ? "" : profileImage!.path.split('/').last,
        invoiceId: invoiceId,
        journalId: journalId,
        amount: moneyController.text);
    result.fold(
      (failure) {
        Navigator.pop(context);
        Navigator.pop(context);
        errorGetBar("error_register_payment".tr());
        emit(RegisterPaymentErrorState('Error loading  data: $failure'));
      },
      (r) {
        Navigator.pop(context);
        Navigator.pop(context);
        if (r.result != null) {
          if (r.result!.message != null) {
            successGetBar(r.result!.message);
            emit(RegisterPaymentLoadedState());
            Navigator.pop(context);
            selectedBase64String = "";
            profileImage = null;
            getDetailsOrders(orderId: orderId);
            context.read<DeleveryOrdersCubit>().getOrders();
          } else {
            emit(RegisterPaymentErrorState('Error loading  data: '));

            errorGetBar("error_register_payment".tr());
          }
        } else {
          emit(RegisterPaymentErrorState('Error loading  data: '));

          errorGetBar("error_register_payment".tr());
        }

        moneyController.clear();
      },
    );
  }

  // RegisterPaymentModel? registerPaymentModel;
  void registerPaymentReturn(
    BuildContext context, {
    required int journalId,
  }) async {
    emit(RegisterPaymentLoadingState());
      AppWidget.createProgressDialog(context);

    final result = await api.registerPaymentReturn(
        image: selectedBase64String,
        imagePath:
            profileImage == null ? "" : profileImage!.path.split('/').last,
        invoiceId: returnOrderModel!.result!.creditNoteId,
        journalId: journalId,
        amount: moneyController.text);
    result.fold(
      (failure) {
        Navigator.pop(context);
        Navigator.pop(context);
        errorGetBar("error_register_payment".tr());
        emit(RegisterPaymentErrorState('Error loading  data: $failure'));
      },
      (r) {
        Navigator.pop(context);
        Navigator.pop(context);
        if (r.result != null) {
          if (r.result!.status != null) {
            selectedBase64String = "";
            profileImage = null;
            successGetBar(r.result!.status.toString());
            emit(RegisterPaymentLoadedState());
            Navigator.pushReplacementNamed(context, Routes.mainRoute);
            context.read<DeleveryOrdersCubit>().getOrders();
          } else {
            emit(RegisterPaymentErrorState('Error loading  data: '));

            errorGetBar("error_register_payment".tr());
          }
        } else {
          emit(RegisterPaymentErrorState('Error loading  data: '));

          errorGetBar("error_register_payment".tr());
        }

        moneyController.clear();
      },
    );
  }

  void createAndValidateInvoice(BuildContext context,
      {required int orderId}) async {
    emit(CreateAndValidateInvoiceLoadingState());
          AppWidget.createProgressDialog(context);


    final result = await api.createAndValidateInvoice(orderId: orderId);
    result.fold(
      (failure) {
        Navigator.pop(context);
        emit(CreateAndValidateInvoiceErrorState(
            'Error loading  data: $failure'));
      },
      (r) {
        Navigator.pop(context);

        if (r.result != null) {
          if (r.result!.message != null) {
            successGetBar(r.result!.message);
            emit(CreateAndValidateInvoiceLoadedState());
            context.read<DeleveryOrdersCubit>().getOrders();
            getDetailsOrders(orderId: orderId);
          } else {
            emit(CreateAndValidateInvoiceErrorState('Error loading  data: '));

            errorGetBar("error_from_create_and_validate_invoice".tr());
          }
        } else {
          emit(CreateAndValidateInvoiceErrorState('Error loading  data: '));

          errorGetBar("error_from_create_and_validate_invoice".tr());
        }
      },
    );
  }

  GetAllJournalsModel? getAllJournalsModel;
  void getAllJournals() async {
    emit(GetAllJournalsLoadingState());
    final result = await api.getAllJournals();
    result.fold(
      (failure) =>
          emit(GetAllJournalsErrorState('Error loading  data: $failure')),
      (r) {
        getAllJournalsModel = r;
        emit(GetAllJournalsLoadedState());
      },
    );
  }

  var listOfremovedItems = [];

  void removeItemFromOrderLine(int index) {
    // Check if getDetailsOrdersModel and its orderLines list are not null
    if (getDetailsOrdersModel != null &&
        getDetailsOrdersModel!.orderLines != null &&
        index >= 0 &&
        index < getDetailsOrdersModel!.orderLines!.length) {
      // Get the ID of the item to be removed
      var itemId = getDetailsOrdersModel!.orderLines![index].id;

      // Remove the item from orderLines
      getDetailsOrdersModel!.orderLines!.removeAt(index);

      // Add the ID to the list of removed items
      listOfremovedItems.add(itemId);

      print('Removed item ID: $itemId');
      print('List of removed items: $listOfremovedItems');

      // Emit the state after removal
      emit(RemoveItemFromOrderLineLoadedState());
    } else {
      // Handle invalid index case
      print('Error: Invalid index or null order lines.');
    }
  }

  onClickBack(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.deleveryOrderRoute, (route) => false);
    // Navigator.pushNamed(context, Routes.salesRoute);
    // Navigator.pop(context);
    listOfremovedItems.clear();
    emit(ClickBackState());
  }

  double totalBasket() {
    double total = 0.0;
    for (int i = 0; i < getDetailsOrdersModel!.orderLines!.length; i++) {
      total += (int.parse(
              getDetailsOrdersModel!.orderLines![i].productUomQty.toString()) *
          (double.parse(
              getDetailsOrdersModel!.orderLines![i].priceUnit.toString())));
    }

    getDetailsOrdersModel!.amountTotal = total;
    return total;
  }

  addAndRemoveToBasket({
    required bool isAdd,
    required OrderLine product,
    bool isReturned = false,
  }) {
    emit(LoadingTheQuantityCount());

  
    final int maxQuantityAllowed = isReturned
        ? product.oldQty
        : 9999;

    if (isAdd) {
    
      bool existsInBasket = getDetailsOrdersModel!.orderLines!
          .any((item) => item.id == product.id);
      final existingProduct = existsInBasket
          ? getDetailsOrdersModel!.orderLines!
              .firstWhere((item) => item.id == product.id)
          : null;

      if (existsInBasket && existingProduct != null) {
        if (existingProduct.productUomQty < maxQuantityAllowed) {
          existingProduct.productUomQty++;
          emit(IncreaseTheQuantityCount());
        } else {
          errorGetBar("cannot_add_more".tr());
        }
      } else {
        if (product.productUomQty < maxQuantityAllowed) {
          product.productUomQty++;
          getDetailsOrdersModel!.orderLines?.add(product);
          emit(IncreaseTheQuantityCount());
        } else {
          errorGetBar("cannot_add_more".tr());
        }
      }
    } else {
      bool existsInBasket = getDetailsOrdersModel!.orderLines!
          .any((item) => item.id == product.id);
      if (existsInBasket) {
        final existingProduct = getDetailsOrdersModel!.orderLines!
            .firstWhere((item) => item.id == product.id);
        if (existingProduct.productUomQty > 1) {
          existingProduct.productUomQty--;
          emit(DecreaseTheQuantityCount());
        } else {
          getDetailsOrdersModel!.orderLines
              ?.removeWhere((item) => item.id == product.id);
          listOfremovedItems.add(product.id);
          emit(DecreaseTheQuantityCount());
        }
      }
    }

    totalBasket();
  }

  // List<OrderLine> basket = [];
  CreateOrderModel? updateOrderModel;
  updateQuotation({
    required int partnerId,
    required BuildContext context,
    required OrderModel orderModel,
  }) async {
    emit(LoadingUpdateQuotation());
    final result = await api.updateQuotation(
        partnerId: partnerId,
        saleOrderId: getDetailsOrdersModel!.id.toString(),
        products: getDetailsOrdersModel!.orderLines ?? [],
        lat: context.read<ClientsCubit>().currentLocation?.latitude ?? 0.0,
        long: context.read<ClientsCubit>().currentLocation?.longitude ?? 0.0,
        address: context.read<ClientsCubit>().address,
        listOfremovedItems: listOfremovedItems);
    result.fold((l) {
      emit(ErrorUpdateQuotation());
    }, (r) {
      listOfremovedItems.clear();

      updateOrderModel = r;
      // successGetBar('Success Update Quotation');
      debugPrint("Success Update Quotation");
      //! Nav to
      confirmQuotation(
        orderId: getDetailsOrdersModel!.id!,
        context: context,
        lat: context.read<ClientsCubit>().currentLocation?.latitude ?? 0.0,
        long: context.read<ClientsCubit>().currentLocation?.longitude ?? 0.0,
        address: context.read<ClientsCubit>().address,
        orderModel: OrderModel(
            amountTotal: orderModel.amountTotal,
            deliveryStatus: 'pending',
            displayName: orderModel.displayName,
            employeeId: orderModel.employeeId,
            id: orderModel.id,
            invoiceStatus: 'to invoice',
            partnerId: orderModel.partnerId,
            state: 'sale',
            userId: orderModel.userId,
            writeDate: orderModel.writeDate),
      );
      emit(LoadedUpdateQuotation());
    });
  }

  ReturnOrderModel? returnOrderModel;
  returnOrder({
    required int pickingId,
    required BuildContext context,
    required OrderModel orderModel,
  }) async {
    emit(LoadingUpdateQuotation());
    final result = await api.returnOrder(
      pickingId: pickingId,
      products: getDetailsOrdersModel!.orderLines ?? [],
    );
    result.fold((l) {
      emit(ErrorUpdateQuotation());
    }, (r) {
      //   listOfremovedItems.clear();
      if (r.result != null) {
        if (r.result!.message != null) {
          updateDelivery(context);
          returnOrderModel = r;
          successGetBar(r.result!.message.toString());
          Navigator.pushReplacementNamed(context, Routes.detailsOrderReturns,
              arguments: {'isClientOrder': false, 'orderModel': orderModel});
        } else {
          errorGetBar((r.result!.error ?? "error".tr()));
        }
      }else{
        errorGetBar(( "error".tr()));
      }
      //  updateOrderModel = r;
      // successGetBar('Success Update Quotation');
      debugPrint("Success Update Quotation");

      emit(LoadedUpdateQuotation());
    });
  }

  void updateDelivery(BuildContext context) async {
    emit(LoadingUpdateDleiery());
    final result = await api.updateDelivery(
      orderId: getDetailsOrdersModel!.id!,
    );
    result.fold((l) {
      emit(FailureUpdateDleiery());
    }, (r) {
      print(r.result.toString());

      emit(SuccessUpdateDleiery());
    }
        //!}
        );
  }

  confirmQuotation({
    required int orderId,
    required OrderModel orderModel,
    required BuildContext context,
    required double lat,
    required double long,
    required String address,
  }) async {
    emit(LoadingConfirmQuotation());
    final result = await api.confirmQuotation(
        lat: lat, long: long, address: address, orderId: orderId);
    result.fold((l) {
      emit(ErrorConfirmQuotation());
    }, (r) {
      if (r.result?.message == null) {
          errorGetBar(r.result?.error ?? "socket_limit".tr());       
      } else {
        getDetailsOrdersModel!.orderLines?.clear();
        context.read<DeleveryOrdersCubit>().getOrders();
        //! Make confirm quotation
        Navigator.pushReplacementNamed(context, Routes.detailsOrder,
            arguments: {'isClientOrder': false, 'orderModel': orderModel});
      }

      emit(LoadedConfirmQuotation());
    });
  }

//profileImage!.path.split('/').last
  cancelOrder(
      {required int orderId,
      required OrderModel orderModel,
      required BuildContext context,
      String? note}) async {
      AppWidget.createProgressDialog(context);

    emit(LoadingCancel());
    final result = await api.cancelOrder(
        imagePath:
            profileImage == null ? "" : profileImage!.path.split('/').last,
        orderId: orderId,
        note: note,
        lat: context.read<ClientsCubit>().currentLocation?.latitude ?? 0.0,
        long: context.read<ClientsCubit>().currentLocation?.longitude ?? 0.0,
        address: context.read<ClientsCubit>().address,
        image: selectedBase64String);
    result.fold((l) {
      Navigator.pop(context);
      emit(ErrorCancel());
    }, (r) {
      Navigator.pop(context);
      Navigator.pop(context);
      if (r.result!.message!.contains("successfully")) {
        Navigator.pop(context);
        context.read<DeleveryOrdersCubit>().getOrders();
        //! Make confirm quotation
        successGetBar(r.result!.message!);
        profileImage = null;
        selectedBase64String = '';
        Navigator.pop(context);
        emit(LoadedCancel());
      } else {
        errorGetBar(r.result!.message!);
        emit(ErrorCancel());
      }
    });
  }

  TextEditingController newPriceController = TextEditingController();
  onChnagePriceOfUnit(OrderLine item, BuildContext context) {
    item.priceUnit = double.parse(newPriceController.text.toString());
    Navigator.pop(context);
    newPriceController.clear();
    totalBasket();
    emit(OnChangeUnitPriceOfItem());
  }

  TextEditingController newQtyController = TextEditingController();

  onChnageProductQuantity(OrderLine item, BuildContext context) {
    item.productUomQty = int.parse(newQtyController.text.toString());
    Navigator.pop(context);
    newQtyController.clear();
    totalBasket();
    emit(OnChangeUnitPriceOfItem());
  }

  TextEditingController newDiscountController = TextEditingController();

  onChnageDiscountOfUnit(OrderLine item, BuildContext context) {
    item.discount = double.parse(newDiscountController.text.toString());
    Navigator.pop(context);
      totalBasket();
  newDiscountController.clear();
    emit(OnChangeUnitPriceOfItem());
  }

  TextEditingController newAllDiscountController = TextEditingController();

  onChnageAllDiscountOfUnit(BuildContext context) {
    for (int i = 0; i < getDetailsOrdersModel!.orderLines!.length; i++) {
      getDetailsOrdersModel!.orderLines![i].discount =
          double.parse(newAllDiscountController.text.toString());
    }
    Navigator.pop(context);
       totalBasket();
 newAllDiscountController.clear();
    emit(OnChangeAllUnitPriceOfItem());
  }
}
