import 'package:flutter/material.dart';
import 'package:todoapp/router.dart';
import 'package:todoapp/src/blocks/event_stream.dart';
import 'package:todoapp/src/components/dropdown/sort_dropdown.dart';
import 'package:todoapp/src/components/show_flushbar/show_flushbar.dart';
import 'package:todoapp/src/model/category.dart';
import 'package:todoapp/src/model/event.dart';
import 'package:todoapp/src/model/task.dart';
import 'package:todoapp/src/model/user_data.dart';
import 'package:todoapp/src/pages/edit_task.dart';
import 'package:todoapp/src/services/firestore_service.dart';
import 'package:todoapp/src/utils/text_styles.dart';

class TaskListPage extends StatefulWidget {
  final int categoryIndex;
  const TaskListPage({Key key, this.categoryIndex}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String _currentSortType = "All";
  final List<String> _dropdownValues = ["All", "Finished", "Unfinished"];

  Future<List<Task>> _getTaskList() async {
    UserData userData = await FirebaseCloudStore.retrieveData();
    List<Task> tasks = userData.categories[widget.categoryIndex].tasks;
    return tasks;
  }

  _handleSort(String value) async {
    _currentSortType = value;

    UserData userData = await FirebaseCloudStore.retrieveData();
    List<Task> unfinished = new List();
    List<Task> finished = new List();
    List<Task> allTask = new List();

    for (Task task in userData.categories[widget.categoryIndex].tasks) {
      if (!task.isFinished) {
        unfinished.add(task);
      }
    }

    for (Task task in userData.categories[widget.categoryIndex].tasks) {
      if (task.isFinished) {
        finished.add(task);
      }
    }

    allTask.addAll(userData.categories[widget.categoryIndex].tasks);

    if (value == 'All') {
      userData.categories[widget.categoryIndex].tasks.shuffle();
    } else if (value == 'Finished') {
      finished.addAll(unfinished);
      userData.categories[widget.categoryIndex].tasks = finished;
    } else if (value == 'Unfinished') {
      unfinished.addAll(finished);
      userData.categories[widget.categoryIndex].tasks = unfinished;
    }

    await FirebaseCloudStore.addDataToDB(userData);

    setState(() {});
  }

  void refreshUI() {
    if (mounted) {
      setState(() {});
    }
  }

  void eventChecker() async {
    EventStream.getStream().listen((event) {
      if (event.eventType == EventType.DATA_REFRESHED) refreshUI();
    });
  }

  @override
  void initState() {
    eventChecker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Column(
        children: <Widget>[
          _buildDropdownRow(),
          FutureBuilder(
            future: _getTaskList(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return Expanded(child: _taskListview(context, snapshot.data));
              } else if (snapshot.data == null) {
                return Center(
                  child: Text('Data is Empty!!'),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddTask(context, widget.categoryIndex),
        tooltip: 'Add Task',
        elevation: 5,
        child: Icon(
          Icons.add_circle_outline,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildDropdownRow() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Sort The List:'),
          SizedBox(width: 30),
          SortDropdown(
            currentValue: _currentSortType,
            itemList: _dropdownValues,
            onValueChange: (newValue) {
              _handleSort(newValue);
            },
          ),
        ],
      ),
    );
  }

  Widget _taskListview(BuildContext context, List<Task> taskList) {
    return taskList == null || taskList.isEmpty
        ? Center(
            child: Text('Empty Task'),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    print('task card tapped!!');
                    openTaskDetailsPage(context, taskList[index]);
                  },
                  leading: Checkbox(
                    value: taskList[index].isFinished,
                    onChanged: (newValue) {
                      _handleMarkAsFinished(index);
                    },
                  ),
                  title: Text(taskList[index].title,
                      style: ButtonTextStyle.accent),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: () =>
                            _handleEditTask(context, index, taskList[index]),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _handleDeleteTask(index),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: taskList.length,
          );
  }

  _handleAddTask(BuildContext context, int index) async {
    //UserData userData = await FirebaseCloudStore.retrieveData();
    openAddTaskPage(context, index);
  }

  _handleMarkAsFinished(int index) async {
    UserData userData = await FirebaseCloudStore.retrieveData();
    userData.categories[widget.categoryIndex].tasks[index].isFinished =
        !userData.categories[widget.categoryIndex].tasks[index].isFinished;
    FirebaseCloudStore.addDataToDB(userData);

    EventStream.putEvent(Event(EventType.DATA_REFRESHED));
  }

  _handleDeleteTask(int index) async {
    UserData userData = await FirebaseCloudStore.retrieveData();
    userData.categories[widget.categoryIndex].tasks.removeAt(index);

    FirebaseCloudStore.addDataToDB(userData);

    ShowFlushbar.showFlushbar(context, 'Deleted Successfully', 1500);

    EventStream.putEvent(Event(EventType.DATA_REFRESHED));
  }

  _handleEditTask(BuildContext context, int index, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(
          task: task,
          categoryIndex: widget.categoryIndex,
          taskIndex: index,
        ),
      ),
    );
  }
}
