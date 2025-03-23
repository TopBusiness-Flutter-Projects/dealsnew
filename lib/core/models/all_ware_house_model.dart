// To parse this JSON data, do
//
//     final allWareHouseModel = allWareHouseModelFromJson(jsonString);

import 'dart:convert';

AllWareHouseModel allWareHouseModelFromJson(String str) => AllWareHouseModel.fromJson(json.decode(str));

String allWareHouseModelToJson(AllWareHouseModel data) => json.encode(data.toJson());

class AllWareHouseModel {
    List<WareHouse>? result;

    AllWareHouseModel({
        this.result,
    });

    factory AllWareHouseModel.fromJson(Map<String, dynamic> json) => AllWareHouseModel(
        result: json["result"] == null ? [] : List<WareHouse>.from(json["result"]!.map((x) => WareHouse.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    };
}

class WareHouse {
    int? id;
    dynamic name;

    WareHouse({
        this.id,
        this.name,
    });

    factory WareHouse.fromJson(Map<String, dynamic> json) => WareHouse(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
