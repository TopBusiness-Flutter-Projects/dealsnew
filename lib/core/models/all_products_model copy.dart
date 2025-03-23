// // To parse this JSON data, do
// //
// //     final allProductsModel = allProductsModelFromJson(jsonString);

// import 'dart:convert';

// AllProductsModel allProductsModelFromJson(String str) =>
//     AllProductsModel.fromJson(json.decode(str));

// String allProductsModelToJson(AllProductsModel data) =>
//     json.encode(data.toJson());

// class AllProductsModel {
//   Result? result;

//   AllProductsModel({
//     this.result,
//   });

//   factory AllProductsModel.fromJson(Map<String, dynamic> json) =>
//       AllProductsModel(
//         result: json["result"] == null ? null : Result.fromJson(json["result"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "result": result?.toJson(),
//       };
// }

// class Result {
//   List<ProductModelData>? products;
//   dynamic totalProducts;
//   dynamic limit;
//   dynamic page;
//   dynamic totalPages;

//   Result({
//     this.products,
//     this.totalProducts,
//     this.limit,
//     this.page,
//     this.totalPages,
//   });

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         products: json["products"] == null
//             ? []
//             : List<ProductModelData>.from(
//                 json["products"]!.map((x) => ProductModelData.fromJson(x))),
//         totalProducts: json["total_products"],
//         limit: json["limit"],
//         page: json["page"],
//         totalPages: json["total_pages"],
//       );

//   Map<String, dynamic> toJson() => {
//         "products": products == null
//             ? []
//             : List<dynamic>.from(products!.map((x) => x.toJson())),
//         "total_products": totalProducts,
//         "limit": limit,
//         "page": page,
//         "total_pages": totalPages,
//       };
// }

// class ProductModelData {
//   int? id;
//   String? name;
//   double? listPrice;
//   dynamic categId;
//   dynamic uomName;
//   int userOrderedQuantity;
//   List<int>? taxesId;
//   dynamic image1920;
//   double discount;

//   //  int? productId;
//   // String? name;
//   // int? price;
//   dynamic cost;
//   // Uom? uom;
//   dynamic defaultCode;
//   dynamic barcode;
//   // dynamic image;
//   List<Category>? categories;
//   dynamic stockQuantity;
//   ProductModelData({
//     this.id,
//     this.name,
//     this.listPrice,
//     this.cost,
//     this.uomName,
//     this.defaultCode,
//     this.barcode,
//     this.image1920,
//     this.categories,
//     this.stockQuantity,
//     this.userOrderedQuantity = 0,
//     this.discount = 0,
//   });

//   factory ProductModelData.fromJson(Map<String, dynamic> json) =>
//       ProductModelData(
//         id: json["product_id"],
//         name: json["name"],
//         listPrice: json["price"],
//         cost: json["cost"],
//         uomName: json["uom"],
//         defaultCode: json["default_code"],
//         barcode: json["barcode"],
//         image1920: json["image"],
//         categories: json["categories"] == null
//             ? []
//             : List<Category>.from(
//                 json["categories"]!.map((x) => Category.fromJson(x))),
//         stockQuantity: json["stock_quantity"],
//       );

//   Map<String, dynamic> toJson() => {
//         "product_id": id,
//         "name": name,
//         "price": listPrice,
//         "cost": cost,
//         "uom": uomName,
//         "default_code": defaultCode,
//         "barcode": barcode,
//         "image": image1920,
//         "categories": categories == null
//             ? []
//             : List<dynamic>.from(categories!.map((x) => x.toJson())),
//         "stock_quantity": stockQuantity,
//       };
// }

// class Category {
//   int? categoryId;
//   dynamic categoryName;

//   Category({
//     this.categoryId,
//     this.categoryName,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//         categoryId: json["category_id"],
//         categoryName: json["category_name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "category_id": categoryId,
//         "category_name": categoryName,
//       };
// }
