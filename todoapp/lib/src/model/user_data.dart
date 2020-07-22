import 'dart:convert';

import 'package:todoapp/src/model/category.dart';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    this.categories,
  });

  List<Category> categories = new List();

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}
