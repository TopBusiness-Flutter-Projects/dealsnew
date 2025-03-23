
class AllSalaryModel {
  List<PayslipHistory>? payslipHistory;

  AllSalaryModel({
    this.payslipHistory,
  });

  factory AllSalaryModel.fromJson(Map<String, dynamic> json) => AllSalaryModel(
    payslipHistory: json["payslip_history"] == null ? [] : List<PayslipHistory>.from(json["payslip_history"]!.map((x) => PayslipHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "payslip_history": payslipHistory == null ? [] : List<dynamic>.from(payslipHistory!.map((x) => x.toJson())),
  };
}

class PayslipHistory {
  int? payslipId;
  dynamic patch;
  dynamic employeeId;
  dynamic dateFrom;
  dynamic dateTo;
  dynamic amountTotal;
  dynamic state;

  PayslipHistory({
    this.payslipId,
    this.patch,
    this.employeeId,
    this.dateFrom,
    this.dateTo,
    this.amountTotal,
    this.state,
  });

  factory PayslipHistory.fromJson(Map<String, dynamic> json) => PayslipHistory(
    payslipId: json["payslip_id"],
    patch: json["patch"],
    employeeId: json["employee_id"],
    dateFrom: json["date_from"] == null ? null : DateTime.parse(json["date_from"]),
    dateTo: json["date_to"] == null ? null : DateTime.parse(json["date_to"]),
    amountTotal: json["amount_total"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "payslip_id": payslipId,
    "patch": patch,
    "employee_id": employeeId,
    "date_from": dateFrom,
    "date_to": dateTo,
    "amount_total": amountTotal,
    "state": state,
  };
}
