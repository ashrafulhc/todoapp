import 'package:todoapp/src/model/task.dart';

class Category {
  String id;
  String name;
  List<Task> tasks;

  Category({
    this.id,
    this.name,
    this.tasks,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
  };
}