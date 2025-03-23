// To parse this JSON data, do
//
//     final getAllExpensesProductModel = getAllExpensesProductModelFromJson(jsonString);

import 'dart:convert';

GetAllExpensesProductModel getAllExpensesProductModelFromJson(String str) => GetAllExpensesProductModel.fromJson(json.decode(str));

String getAllExpensesProductModelToJson(GetAllExpensesProductModel data) => json.encode(data.toJson());

class GetAllExpensesProductModel {
    List<Product>? result;

    GetAllExpensesProductModel({
        this.result,
    });

    factory GetAllExpensesProductModel.fromJson(Map<String, dynamic> json) => GetAllExpensesProductModel(
        result: json["result"] == null ? [] : List<Product>.from(json["result"]!.map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    };
}

class Product {
    int? id;
    dynamic name;
    dynamic image1920;

    Product({
        this.id,
        this.name,
        this.image1920,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        image1920: json["image_1920"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_1920": image1920,
    };
}
