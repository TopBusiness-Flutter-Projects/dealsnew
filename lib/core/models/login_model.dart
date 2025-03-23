// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  Result? result;
  AuthModel({
    this.result,
  });
  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );
  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
      };
}

class Result {
  UserContext? userContext;
  String? name;
  bool? isAdmin;
  String? username;
  String? partnerDisplayName;
  int? partnerId;
  bool? isDiscountManager;
  bool? isPriceListManager;
  int? propertyWarehouseId;
  DefaultCurrency? defaultCurrency;

  UserCompanies? userCompanies;

  Result({
    this.userContext,
    this.name,
    this.username,
    this.isAdmin = false,
    this.partnerDisplayName,
    this.partnerId,
    this.isDiscountManager = false,
    this.isPriceListManager = false,
    this.userCompanies,
    this.propertyWarehouseId,
    this.defaultCurrency,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        userContext: json["user_context"] == null
            ? null
            : UserContext.fromJson(json["user_context"]),
        name: json["name"],
        isAdmin: json["is_admin"],
        username: json["username"],
        partnerDisplayName: json["partner_display_name"],
        isDiscountManager: json["is_discount_manager"],
        isPriceListManager: json["is_pricelist_manager"],
        partnerId: json["partner_id"],
        userCompanies: json["user_companies"] == null
            ? null
            : UserCompanies.fromJson(json["user_companies"]),
        propertyWarehouseId: json["property_warehouse_id"],
        defaultCurrency: json["default_currency"] == null
            ? null
            : DefaultCurrency.fromJson(json["default_currency"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "partner_display_name": partnerDisplayName,
        "partner_id": partnerId,
        "is_admin": isAdmin,
        "user_companies": userCompanies?.toJson(),
        "property_warehouse_id": propertyWarehouseId,
        "is_discount_manager": isDiscountManager,
        "is_pricelist_manager": isPriceListManager,
        "default_currency": defaultCurrency?.toJson(),
      };
}

class DefaultCurrency {
  int? id;
  dynamic name;
  dynamic symbol;
  dynamic position;

  DefaultCurrency({
    this.id,
    this.name,
    this.symbol,
    this.position,
  });

  factory DefaultCurrency.fromJson(Map<String, dynamic> json) =>
      DefaultCurrency(
        id: json["id"],
        name: json["name"],
        symbol: json["symbol"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "position": position,
      };
}

class UserCompanies {
  int? currentCompany;

  UserCompanies({
    this.currentCompany,
  });

  factory UserCompanies.fromJson(Map<String, dynamic> json) => UserCompanies(
        currentCompany: json["current_company"],
      );

  Map<String, dynamic> toJson() => {
        "current_company": currentCompany,
      };
}

class UserContext {
  int? uid;

  UserContext({
    this.uid,
  });

  factory UserContext.fromJson(Map<String, dynamic> json) => UserContext(
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
      };
}

class UserId {
  int? id;

  UserId({
    this.id,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
