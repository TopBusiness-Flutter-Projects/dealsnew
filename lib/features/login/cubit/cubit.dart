// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_sale/config/routes/app_routes.dart';
import 'package:top_sale/core/api/end_points.dart';
import 'package:top_sale/core/models/check_employee_model.dart';
import 'package:top_sale/core/models/login_model.dart';
import 'package:top_sale/core/preferences/preferences.dart';
import 'package:top_sale/core/remote/service.dart';
import 'package:top_sale/core/utils/app_strings.dart';
import 'package:top_sale/core/utils/appwidget.dart';
import 'package:top_sale/core/utils/dialogs.dart';

import 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.api) : super(LoginStateInitial());
  ServiceApi api;
  TextEditingController companynameController = TextEditingController();
  TextEditingController odooLinkController = TextEditingController();
  TextEditingController dbNumberController = TextEditingController();
  TextEditingController adminNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();
//! case user
  TextEditingController usernameController = TextEditingController();
  //! case emplyee
  TextEditingController emplyeeNumberController = TextEditingController();

  bool isEmplyee = false;
  onchangeEmplyeeStatus(bool status) {
    isEmplyee = status;
    emplyeeNumberController.clear();
    usernameController.clear();

    emit(ChnageStatusOfEmplyeeAndUser());
  }

  AuthModel? authModel;
  login(BuildContext context,
      {required String phoneOrMail,
      required String password,
      required String baseUrl,
      required String database,
      required bool isEmployeeType,
      bool isSplash = false,
      required bool isVisitor}) async {
    emit(LoadingLoginState());
    if (!isSplash) {
          AppWidget.createProgressDialog(context);

    }
    final response = isVisitor
        ? await api.login(
            phoneOrMail: AppStrings.demoUserName,
            password: AppStrings.demoUserpassword,
            baseUrl: AppStrings.demoBaseUrl,
            database: AppStrings.demoDB)
        : await api.login(
            phoneOrMail: phoneOrMail,
            password: password,
            baseUrl: baseUrl,
            database: database);
    response.fold((l) {
      if (!isSplash) {
        Navigator.pop(context);
        errorGetBar(l.message ?? '');
      } else {
        Navigator.pushReplacementNamed(context, Routes.loginRoute);
      }

      emit(FailureLoginState());
    }, (r) async {
      if (r.result != null) {
        authModel = r;
        print("rrrrrrrrrrrrrrrrrr");
        print("rrrrrrrrrrrrrrrrrr warehouse ${r.result!.propertyWarehouseId}");
        print("rrrrrrrrrrrrrrrrrr admin ${r.result!.isAdmin}");
        print("rrrrrrrrrrrrrrrrrr discount ${r.result!.isDiscountManager}");
        print("rrrrrrrrrrrrrrrrrr pricelist ${r.result!.isPriceListManager}");

        String sessionId = isVisitor
            ? await api.getSessionId(
                phone: AppStrings.demoUserName,
                password: AppStrings.demoUserpassword,
                baseUrl: AppStrings.demoBaseUrl,
                database: AppStrings.demoDB)
            : await api.getSessionId(
                phone: phoneOrMail,
                password: password,
                baseUrl: baseUrl,
                database: database);

        emit(SuccessLoginState());
        await Preferences.instance.setSessionId(sessionId);
        if (!isVisitor) {
          if (isEmployeeType) {
            await Preferences.instance.setMasterUserName(phoneOrMail);
            await Preferences.instance.setMasterUserPass(password);
          } else {
            await Preferences.instance.setUserName(phoneOrMail);
            await Preferences.instance.setUserPass(password);
          }
          await Preferences.instance.setOdooUrl(baseUrl);
          await Preferences.instance.setDataBaseName(database);
        } else {
          Preferences.instance.setIsVisitor(true);
        }
        if (!isSplash) {
          Navigator.pop(context);
        }
        Preferences.instance.setUserId(r.result!.userContext!.uid.toString());
        Preferences.instance.setUserModel(r);
        print("wwwwwwwwwwwwww ${r.result!.propertyWarehouseId}");
        if (isEmployeeType) {
          //  isEmplyee = true;
          Navigator.pushNamed(context, Routes.loginRoute);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.mainRoute, (route) => false);
        }
      } else {
        errorGetBar("error".tr());
        Navigator.pop(context);
      }
    });
  }

  auth({
    required String phoneOrMail,
    required String password,
    required String baseUrl,
    required String database,
  }) async {
    emit(LoadingLoginState());

    final response = await api.login(
        phoneOrMail: phoneOrMail,
        password: password,
        baseUrl: baseUrl,
        database: database);
    response.fold((l) {
      emit(FailureLoginState());
    }, (r) async {
      if (r.result != null) {
        authModel = r;
        debugPrint("rrrrrrrrrrrrrrrrrr");
        debugPrint(
            "rrrrrrrrrrrrrrrrrr warehouse ${r.result!.propertyWarehouseId}");
        debugPrint("rrrrrrrrrrrrrrrrrr admin ${r.result!.isAdmin}");
        debugPrint(
            "rrrrrrrrrrrrrrrrrr discount ${r.result!.isDiscountManager}");
        debugPrint(
            "rrrrrrrrrrrrrrrrrr pricelist ${r.result!.isPriceListManager}");
        String sessionId = await api.getSessionId(
            phone: phoneOrMail,
            password: password,
            baseUrl: baseUrl,
            database: database);
        emit(SuccessLoginState());
        await Preferences.instance.setSessionId(sessionId);
        emit(SuccessLoginState());
        Preferences.instance.setUserId(r.result!.userContext!.uid.toString());
        Preferences.instance.setUserModel(r);
        print("wwwwwwwwwwwwww ${r.result!.propertyWarehouseId}");
      } else {
        emit(FailureLoginState());
      }
    });
  }

  CheckEmployeeModel? employeeModel;
  checkEmployee(
    BuildContext context, {
    required String employeeId,
    required String password,
  }) async {
    if (await Preferences.instance.getMasterUserName() == null ||
        await Preferences.instance.getOdooUrl() == null) {
      errorGetBar("enter_company_data".tr());
    } else {
      emit(LoadingCheckEmployeeState());
            AppWidget.createProgressDialog(context);

      final response = await api.checkEmployee(
        employeeId: employeeId,
        password: password,
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
                .setEmployeeId(r.result!.first.id.toString());
            successGetBar("success".tr());
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.mainRoute, (route) => false);
            if (r.result!.first.workId != null) {
              await Preferences.instance
                  .setEmployeePartnerId(r.result!.first.workId.toString());
            }
            //  if (r.result!.first.messagePartnerIds!.isNotEmpty) {
            //     await Preferences.instance.setEmployeePartnerId(
            //         r.result!.first.messagePartnerIds!.first.id.toString());
            //   }
          } else {
            errorGetBar('error'.tr());
          }
          //  employeeModel = r;
        } else {
          errorGetBar("error".tr());
        }
      });
    }
  }

  Future<String> setSessionId({
    required String phoneOrMail,
    required String password,
    required String baseUrl,
    required String database,
  }) async {
    String mySessionId = await api.getSessionId(
        phone: phoneOrMail,
        password: password,
        baseUrl: baseUrl,
        database: database);

    return mySessionId;
  }
}
//https://novapolaris-top-staging-15626573.dev.odoo.com
//novapolaris-top-staging-15626573
// master@gmail.com
// master