// To parse this JSON data, do
//
//     final getContractModel = getContractModelFromJson(jsonString);

import 'dart:convert';

GetContractModel getContractModelFromJson(String str) => GetContractModel.fromJson(json.decode(str));

String getContractModelToJson(GetContractModel data) => json.encode(data.toJson());

class GetContractModel {
    ContractDetails? contractDetails;

    GetContractModel({
        this.contractDetails,
    });

    factory GetContractModel.fromJson(Map<String, dynamic> json) => GetContractModel(
        contractDetails: json["contract_details"] == null ? null : ContractDetails.fromJson(json["contract_details"]),
    );

    Map<String, dynamic> toJson() => {
        "contract_details": contractDetails?.toJson(),
    };
}

class ContractDetails {
    int? contractId;
    dynamic displayName;
    dynamic employeeId;
    dynamic dateStart;
    dynamic dateEnd;
    dynamic wage;
    dynamic jobTitle;
    dynamic department;
    dynamic workingHours;


    ContractDetails({
        this.contractId,
        this.displayName,
        this.employeeId,
        this.dateStart,
        this.dateEnd,
        this.wage,
        this.jobTitle,
        this.department,
        this.workingHours,
    });

    factory ContractDetails.fromJson(Map<String, dynamic> json) => ContractDetails(
        contractId: json["contract_id"],
        displayName: json["display_name"],
        employeeId: json["employee_id"],
        dateStart: json["date_start"],
        dateEnd: json["date_end"],
        wage: json["wage"],
        jobTitle: json["job_title"],
        department: json["department"],
        workingHours: json["working_hours"],
    );

    Map<String, dynamic> toJson() => {
        "contract_id": contractId,
        "display_name": displayName,
        "employee_id": employeeId,
        "date_start": dateStart,
        "date_end": dateEnd,
        "wage": wage,
        "job_title": jobTitle,
        "department": department,
        "working_hours": workingHours,
    };
}
