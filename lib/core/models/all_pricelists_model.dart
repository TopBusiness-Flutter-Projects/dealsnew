// To parse this JSON data, do
//
//     final getAllPriceListtsModel = getAllPriceListtsModelFromJson(jsonString);

import 'dart:convert';

GetAllPriceListtsModel getAllPriceListtsModelFromJson(String str) => GetAllPriceListtsModel.fromJson(json.decode(str));

String getAllPriceListtsModelToJson(GetAllPriceListtsModel data) => json.encode(data.toJson());

class GetAllPriceListtsModel {
    List<Pricelist>? pricelists;

    GetAllPriceListtsModel({
        this.pricelists,
    });

    factory GetAllPriceListtsModel.fromJson(Map<String, dynamic> json) => GetAllPriceListtsModel(
        pricelists: json["pricelists"] == null ? [] : List<Pricelist>.from(json["pricelists"]!.map((x) => Pricelist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pricelists": pricelists == null ? [] : List<dynamic>.from(pricelists!.map((x) => x.toJson())),
    };
}

class Pricelist {
    int? pricelistId;
    dynamic pricelistName;
    dynamic currency;
   dynamic active;

    Pricelist({
        this.pricelistId,
        this.pricelistName,
        this.currency,
        this.active,
    });

    factory Pricelist.fromJson(Map<String, dynamic> json) => Pricelist(
        pricelistId: json["pricelist_id"],
        pricelistName: json["pricelist_name"],
        currency: json["currency"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "pricelist_id": pricelistId,
        "pricelist_name": pricelistName,
        "currency": currency,
        "active": active,
    };
}
