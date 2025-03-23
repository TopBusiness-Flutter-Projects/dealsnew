// To parse this JSON data, do
//
//     final getCarIdsModel = getCarIdsModelFromJson(jsonString);

import 'dart:convert';

GetCarIdsModel getCarIdsModelFromJson(String str) => GetCarIdsModel.fromJson(json.decode(str));

String getCarIdsModelToJson(GetCarIdsModel data) => json.encode(data.toJson());

class GetCarIdsModel {
    List<CarId>? carIds;

    GetCarIdsModel({
        this.carIds,
    });

    factory GetCarIdsModel.fromJson(Map<String, dynamic> json) => GetCarIdsModel(
        carIds: json["car_ids"] == null ? [] : List<CarId>.from(json["car_ids"]!.map((x) => CarId.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "car_ids": carIds == null ? [] : List<dynamic>.from(carIds!.map((x) => x.toJson())),
    };
}

class CarId {
    dynamic id;
    dynamic name;

    CarId({
        this.id,
        this.name,
    });

    factory CarId.fromJson(Map<String, dynamic> json) => CarId(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
