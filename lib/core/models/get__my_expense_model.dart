// To parse this JSON data, do
//
//     final getLastAttendanceModel = getLastAttendanceModelFromJson(jsonString);

import 'dart:convert';

GetMyExpensesModel getMyExpensesModelFromJson(String str) =>
    GetMyExpensesModel.fromJson(json.decode(str));

String getMyExpensesModelToJson(GetMyExpensesModel data) =>
    json.encode(data.toJson());

class GetMyExpensesModel {
  dynamic success;
  List<Expense>? expenses;

  GetMyExpensesModel({
    this.success,
    this.expenses,
  });

  factory GetMyExpensesModel.fromJson(Map<String, dynamic> json) =>
      GetMyExpensesModel(
        success: json["success"],
        expenses: json["expenses"] == null
            ? []
            : List<Expense>.from(
                json["expenses"]!.map((x) => Expense.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "expenses": expenses == null
            ? []
            : List<dynamic>.from(expenses!.map((x) => x.toJson())),
      };
}

class Expense {
  int? id;
  dynamic name;
  dynamic employeeId;
  dynamic employeeName;
  dynamic activityUserId;
  dynamic activityUserName;
  dynamic date;
  dynamic unitAmount;
  dynamic productId;
  dynamic productName;
  dynamic description;
  dynamic state;
  dynamic sheetId;
  dynamic sheetName;
  dynamic sheetState;

  Expense({
    this.id,
    this.name,
    this.employeeId,
    this.employeeName,
    this.activityUserId,
    this.activityUserName,
    this.date,
    this.unitAmount,
    this.productId,
    this.productName,
    this.description,
    this.state,
    this.sheetId,
    this.sheetName,
    this.sheetState,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json["id"],
        name: json["name"],
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        activityUserId: json["activity_user_id"],
        activityUserName: json["activity_user_name"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        unitAmount: json["unit_amount"]?.toDouble(),
        productId: json["product_id"],
        productName: json["product_name"],
        description: json["description"],
        state: json["state"],
        sheetId: json["sheet_id"],
        sheetName: json["sheet_name"],
        sheetState: json["sheet_state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "employee_id": employeeId,
        "employee_name": employeeName,
        "activity_user_id": activityUserId,
        "activity_user_name": activityUserName,
        "date": date,
        "unit_amount": unitAmount,
        "product_id": productId,
        "product_name": productName,
        "description": description,
        "state": state,
        "sheet_id": sheetId,
        "sheet_name": sheetName,
        "sheet_state": sheetState,
      };
}
