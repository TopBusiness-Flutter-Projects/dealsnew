// To parse this JSON data, do
//
//     final allPaymentsModel = allPaymentsModelFromJson(jsonString);

import 'dart:convert';

AllPaymentsModel allPaymentsModelFromJson(String str) => AllPaymentsModel.fromJson(json.decode(str));

String allPaymentsModelToJson(AllPaymentsModel data) => json.encode(data.toJson());

class AllPaymentsModel {
    String? jsonrpc;
    dynamic id;
    Result? result;

    AllPaymentsModel({
        this.jsonrpc,
        this.id,
        this.result,
    });

    factory AllPaymentsModel.fromJson(Map<String, dynamic> json) => AllPaymentsModel(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result?.toJson(),
    };
}

class Result {
    List<PaymentModel>? payments;

    Result({
        this.payments,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        payments: json["payments"] == null ? [] : List<PaymentModel>.from(json["payments"]!.map((x) => PaymentModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toJson())),
    };
}

class PaymentModel {
    int? paymentId;
    String? name;
    dynamic paymentDate;
    dynamic amount;
    dynamic currency;
   dynamic paymentType;
    dynamic state;
    dynamic partnerName;
    dynamic journalName;

    PaymentModel({
        this.paymentId,
        this.name,
        this.paymentDate,
        this.amount,
        this.currency,
        this.paymentType,
        this.state,
        this.partnerName,
        this.journalName,
    });

    factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        paymentId: json["payment_id"],
        name: json["name"],
        paymentDate: json["payment_date"] ,
        amount: json["amount"]?.toDouble(),
        currency: json["currency"],
        paymentType:json["payment_type"],
        state: json["state"],
        partnerName: json["partner_name"],
        journalName: json["journal_name"],
    );

    Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "name": name,
        "payment_date": paymentDate,
        "amount": amount,
        "currency": currency,
        "payment_type": paymentType,
        "state": state,
        "partner_name": partnerName,
        "journal_name": journalName,
    };
}

