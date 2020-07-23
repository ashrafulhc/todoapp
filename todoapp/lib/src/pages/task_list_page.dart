import 'package:flutter/material.dart';
import 'package:todoapp/router.dart';
import 'package:todoapp/src/blocks/event_stream.dart';
import 'package:todoapp/src/model/category.dart';
import 'package:todoapp/src/model/event.dart';
import 'package:todoapp/src/model/user_data.dart';
import 'package:todoapp/src/pages/add_task.dart';
import 'package:todoapp/src/services/firestore_service.dart';
import 'package:todoapp/src/utils/text_styles.dart';

class TaskListPage extends StatefulWidget {
  final int categoryIndex;

  const TaskListPage({Key key, this.categoryIndex}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {

  Future<Category> _getCategory() async {
    UserData userData = await FirebaseCloudStore.retrieveData();
    return userData.categories[widget.categoryIndex];
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
      body: FutureBuilder(
        future: _getCategory(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return _taskListview(context, snapshot.data);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddTask(context, widget.categoryIndex),
        tooltip: 'Add Task',
        elevation: 5,
        child: Icon(Icons.add_circle_outline, size: 32,),
      ),
    );
  }

  Widget _taskListview(BuildContext context, Category category) {
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

  _handleAddTask(BuildContext context, int index) async {
    //UserData userData = await FirebaseCloudStore.retrieveData();
    openAddTaskPage(context, index);
  }
}
