// To parse this JSON data, do
//
//     final getAllPartnersReportsModel = getAllPartnersReportsModelFromJson(jsonString);

import 'dart:convert';

GetAllPartnersModel getAllPartnersReportsModelFromJson(String str) =>
    GetAllPartnersModel.fromJson(json.decode(str));

String getAllPartnersReportsModelToJson(GetAllPartnersModel data) =>
    json.encode(data.toJson());

class GetAllPartnersModel {
  int? count;
  dynamic prev;
  int? current;
  dynamic? next;
  int? totalPages;
  List<AllPartnerResults>? result;

  GetAllPartnersModel({
    this.count,
    this.prev,
    this.current,
    this.next,
    this.totalPages,
    this.result,
  });

  factory GetAllPartnersModel.fromJson(Map<String, dynamic> json) =>
      GetAllPartnersModel(
        count: json["count"],
        prev: json["prev"],
        current: json["current"],
        next: json["next"],
        totalPages: json["total_pages"],
        result: json["result"] == null
            ? []
            : List<AllPartnerResults>.from(
                json["result"]!.map((x) => AllPartnerResults.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "prev": prev,
        "current": current,
        "next": next,
        "total_pages": totalPages,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class AllPartnerResults {
  dynamic name;
  int? id;
  dynamic pricListId;
  dynamic phone;
  dynamic image;
  // dynamic totalDue;
  // dynamic totalInvoiced;
  // dynamic creditToInvoice;
  // List<int>? saleOrderIds;

  AllPartnerResults({
    this.name,
    this.id,
    this.phone,
    this.image,
    this.pricListId,
    // this.totalDue,
    // this.totalInvoiced,
    // this.creditToInvoice,
    // this.saleOrderIds,
  });

  factory AllPartnerResults.fromJson(Map<String, dynamic> json) =>
      AllPartnerResults(
        name: json["name"],
        id: json["id"],
        phone: json["phone"],
        image: json["image_1920"],
        pricListId: json["property_product_pricelist"],
        // totalDue: json["total_due"],
        // totalInvoiced: json["total_invoiced"],
        // creditToInvoice: json["credit_to_invoice"],
        // saleOrderIds: json["sale_order_ids"] == null
        //     ? []
        //     : List<int>.from(json["sale_order_ids"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "phone": phone,
        "image_1920": image,
        "property_product_pricelist": pricListId,
        // "total_due": totalDue,
        // "total_invoiced": totalInvoiced,
        // "credit_to_invoice": creditToInvoice,
        // "sale_order_ids": saleOrderIds == null
        //     ? []
        //     : List<dynamic>.from(saleOrderIds!.map((x) => x)),
      };
}
