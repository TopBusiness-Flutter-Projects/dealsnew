
class AllTasksModel {
  String? message;
  List<Task>? tasks;

  AllTasksModel({
    this.message,
    this.tasks,
  });

  factory AllTasksModel.fromJson(Map<String, dynamic> json) => AllTasksModel(
    message: json["message"],
    tasks: json["tasks"] == null ? [] : List<Task>.from(json["tasks"]!.map((x) => Task.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
  };
}

class Task {
  int? taskId;
  dynamic taskName;
  dynamic description;
  dynamic deadline;
  dynamic stageId;
  dynamic stageName;
  dynamic state;

  Task({
    this.taskId,
    this.taskName,
    this.description,
    this.deadline,
    this.stageId,
    this.stageName,
    this.state,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    taskId: json["task_id"],
    taskName: json["task_name"],
    description: json["description"],
    deadline: json["deadline"],
    stageId: json["stage_id"],
    stageName: json["stage_name"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "task_id": taskId,
    "task_name": taskName,
    "description": description,
    "deadline": deadline,
    "stage_id": stageId,
    "stage_name": stageName,
    "state": state,
  };
}
