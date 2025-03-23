// To parse this JSON data, do
//
//     final getPromotionsModel = getPromotionsModelFromJson(jsonString);

import 'dart:convert';

GetPromotionsModel getPromotionsModelFromJson(String str) => GetPromotionsModel.fromJson(json.decode(str));

String getPromotionsModelToJson(GetPromotionsModel data) => json.encode(data.toJson());

class GetPromotionsModel {
    int? count;
    List<PromotionModel>? result;

    GetPromotionsModel({
        this.count,
        this.result,
    });

    factory GetPromotionsModel.fromJson(Map<String, dynamic> json) => GetPromotionsModel(
        count: json["count"],
        result: json["result"] == null ? [] : List<PromotionModel>.from(json["result"]!.map((x) => PromotionModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    };
}

class PromotionModel {
    int? id;
    dynamic name;
    dynamic programType;

    PromotionModel({
        this.id,
        this.name,
        this.programType,
    });

    factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
        id: json["id"],
        name: json["name"],
        programType: json["program_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "program_type": programType,
    };
}
