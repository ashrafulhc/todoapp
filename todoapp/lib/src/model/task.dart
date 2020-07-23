class Task {
  Task({
    this.id,
    this.title,
    this.details,
    this.isFinished = false,
    this.subtasks,
  });

  String id;
  String title;
  String details;
  bool isFinished;
  List<String> subtasks = new List();

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    isFinished: json["isFinished"],
    subtasks: List<String>.from(json["subtasks"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "isFinished": isFinished,
    "subtasks": List<dynamic>.from(subtasks.map((x) => x)),
  };
}
