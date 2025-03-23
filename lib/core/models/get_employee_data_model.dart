// To parse this JSON data, do
//
//     final getEmployeeDataModel = getEmployeeDataModelFromJson(jsonString);

import 'dart:convert';

GetEmployeeDataModel getEmployeeDataModelFromJson(String str) => GetEmployeeDataModel.fromJson(json.decode(str));

String getEmployeeDataModelToJson(GetEmployeeDataModel data) => json.encode(data.toJson());

class GetEmployeeDataModel {
    int? id;
    dynamic name;
    dynamic image1920;
   dynamic workPhone;
    dynamic workEmail;
    dynamic wareHouseId;
    
    

    GetEmployeeDataModel({
        this.id,
        this.name,
        this.image1920,
        this.workPhone,
        this.workEmail,this.wareHouseId
    });

    factory GetEmployeeDataModel.fromJson(Map<String, dynamic> json) => GetEmployeeDataModel(
        id: json["id"],
        name: json["name"],
        image1920: json["image_1920"],
        workPhone: json["work_phone"],
        workEmail: json["work_email"],
        wareHouseId: json["warehouse_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_1920": image1920,
        "work_phone": workPhone,
        "work_email": workEmail,
        "warehouse_id": wareHouseId,
    };
}
