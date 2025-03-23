// To parse this JSON data, do
//
//     final getAllAttendanceModel = getAllAttendanceModelFromJson(jsonString);

import 'dart:convert';

GetAllAttendanceModel getAllAttendanceModelFromJson(String str) => GetAllAttendanceModel.fromJson(json.decode(str));

String getAllAttendanceModelToJson(GetAllAttendanceModel data) => json.encode(data.toJson());
class GetAllAttendanceModel {
  List<Attendance>? attendances;

  GetAllAttendanceModel({
    this.attendances,
  });

  factory GetAllAttendanceModel.fromJson(Map<String, dynamic> json) => GetAllAttendanceModel(
    attendances: json["attendances"] == null ? [] : List<Attendance>.from(json["attendances"]!.map((x) => Attendance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "attendances": attendances == null ? [] : List<dynamic>.from(attendances!.map((x) => x.toJson())),
  };
}

class Attendance {
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

    Attendance({
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
    });

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        attendanceId: json["attendance_id"],
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        checkIn: json["check_in"] ,
        checkOut: json["check_out"],
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
    );

    Map<String, dynamic> toJson() => {
        "attendance_id": attendanceId,
        "employee_id": employeeId,
        "employee_name": employeeName,
        "check_in": checkIn?.toIso8601String(),
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
    };
}
