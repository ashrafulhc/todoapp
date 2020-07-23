import 'package:flutter/material.dart';
import 'package:todoapp/src/components/cards/task_details_card.dart';
import 'package:todoapp/src/model/task.dart';

class TaskDetails extends StatelessWidget {
  final Task task;

  const TaskDetails({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            TaskDetailsCard(
              title: task.title,
              body: task.details,
            ),
          ],
        ),
      ),
    );
  }
}
