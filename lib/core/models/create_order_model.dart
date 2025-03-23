// To parse this JSON data, do
//
//     final createOrderModel = createOrderModelFromJson(jsonString);

import 'dart:convert';

CreateOrderModel createOrderModelFromJson(String str) =>
    CreateOrderModel.fromJson(json.decode(str));

String createOrderModelToJson(CreateOrderModel data) =>
    json.encode(data.toJson());

class CreateOrderModel {
  Result? result;
  

  CreateOrderModel({
    this.result,
  });

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) =>
      CreateOrderModel(
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
      };
}

class Result {
  dynamic message;
  dynamic error;
  dynamic success;
  
  dynamic paymentId;
  dynamic pickingId;
  dynamic orderId;
 

  Result({
    this.message,
    this.paymentId,this.success,this.error,
    this.orderId,this.pickingId
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        message: json["message"],
        success: json["success"],
        error: json["error"],
        paymentId: json["payment_id"],
        pickingId: json["picking_id"],
        orderId: json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "error": error,
        "payment_id": paymentId,
        "picking_id": pickingId,
        "order_id": orderId,
      };
}

class Error {
  String? message;

  Error({
    this.message,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
