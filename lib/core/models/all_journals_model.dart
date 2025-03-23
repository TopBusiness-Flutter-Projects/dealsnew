// To parse this JSON data, do
//
//     final getAllJournalsModel = getAllJournalsModelFromJson(jsonString);

import 'dart:convert';

GetAllJournalsModel getAllJournalsModelFromJson(String str) =>
    GetAllJournalsModel.fromJson(json.decode(str));

String getAllJournalsModelToJson(GetAllJournalsModel data) =>
    json.encode(data.toJson());
class GetAllJournalsModel {
  List<Result>? result;
  GetAllJournalsModel({
    this.result,
  });
  factory GetAllJournalsModel.fromJson(Map<String, dynamic> json) =>
      GetAllJournalsModel(
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
  dynamic? displayName;
  Result({
    this.id,
    this.displayName,
  });
  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        displayName: json["display_name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": displayName,
      };
}