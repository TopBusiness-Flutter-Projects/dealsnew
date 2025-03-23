// To parse this JSON data, do
//
//     final approveExpensesModel = approveExpensesModelFromJson(jsonString);

import 'dart:convert';

ApproveExpensesModel approveExpensesModelFromJson(String str) => ApproveExpensesModel.fromJson(json.decode(str));

String approveExpensesModelToJson(ApproveExpensesModel data) => json.encode(data.toJson());

class ApproveExpensesModel {
    dynamic success;
    //Data? data;

    ApproveExpensesModel({
        this.success,
      //  this.data,
    });

    factory ApproveExpensesModel.fromJson(Map<String, dynamic> json) => ApproveExpensesModel(
        success: json["success"],
        // data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        // "data": data?.toJson(),
    };
}

class Data {
    int? expenseId;
    String? expenseState;
    int? paymentId;
    String? paymentState;
    int? sheetId;
    String? sheetName;
    String? sheetState;

    Data({
        this.expenseId,
        this.expenseState,
        this.paymentId,
        this.paymentState,
        this.sheetId,
        this.sheetName,
        this.sheetState,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        expenseId: json["expense_id"],
        expenseState: json["expense_state"],
        paymentId: json["payment_id"],
        paymentState: json["payment_state"],
        sheetId: json["sheet_id"],
        sheetName: json["sheet_name"],
        sheetState: json["sheet_state"],
    );

    Map<String, dynamic> toJson() => {
        "expense_id": expenseId,
        "expense_state": expenseState,
        "payment_id": paymentId,
        "payment_state": paymentState,
        "sheet_id": sheetId,
        "sheet_name": sheetName,
        "sheet_state": sheetState,
    };
}
