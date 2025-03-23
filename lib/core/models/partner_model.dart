// To parse this JSON data, do
//
//     final partnerModel = partnerModelFromJson(jsonString);

import 'dart:convert';

List<PartnerModel> partnerModelFromJson(String str) => List<PartnerModel>.from(json.decode(str).map((x) => PartnerModel.fromJson(x)));
String partnerModelToJson(List<PartnerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PartnerModel {
    int? id;
    dynamic name;
    dynamic email;
    dynamic phone;
    dynamic mobile;
    dynamic street;
    dynamic city;
    dynamic zip;
    dynamic latitude;
    dynamic longitude;
    dynamic country;
    dynamic companyName;
    dynamic website;
    dynamic image;
    dynamic creditToInvoice;
    dynamic dueAmount;
    dynamic overdueAmount;
    dynamic invoiceCount;
    dynamic salesOrderCount;
    List<SalesOrder>? salesOrders;
    List<Invoice>? invoices;

    PartnerModel({
        this.id,
        this.name,
        this.email,
        this.phone,
        this.mobile,
        this.street,
        this.city,
        this.zip,
        this.latitude,
        this.longitude,
        this.country,
        this.companyName,
        this.website,
        this.image,
        this.creditToInvoice,
        this.dueAmount,
        this.overdueAmount,
        this.invoiceCount,
        this.salesOrderCount,
        this.salesOrders,
        this.invoices,
    });

    factory PartnerModel.fromJson(Map<String, dynamic> json) => PartnerModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        mobile: json["mobile"],
        street: json["street"],
        city: json["city"],
        zip: json["zip"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        country: json["country"],
        companyName: json["company_name"],
        website: json["website"],
        image: json["image"],
        creditToInvoice: json["credit_to_invoice"],
        dueAmount: json["due_amount"],
        overdueAmount: json["overdue_amount"],
        invoiceCount: json["invoice_count"],
        salesOrderCount: json["sales_order_count"],
        salesOrders: json["sales_orders"] == null ? [] : List<SalesOrder>.from(json["sales_orders"]!.map((x) => SalesOrder.fromJson(x))),
        invoices: json["invoices"] == null ? [] : List<Invoice>.from(json["invoices"]!.map((x) => Invoice.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "mobile": mobile,
        "street": street,
        "city": city,
        "zip": zip,
        "latitude": latitude,
        "longitude": longitude,
        "country": country,
        "company_name": companyName,
        "website": website,
        "image": image,
        "credit_to_invoice": creditToInvoice,
        "due_amount": dueAmount,
        "overdue_amount": overdueAmount,
        "invoice_count": invoiceCount,
        "sales_order_count": salesOrderCount,
        "sales_orders": salesOrders == null ? [] : List<dynamic>.from(salesOrders!.map((x) => x.toJson())),
        "invoices": invoices == null ? [] : List<dynamic>.from(invoices!.map((x) => x.toJson())),
    };
}

class Invoice {
    int? id;
    dynamic name;
   dynamic invoiceDate;
    dynamic amountTotal;
    dynamic amountResidual;
    dynamic state;
    dynamic paymentState;

    Invoice({
        this.id,
        this.name,
        this.invoiceDate,
        this.amountTotal,
        this.amountResidual,
        this.state,
        this.paymentState,
    });

    factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json["id"],
        name: json["name"],
        invoiceDate: json["invoice_date"],
        amountTotal: json["amount_total"],
        amountResidual: json["amount_residual"],
        state: json["state"],
        paymentState: json["payment_state"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "invoice_date":invoiceDate,
        "amount_total": amountTotal,
        "amount_residual": amountResidual,
        "state": state,
        "payment_state": paymentState,
    };
}

class SalesOrder {
    int? id;
    dynamic name;
    dynamic dateOrder;
   dynamic amountTotal;
    dynamic state;
   dynamic invoiceStatus;
   dynamic delivery_status;

    SalesOrder({
        this.id,
        this.name,
        this.dateOrder,
        this.amountTotal,
        this.state,
        this.invoiceStatus,
        this.delivery_status,
    });

    factory SalesOrder.fromJson(Map<String, dynamic> json) => SalesOrder(
        id: json["id"],
        name: json["name"],
        dateOrder: json["date_order"],
        amountTotal: json["amount_total"],
        state: json["state"],
        invoiceStatus: json["invoice_status"],
        delivery_status: json["delivery_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date_order": dateOrder?.toIso8601String(),
        "amount_total": amountTotal,
        "state": state,
        "invoice_status": invoiceStatus,
        "delivery_status": delivery_status,
    };
}
