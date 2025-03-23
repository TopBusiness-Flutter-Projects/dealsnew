// To parse this JSON data, do
//
//     final addTimeOffModel = addTimeOffModelFromJson(jsonString);

import 'dart:convert';

AddTimeOffModel addTimeOffModelFromJson(String str) => AddTimeOffModel.fromJson(json.decode(str));

String addTimeOffModelToJson(AddTimeOffModel data) => json.encode(data.toJson());

class AddTimeOffModel {
  String? jsonrpc;
  dynamic id;
  Result? result;

  AddTimeOffModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory AddTimeOffModel.fromJson(Map<String, dynamic> json) => AddTimeOffModel(
    jsonrpc: json["jsonrpc"],
    id: json["id"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "jsonrpc": jsonrpc,
    "id": id,
    "result": result?.toJson(),
  };
}

class Result {
  dynamic status;
  int? timeOffRequestId;
  dynamic message;

  Result({
    this.status,
    this.timeOffRequestId,
    this.message,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    status: json["status"],
    timeOffRequestId: json["time_off_request_id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "time_off_request_id": timeOffRequestId,
    "message": message,
  };
}
