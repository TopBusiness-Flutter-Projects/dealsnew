// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  int? id;
  dynamic name;
  dynamic dateOrder;
  dynamic amountTotal;
  dynamic state;
  dynamic currencyId;
  dynamic partnerName;
  dynamic mobile;
  dynamic partnerLongitude;
  dynamic partnerLatitude;
  List<OrderLine>? orderLines;
  List<Invoice>? invoices;
  List<Picking>? pickings;
  List<Payment>? payments;

  OrderDetailsModel({
    this.partnerLatitude,
    this.partnerLongitude,
    this.id,
    this.name,
    this.dateOrder,
    this.amountTotal,
    this.state,
    this.currencyId,
    this.partnerName,
    this.mobile,
    this.orderLines,
    this.invoices,
    this.pickings,
    this.payments,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        partnerLatitude: json["partner_latitude"],
        partnerLongitude: json["partner_longitude"],
        id: json["id"],
        name: json["name"],
        dateOrder: json["date_order"],
        amountTotal: json["amount_total"],
        state: json["state"],
        currencyId: json["currency_id"],
        partnerName: json["partner_name"],
        mobile: json["mobile"],
        orderLines: json["order_lines"] == null
            ? []
            : List<OrderLine>.from(
                json["order_lines"]!.map((x) => OrderLine.fromJson(x))),
        invoices: json["invoices"] == null
            ? []
            : List<Invoice>.from(
                json["invoices"]!.map((x) => Invoice.fromJson(x))),
        pickings: json["pickings"] == null
            ? []
            : List<Picking>.from(
                json["pickings"]!.map((x) => Picking.fromJson(x))),
        payments: json["payments"] == null
            ? []
            : List<Payment>.from(
                json["payments"]!.map((x) => Payment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "partner_latitude": partnerLatitude,
        "partner_longitude": partnerLongitude,
        "date_order": dateOrder?.toIso8601String(),
        "amount_total": amountTotal,
        "state": state,
        "currency_id": currencyId,
        "partner_name": partnerName,
        "mobile": mobile,
        "order_lines": orderLines == null
            ? []
            : List<dynamic>.from(orderLines!.map((x) => x.toJson())),
        "invoices": invoices == null
            ? []
            : List<dynamic>.from(invoices!.map((x) => x.toJson())),
        "pickings": pickings == null
            ? []
            : List<dynamic>.from(pickings!.map((x) => x.toJson())),
        "payments":
            payments == null ? [] : List<dynamic>.from(payments!.map((x) => x)),
      };
}

class Invoice {
  int? invoiceId;
  dynamic name;
  dynamic state;
  dynamic amountTotal;
  dynamic amountDue;
  dynamic paymentState;
  dynamic currency;
  dynamic invoiceDate;
  List<InvoiceLine>? invoiceLines;

  Invoice(
      {this.invoiceId,
      this.name,
      this.state,
      this.amountTotal,
      this.currency,
      this.invoiceDate,
      this.invoiceLines,
      this.amountDue,
      this.paymentState});

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        invoiceId: json["invoice_id"],
        name: json["name"],
        state: json["state"],
        amountTotal: json["amount_total"]?.toDouble(),
        amountDue: json["amount_due"]?.toDouble(),
        currency: json["currency"],
        paymentState: json["payment_state"],
        invoiceDate: json["invoice_date"],
        invoiceLines: json["invoice_lines"] == null
            ? []
            : List<InvoiceLine>.from(
                json["invoice_lines"]!.map((x) => InvoiceLine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "invoice_id": invoiceId,
        "name": name,
        "state": state,
        "amount_total": amountTotal,
        "currency": currency,
        "invoice_date":
            "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
        "invoice_lines": invoiceLines == null
            ? []
            : List<dynamic>.from(invoiceLines!.map((x) => x.toJson())),
      };
}

class InvoiceLine {
  int? id;
  dynamic productId;
  dynamic quantity;
  dynamic priceUnit;
  dynamic discount;
  dynamic priceSubtotal;
  List<dynamic>? taxes;

  InvoiceLine({
    this.id,
    this.productId,
    this.quantity,
    this.priceUnit,
    this.discount,
    this.priceSubtotal,
    this.taxes,
  });

  factory InvoiceLine.fromJson(Map<String, dynamic> json) => InvoiceLine(
        id: json["id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        priceUnit: json["price_unit"],
        discount: json["discount"],
        priceSubtotal: json["price_subtotal"],
        taxes: json["taxes"] == null
            ? []
            : List<dynamic>.from(json["taxes"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "quantity": quantity,
        "price_unit": priceUnit,
        "discount": discount,
        "price_subtotal": priceSubtotal,
        "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x)),
      };
}

class OrderLine {
  int? id;
  int? productId;
  dynamic productName;
  dynamic productUomQty;
  dynamic oldQty;
  dynamic priceUnit;
  dynamic discount;
  dynamic priceSubtotal;
  dynamic priceTotal;
  dynamic returned;

  List<dynamic>? taxes;
  OrderLine(
      {this.id,
      this.productId,
      this.productName,
      this.productUomQty,
      this.oldQty,
      this.priceUnit,
      this.discount,
      this.priceSubtotal,
      this.returned,
      this.taxes,
      this.priceTotal});

  factory OrderLine.fromJson(Map<String, dynamic> json) => OrderLine(
        id: json["id"],
        productId: json["product_id"],
        productName: json["product_name"],
        productUomQty: int.parse(
            double.parse(json["product_uom_qty"].toString())
                .round()
                .toString()),
        oldQty: int.parse(double.parse(json["product_uom_qty"].toString())
            .round()
            .toString()),
        priceUnit: json["price_unit"],
        priceTotal: json["price_total"],
        discount: json["discount"],
        priceSubtotal: json["price_total"],
        returned: json["returned"],
        taxes: json["taxes"] == null
            ? []
            : List<dynamic>.from(json["taxes"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "product_name": productName,
        "product_uom_qty": productUomQty,
        "price_unit": priceUnit,
        "discount": discount,
        "price_total": priceSubtotal,
        // "price_total": priceTotal,
        "returned": returned,
        "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x)),
      };
}

class Payment {
  int? paymentId;
  dynamic? amount;
  dynamic? paymentDate;
  dynamic? paymentMethod;
  dynamic? state;

  Payment({
    this.paymentId,
    this.amount,
    this.paymentDate,
    this.paymentMethod,
    this.state,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        paymentId: json["payment_id"],
        amount: json["amount"],
        paymentDate: json["payment_date"],
        paymentMethod: json["payment_method"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "amount": amount,
        "payment_date": paymentDate,
        "payment_method": paymentMethod,
        "state": state,
      };
}

class Picking {
  int? pickingId;
  dynamic name;
  dynamic state;
  dynamic scheduledDate;
  dynamic dateDone;
  List<PickingLine>? pickingLines;

  Picking({
    this.pickingId,
    this.name,
    this.state,
    this.scheduledDate,
    this.dateDone,
    this.pickingLines,
  });

  factory Picking.fromJson(Map<String, dynamic> json) => Picking(
        pickingId: json["picking_id"],
        name: json["name"],
        state: json["state"],
        scheduledDate: json["scheduled_date"],
        dateDone: json["date_done"] == null,
        pickingLines: json["picking_lines"] == null
            ? []
            : List<PickingLine>.from(
                json["picking_lines"]!.map((x) => PickingLine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "picking_id": pickingId,
        "name": name,
        "state": state,
        "scheduled_date": scheduledDate?.toIso8601String(),
        "date_done": dateDone?.toIso8601String(),
        "picking_lines": pickingLines == null
            ? []
            : List<dynamic>.from(pickingLines!.map((x) => x.toJson())),
      };
}

class PickingLine {
  int? moveId;
  dynamic productId;
  dynamic demand;
  dynamic quantity;
  dynamic locationId;
  dynamic locationDestId;

  PickingLine({
    this.moveId,
    this.productId,
    this.demand,
    this.quantity,
    this.locationId,
    this.locationDestId,
  });

  factory PickingLine.fromJson(Map<String, dynamic> json) => PickingLine(
        moveId: json["move_id"],
        productId: json["product_id"],
        demand: json["demand"],
        quantity: json["quantity"],
        locationId: json["location_id"],
        locationDestId: json["location_dest_id"],
      );

  Map<String, dynamic> toJson() => {
        "move_id": moveId,
        "product_id": productId,
        "demand": demand,
        "quantity": quantity,
        "location_id": locationId,
        "location_dest_id": locationDestId,
      };
}
