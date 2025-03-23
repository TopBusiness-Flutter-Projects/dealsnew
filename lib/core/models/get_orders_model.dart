// To parse this JSON data, do
//
//     final getOrdersModel = getOrdersModelFromJson(jsonString);

import 'dart:convert';

import 'partner_model.dart';

GetOrdersModel getOrdersModelFromJson(String str) =>
    GetOrdersModel.fromJson(json.decode(str));

String getOrdersModelToJson(GetOrdersModel data) => json.encode(data.toJson());

class GetOrdersModel {
  int? count;
  dynamic prev;
  int? current;
  dynamic next;
  int? totalPages;
  List<OrderModel>? result;

  GetOrdersModel({
    this.count,
    this.prev,
    this.current,
    this.next,
    this.totalPages,
    this.result,
  });

  factory GetOrdersModel.fromJson(Map<String, dynamic> json) => GetOrdersModel(
        count: json["count"],
        prev: json["prev"],
        current: json["current"],
        next: json["next"],
        totalPages: json["total_pages"],
        result: json["result"] == null
            ? []
            : List<OrderModel>.from(
                json["result"]!.map((x) => OrderModel.fromJson(x))),
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

class OrderModel {
  int? id;
  int? userId;
  PartnerId? partnerId;
  dynamic displayName;
  dynamic state;
  dynamic writeDate;
  dynamic expectedDate;
  CurrencyId? currencyId;
  dynamic amountTotal;
  dynamic amountUnTaxed;
  String? invoiceStatus;
  dynamic deliveryStatus;
  EmployeeId? employeeId;
  // PartnerModel? partnerModel;
  OrderModel({
    this.id,
    this.userId,
    this.partnerId,
    this.displayName,
    this.state,
    this.writeDate,
    this.expectedDate,
    this.currencyId,
    this.amountTotal,
    this.invoiceStatus,
    this.employeeId,
    this.deliveryStatus,
    this.amountUnTaxed,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        userId: json["user_id"],
        partnerId: json["partner_id"] == null
            ? null
            : PartnerId.fromJson(json["partner_id"]),
        displayName: json["display_name"],
        state: json["state"],
        currencyId: json["currency_id"] == null
            ? null
            : CurrencyId.fromJson(json["currency_id"]),
        writeDate: json["write_date"],
        expectedDate: json["date_order"],
       // amountTotal: json["amount_untaxed"],
         amountTotal: json["amount_total"],
        invoiceStatus: json["invoice_status"],
        deliveryStatus: json["delivery_status"],
        amountUnTaxed: json["amount_untaxed"],
        employeeId: json["employee_id"] == null
            ? null
            : EmployeeId.fromJson(json["employee_id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "partner_id": partnerId?.toJson(),
        "display_name": displayName,
        "state": state,
        "currency_id": currencyId?.toJson(),
        "write_date": writeDate,
        "date_order": expectedDate,

         "amount_total": amountTotal,
       // "amount_untaxed": amountTotal,
        "invoice_status": invoiceStatus,
        "delivery_status": deliveryStatus,
        "employee_id": employeeId?.toJson(),
      };
}

class CurrencyId {
  dynamic name;

  CurrencyId({
    this.name,
  });

  factory CurrencyId.fromJson(Map<String, dynamic> json) => CurrencyId(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class EmployeeId {
  dynamic id;
  dynamic name;

  EmployeeId({
    this.id,
    this.name,
  });

  factory EmployeeId.fromJson(Map<String, dynamic> json) => EmployeeId(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class PartnerId {
  int? id;
  dynamic name;
  dynamic phone;
  dynamic partnerLatitude;
  dynamic partnerLongitude;

  PartnerId({
    this.id,
    this.name,
    this.phone,
    this.partnerLatitude,
    this.partnerLongitude,
  });

  factory PartnerId.fromJson(Map<String, dynamic> json) => PartnerId(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        partnerLatitude: json["partner_latitude"],
        partnerLongitude: json["partner_longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "partner_latitude": partnerLatitude,
        "partner_longitude": partnerLongitude,
      };
}
