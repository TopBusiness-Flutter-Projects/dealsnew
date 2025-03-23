// To parse this JSON data, do
//
//     final getAllShippingModel = getAllShippingModelFromJson(jsonString);

import 'dart:convert';

GetAllShippingModel getAllShippingModelFromJson(String str) => GetAllShippingModel.fromJson(json.decode(str));

String getAllShippingModelToJson(GetAllShippingModel data) => json.encode(data.toJson());

class GetAllShippingModel {
    List<ShippingMethod>? shippingMethods;

    GetAllShippingModel({
        this.shippingMethods,
    });

    factory GetAllShippingModel.fromJson(Map<String, dynamic> json) => GetAllShippingModel(
        shippingMethods: json["shipping_methods"] == null ? [] : List<ShippingMethod>.from(json["shipping_methods"]!.map((x) => ShippingMethod.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "shipping_methods": shippingMethods == null ? [] : List<dynamic>.from(shippingMethods!.map((x) => x.toJson())),
    };
}

class ShippingMethod {
    int? id;
    dynamic name;
   dynamic productId;
    dynamic deliveryType;
   dynamic active;

    ShippingMethod({
        this.id,
        this.name,
        this.productId,
        this.deliveryType,
        this.active,
    });

    factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
        id: json["id"],
        name: json["name"],
        productId: json["product_id"],
        deliveryType: json["delivery_type"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "product_id": productId,
        "delivery_type": deliveryType,
        "active": active,
    };
}
