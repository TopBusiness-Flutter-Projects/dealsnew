
class HolidaysTypeModel {
  dynamic status;
  List<TimeOffBalance>? timeOffBalances;

  HolidaysTypeModel({
    this.status,
    this.timeOffBalances,
  });

  factory HolidaysTypeModel.fromJson(Map<String, dynamic> json) => HolidaysTypeModel(
    status: json["status"],
    timeOffBalances: json["time_off_balances"] == null ? [] : List<TimeOffBalance>.from(json["time_off_balances"]!.map((x) => TimeOffBalance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "time_off_balances": timeOffBalances == null ? [] : List<dynamic>.from(timeOffBalances!.map((x) => x.toJson())),
  };
}

class TimeOffBalance {
  int? timeOffId;
  dynamic timeOffType;
  dynamic allocatedDays;
  dynamic remainingDays;
  dynamic usedDays;

  TimeOffBalance({
    this.timeOffId,
    this.timeOffType,
    this.allocatedDays,
    this.remainingDays,
    this.usedDays,
  });

  factory TimeOffBalance.fromJson(Map<String, dynamic> json) => TimeOffBalance(
    timeOffId: json["time_off_id"],
    timeOffType: json["time_off_type"],
    allocatedDays: json["allocated_days"],
    remainingDays: json["remaining_days"],
    usedDays: json["used_days"],
  );

  Map<String, dynamic> toJson() => {
    "time_off_id": timeOffId,
    "time_off_type": timeOffType,
    "allocated_days": allocatedDays,
    "remaining_days": remainingDays,
    "used_days": usedDays,
  };

}
