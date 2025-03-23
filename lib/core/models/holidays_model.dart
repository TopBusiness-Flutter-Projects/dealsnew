
class HolidaysModel {
  List<TimeOffRequest>? timeOffRequests;

  HolidaysModel({
    this.timeOffRequests,
  });

  factory HolidaysModel.fromJson(Map<String, dynamic> json) => HolidaysModel(
    timeOffRequests: json["time_off_requests"] == null ? [] : List<TimeOffRequest>.from(json["time_off_requests"]!.map((x) => TimeOffRequest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "time_off_requests": timeOffRequests == null ? [] : List<dynamic>.from(timeOffRequests!.map((x) => x.toJson())),
  };
}

class TimeOffRequest {
  int? timeOffRequestId;
  int? employeeId;
  dynamic employeeName;
  dynamic dateFrom;
  dynamic dateTo;
  dynamic status;
  dynamic duration;
  dynamic timeOffType;
  dynamic description;
  dynamic dateCreated;

  TimeOffRequest({
    this.timeOffRequestId,
    this.employeeId,
    this.employeeName,
    this.dateFrom,
    this.dateTo,
    this.status,
    this.duration,
    this.timeOffType,
    this.description,
    this.dateCreated,
  });

  factory TimeOffRequest.fromJson(Map<String, dynamic> json) => TimeOffRequest(
    timeOffRequestId: json["time_off_request_id"],
    employeeId: json["employee_id"],
    employeeName: json["employee_name"],
    dateFrom: json["date_from"] ,
    dateTo: json["date_to"],
    status: json["status"],
    duration: json["duration"],
    timeOffType: json["time_off_type"],
    description: json["description"],
    dateCreated: json["date_created"] ,
  );

  Map<String, dynamic> toJson() => {
    "time_off_request_id": timeOffRequestId,
    "employee_id": employeeId,
    "employee_name": employeeName,
    "date_from": dateFrom,
    "date_to": dateTo,
    "status": status,
    "duration": duration,
    "time_off_type": timeOffType,
    "description": description,
    "date_created": dateCreated?.toIso8601String(),
  };
}
