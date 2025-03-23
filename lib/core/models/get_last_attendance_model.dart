// To parse this JSON data, do
//
//     final getLastAttendanceModel = getLastAttendanceModelFromJson(jsonString);

import 'dart:convert';

GetLastAttendanceModel getLastAttendanceModelFromJson(String str) => GetLastAttendanceModel.fromJson(json.decode(str));

String getLastAttendanceModelToJson(GetLastAttendanceModel data) => json.encode(data.toJson());

class GetLastAttendanceModel {
    dynamic status;
    LastAttendance? lastAttendance;

    GetLastAttendanceModel({
        this.status,
        this.lastAttendance,
    });

    factory GetLastAttendanceModel.fromJson(Map<String, dynamic> json) => GetLastAttendanceModel(
        status: json["status"],
        lastAttendance: json["last_attendance"] == null ? null : LastAttendance.fromJson(json["last_attendance"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "last_attendance": lastAttendance?.toJson(),
    };
}

class LastAttendance {
    dynamic attendanceId;
    dynamic employeeId;
    dynamic employeeName;
    dynamic checkIn;
    dynamic checkOut;
    dynamic workedHours;
    dynamic overtimeHours;
    dynamic inLatitude;
    dynamic inLongitude;
    dynamic inCountryName;
    dynamic inCity;
    dynamic inBrowser;
    dynamic outLatitude;
    dynamic outLongitude;
    dynamic outCountryName;
    dynamic outCity;
    dynamic outBrowser;
    dynamic status;

    LastAttendance({
        this.attendanceId,
        this.employeeId,
        this.employeeName,
        this.checkIn,
        this.checkOut,
        this.workedHours,
        this.overtimeHours,
        this.inLatitude,
        this.inLongitude,
        this.inCountryName,
        this.inCity,
        this.inBrowser,
        this.outLatitude,
        this.outLongitude,
        this.outCountryName,
        this.outCity,
        this.outBrowser,
        this.status,
    });

    factory LastAttendance.fromJson(Map<String, dynamic> json) => LastAttendance(
        attendanceId: json["attendance_id"],
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        checkIn: json["check_in"],
        checkOut: json["check_out"] ,
        workedHours: json["worked_hours"],
        overtimeHours: json["overtime_hours"],
        inLatitude: json["in_latitude"],
        inLongitude: json["in_longitude"],
        inCountryName: json["in_country_name"],
        inCity: json["in_city"],
        inBrowser: json["in_browser"],
        outLatitude: json["out_latitude"],
        outLongitude: json["out_longitude"],
        outCountryName: json["out_country_name"],
        outCity: json["out_city"],
        outBrowser: json["out_browser"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "attendance_id": attendanceId,
        "employee_id": employeeId,
        "employee_name": employeeName,
        "check_in": checkIn,
        "check_out": checkOut,
        "worked_hours": workedHours,
        "overtime_hours": overtimeHours,
        "in_latitude": inLatitude,
        "in_longitude": inLongitude,
        "in_country_name": inCountryName,
        "in_city": inCity,
        "in_browser": inBrowser,
        "out_latitude": outLatitude,
        "out_longitude": outLongitude,
        "out_country_name": outCountryName,
        "out_city": outCity,
        "out_browser": outBrowser,
        "status": status,
    };
}
