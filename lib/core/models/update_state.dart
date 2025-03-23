
class UpdateStateModel {
  String? jsonrpc;
  dynamic id;
  Result? result;

  UpdateStateModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory UpdateStateModel.fromJson(Map<String, dynamic> json) => UpdateStateModel(
    jsonrpc: json["jsonrpc"],
    id: json["id"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "jsonrpc": jsonrpc,
    "id": id,
    "result": result?.toJson(),
  };
}

class Result {
  dynamic message;
  dynamic taskId;
  dynamic newStageId;
  dynamic newState;

  Result({
    this.message,
    this.taskId,
    this.newStageId,
    this.newState,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    message: json["message"],
    taskId: json["task_id"],
    newStageId: json["new_stage_id"],
    newState: json["new_state"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "task_id": taskId,
    "new_stage_id": newStageId,
    "new_state": newState,
  };
}
