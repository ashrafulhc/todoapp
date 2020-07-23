class Task {
  String id;
  String title;
  String details;
  bool isFinished;

  Task({
    this.id,
    this.title,
    this.details,
    this.isFinished = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    isFinished: json["isFinished"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "isFinished": isFinished,
  };
}
