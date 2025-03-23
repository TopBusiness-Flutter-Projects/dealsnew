import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_sale/core/models/all_tasks_model.dart';
import 'package:top_sale/core/models/get_orders_model.dart';
import 'package:top_sale/core/utils/app_strings.dart';

import '../models/login_model.dart';

class Preferences {
  static final Preferences instance = Preferences._internal();

  Preferences._internal();

  factory Preferences() => instance;

  // Future<void> setFirstInstall() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('onBoarding', 'Done');
  // }

  // Future<String?> getFirstInstall() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? jsonData = prefs.getString('onBoarding');
  //   return jsonData;
  // }

  // Future<void> setUser(LoginModel loginModel) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString(
  //       'user', jsonEncode(LoginModel.fromJson(loginModel.toJson())));
  //   print(await getUserModel());
  // }

  Future<void> clearShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  Future<AuthModel> getUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? jsonData = preferences.getString('user');
    AuthModel userModel;
    if (jsonData != null) {
      userModel = AuthModel.fromJson(jsonDecode(jsonData));
    } else {
      userModel = AuthModel();
    }
    return userModel;
  }
  //// Schedule notification
  Future<AllTasksModel> getNewTasks() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? jsonData = preferences.getString('newTasks');
    AllTasksModel tasksModel;
    if (jsonData != null) {
      tasksModel = AllTasksModel.fromJson(jsonDecode(jsonData));
    } else {
      tasksModel = AllTasksModel();
    }
    return tasksModel;
  }

  Future<void> setAllOrders(GetOrdersModel orders) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(
        'orders', jsonEncode(GetOrdersModel.fromJson(orders.toJson())));
  }
  Future<GetOrdersModel> getAllOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? jsonData = preferences.getString('orders');
    GetOrdersModel ordersModel;
    if (jsonData != null) {
      ordersModel = GetOrdersModel.fromJson(jsonDecode(jsonData));
    } else {
      ordersModel = GetOrdersModel();
    }
    return ordersModel;
  }

  Future<void> setNewTasks(AllTasksModel tasks) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(
        'newTasks', jsonEncode(AllTasksModel.fromJson(tasks.toJson())));
    print("tasks = ${tasks.tasks!.first.taskName}");
  }

  Future<void> setUserModel(AuthModel user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(
        'user', jsonEncode(AuthModel.fromJson(user.toJson())));
    print(await getUserModel());
  }

  Future<void> setSessionId(String sessionId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('sessionId', sessionId);
    print("sessionId = $sessionId");
  }

  Future<String?> getSessionId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? sessionId = preferences.getString('sessionId');
    return sessionId;
  }

  Future<void> setDataBaseName(String db) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('database', db);
    print("sessionIdTrueUser = $db");
  }

  Future<String?> getDataBaseName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? database = preferences.getString('database');
    return database;
  }

  Future<void> setOdooUrl(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('odooUrl', url);
    print("sessionIdTrueUser = $url");
  }

  Future<String?> getOdooUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? url = preferences.getString('odooUrl');
    return url;
  }

  Future<void> setUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userId', userId);
    print("userId = $userId");
  }

  Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('userId');
    return userId;
  }

  Future<void> setCompanyId(String companyId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('companyId', companyId);
    print("userId = $companyId");
  }

  Future<String?> getCompanyId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? companyId = preferences.getString('companyId');
    return companyId;
  }

  Future<void> setUserName(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userName', userName);
  }

  Future<void> removeUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('userName');
  }

  Future<String?> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userName = preferences.getString('userName');
    return userName;
  }

  Future<void> setMasterUserName(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userNameMaster', userName);
  }

  Future<String?> getMasterUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userName = preferences.getString('userNameMaster');
    return userName;
  }

  Future<void> setMasterUserPass(String userPass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userPassMaster', userPass);
    print("Password = $userPass");
  }

  Future<String?> getMasterUserPass() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userPass = preferences.getString('userPassMaster');
    return userPass;
  }

  Future<void> setUserPass(String userPass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userPass', userPass);
    print("Password = $userPass");
  }

  Future<String?> getUserPass() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userPass = preferences.getString('userPass');
    return userPass;
  }

  Future<void> setEmployeeId(String employeeId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('employeeId', employeeId);
    print("employeeId = $employeeId");
  }

  Future<void> removeEmployeeId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('employeeId');
  }

  Future<String?> getEmployeeId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? employeeId = preferences.getString('employeeId');
    return employeeId;
  }
  Future<void> setEmployeeIdNumber(String employeeId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('employeeIdNumber', employeeId);
    print("employeeId = $employeeId");
  }

  Future<void> removeEmployeeIdNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('employeeIdNumber');
  }

  Future<String?> getEmployeeIdNumber() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? employeeId = preferences.getString('employeeIdNumber');
    return employeeId;
  }
    Future<void> setEmployeePartnerId(String employeeId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('employeePartnerId', employeeId);
    print("employeeId = $employeeId");
  }
Future<String?> getEmployeePartnerId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? employeeId = preferences.getString('employeePartnerId');
    return employeeId;
  }



  Future<void> setIsInTrip(bool isInTrip) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isInTrip', isInTrip);
    print("isInTrip = $isInTrip");
  }
  Future<void> removeIsInTrip() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('isInTrip');
  }
  Future<bool> getIsInTrip() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isInTrip = preferences.getBool('isInTrip') ?? false;
    return isInTrip;
  }
  Future<void> setEmployeeWareHouse(int employeeId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('employeeIdWareHouse', employeeId);
    print("EmployeeWareHouse = $employeeId");
  }

  Future<void> removeEmployeeWareHouse() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('employeeIdWareHouse');
  }

  Future<int?> getEmployeeWareHouse() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? employeeId = preferences.getInt('employeeIdWareHouse');
    return employeeId;
  }
    Future<bool> getIsVisitor() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isVisitor = preferences.getBool('isVisitor') ?? false;
    return isVisitor;
  }
   Future<void> setIsVisitor(bool isVisitor) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isVisitor', isVisitor);
    print("isVisitor = $isVisitor");
  }
    Future<String> getSavedLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(AppStrings.locale) ?? 'ar';
  }

  Future<void> savedLang(String local) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(AppStrings.locale, local);
  }
}
