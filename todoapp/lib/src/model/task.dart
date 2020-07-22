class Task {
  Task({
    this.id,
    this.title,
    this.isFinished = false,
    this.subtasks,
  });

  String id;
  String title;
  bool isFinished;
  List<String> subtasks;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        isFinished: json["isFinished"],
        subtasks: List<String>.from(json["subtasks"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "isFinished": isFinished,
        "subtasks": List<dynamic>.from(subtasks.map((x) => x)),
      };
}
