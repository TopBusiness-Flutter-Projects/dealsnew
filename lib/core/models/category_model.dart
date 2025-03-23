// To parse this JSON data, do
//
//     final getCategoriesModel = getCategoriesModelFromJson(jsonString);

import 'dart:convert';

CategoriesModel getCategoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String getCategoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
    int? count;
    dynamic prev;
    int? current;
    dynamic next;
    int? totalPages;
    List<CategoryModelData>? result;

    CategoriesModel({
        this.count,
        this.prev,
        this.current,
        this.next,
        this.totalPages,
        this.result,
    });

    factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
        count: json["count"],
        prev: json["prev"],
        current: json["current"],
        next: json["next"],
        totalPages: json["total_pages"],
        result: json["result"] == null ? [] : List<CategoryModelData>.from(json["result"]!.map((x) => CategoryModelData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "prev": prev,
        "current": current,
        "next": next,
        "total_pages": totalPages,
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    };
}

class CategoryModelData {
    int? id;
    String? name;
    dynamic image;

    CategoryModelData({
        this.id,
        this.name,
        this.image,
    });

    factory CategoryModelData.fromJson(Map<String, dynamic> json) => CategoryModelData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
    };
}
