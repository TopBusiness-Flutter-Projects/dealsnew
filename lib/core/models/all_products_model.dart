// // ignore_for_file: non_constant_identifier_names

// class AllProductsModel {
//   int? count;
//   dynamic prev;
//   int? current;
//   dynamic next;
//   int? totalPages;
//   List<ProductModelData>? result;

//   AllProductsModel({
//     this.count,
//     this.prev,
//     this.current,
//     this.next,
//     this.totalPages,
//     this.result,
//   });

//   factory AllProductsModel.fromJson(Map<String, dynamic> json) =>
//       AllProductsModel(
//         count: json["count"],
//         prev: json["prev"],
//         current: json["current"],
//         next: json["next"],
//         totalPages: json["total_pages"],
//         result: json["result"] == null
//             ? []
//             : List<ProductModelData>.from(
//                 json["result"]!.map((x) => ProductModelData.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "count": count,
//         "prev": prev,
//         "current": current,
//         "next": next,
//         "total_pages": totalPages,
//         "result": result == null
//             ? []
//             : List<dynamic>.from(result!.map((x) => x.toJson())),
//       };
// }

// class ProductModelData {
//   int? id;
//   String? name;
//   double? listPrice;
//   dynamic categId;
//   dynamic uomName;
//   int? uomId;
//   CurrencyId? currencyId;
//   int userOrderedQuantity;
//   dynamic qtyAvailable;
//   List<int>? taxesId;
//   dynamic image1920;
//   double discount;
//   ProductModelData({
//     this.id,
//     this.name,
//     this.listPrice,
//     this.taxesId,
//     this.uomName,
//     this.uomId,
//     this.categId,
//     this.qtyAvailable,
//     this.image1920 = false,
//     this.currencyId,
//     this.userOrderedQuantity = 0,
//     this.discount = 0,
//   });

//   factory ProductModelData.fromJson(Map<String, dynamic> json) =>
//       ProductModelData(
//         id: json["id"],
//         name: json["name"],
//         listPrice: json["list_price"]?.toDouble(),
//         currencyId: json["currency_id"] == null
//             ? null
//             : CurrencyId.fromJson(json["currency_id"]),
//         uomName: json["uom_name"],
//         uomId: json["uom_id"],
//         taxesId: json["taxes_id"] == null
//             ? []
//             : List<int>.from(json["taxes_id"]!.map((x) => x)),
//         qtyAvailable: json["qty_available"],
//         categId: json["categ_id"],
//         image1920: json["image_1920"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "list_price": listPrice,
//         "currency_id": currencyId?.toJson(),
//         "uom_name": uomName,
//         "qty_available": qtyAvailable,
//         "uom_id": uomId,
//         "categ_id": categId,
//         "taxes_id":
//             taxesId == null ? [] : List<dynamic>.from(taxesId!.map((x) => x)),
//         "image_1920": image1920,
//       };
// }

// class CurrencyId {
//   String? name;

//   CurrencyId({
//     this.name,
//   });

//   factory CurrencyId.fromJson(Map<String, dynamic> json) => CurrencyId(
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//       };
// }
// To parse this JSON data, do
//
//     final allProductsModel = allProductsModelFromJson(jsonString);

import 'dart:convert';

AllProductsModel allProductsModelFromJson(String str) =>
    AllProductsModel.fromJson(json.decode(str));

String allProductsModelToJson(AllProductsModel data) =>
    json.encode(data.toJson());

class AllProductsModel {
  ProductsResult? result;

  AllProductsModel({
    this.result,
  });

  factory AllProductsModel.fromJson(Map<String, dynamic> json) =>
      AllProductsModel(
        result: json["result"] == null ? null : ProductsResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
      };
}

class ProductsResult {
  List<ProductModelData>? products;
  dynamic totalProducts;
  dynamic limit;
  dynamic page;
  dynamic totalPages;

  ProductsResult({
    this.products,
    this.totalProducts,
    this.limit,
    this.page,
    this.totalPages,
  });

  factory ProductsResult.fromJson(Map<String, dynamic> json) => ProductsResult(
        products: json["products"] == null
            ? []
            : List<ProductModelData>.from(
                json["products"]!.map((x) => ProductModelData.fromJson(x))),
        totalProducts: json["total_products"],
        limit: json["limit"],
        page: json["page"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "total_products": totalProducts,
        "limit": limit,
        "page": page,
        "total_pages": totalPages,
      };
}

class ProductModelData {
  int? id;
  String? name;
  double? listPrice;
  dynamic categId;
  dynamic uomName;
  int userOrderedQuantity;
  List<int>? taxesId;
  dynamic image1920;
  double discount;

  //  int? productId;
  // String? name;
  // int? price;
  dynamic cost;
  // Uom? uom;
  dynamic defaultCode;
  dynamic barcode;
  // dynamic image;
  List<Category>? categories;
  dynamic stockQuantity;
  ProductModelData({
    this.id,
    this.name,
    this.listPrice,
    this.cost,
    this.uomName,
    this.defaultCode,
    this.barcode,
    this.image1920,
    this.categories,
    this.stockQuantity,
    this.userOrderedQuantity = 0,
    this.discount = 0,
  });

  factory ProductModelData.fromJson(Map<String, dynamic> json) =>
      ProductModelData(
        id: json["product_id"],
        name: json["name"],
        listPrice: json["price"],
        cost: json["cost"],
        uomName: json["uom"],
        defaultCode: json["default_code"],
        barcode: json["barcode"],
        image1920: json["image"],
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        stockQuantity: json["stock_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": id,
        "name": name,
        "price": listPrice,
        "cost": cost,
        "uom": uomName,
        "default_code": defaultCode,
        "barcode": barcode,
        "image": image1920,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "stock_quantity": stockQuantity,
      };
}

class Category {
  int? categoryId;
  dynamic categoryName;

  Category({
    this.categoryId,
    this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
      };
}
