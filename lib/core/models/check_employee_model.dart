// To parse this JSON data, do
//
//     final checkEmployeeModel = checkEmployeeModelFromJson(jsonString);

import 'dart:convert';

CheckEmployeeModel checkEmployeeModelFromJson(String str) =>
    CheckEmployeeModel.fromJson(json.decode(str));

String checkEmployeeModelToJson(CheckEmployeeModel data) =>
    json.encode(data.toJson());

class CheckEmployeeModel {
  List<Result>? result;

  CheckEmployeeModel({
    this.result,
  });

  factory CheckEmployeeModel.fromJson(Map<String, dynamic> json) =>
      CheckEmployeeModel(
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  int? id;
  dynamic name;
  dynamic workId;
  List<MessagePartnerId>? messagePartnerIds;

  Result({
    this.id,
    this.name,
    this.messagePartnerIds,
    this.workId
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        workId: json["work_contact_id"],
        messagePartnerIds: json["message_partner_ids"] == null
            ? []
            : List<MessagePartnerId>.from(json["message_partner_ids"]!
                .map((x) => MessagePartnerId.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "work_contact_id": workId,
        "message_partner_ids": messagePartnerIds == null
            ? []
            : List<dynamic>.from(messagePartnerIds!.map((x) => x.toJson())),
      };
}

class MessagePartnerId {
  dynamic id;


  MessagePartnerId({
    this.id,
  });

  factory MessagePartnerId.fromJson(Map<String, dynamic> json) =>
      MessagePartnerId(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
