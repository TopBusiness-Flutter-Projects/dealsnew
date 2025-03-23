class ReturnedOrderModel {
  dynamic id;
  Result? result;

  ReturnedOrderModel({
    this.id,
    this.result,
  });

  factory ReturnedOrderModel.fromJson(Map<String, dynamic> json) => ReturnedOrderModel(
    id: json["id"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {

    "id": id,
    "result": result?.toJson(),
  };
}

class Result {
  int? status;
  List<Datum>? data;

  Result({
    this.status,
    this.data,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  dynamic name;
  dynamic userId;
  dynamic userName;
  dynamic employeeId;
  dynamic employeeName;
  dynamic amountTotal;
  dynamic date;
  dynamic status;

  Datum({
    this.id,
    this.name,
    this.userId,
    this.userName,
    this.employeeId,
    this.employeeName,
    this.amountTotal,
    this.date,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    userId: json["user_id"],
    userName: json["user_name"],
    employeeId: json["employee_id"],
    employeeName: json["employee_name"],
    amountTotal: json["amount_total"],
    date: json["date"] ,
    status: json["status"] ,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "user_id": userId,
    "user_name": userName,
    "employee_id": employeeId,
    "employee_name": employeeName,
    "amount_total": amountTotal,
    "date": date,
    "status": status,
  };
}