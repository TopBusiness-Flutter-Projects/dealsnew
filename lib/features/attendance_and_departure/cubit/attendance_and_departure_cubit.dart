// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_sale/core/models/all_journals_model.dart';
import 'package:top_sale/core/models/get__my_expense_model.dart';
import 'package:top_sale/core/models/get_all_expenses_product_model.dart';
import 'package:top_sale/core/models/get_last_attendance_model.dart';
import 'package:top_sale/core/remote/service.dart';
import '../../../core/models/add_time_off.dart';
import 'package:top_sale/core/utils/app_colors.dart';
import 'package:top_sale/core/utils/app_fonts.dart';
import '../../../core/models/all_salary_model.dart';
import '../../../core/models/get_all_attendance_model.dart';
import 'package:top_sale/core/utils/appwidget.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import '../../../core/models/get_contract_model.dart';
import '../../../core/models/holidays_model.dart';
import '../../../core/models/holidays_type_model.dart';
import 'attendance_and_departure_state.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:intl/intl.dart';

enum AttendanceAndDepartureEnum {
  workContract,
  attendanceAndDeparture,
  monthlySalaries,
  availableHolidays
}

class AttendanceAndDepartureCubit extends Cubit<AttendanceAndDepartureState> {
  AttendanceAndDepartureCubit(this.api)
      : super(AttendanceAndDepartureInitial());
  ServiceApi api;
  TextEditingController searchController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GetContractModel? contractDetails;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? fromDate;
  String? toDate;
  getContract() async {
    emit(GetContractLoading());
    final result = await api.getContract();
    result.fold(
      (failure) => emit(GetContractError()),
      (r) {
        contractDetails = r;
        emit(GetContractLoaded());
      },
    );
  }

  void onSelectedDate(bool isStartDate, BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (selectedStartDate ?? DateTime.now())
          : (selectedEndDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(9999),
    );

    if (picked != null) {
      if (isStartDate) {
        if (selectedEndDate != null && picked.isAfter(selectedEndDate!)) {
          errorGetBar("start_end_date".tr());
          return;
        }
        selectedStartDate = picked;
      } else {
        if (selectedStartDate != null && picked.isBefore(selectedStartDate!)) {
          errorGetBar("start_end_date".tr());
          return;
        }
        selectedEndDate = picked;
      }
      updateDateStrings();
      emit(DateChangedState());
    }
  }

  void updateDateStrings() {
    fromDate = selectedStartDate != null
        ? DateFormat('yyyy-MM-dd', 'en').format(selectedStartDate!)
        : DateFormat('yyyy-MM-dd', 'en')
            .format(DateTime.now()); 

    toDate = selectedEndDate != null
        ? DateFormat('yyyy-MM-dd', 'en').format(selectedEndDate!)
        : DateFormat('yyyy-MM-dd', 'en')
            .format(DateTime.now()); 

    print('From date: $fromDate, To date: $toDate');
  }

  GetAllAttendanceModel getAllAttendanceModel = GetAllAttendanceModel();
  void getAllAttendance() async {
    emit(GetAllAttendanceLoadingState());
    final result = await api.getAllAttendance();
    result.fold(
      (failure) => emit(GetAllAttendanceErrorState()),
      (r) {
        if (r.attendances == null) {
        } else {
          getAllAttendanceModel = r;
        }

        emit(GetAllAttendanceLoadedState());
      },
    );
  }

  HolidaysModel holidaysModel = HolidaysModel();
  void getAllHolidays() async {
    emit(GetAllHolidaysLoadingState());
    final result = await api.getHolidays();
    result.fold(
      (failure) => emit(GetAllHolidaysErrorState()),
      (r) {
        holidaysModel = r;
        emit(GetAllHolidaysLoadedState());
      },
    );
  }

  final info = NetworkInfo();
  String wifiIPP = '';
  String convertToEnglishDigits(String input) {
    const Map<String, String> arabicToEnglishDigits = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };

    String output = input;
    arabicToEnglishDigits.forEach((arabic, english) {
      output = output.replaceAll(arabic, english);
    });

    return output;
  }

  // Your getIp method
  Future<void> getIp() async {
    String wifiIP = await info.getWifiIP() ?? "";
    wifiIPP = convertToEnglishDigits(wifiIP); // Convert to Western digits
    print("WIFIIP:  $wifiIPP");
    emit(GetWifiIPLoaded());
  }

  checkInOut(
    BuildContext context, {
    required bool isChechIn,
    required double lat,
    required double long,
    required String country,
    required String city,
  }) async {
    // getIp();
    AppWidget.createProgressDialog(context);
    emit(CheckInOutLoading());
    print("laat : $lat");
    print("long : $long");
    final result = await api.checkInOutt(
      city: city,
      country: country,
      ip: wifiIPP,
      lat: lat,
      long: long,
      isChechIn: isChechIn,
    );
    result.fold(
      (failure) {
        Navigator.pop(context);
        errorGetBar("error".tr());
        emit(CheckInOutError());
      },
      (r) {
        Navigator.pop(context);
        if (r.result != null) {
          if (r.result!.message != null) {
            if (getLastAttendanceModel!.lastAttendance != null){
              getLastAttendanceModel!.lastAttendance!.status =
                isChechIn ? "check-in" : "check-out";}
            
            successGetBar(r.result!.message!);
            getLastAttendance();
          } else {
            // if (r.result!.error != null) {
            //   errorGetBar(r.result!.error!.message ?? "error".tr());
            // } else {
              errorGetBar("error".tr());
            //}
          }
        } else {
          errorGetBar("error".tr());
        }

        emit(CheckInOutLoaded());
      },
    );
  }

  GetLastAttendanceModel? getLastAttendanceModel;
  getLastAttendance() async {
    emit(GetContractLoading());
    final result = await api.getLastAttendance();
    result.fold(
      (failure) => emit(GetContractError()),
      (r) {
        getLastAttendanceModel = r;

        emit(GetContractLoaded());
      },
    );
  }

  HolidaysTypeModel? holidaysTypeModel;
  getTypeHolidays() async {
    emit(GetTypeHolidaysLoading());
    final result = await api.getTypeHolidays();
    result.fold(
      (failure) => emit(GetTypeHolidaysError()),
      (r) {
        holidaysTypeModel = r;

        emit(GetTypeHolidaysLoaded());
      },
    );
  }

  //// expense
  GetMyExpensesModel getMyExpensesModel = GetMyExpensesModel();
  getMyExpenses() async {
    emit(GetTypeHolidaysLoading());
    final result = await api.getMyExpenses();
    result.fold(
      (failure) => emit(GetTypeHolidaysError()),
      (r) {
        getMyExpensesModel = r;
        emit(GetTypeHolidaysLoaded());
      },
    );
  }

  GetAllExpensesProductModel? getAllExpensesProductModel;
  getAllExpensesProduct() async {
    emit(GetTypeHolidaysLoading());
    final result = await api.getAllExpensesProduct();
    result.fold(
      (failure) => emit(GetTypeHolidaysError()),
      (r) {
        getAllExpensesProductModel = r;
        emit(GetTypeHolidaysLoaded());
      },
    );
  }

  File? profileImage;
  String selectedBase64String = "";

  // // Method to pick image from camera or gallery
  // Future<void> pickImage(ImageSource source) async {
  //   try {
  //     final pickedFile = await ImagePicker().pickImage(source: source);
  //     if (pickedFile != null) {
  //       profileImage = File(pickedFile.path);
  //       // selectedBase64String=await fileToBase64String(pickedFile.path);
  //       emit(UpdateProfileImagePicked()); // Emit state for image picked
  //     }
  //   } catch (e) {
  //     // Handle any errors
  //     emit(UpdateProfileError());
  //   }
  // }

  //photo transfer
  Future<String> fileToBase64String(String filePath) async {
    File file = File(filePath);
    Uint8List bytes = await file.readAsBytes();
    String base64String = base64Encode(bytes);
    return base64String;
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
      // selectedBase64String=await fileToBase64String(pickedFile.path);
      emit(UpdateProfileImagePicked()); // Emit state for image picked
    } else {
      emit(FileNotPicked());
    }
    Navigator.pop(context);
  }

  removeImage() {
    profileImage = null;
    emit(FileRemovedSuccessfully());
  }

  void createExpense(BuildContext context, {required int productId}) async {
    if (selectedPaymentMethod == null) {
      errorGetBar("please_select_pay");
    } else {
      emit(UpdateProfileUserLoading());
      AppWidget.createProgressDialog(context);
      final result = await api.createExpense(
          path: profileImage != null ? profileImage!.path : "",
          amount: amountController.text,
          description: descriptionController.text,
          productId: productId);
      result.fold((l) {
        Navigator.pop(context);
        emit(UpdateProfileUserError());
      }, (r) {
        approveExpense(context, expenseId: r.expense!.id);

        emit(UpdateProfileUserLoaded());
      });
    }
  }

  void approveExpense(BuildContext context, {required int expenseId}) async {
    emit(UpdateProfileUserLoading());
    final result = await api.approveExpense(
        journalId: selectedPaymentMethod!, expenseId: expenseId);
    result.fold((l) {
      Navigator.pop(context);
      emit(UpdateProfileUserError());
    }, (r) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      successGetBar("added".tr());
      getMyExpenses();
      emit(UpdateProfileUserLoaded());
    }
        //!}
        );
  }

  int? selectedPaymentMethod;
  void changeJournal(int selectedPayment) {
    selectedPaymentMethod = selectedPayment;
    emit(ChangeJournalState());
  }

  GetAllJournalsModel? getAllJournalsModel;
  void getAllJournals() async {
    emit(GetAllJournalsLoadingState());
    final result = await api.getAllJournals();
    result.fold(
      (failure) => emit(GetAllJournalsErrorState()),
      (r) {
        getAllJournalsModel = r;
        emit(GetAllJournalsLoadedState());
      },
    );
  }

  AllSalaryModel? allSalaryModel;
  getAllSalary() async {
    emit(GetAllSalaryLoading());
    final result = await api.getMySalary();
    result.fold(
      (failure) => emit(GetAllSalaryError()),
      (r) {
        allSalaryModel = r;
        emit(GetAllSalaryLoaded());
      },
    );
  }
  
  AddTimeOffModel? addTimeOffModel;
  Future<void> addTimeOff({
    required BuildContext context,
    required String timeOffTypeId,
  }) async {
    if (fromDate == null || toDate == null) {
      errorGetBar("please_select_date".tr());
      return;
    }

    if (selectedEndDate!.isBefore(selectedStartDate!)) {
      errorGetBar("start_end_date".tr());
      return;
    }

    emit(GetAllSalaryLoading());
    final result = await api.addTimeOff(
      timeOffTypeId: timeOffTypeId,
      dateFrom: fromDate!,
      reason: reasonController.text,
      dateTo: toDate!,
    );
    result.fold(
      (failure) => emit(GetAllSalaryError()),
      (r) {
        if (r.result!.status == "error") {
          errorGetBar(r.result!.message!);
        } else {
          successGetBar(r.result!.message!);
        }
        addTimeOffModel = r;
        updateDateStrings();
        emit(GetAllSalaryLoaded());
        reasonController.clear();
        Navigator.pop(context);
        Navigator.pop(context);
        getAllHolidays();
      },
    );
  }
}
