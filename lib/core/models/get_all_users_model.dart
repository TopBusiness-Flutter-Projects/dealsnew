// To parse this JSON data, do
//
//     final geyAllUsersModel = geyAllUsersModelFromJson(jsonString);

import 'dart:convert';

GeyAllUsersModel geyAllUsersModelFromJson(String str) =>
    GeyAllUsersModel.fromJson(json.decode(str));

String geyAllUsersModelToJson(GeyAllUsersModel data) =>
    json.encode(data.toJson());

class GeyAllUsersModel {
  
  List<UserModel>? result;

  GeyAllUsersModel({

    this.result,
  });

  factory GeyAllUsersModel.fromJson(Map<String, dynamic> json) =>
      GeyAllUsersModel(
     
        result: json["result"] == null
            ? []
            : List<UserModel>.from(json["result"]!.map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
      
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class UserModel {
  int? id;

  dynamic name;

  UserModel({
    this.id,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
