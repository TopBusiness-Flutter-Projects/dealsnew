// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/core/models/check_employee_model.dart';
import 'package:top_sale/core/remote/service.dart';
import 'package:top_sale/core/utils/appwidget.dart';
import 'package:top_sale/core/utils/dialogs.dart';
import 'package:top_sale/features/main/cubit/main_cubit.dart';
import '../../../config/routes/app_routes.dart';
import '../../../core/models/get_employee_data_model.dart';
import '../../../core/models/get_user_data_model.dart';
import '../../../core/preferences/preferences.dart';
import 'state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.api) : super(MainInitial()) {
    checkEmployeeOrUser();
    getCurrencyName();
  }
  ServiceApi api;
  String? nameOfUser;
  String? phoneOfUser;
  String? imageOfUser;
  String? emailOfUser;
  GetUserDataModel? getUserDataModel;
  bool isEmployeeAdded = false;
  TextEditingController reasonController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CheckEmployeeModel? employeeModel;
  checkEmployeeNumber(BuildContext context,
      {required String employeeId, bool isHR = true
      // required String password,
      }) async {
  
    emit(LoadingCheckEmployeeState());
          AppWidget.createProgressDialog(context);

    final response = await api.checkEmployeeNumber(
      employeeId: employeeId,
    );
    response.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureCheckEmployeeState());
    }, (r) async {
      Navigator.pop(context);
      emit(SuccessCheckEmployeeState());
      if (r.result != null) {
        if (r.result!.isNotEmpty) {
          await Preferences.instance
              .setEmployeeIdNumber(r.result!.first.id.toString());
          isEmployeeAdded = true;
          Navigator.pop(context);
          if (r.result!.first.workId != null) {
            await Preferences.instance
                .setEmployeePartnerId(r.result!.first.workId.toString());
          }
        
          if (isHR) {
            context.read<MainCubit>().changeNavigationBar(2);
          }
          successGetBar("success".tr());
      
        } else {
          errorGetBar("not_employee".tr());
        }
     
      } else {
        errorGetBar("error".tr());
      }
    });
    // }
  }

  //get  userdata
  void getUserData() async {
    emit(ProfileUserLoading());
    final result = await api.getUserData();
    result.fold(
      (failure) =>
          emit(ProfileUserLoaded(error: 'Error loading data: $failure')),
      (r) {
        getUserDataModel = r;
        nameOfUser = r.name;
        if (r.phone == 'false') {
          phoneOfUser = "";
          debugPrint("phone false of user");
        } else {
          phoneOfUser = r.phone;
        }
        imageOfUser = r.image1920;
        emailOfUser = r.email;
        emit(ProfileUserError());
      },
    );
  }

//get empolyee data
  GetEmployeeDataModel? getEmployeeDataModel;
  void getEmployeeData() async {
    emit(ProfileEmployeeLoading());
    final result = await api.getEmployeeData();
    result.fold(
      (failure) =>
          emit(ProfileEmployeeError(error: 'Error loading data: $failure')),
      (r) async {
        getEmployeeDataModel = r;
        nameOfUser = r.name;
        if (r.workPhone.toString() == 'false') {
          debugPrint("phone false of employee");
          phoneOfUser = "";
        } else {
          phoneOfUser = r.workPhone.toString();
        }
        imageOfUser = r.image1920.toString();
        emailOfUser =
            r.workEmail.toString() == "false" ? "" : r.workEmail.toString();
        if (r.wareHouseId.toString() != "false") {
          await Preferences.instance.setEmployeeWareHouse(r.wareHouseId);
        }
        debugPrint("the model : emmm ${getEmployeeDataModel?.name.toString()}");
        emit(ProfileEmployeeLoaded());
      },
    );
  }

  void checkEmployeeOrUser() {
    Preferences.instance.getEmployeeId().then((value) async {
      debugPrint(value.toString());
      if (value == null) {
        String? id = await Preferences.instance.getEmployeeIdNumber();
        isEmployeeAdded = id != null;
        getUserData();
        debugPrint("user");
        // name= getUserDataModel?.name.toString()??"";
      } else {
        isEmployeeAdded = true;
        debugPrint("employee");
        getEmployeeData();
        // name= getEmployeeDataModel?.name.toString()??"";
      }
      emit(checkLoaded());
    });
    emit(checkLoaded());
  }

  void checkClearUserOrEmplyee(BuildContext context, bool isLogout) {
    Preferences.instance.getEmployeeId().then((value) {
      debugPrint('${value.toString()}');
      if (value == null) {
        //     getUserData();
        Preferences.instance.removeUserName();
        Preferences.instance.removeEmployeeId();
        Preferences.instance.removeEmployeeIdNumber();
        Preferences.instance.removeEmployeeWareHouse();
        Preferences.instance.removeIsInTrip();
        debugPrint("user");

        // name= getUserDataModel?.name.toString()??"";
      } else {
        Preferences.instance.removeUserName();
        Preferences.instance.removeEmployeeId();
        Preferences.instance.removeEmployeeIdNumber();
        Preferences.instance.removeIsInTrip();
        Preferences.instance.removeEmployeeWareHouse();

        debugPrint("employee");
        // getEmployeeData();

        // name= getEmployeeDataModel?.name.toString()??"";
      }
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.loginRoute, (route) => false);
      isLogout
          ? successGetBar("logout_success".tr())
          : successGetBar( "delete_success".tr());
      // Navigator.pushNamedAndRemoveUntil(context, Routes.loginRoute, );
      emit(checkClearLoaded());
    });
  }

  String currencyName = '';
  bool isDiscountManager = false;
  bool ispriceListManager = false;
  bool isAdmin = false;

  getCurrencyName() {
    Preferences.instance.getUserModel().then((value) {
      currencyName = value.result!.defaultCurrency!.name ?? "";
      isDiscountManager = value.result!.isDiscountManager ?? false;
      isAdmin = value.result!.isAdmin ?? false;
      ispriceListManager = value.result!.isPriceListManager ?? false;
    });
     emit(GetCurrencyNameLoaded());
    debugPrint("currency name : $currencyName");
    debugPrint("isDiscountManager : $isDiscountManager");
    debugPrint("ispriceListManager : $ispriceListManager");
    debugPrint("isAdmin : $isAdmin");
   
  }

  DateTime selectedDate = DateTime.now();
  // String formattedDate = DateFormat(
  //     'yyyy-MM-dd',
  //   ).format(selectedDate);
}
