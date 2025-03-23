// To parse this JSON data, do
//
//     final getPickingsModel = getPickingsModelFromJson(jsonString);

import 'dart:convert';

GetPickingsModel getPickingsModelFromJson(String str) => GetPickingsModel.fromJson(json.decode(str));

String getPickingsModelToJson(GetPickingsModel data) => json.encode(data.toJson());

class GetPickingsModel {
   
    Result? result;

    GetPickingsModel({
     
        this.result,
    });

    factory GetPickingsModel.fromJson(Map<String, dynamic> json) => GetPickingsModel(
    
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
      
        "result": result?.toJson(),
    };
}

class Result {
    String? message;
    List<Datum>? data;

    Result({
        this.message,
        this.data,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? pickingId;
    dynamic transferName;
    dynamic status;
    dynamic scheduledDate;
    dynamic dateDone;
    dynamic employeeId;
    dynamic userId;
    SourceLocation? sourceLocation;
    DestinationLocation? destinationLocation;
    List<MoveLine>? moveLines;

    Datum({
        this.pickingId,
        this.transferName,
        this.status,
        this.scheduledDate,
        this.dateDone,
        this.employeeId,
        this.userId,
        this.sourceLocation,
        this.destinationLocation,
        this.moveLines,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        pickingId: json["picking_id"],
        transferName: json["transfer_name"],
        status: json["status"],
        scheduledDate: json["scheduled_date"],
        dateDone: json["date_done"],
        employeeId: json["employee_id"],
        userId: json["user_id"],
        sourceLocation: json["source_location"] == null ? null : SourceLocation.fromJson(json["source_location"]),
        destinationLocation: json["destination_location"] == null ? null : DestinationLocation.fromJson(json["destination_location"]),
        moveLines: json["move_lines"] == null ? [] : List<MoveLine>.from(json["move_lines"]!.map((x) => MoveLine.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "picking_id": pickingId,
        "transfer_name": transferName,
        "status": status,
        "scheduled_date": scheduledDate,
        "date_done": dateDone,
        "employee_id": employeeId,
        "user_id": userId,
        "source_location": sourceLocation,
        "destination_location": destinationLocation,
        "move_lines": moveLines == null ? [] : List<dynamic>.from(moveLines!.map((x) => x.toJson())),
    };
}

class DestinationLocation {
    int? locationDestId;
   dynamic locationDestName;
   dynamic wareHouseName;

    DestinationLocation({
        this.locationDestId,
        this.locationDestName,
        this.wareHouseName,
    });

    factory DestinationLocation.fromJson(Map<String, dynamic> json) => DestinationLocation(
        locationDestId: json["location_dest_id"],
        locationDestName: json["location_dest_name"],
        wareHouseName: json["warehouse_name"],
    );

    Map<String, dynamic> toJson() => {
        "location_dest_id": locationDestId,
        "location_dest_name": locationDestName,
        "warehouse_name": wareHouseName,
    };
}
class MoveLine {
    int? productId;
    dynamic productName;
    dynamic productUomQty;
    dynamic productUom;
    dynamic locationId;
    dynamic locationName;
    dynamic locationDestId;
   dynamic locationDestName;

    MoveLine({
        this.productId,
        this.productName,
        this.productUomQty,
        this.productUom,
        this.locationId,
        this.locationName,
        this.locationDestId,
        this.locationDestName,
    });

    factory MoveLine.fromJson(Map<String, dynamic> json) => MoveLine(
        productId: json["product_id"],
        productName: json["product_name"],
        productUomQty: json["product_uom_qty"],
        productUom: json["product_uom"],
        locationId: json["location_id"],
        locationName: json["location_name"],
        locationDestId: json["location_dest_id"],
        locationDestName: json["location_dest_name"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_uom_qty": productUomQty,
        "product_uom": productUom,
        "location_id": locationId,
        "location_name": locationName,
        "location_dest_id": locationDestId,
        "location_dest_name": locationDestName,
    };
}



class SourceLocation {
    int? locationId;
    dynamic locationName;
    dynamic wareHouseName;


    SourceLocation({
        this.locationId,
        this.locationName,
        this.wareHouseName,
    });

    factory SourceLocation.fromJson(Map<String, dynamic> json) => SourceLocation(
        locationId: json["location_id"],
        locationName: json["location_name"],
        wareHouseName: json["warehouse_name"],
    );

    Map<String, dynamic> toJson() => {
        "location_id": locationId,
        "location_name": locationName,
        "warehouse_name": wareHouseName,
    };
}

