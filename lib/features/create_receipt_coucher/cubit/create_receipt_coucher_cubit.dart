import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_sale/core/api/end_points.dart';
import 'package:top_sale/core/models/all_payments_model.dart';
import 'package:top_sale/core/remote/service.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import 'package:top_sale/core/utils/appwidget.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:top_sale/features/details_order/screens/pdf.dart';
import '../../../core/models/all_journals_model.dart';
import '../../../core/models/defaul_model.dart';
import 'create_receipt_coucher_state.dart';

class CreateReceiptCoucherCubit extends Cubit<CreateReceiptCoucherState> {
  CreateReceiptCoucherCubit(this.api) : super(CreateReceiptCoucherInitial());
  ServiceApi api;
  DateTime selectedDate = DateTime.now();
  int? selectedPaymentMethod;
  TextEditingController amountController = TextEditingController();
  TextEditingController refController = TextEditingController();
  GetAllJournalsModel? getAllJournalsModel;
  void getAllJournals() async {
    emit(GetAllJournalsLoadingState());
    final result = await api.getAllJournals();
    result.fold(
      (failure) =>
          emit(GetAllJournalsErrorState('Error loading  data: $failure')),
      (r) {
        getAllJournalsModel = r;
        // if (r.result != null) {
        //   if (r.result!.isNotEmpty) {
        //     selectedPaymentMethod = r.result!.first.id;
        //   }
        // }

        emit(GetAllJournalsLoadedState());
      },
    );
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
                pickImage(context, true);
              },
              child: Text(
                'gallery'.tr(),
                style:
                    getRegularStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
            TextButton(
             onPressed: () async {pickImage(context, false);
               
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

  //photo transfer
  Future<String> fileToBase64String(String filePath) async {
    File file = File(filePath);
    Uint8List bytes = await file.readAsBytes();
    String base64String = base64Encode(bytes);
    return base64String;
  }

  void partnerPaymentMethod(BuildContext context,
      {required int partnerId}) async {
          AppWidget.createProgressDialog(context);

    emit(GetAllJournalsLoadingState());
    String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(selectedDate);
    final result = await api.partnerPayment(
      image: selectedBase64String,
 imagePath: profileImage == null ? "" : profileImage!.path.split('/').last,
      amount: amountController.text,
      journalId: selectedPaymentMethod!,
      ref: refController.text,
      date: formattedDate,
      // date: selectedDate.toString(),
      partnerId: partnerId,
    );
    result.fold((failure) {
      Navigator.pop(context);
      errorGetBar("error_register_payment".tr());
      emit(GetAllJournalsErrorState('Error loading  data: $failure'));
    }, (r) {
      Navigator.pop(context);
      if (r.result != null) {
        if (r.result!.message != null) {
          emit(GetAllJournalsLoadedState());
          successGetBar("do_create_receipt_coucher".tr());
          Navigator.pop(context);
          Navigator.pop(context);
          refController.clear();
          amountController.clear();
          selectedBase64String = "";
          profileImage = null;
          // selectedPaymentMethod = null;
          selectedDate = DateTime.now();
          if (r.result!.paymentId != null) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return PdfViewerPage(
                  baseUrl:
                      '${EndPoints.printPayment}${r.result!.paymentId.toString()}',
                );
                // return PaymentWebViewScreen(url: "",);
              },
            ));
          }

          getAllReceiptVoucher();
        } else {
          errorGetBar("error_register_payment".tr());
          emit(GetAllJournalsErrorState('Error loading  data: '));
        }
      } else {
        errorGetBar("error_register_payment".tr());
        emit(GetAllJournalsErrorState('Error loading  data: '));
      }
    });
  }

  TextEditingController searchController = TextEditingController();
  AllPaymentsModel allPaymentsModel = AllPaymentsModel();
  getAllReceiptVoucher({String? searchKey}) async {
    emit(GetPaymentsLoading());
    final result = await api.getAllPayments(searchKey);
    result.fold(
      (failure) => emit(GetPaymentsError()),
      (r) {
        allPaymentsModel = r;
        emit(GetPaymentsLoaded());
      },
    );
  }
}
