import 'package:flutter/material.dart';
import 'package:todoapp/src/model/category.dart';
import 'package:todoapp/src/model/user_data.dart';
import 'package:todoapp/src/services/firestore_service.dart';
import 'package:todoapp/src/utils/text_styles.dart';

class TaskListPage extends StatelessWidget {
  final Category category;
  final int categoryPosition;

  const TaskListPage({Key key, this.category, this.categoryPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: _taskListview(category),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddTask(),
        tooltip: 'Add Task',
        elevation: 5,
        child: Icon(Icons.add_circle_outline, size: 32,),
      ),
    );
  }

  Widget _taskListview(Category category) {
    return category == null || category.tasks.isEmpty
        ? Center(
            child: Text('Empty Task'),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    print('task card tapped!!');
                  },
                  title: Text(category.tasks[index].title,
                      style: ButtonTextStyle.accent),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {}),
                    ],
                  ),
                ),
              );
            },
            itemCount: category.tasks.length,
          );
  }

  _handleAddTask() async {
    //UserData userData = await FirebaseCloudStore.retrieveData();
  }
}
