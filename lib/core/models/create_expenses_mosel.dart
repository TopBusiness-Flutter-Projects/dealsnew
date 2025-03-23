// To parse this JSON data, do
//
//     final createExpensesProductModel = createExpensesProductModelFromJson(jsonString);

import 'dart:convert';

CreateExpensesProductModel createExpensesProductModelFromJson(String str) => CreateExpensesProductModel.fromJson(json.decode(str));

String createExpensesProductModelToJson(CreateExpensesProductModel data) => json.encode(data.toJson());

class CreateExpensesProductModel {
    dynamic success;
    Expense? expense;

    CreateExpensesProductModel({
        this.success,
        this.expense,
    });

    factory CreateExpensesProductModel.fromJson(Map<String, dynamic> json) => CreateExpensesProductModel(
        success: json["success"],
        expense: json["expense"] == null ? null : Expense.fromJson(json["expense"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "expense": expense?.toJson(),
    };
}

class Expense {
    dynamic id;
    dynamic name;
    // int? employeeId;
    // String? employeeName;
    // bool? activityUserId;
    // bool? activityUserName;
    // DateTime? date;
    // int? unitAmount;
    // int? productId;
    // String? productName;
    // String? description;
    // String? state;
    // int? sheetId;
    // String? sheetName;
    // String? sheetState;

    Expense({
        this.id,
         this.name,
        // this.employeeId,
        // this.employeeName,
        // this.activityUserId,
        // this.activityUserName,
        // this.date,
        // this.unitAmount,
        // this.productId,
        // this.productName,
        // this.description,
        // this.state,
        // this.sheetId,
        // this.sheetName,
        // this.sheetState,
    });

    factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json["id"],
         name: json["name"],
        // employeeId: json["employee_id"],
        // employeeName: json["employee_name"],
        // activityUserId: json["activity_user_id"],
        // activityUserName: json["activity_user_name"],
        // date: json["date"] ,
        // unitAmount: json["unit_amount"],
        // productId: json["product_id"],
        // productName: json["product_name"],
        // description: json["description"],
        // state: json["state"],
        // sheetId: json["sheet_id"],
        // sheetName: json["sheet_name"],
        // sheetState: json["sheet_state"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "employee_id": employeeId,
        // "employee_name": employeeName,
        // "activity_user_id": activityUserId,
        // "activity_user_name": activityUserName,
        // "date": date,
        // "unit_amount": unitAmount,
        // "product_id": productId,
        // "product_name": productName,
        // "description": description,
        // "state": state,
        // "sheet_id": sheetId,
        // "sheet_name": sheetName,
        // "sheet_state": sheetState,
    };
}
