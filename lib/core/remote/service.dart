// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:top_sale/core/api/end_points.dart';
import 'package:top_sale/core/error/exceptions.dart';
import 'package:top_sale/core/error/failures.dart';
import 'package:top_sale/core/models/add_time_off.dart';
import 'package:top_sale/core/models/all_journals_model.dart';
import 'package:top_sale/core/models/all_partners_for_reports_model.dart';
import 'package:top_sale/core/models/all_payments_model.dart';
import 'package:top_sale/core/models/all_pricelists_model.dart';
import 'package:top_sale/core/models/all_products_model.dart';
import 'package:top_sale/core/models/all_tasks_model.dart';
import 'package:top_sale/core/models/all_ware_house_model.dart';
import 'package:top_sale/core/models/approve_expenses_model.dart';
import 'package:top_sale/core/models/category_model.dart';
import 'package:top_sale/core/models/check_employee_model.dart';
import 'package:top_sale/core/models/create_expenses_mosel.dart';
import 'package:top_sale/core/models/create_order_model.dart';
import 'package:top_sale/core/models/defaul_model.dart';
import 'package:top_sale/core/models/get__my_expense_model.dart';
import 'package:top_sale/core/models/get_all_attendance_model.dart';
import 'package:top_sale/core/models/get_all_expenses_product_model.dart';
import 'package:top_sale/core/models/get_all_promotions.dart';
import 'package:top_sale/core/models/get_all_users_model.dart';
import 'package:top_sale/core/models/get_car_ids_model.dart';
import 'package:top_sale/core/models/get_contract_model.dart';
import 'package:top_sale/core/models/get_employee_data_model.dart';
import 'package:top_sale/core/models/get_last_attendance_model.dart';
import 'package:top_sale/core/models/get_orders_model.dart';
import 'package:top_sale/core/models/get_pickings_model.dart';
import 'package:top_sale/core/models/get_shippind.dart';
import 'package:top_sale/core/models/get_user_data_model.dart';
import 'package:top_sale/core/models/login_model.dart';
import 'package:top_sale/core/models/order_details_model.dart';
import 'package:top_sale/core/models/partner_model.dart';
import 'package:top_sale/core/models/return_model.dart';
import 'package:top_sale/core/models/returned_order_model.dart';
import 'package:top_sale/core/models/rigister_payment_model.dart';
import 'package:top_sale/core/preferences/preferences.dart';
import 'package:top_sale/core/utils/app_strings.dart';
import '../api/base_api_consumer.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import '../models/all_salary_model.dart';
import '../models/car_details_model.dart';
import '../models/holidays_model.dart';
import '../models/holidays_type_model.dart';
import '../models/update_state.dart';

class ServiceApi {
  final BaseApiConsumer dio;
  ServiceApi(this.dio);
  Future<String> getSessionId(
      {required String phone,
      required String password,
      required String baseUrl,
      required String database}) async {
    try {
      final odoo = OdooClient(baseUrl);
      final odoResponse = await odoo.authenticate(database, phone, password);
      final sessionId = odoResponse.id;
      debugPrint("getSessionId = $sessionId");
      await Preferences.instance.setSessionId(sessionId);
      return sessionId;
    } on OdooException catch (e) {
      return "error";
    }
  }

  Future<Either<Failure, AllTasksModel>> getAllTasks(
      {required String state}) async {
    try {
      String userId = await Preferences.instance.getUserId() ?? "1";

      String? sessionId = await Preferences.instance.getSessionId();
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.get(
        odooUrl + EndPoints.getTasks + '?user_id=$userId&state=$state',
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(AllTasksModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<ServerFailure, AuthModel>> login(
      {required String phoneOrMail,
      required String password,
      required String baseUrl,
      required String database}) async {
    String sessionId = await getSessionId(
        phone: phoneOrMail,
        password: password,
        baseUrl: baseUrl,
        database: database);
    if (sessionId == 'error') {
      return Left(ServerFailure(message: "server_error".tr()));
    } else {
      try {
        final response = await dio.post(
          baseUrl + EndPoints.auth,
          options: Options(
            headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
          ),
          body: {
            "params": {
              'login': phoneOrMail,
              "password": password,
              "db": database
            },
          },
        );
        return Right(AuthModel.fromJson(response));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }
  }

  Future<Either<Failure, DefaultModel>> updateUserData({
    required dynamic image,
    required String name,
    required String mobile,
    required String email,
  }) async {
    String? sessionId = await Preferences.instance.getSessionId();
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String userId = await Preferences.instance.getUserId() ?? "1";
    try {
      final response = await dio.put(odooUrl + EndPoints.resUsers,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "filter": [
                [
                  "user_ids",
                  "=",
                  [userId]
                ]
              ],
              "data": {
                "image_1920": image, //base_64
                "phone": mobile,
                "name": name,
                "email": email,
                // "password": password
              }
            }
          });
      return Right(DefaultModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, DefaultModel>> updatePartnerLatLong({
    required double lat,
    required double long,
  }) async {
    String? sessionId = await Preferences.instance.getSessionId();
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String partnerId = await Preferences.instance.getEmployeePartnerId() ?? "1";
    try {
      final response = await dio.put(odooUrl + EndPoints.resPartner,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "filter": [
                ["id", "=", int.parse(partnerId)]
              ],
              "data": {"partner_latitude": lat, "partner_longitude": long}
            }
          });
      return Right(DefaultModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, DefaultModel>> tracking({
    required double lat,
    required double long,
    required int carId,
    required String date,
    required String name,
  }) async {
    String? sessionId = await Preferences.instance.getSessionId();
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String partnerId = await Preferences.instance.getEmployeePartnerId() ?? "1";
    try {
      final response = await dio.post(
          odooUrl +
              EndPoints
                  .fleetLogs, //   /api/fleet.vehicle/$carId?query={id,name,license_plate,image_128}
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "data": {
                "name": name,
                "vehicle_id": carId,
                "driver_id": int.parse(partnerId),
                "latitude": lat,
                "longitude": long,
                "date": date
              }
            }
          });
      return Right(DefaultModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, DefaultModel>> updateEmployeeData({
    required dynamic image,
    required String name,
    required String mobile,
    required String email,
  }) async {
    String? sessionId = await Preferences.instance.getSessionId();
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String employeeId = await Preferences.instance.getEmployeeId() ?? "1";
    try {
      final response = await dio.put(odooUrl + EndPoints.checkEmployee,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "filter": [
                ["id", "=", employeeId]
              ],
              "data": {
                "name": name,
                "work_phone": mobile,
                "image_1920": image, //base_64
                "work_email": email
              }
            }
          });
      return Right(DefaultModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, CheckEmployeeModel>> checkEmployee(
      {required String employeeId, required String password}) async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.get(
        odooUrl +
            EndPoints.checkEmployee +
            '?query={id,name,work_contact_id,message_partner_ids{id}}&filter=[["barcode","=","$employeeId"],["pin","=","$password"]]',
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(CheckEmployeeModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, CheckEmployeeModel>> checkEmployeeNumber(
      {required String employeeId}) async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.get(
        odooUrl +
            EndPoints.checkEmployee +
            '?query={id,name,work_contact_id,message_partner_ids{id}}&filter=[["barcode","=","$employeeId"]]',
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(CheckEmployeeModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetUserDataModel>> getUserData() async {
    try {
      String userId = await Preferences.instance.getUserId() ?? "1";
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

      String? sessionId = await Preferences.instance.getSessionId();
      final response = await dio.get(
        odooUrl +
            EndPoints.getUserData +
            '$userId?query={id, name,partner_id,image_1920,login}',
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(GetUserDataModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, CarDetails>> getCarDetails(
      {required int carId}) async {
    try {
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

      String? sessionId = await Preferences.instance.getSessionId();
      final response = await dio.get(
        odooUrl +
            '/api/fleet.vehicle/$carId?query={id,name,license_plate,image_128}',
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(CarDetails.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetEmployeeDataModel>> getEmployeeData() async {
    try {
      String employeeId = await Preferences.instance.getEmployeeId() ?? "1";
      String? sessionId = await Preferences.instance.getSessionId();
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

      final response = await dio.get(
        odooUrl +
            EndPoints.checkEmployee +
            '$employeeId?query={id, name,image_1920,work_phone,work_email,warehouse_id}',
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(GetEmployeeDataModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetCarIdsModel>> getEmployeeCarId() async {
    try {
      String employeeId = await Preferences.instance.getEmployeeId() ??
          await Preferences.instance.getEmployeeIdNumber() ??
          "1";
      String? sessionId = await Preferences.instance.getSessionId();
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

      final response = await dio.get(
        odooUrl +
            EndPoints.checkEmployee +
            '$employeeId?query={car_ids{id,name}}',
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(GetCarIdsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, CategoriesModel>> getAllCategories() async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

      final response = await dio.get(
        odooUrl + EndPoints.allCategoriesUrl,
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );

      return Right(CategoriesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

//getAllProducts
  Future<Either<Failure, AllProductsModel>> getAllProducts(
      int page, bool isStockOnly,
      {int? priceListId}) async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      AuthModel? authModel = await Preferences.instance.getUserModel();
      int? wareHouseId = await Preferences.instance.getEmployeeWareHouse();
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.post(
        odooUrl + EndPoints.products,
        // '?filter=[["detailed_type","=","product"]]&query={id,name,image_1920,list_price,taxes_id,uom_name,uom_id,qty_available,categ_id,currency_id{name}}&page_size=10&limit=10&page=$page',
        // '?filter=[["detailed_type","=","product"],["virtual_available","!=",0.0]]&query={id,name,image_1920,categ_id,list_price,currency_id,taxes_id,uom_name,uom_id,description_sale,virtual_available,image_1920}&page_size=10&limit=10&page=$page',
        body: {
          "params": {
            "warehouse_id":
                wareHouseId ?? authModel.result?.propertyWarehouseId ?? 1,
            "limit": 20,
            "page": page,
            "category_id": null,
            "pricelist_id": priceListId,
            "in_stock_only": isStockOnly
          }
        },
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(AllProductsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, AllProductsModel>> getAllProductsByCategory(
      int? page, bool isStockOnly,
      {required int categoryId, int? priceListId}) async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      int? wareHouseId = await Preferences.instance.getEmployeeWareHouse();
      AuthModel? authModel = await Preferences.instance.getUserModel();
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.post(
        odooUrl + EndPoints.products,
        // '?filter=[["detailed_type","=","product"]]&query={id,name,image_1920,list_price,taxes_id,uom_name,uom_id,qty_available,categ_id,currency_id{name}}&page_size=10&limit=10&page=$page',
        // '?filter=[["detailed_type","=","product"],["virtual_available","!=",0.0]]&query={id,name,image_1920,categ_id,list_price,currency_id,taxes_id,uom_name,uom_id,description_sale,virtual_available,image_1920}&page_size=10&limit=10&page=$page',
        body: {
          "params": {
            "warehouse_id":
                wareHouseId ?? authModel.result?.propertyWarehouseId ?? 1,
            "limit": 20,
            "page": page,
            "category_id": categoryId,
            "pricelist_id": priceListId,
            "in_stock_only": isStockOnly
          }
        },
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );

      return Right(AllProductsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, AllProductsModel>> searchProducts(
      int page, String name, bool isBarcode,
      {int? priceListId}) async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      AuthModel? authModel = await Preferences.instance.getUserModel();
      int? wareHouseId = await Preferences.instance.getEmployeeWareHouse();
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.post(
        odooUrl + EndPoints.productSearch,
        // '?filter=[["detailed_type","=","product"]]&query={id,name,image_1920,list_price,taxes_id,uom_name,uom_id,qty_available,categ_id,currency_id{name}}&page_size=10&limit=10&page=$page',
        // '?filter=[["detailed_type","=","product"],["virtual_available","!=",0.0]]&query={id,name,image_1920,categ_id,list_price,currency_id,taxes_id,uom_name,uom_id,description_sale,virtual_available,image_1920}&page_size=10&limit=10&page=$page',
        body: {
          "params": {
            "data": {
              "warehouse_id":
                  wareHouseId ?? authModel.result?.propertyWarehouseId ?? 1,
              "name": isBarcode
                  ? null
                  : name, // Optional: Product name or part of the name
              "code": null, // Optional: Product code (can be null if not used)
              "barcode": isBarcode
                  ? name
                  : null, // Optional: Product barcode (can be null if not used)
              "pricelist_id": priceListId
              // Optional: Price list ID to calculate product prices
            }
          }
        },
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(AllProductsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  //   Future<Either<Failure, AllProductsModel>> searchProducts(
  //     int page, String name, bool isBarcode) async {
  //   try {
  //     String? sessionId = await Preferences.instance.getSessionId();

  //     String odooUrl =
  //         await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
  //     final response = await dio.get(
  //       isBarcode
  //           ? odooUrl +
  //               EndPoints.allProducts +
  //               '?filter=[["detailed_type","=","product"],["barcode","=","$name"]]&query={id,name,image_1920,list_price,taxes_id,uom_name,uom_id,qty_available,categ_id,currency_id{name}}&page_size=10&limit=10&page=$page'
  //           : odooUrl +
  //               EndPoints.allProducts +
  //               '?filter=[["detailed_type","=","product"],["name", "=like", "%$name%"]]&query={id,name,image_1920,list_price,taxes_id,uom_name,uom_id,qty_available,categ_id,currency_id{name}}&page_size=10&limit=10&page=$page',
  //       options: Options(
  //         headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
  //       ),
  //     );
  //     return Right(AllProductsModel.fromJson(response));
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   }
  // }
// //getAllProducts
//   Future<Either<Failure, AllProductsModel>> getAllProducts(int page) async {
//     try {
//       String? sessionId = await Preferences.instance.getSessionId();
//       String odooUrl =
//           await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
//       final response = await dio.get(
//         odooUrl +
//             EndPoints.allProducts +
//             '?filter=[["detailed_type","=","product"]]&query={id,name,image_1920,list_price,taxes_id,uom_name,uom_id,qty_available,categ_id,currency_id{name}}&page_size=10&limit=10&page=$page',
//         // '?filter=[["detailed_type","=","product"],["virtual_available","!=",0.0]]&query={id,name,image_1920,categ_id,list_price,currency_id,taxes_id,uom_name,uom_id,description_sale,virtual_available,image_1920}&page_size=10&limit=10&page=$page',
//         options: Options(
//           headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
//         ),
//       );
//       return Right(AllProductsModel.fromJson(response));
//     } on ServerException {
//       return Left(ServerFailure());
//     }
//   }

//   Future<Either<Failure, AllProductsModel>> getAllProductsByCategory(int? page,
//       {required int categoryId}) async {
//     try {
//       String? sessionId = await Preferences.instance.getSessionId();
//       String odooUrl =
//           await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
//       final response = await dio.get(
//         odooUrl +
//             EndPoints.allProducts +
//             '?filter=[["detailed_type","=","product"],["categ_id", "=", $categoryId]]&query={id,name,image_1920,list_price,taxes_id,uom_name,uom_id,qty_available,categ_id,currency_id{name}}&page_size=10&limit=10&page=$page',
//         // '?filter=[["detailed_type","=","product"],["virtual_available","!=",0.0]]&query={id,name,image_1920,categ_id,list_price,currency_id,taxes_id,uom_name,uom_id,description_sale,virtual_available,image_1920}&page_size=10&limit=10&page=$page',

//         // queryParameters: {
//         //   'filter': '[["categ_id", "=", [$categoryId]]',
//         //   'query':
//         //       '{id,name,list_price,taxes_id,uom_name,uom_id,virtual_available,categ_id}'
//         // },
//         options: Options(
//           headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
//         ),
//       );

//       return Right(AllProductsModel.fromJson(response));
//     } on ServerException {
//       return Left(ServerFailure());
//     }
//   }

  Future<Either<Failure, GetAllPartnersModel>> getAllPartnersForReport(
      int page, int pageSize,
      {required bool isUserOnly}) async {
    try {
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      String? sessionId = await Preferences.instance.getSessionId();
      String userId = await Preferences.instance.getUserId() ?? "1";
      final response = await dio.get(
        isUserOnly
            ? odooUrl +
                EndPoints.getAllPartners +
                '?page_size=20&page=$page&query={name,id,phone,image_1920,property_product_pricelist}&filter=[["user_id", "=",$userId],["state", "=", "approved"]]'
            : odooUrl +
                EndPoints.getAllPartners +
                '?page_size=20&page=$page&query={name,id,phone,image_1920,property_product_pricelist}&filter=[["state", "=", "approved"]]',
        // '?page_size=$pageSize&page=$page&query={name,id,phone,total_overdue,total_due,total_invoiced,credit_to_invoice,sale_order_ids}',
        // 'page_size=$pageSize&page=$page&filter=[["user_id", "=",${authModel.result!.userContext!.uid}]]&query={name,id,phone,total_overdue,total_due,total_invoiced,credit_to_invoice,sale_order_ids}',
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      return Right(GetAllPartnersModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetAllPartnersModel>> searchUsers(
      {required int page,
      required String name,
      required bool isUserOnly}) async {
    try {
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      String? sessionId = await Preferences.instance.getSessionId();
      String userId = await Preferences.instance.getUserId() ?? "1";

      final response = await dio.get(
        isUserOnly
            ? odooUrl +
                EndPoints.getAllPartners +
                '?filter=[["name", "=like", "%$name%"],["state", "=", "approved"],["user_id", "=",$userId]]&query={name,id,phone,image_1920,property_product_pricelist}&page_size=20&page=$page'
            : odooUrl +
                EndPoints.getAllPartners +
                '?filter=[["name", "=like", "%$name%"],["state", "=", "approved"]]&query={name,id,phone,image_1920,property_product_pricelist}&page_size=20&page=$page',
        // 'filter=[["name", "=like", "%$name%"],["user_id", "=",${authModel.result!.userContext!.uid}]]&query={name,id,phone,total_overdue,total_due,total_invoiced,credit_to_invoice,sale_order_ids}&page_size=20&page=$page',
        options: Options(
          headers: {"Cookie": "frontend_lang=en_US;session_id=$sessionId"},
        ),
      );
      print("lllllllllllll" + response.toString());
      return Right(GetAllPartnersModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetOrdersModel>> getOrders() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String userId = await Preferences.instance.getUserId() ?? "1";

    String? employeeId = await Preferences.instance.getEmployeeId();
    try {
      final response = await dio.get(
        employeeId == null
            ? odooUrl +
                EndPoints.saleOrder +
                '?query={id,user_id,partner_id{id,name,phone,partner_latitude,partner_longitude},currency_id{name},display_name,state,write_date,expected_date,amount_total,invoice_status,delivery_status,employee_id{id,name},amount_untaxed}&page_size=20&page=1&filter=[["delivery_status", "!=","returned"],["user_id", "=", $userId]]'
            : odooUrl +
                EndPoints.saleOrder +
                '?query={id,user_id,partner_id{id,name,phone,partner_latitude,partner_longitude},currency_id{name},display_name,state,write_date,expected_date,amount_total,invoice_status,delivery_status,employee_id{id,name},amount_untaxed}&page_size=20&page=1&filter=[["delivery_status", "!=","returned"],["user_id", "=", $userId],["employee_id", "=", $employeeId]]',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetOrdersModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetOrdersModel>> getDraftOrders() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String userId = await Preferences.instance.getUserId() ?? "1";

    String? employeeId = await Preferences.instance.getEmployeeId();
    try {
      final response = await dio.get(
        employeeId == null
            ? odooUrl +
                EndPoints.saleOrder +
                '?query={id,user_id,partner_id{id,name,phone,partner_latitude,partner_longitude},currency_id{name},display_name,state,write_date,expected_date,amount_total,invoice_status,delivery_status,employee_id{id,name},amount_untaxed}&page_size=20&page=1&filter=[["delivery_status", "!=","returned"],["user_id", "=", $userId],["state", "=", "draft"]]'
            : odooUrl +
                EndPoints.saleOrder +
                '?query={id,user_id,partner_id{id,name,phone,partner_latitude,partner_longitude},currency_id{name},display_name,state,write_date,expected_date,amount_total,invoice_status,delivery_status,employee_id{id,name},amount_untaxed}&page_size=20&page=1&filter=[["delivery_status", "!=","returned"],["user_id", "=", $userId],["employee_id", "=", $employeeId],["state", "=", "draft"]]',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetOrdersModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetOrdersModel>> getOrderFromId(int id) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response = await dio.get(
        odooUrl +
            EndPoints.saleOrder +
            '?query={id,user_id,partner_id{id,name,phone,partner_latitude,partner_longitude},currency_id{name},display_name,state,write_date,expected_date,amount_total,invoice_status,delivery_status,employee_id{id,name},amount_untaxed}&page_size=20&page=1&filter=[["delivery_status", "!=","returned"],["id", "=", $id]]',
        //             '?query={id,user_id,partner_id{id,name,phone,partner_latitude,partner_longitude},currency_id{name},display_name,state,write_date,expected_date,amount_total,invoice_status,delivery_status,employee_id{id,name}}&page_size=20&page=1&filter=[["delivery_status", "!=","started"]]',

        // '?query={id,partner_id,display_name,state,write_date,expected_date,amount_total}&filter=[["user_id", "=",1]]',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetOrdersModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, PartnerModel>> getPartnerDetails(
      {required int partnerId}) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response = await dio.get(
        odooUrl + EndPoints.partners + '?partner_id=$partnerId',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      if (response.isNotEmpty) {
        return Right(PartnerModel.fromJson(response.first));
      } else {
        return Left(ServerFailure());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, OrderDetailsModel>> getOrderDetails(
      {required int orderId}) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response = await dio.get(
        odooUrl + EndPoints.saleOrder + '$orderId/details',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(OrderDetailsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

// confirm quatation
  Future<Either<Failure, CreateOrderModel>> confirmQuotation({
    required int orderId,
    required double lat,
    required double long,
    required String address,
  }) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response =
          await dio.post(odooUrl + EndPoints.createInvoice + '$orderId/confirm',
              options: Options(
                headers: {"Cookie": "session_id=$sessionId"},
              ),
              body: {
            "jsonrpc": "2.0",
            "method": "call",
            "params": {
              "data": {
                "latitude": lat,
                "longitude": long,
                "address": address,
              }
            }
          });
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  // cancel
  Future<Either<Failure, CreateOrderModel>> cancelOrder({
    required int orderId,
    required String image,
    String? note,
    required String imagePath,
    required double lat,
    required double long,
    required String address,
  }) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response =
          await dio.post(odooUrl + EndPoints.createInvoice + '$orderId/cancel',
              options: Options(
                headers: {"Cookie": "session_id=$sessionId"},
              ),
              body: {
            "jsonrpc": "2.0",
            "method": "call",
            "params": {
              "data": {
                if (image.isNotEmpty) "attachment": image,
                if (image.isNotEmpty) "filename": imagePath,
                if (note != null) "note": note,
                "latitude": lat,
                "longitude": long,
                "address": address,
              }
            }
          });
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

// create quatation
  Future<Either<Failure, CreateOrderModel>> createQuotation(
      {required int partnerId,
      required String warehouseId,
      required List<ProductModelData> products,
      required List<PromotionModel> promotionIds,
      required double lat,
      required double long,
      required String address,
      required String image,
      required String imagePath,
      required String shippingId,
      required String priceListId,
      required String promotionId,
      required String shippingPrice,
      String? note}) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String? employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber();
    String userId = await Preferences.instance.getUserId() ?? "1";
    int? wareHouseId = await Preferences.instance.getEmployeeWareHouse();
    AuthModel? authModel = await Preferences.instance.getUserModel();
    try {
      // Map the ProductModelData list to order_line format
      List<Map<String, dynamic>> orderLine = products
          .map((product) => {
                "product_id": product.id,
                "product_uom_qty": product.userOrderedQuantity,
                "price_unit": product.listPrice,
                "discount": product.discount
              })
          .toList();
      List<int> promotions = promotionIds.map((e) => e.id!).toList();
      final response = await dio.post(odooUrl + EndPoints.createQuotation,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "data": {
                "partner_id": partnerId,
                "warehouse_id":
                    wareHouseId ?? authModel.result?.propertyWarehouseId ?? 1,
                "user_id": int.parse(userId),
                if (employeeId != null) "employee_id": employeeId,
                "latitude": lat,
                "longitude": long,
                "address": address,
                if (promotionIds.isNotEmpty) "promotion_ids": promotions,
                if (shippingId.isNotEmpty)
                  "shipping_method_id": int.parse(shippingId),
                if (priceListId.isNotEmpty)
                  "price_list_id": int.parse(priceListId),
                if (shippingPrice.isNotEmpty)
                  "shipping_cost": double.parse(shippingPrice),
                if (promotionId.isNotEmpty)
                  "promotion_id": int.parse(promotionId),
                if (image.isNotEmpty) "attachment": image,
                if (image.isNotEmpty) "filename": imagePath,
                if (note != null) "note": note,
                "order_line": orderLine
              }
            }
          });
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, ReturnOrderModel>> returnOrder(
      {required int pickingId, required List<OrderLine> products}) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String? employeeId = await Preferences.instance.getEmployeeId();
    String userId = await Preferences.instance.getUserId() ?? "1";
    // AuthModel? authModel = await Preferences.instance.getUserModel();
    try {
      // Map the ProductModelData list to order_line format
      List<Map<String, dynamic>> returnsProducts = products
          .map((product) => {
                "product_id": product.productId,
                "quantity": product.productUomQty,
              })
          .toList();

      final response =
          await dio.post(odooUrl + EndPoints.returnOrder + '$pickingId',
              options: Options(
                headers: {"Cookie": "session_id=$sessionId"},
              ),
              body: {
            //  "return_location_id":null ,
            "products": returnsProducts,
            if (employeeId != null)
              "employee_id": int.parse(employeeId.toString()),
            "user_id": int.parse(userId)
          });
      return Right(ReturnOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, DefaultModel>> updateDelivery({
    required int orderId,
  }) async {
    String? sessionId = await Preferences.instance.getSessionId();
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String userId = await Preferences.instance.getUserId() ?? "1";
    try {
      final response = await dio.put(odooUrl + EndPoints.saleOrder,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "filter": [
                ["id", "=", orderId]
              ],
              "data": {"delivery_status": "returned"}
            }
          });
      return Right(DefaultModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, DefaultModel>> updatePartenerLocation({
    required int id,
    required double partnerLattitude,
    required String street,
    required double partnerLangitude,
  }) async {
    String? sessionId = await Preferences.instance.getSessionId();
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String userId = await Preferences.instance.getUserId() ?? "1";
    try {
      final response = await dio.put(odooUrl + EndPoints.updatePartnerLocation,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "filter": [
                ["id", "=", id]
              ],
              "data": {
                "street": street,
                "partner_latitude": partnerLattitude,
                "partner_longitude": partnerLangitude,
              }
            }
          });
      return Right(DefaultModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, DefaultModel>> updatePartenerDetails({
    required int id,
    required String image1920,
    required String name,
    required String phone,
  }) async {
    String? sessionId = await Preferences.instance.getSessionId();
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String userId = await Preferences.instance.getUserId() ?? "1";
    try {
      final response = await dio.put(odooUrl + EndPoints.updatePartnerLocation,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "filter": [
                ["id", "=", id]
              ],
              "data": {
                "name": name,
                "phone": phone,
                "image_1920": image1920,
              }
            }
          });
      return Right(DefaultModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

// update quatation
  Future<Either<Failure, CreateOrderModel>> updateQuotation(
      {required int partnerId,
      required String saleOrderId,
      required List<OrderLine> products,
      required double lat,
      required double long,
      required String address,
      required List<dynamic> listOfremovedItems}) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String? employeeId = await Preferences.instance.getEmployeeId();
    String userId = await Preferences.instance.getUserId() ?? "1";
    int? wareHouseId = await Preferences.instance.getEmployeeWareHouse();
    AuthModel? authModel = await Preferences.instance.getUserModel();
    try {
      // Map the ProductModelData list to order_line format
      List<Map<String, dynamic>> orderLine = products
          .map((product) => product.productUomQty == 0
              ? {
                  "line_id":
                      product.id, // ID of the existing order line to delete
                  "delete": true // Set to true to delete this line
                }
              : {
                  "product_id": product.productId,
                  "product_uom_qty": product.productUomQty,
                  "price_unit": product.priceUnit,
                  "line_id": product.id,
                  "discount": product.discount
                })
          .toList();
      List<Map<String, dynamic>> orderLineDeleted = listOfremovedItems
          .map((product) => {
                "line_id": product, // ID of the existing order line to delete
                "delete": true // Set to true to delete this line
              })
          .toList();

      final response = await dio.post(odooUrl + EndPoints.updateQuotation,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "data": {
                "sale_order_id": int.parse(saleOrderId.toString()),
                "partner_id": partnerId,
                "latitude": lat,
                "longitude": long,
                "address": address,
                "sale_order_user_id": int.parse(userId),
                "warehouse_id":
                    wareHouseId ?? authModel.result?.propertyWarehouseId ?? 1,
                if (employeeId != null)
                  "employee_id": int.parse(employeeId.toString()),
                "order_line": [
                  ...orderLine,
                  ...orderLineDeleted,
                  //! the new item still
                  // {
                  //   "product_id": 6916, // New product to add to the quotation
                  //   "product_uom_qty": 3, // Quantity of the new product
                  //   "price_unit": 75.0, // Unit price of the new product
                  //   "discount": 5.0 // Discount percentage
                  // }
                ]
              }
            }
          });
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  //confirm delivery
  Future<Either<Failure, CreateOrderModel>> confirmDelivery({
    required int pickingId,
  }) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response =
          await dio.post(odooUrl + EndPoints.picking + '$pickingId/validate',
              options: Options(
                headers: {"Cookie": "session_id=$sessionId"},
              ),
              body: {"jsonrpc": "2.0", "method": "call", "params": {}});
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  //create and validate invoice
  Future<Either<Failure, CreateOrderModel>> createAndValidateInvoice({
    required int orderId,
  }) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response =
          await dio.post(odooUrl + EndPoints.createInvoice + '$orderId/invoice',
              options: Options(
                headers: {"Cookie": "session_id=$sessionId"},
              ),
              body: {"jsonrpc": "2.0", "method": "call", "params": {}});
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  // payment
  Future<Either<Failure, CreateOrderModel>> registerPayment(
      {required int invoiceId,
      required int journalId,
      required String amount,
      required String imagePath,
      required String image}) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response = await dio
          .post(odooUrl + EndPoints.invoice + '$invoiceId/register_payment',
              options: Options(
                headers: {"Cookie": "session_id=$sessionId"},
              ),
              body: {
            "params": {
              "journal_id": journalId,
              if (image.isNotEmpty) "attachment": image,
              if (image.isNotEmpty) "filename": imagePath,

              "payment_method_id": 1, // default
              "amount": amount
            }
          });
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

// returned order
  Future<Either<Failure, ReturnedOrderModel>> returnedOrder() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();

    String? employeeId = await Preferences.instance.getEmployeeId();
    String userId = await Preferences.instance.getUserId() ?? "1";

    try {
      final response = await dio.post(
        odooUrl + EndPoints.returnedOrder,
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
        body: {
          if (employeeId != null) "employee_id": int.parse(employeeId),
          "user_id": int.parse(userId),
        },
      );

      // Log response data for debugging

      return Right(ReturnedOrderModel.fromJson(response));
    } on ServerException {
      print("fail");
      return Left(ServerFailure());
    }
  }

  // registerPaymentreturn
  Future<Either<Failure, RegisterPaymentModel>> registerPaymentReturn(
      {required int invoiceId,
      required int journalId,
      required String amount,
      required String imagePath,
      required String image}) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();

    String? employeeId = await Preferences.instance.getEmployeeId();
    String userId = await Preferences.instance.getUserId() ?? "1";

    try {
      final response = await dio.post(
        odooUrl + "//register_payment_credit/$invoiceId",
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
        body: {
          if (employeeId != null) "employee_id": int.parse(employeeId),
          "user_id": int.parse(userId),
          "journal_id": journalId,
          if (image.isNotEmpty) "attachment": image,
          if (image.isNotEmpty) "filename": imagePath,
          "amount": double.parse(amount)
        },
      );

      // Log response data for debugging

      return Right(RegisterPaymentModel.fromJson(response));
    } on ServerException {
      print("fail");
      return Left(ServerFailure());
    }
  }

  // payment
  Future<Either<Failure, CreateOrderModel>> partnerPayment(
      {required int partnerId,
      required int journalId,
      required String amount,
      required String ref,
      required String date,
      required String imagePath,
      required String image}) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;

    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response = await dio.post(odooUrl + EndPoints.createPayment,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "params": {
              "data": {
                "partner_id": partnerId,
                "payment_type": "inbound",
                "partner_type": "customer",
                "journal_id": journalId,
                "amount": amount,
                "ref": ref,
                if (image.isNotEmpty) "attachment": image,
                if (image.isNotEmpty) "filename": imagePath,
                "date": date //"2024-05-02"
              }
            }
          });
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, AllPaymentsModel>> getAllPayments(
      String? searchKey) async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      String userId = await Preferences.instance.getUserId() ?? "1";
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.post(
        odooUrl + '/api/payments/customer',
        body: {
          "params": {
            "data": {
              "user_id": int.parse(userId),
              if (searchKey != null) "customer_name": searchKey
            }
          }
        },
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(AllPaymentsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetAllJournalsModel>> getAllJournals() async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      String employeeId = await Preferences.instance.getEmployeeId() ?? "1";
      String userId = await Preferences.instance.getUserId() ?? "1";
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.get(
        odooUrl +
            EndPoints.getAllJournals +
            '&filter=[["payment_sequence", "=","true"],"|",["user_id", "=", [$userId]],["employee_id", "=", [$employeeId]]]',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetAllJournalsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetAllShippingModel>> getAllShipping() async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      String employeeId = await Preferences.instance.getEmployeeId() ?? "1";
      String userId = await Preferences.instance.getUserId() ?? "1";
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.get(
        odooUrl + EndPoints.getAllShipping,
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetAllShippingModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetPromotionsModel>> getAllPromotions() async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      String employeeId = await Preferences.instance.getEmployeeId() ?? "1";
      String userId = await Preferences.instance.getUserId() ?? "1";
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.get(
        odooUrl + EndPoints.getAllPromotions,
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetPromotionsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetAllPriceListtsModel>> getAllPricelists() async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      String employeeId = await Preferences.instance.getEmployeeId() ?? "1";
      String userId = await Preferences.instance.getUserId() ?? "1";
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.get(
        odooUrl + EndPoints.getAllPricelists,
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetAllPriceListtsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, UpdateStateModel>> updateStateData({
    required int taskId,
    required String state,
  }) async {
    String? sessionId = await Preferences.instance.getSessionId();
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String userId = await Preferences.instance.getUserId() ?? "1";
    try {
      final response = await dio.put(odooUrl + EndPoints.updateState,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {"task_id": int.parse(taskId.toString()), "state": "1_done"});
      return Right(UpdateStateModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, CreateOrderModel>> createPartner({
    required String name,
    required String mobile,
    required String image,
    required String imagePath,
    required String email,
    required String street,
    required bool isCompany,
    required String profileImage,
    String? vat,
    required double lat,
    required double long,
  }) async {
    String? sessionId = await Preferences.instance.getSessionId();
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber();
    String userId = await Preferences.instance.getUserId() ?? "1";

    try {
      final response =
          await dio.post(odooUrl + EndPoints.createPartner + 'create',
              options: Options(
                headers: {"Cookie": "session_id=$sessionId"},
              ),
              body: {
            "params": {
              "data": {
                "name": name,
                "phone": mobile,
                "is_company": isCompany,
                if (isCompany) "company_type": "company", // if isCompany = true
                if (isCompany) "vat": vat, // if isCompany = true
                if (email.isNotEmpty) "email": email,
                "street": street,
                "latitude": lat,
                "longitude": long,
                "image": profileImage,
                if (image.isNotEmpty) "attachment": image,
                if (image.isNotEmpty) "filename": imagePath,
                "user_id": int.parse(userId),
                if (employeeId != null) "employee_id": employeeId,
              }
            }
          });
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  ////////////////////// HR //////////////
  /// Contract ///

  Future<Either<Failure, GetContractModel>> getContract() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.get(
        odooUrl + EndPoints.employee + '$employeeId/contract',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetContractModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  /// attendance ///

  Future<Either<Failure, GetAllAttendanceModel>> getAllAttendance() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.get(
        odooUrl + EndPoints.employee + '$employeeId/attendances',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetAllAttendanceModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  /// holidays ///
  Future<Either<Failure, HolidaysModel>> getHolidays() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.get(
        odooUrl + EndPoints.employee + '$employeeId/time_off_requests',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(HolidaysModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetLastAttendanceModel>> getLastAttendance() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.get(
        odooUrl + EndPoints.employee + '$employeeId/last_attendance_status',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetLastAttendanceModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, HolidaysTypeModel>> getTypeHolidays() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.get(
        odooUrl + EndPoints.employee + '$employeeId/time_off_balance',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(HolidaysTypeModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, CreateOrderModel>> checkInOutt({
    required bool isChechIn,
    required double lat,
    required double long,
    required String ip,
    required String country,
    required String city,
  }) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.post(
        odooUrl + EndPoints.employee + 'attendance',
        body: {
          "params": {
            "data": {
              "employee_id": int.parse(employeeId),
              "latitude": lat,
              "longitude": long,
              "action": isChechIn
                  ? "check_in"
                  : "check_out", //"<check_in or check_out>",
              "ip": ip, //"196.135.114.236",
              "country": country,
              "city": city
            }
          }
        },
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetMyExpensesModel>> getMyExpenses() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String userId = await Preferences.instance.getUserId() ?? "1";
    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.post(
        odooUrl + EndPoints.employee + 'my_expenses',
        body: {
          "employee_id": int.parse(employeeId),
          "user_id": int.parse(userId)
        },
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetMyExpensesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, AllSalaryModel>> getMySalary() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String userId = await Preferences.instance.getUserId() ?? "1";
    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.get(
        odooUrl + EndPoints.employee + '$employeeId/payslip_history',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(AllSalaryModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetAllExpensesProductModel>>
      getAllExpensesProduct() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    // String employeeId = await Preferences.instance.getEmployeeId() ??
    //     await Preferences.instance.getEmployeeIdNumber() ??
    //     "1";
    try {
      final response = await dio.get(
        odooUrl +
            '/api/product.product/?query={id,name,image_1920}&filter=[["can_be_expensed","=","True"]]',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GetAllExpensesProductModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, AddTimeOffModel>> addTimeOff({
    required String timeOffTypeId,
    required String reason,
    required String dateTo,
    required String dateFrom,
  }) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.post(
        odooUrl + EndPoints.employee + 'time_off',
        body: {
          "params": {
            "data": {
              "employee_id": int.parse(employeeId),
              "date_to": dateTo,
              "date_from": dateFrom,
              "reason": reason,
              "time_off_type_id": int.parse(timeOffTypeId)
              // "employee_id": int.parse(employeeId),
              // "reason":"iam sick",
              // "date_from": "2025-9-28",
              // "date_to": "2025-9-30",
              // "time_off_type_id": 2
            }
          }
        },
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(AddTimeOffModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, CreateExpensesProductModel>> createExpense({
    required String path,
    required String amount,
    required int productId,
    required String description,
  }) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String userId = await Preferences.instance.getUserId() ?? "1";

    String employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber() ??
        "1";
    try {
      final response = await dio.post(
        odooUrl + '/api/expense/create',
        body: {
          "description": description,
          "employee_id": int.parse(employeeId),
          // "date": "2024-10-21",
          "amount": amount,
          "user_id": int.parse(userId),
          "product_id": productId,
          if (path.isNotEmpty) "attachment": await MultipartFile.fromFile(path)
          // "attachment": [
          //   "$path"
          //   //await MultipartFile.fromFile(path)
          // ]
        },
        formDataIsEnabled: true,
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(CreateExpensesProductModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, ApproveExpensesModel>> approveExpense({
    required int journalId,
    required int expenseId,
  }) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    // String employeeId = await Preferences.instance.getEmployeeId() ??
    //     await Preferences.instance.getEmployeeIdNumber() ??
    //     "1";
    try {
      final response = await dio.post(
        odooUrl + '/api/manager/approve_expense',
        body: {"expense_id": expenseId, "journal_id": journalId},
        // formDataIsEnabled: true,
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(ApproveExpensesModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, CreateOrderModel>> createPicking(
      {required int sourceWarehouseId,
      required String image,
      int? destinationWareHouseId,
      required String note,
      int? partnerId,
      required String imagePath,
      required List<UserModel> users,
      required List<ProductModelData> products}) async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String? employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber();
    String userId = await Preferences.instance.getUserId() ?? "1";
    int? wareHouseId = await Preferences.instance.getEmployeeWareHouse();
    AuthModel? authModel = await Preferences.instance.getUserModel();
    try {
      List<Map<String, dynamic>> orderLine = products
          .map((product) => {
                "product_id": product.id,
                "quantity": product.userOrderedQuantity,
              })
          .toList();
      List<int> selectedsers = users.map((user) => user.id!).toList();

      final response = await dio.post(odooUrl + EndPoints.createPicking,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "jsonrpc": "2.0",
            "method": "call",
            "params": {
              //  "data": {
              "source_warehouse_id": sourceWarehouseId,

              if (image.isNotEmpty) "attachment": image,
              if (image.isNotEmpty) "attachmentname": imagePath,
              if (note.isNotEmpty) "message": note,
              if (partnerId != null) "partner_id": partnerId,
              "users": selectedsers,
              "destination_warehouse_id": destinationWareHouseId ??
                  wareHouseId ??
                  authModel.result?.propertyWarehouseId ??
                  1,
              "user_id": int.parse(userId),
              if (employeeId != null) "employee_id": employeeId,
              "products": orderLine
              //   }
            }
          });
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GetPickingsModel>> getPicking() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    String? employeeId = await Preferences.instance.getEmployeeId() ??
        await Preferences.instance.getEmployeeIdNumber();
    String userId = await Preferences.instance.getUserId() ?? "1";

    try {
      final response = await dio.post(odooUrl + EndPoints.getPicking,
          options: Options(
            headers: {"Cookie": "session_id=$sessionId"},
          ),
          body: {
            "jsonrpc": "2.0",
            "method": "call",
            "params": {
              "user_id": int.parse(userId),
              if (employeeId != null) "employee_id": int.parse(employeeId)
            }
          });
      return Right(GetPickingsModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, AllWareHouseModel>> getWareHouses() async {
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response = await dio.get(
        odooUrl + EndPoints.wareHouse + '?query={id,name}',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(AllWareHouseModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, CreateOrderModel>> createTask({
    required String description,
    required String title,
    required String deadline,
  }) async {
    String userId = await Preferences.instance.getUserId() ?? "1";

    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response = await dio.post(
        odooUrl + EndPoints.createTask,
        body: {
          "title": title,
          "description": description,
          "user_id": int.parse(userId),
          // "stage_id": 8,
          "deadline": deadline
        },
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(CreateOrderModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, WareHouse>> getWareHouseById() async {
    AuthModel? authModel = await Preferences.instance.getUserModel();

    int id = await Preferences.instance.getEmployeeWareHouse() ??
        authModel.result?.propertyWarehouseId ??
        1;
    bool isVisitor = await Preferences.instance.getIsVisitor();
    String odooUrl = isVisitor
        ? AppStrings.demoBaseUrl
        : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String? sessionId = await Preferences.instance.getSessionId();
    try {
      final response = await dio.get(
        odooUrl + EndPoints.wareHouse + '$id?query={id,name}',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(WareHouse.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, GeyAllUsersModel>> getAllUsers() async {
    try {
      String? sessionId = await Preferences.instance.getSessionId();
      // String userId = await Preferences.instance.getUserId() ?? "1";
      bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl = isVisitor
          ? AppStrings.demoBaseUrl
          : await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
      final response = await dio.get(
        odooUrl + '/api/res.users/?query={id,name}',
        options: Options(
          headers: {"Cookie": "session_id=$sessionId"},
        ),
      );
      return Right(GeyAllUsersModel.fromJson(response));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
