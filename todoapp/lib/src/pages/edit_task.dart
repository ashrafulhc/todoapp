import 'package:todoapp/src/blocks/event_stream.dart';
import 'package:todoapp/src/components/buttons/primary_button.dart';
import 'package:todoapp/src/components/show_flushbar/show_flushbar.dart';
import 'package:todoapp/src/model/event.dart';
import 'package:todoapp/src/model/task.dart';
import 'package:todoapp/src/model/user_data.dart';
import 'package:todoapp/src/services/firestore_service.dart';
import 'package:flutter/material.dart';

class EditTaskPage extends StatefulWidget {
  final int categoryIndex;
  final int taskIndex;
  final Task task;

  const EditTaskPage({Key key, this.task, this.categoryIndex, this.taskIndex}) : super(key: key);
  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  TextEditingController _taskController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();

  @override
  void initState() {
    _taskController.text = widget.task.title;
    _detailsController.text = widget.task.details;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30),
                  Text('Enter Task Title'),
                  SizedBox(height: 20),
                  wordTextField(context),
                  SizedBox(height: 30),
                  Text('Enter Task Details'),
                  SizedBox(height: 20),
                  meaningTextField(context),
                ],
              ),
            ),
            Spacer(),
            SizedBox(height: 10),
            PrimaryButton(
              label: 'Add',
              onPressed: () => _addTaskToFirebase(context),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget wordTextField(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width - 50,
      height: 42,
      decoration: new BoxDecoration(
        color: Color(0x167b85da),
        borderRadius: BorderRadius.circular(43),
      ),
      child: TextField(
        controller: _taskController,
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 5, right: 15),
            hintText: ''),
      ),
    );
  }

  Widget meaningTextField(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width - 50,
      decoration: new BoxDecoration(
        color: Color(0x167b85da),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _detailsController,
        minLines: 10,
        maxLines: null,
        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 10, right: 15),
            hintText: ''),
      ),
    );
  }

  void _addTaskToFirebase(BuildContext context) async {
    String taskName = _taskController.text.trim();
    String taskDetails = _detailsController.text.trim();

    if (taskName == null || taskName == '') {
      ShowFlushbar.showFlushbar(context, 'Invalid task name!', 1500);
      return;
    }

    if (taskDetails == null || taskDetails == '') {
      ShowFlushbar.showFlushbar(context, 'Invalid details!!', 1500);
      return;
    }

    UserData userData = await FirebaseCloudStore.retrieveData();
    Task task = Task(title: taskName, details: taskDetails, isFinished: widget.task.isFinished);

    userData.categories[widget.categoryIndex].tasks[widget.taskIndex] = task;

    await FirebaseCloudStore.addDataToDB(userData);

    EventStream.putEvent(Event(EventType.DATA_REFRESHED));
    //ShowFlushbar.showFlushbar(context, 'Added Task!!', 1500);

    Navigator.pop(context);
  }
}
