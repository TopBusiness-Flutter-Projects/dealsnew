// To parse this JSON data, do
//
//     final registerPaymentModel = registerPaymentModelFromJson(jsonString);

import 'dart:convert';

RegisterPaymentModel registerPaymentModelFromJson(String str) => RegisterPaymentModel.fromJson(json.decode(str));

String registerPaymentModelToJson(RegisterPaymentModel data) => json.encode(data.toJson());

class RegisterPaymentModel {
  
    Result? result;

    RegisterPaymentModel({
       
        this.result,
    });

    factory RegisterPaymentModel.fromJson(Map<String, dynamic> json) => RegisterPaymentModel(
     
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
      
        "result": result?.toJson(),
    };
}

class Result {
    String? status;
    dynamic creditNoteId;
    dynamic paymentId;
    dynamic paymentStatus;

    Result({
        this.status,
        this.creditNoteId,
        this.paymentId,
        this.paymentStatus,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        status: json["status"],
        creditNoteId: json["credit_note_id"],
        paymentId: json["payment_id"],
        paymentStatus: json["payment_status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "credit_note_id": creditNoteId,
        "payment_id": paymentId,
        "payment_status": paymentStatus,
    };
}
