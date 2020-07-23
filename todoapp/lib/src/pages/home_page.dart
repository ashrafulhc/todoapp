import 'package:flutter/material.dart';
import 'package:todoapp/router.dart';
import 'package:todoapp/src/blocks/event_stream.dart';
import 'package:todoapp/src/components/dialogs/add_category_dialog.dart';
import 'package:todoapp/src/components/show_flushbar/show_flushbar.dart';
import 'package:todoapp/src/model/category.dart';
import 'package:todoapp/src/model/event.dart';
import 'package:todoapp/src/model/user_data.dart';
import 'package:todoapp/src/services/firebase_auth_service.dart';
import 'package:todoapp/src/services/firestore_service.dart';
import 'package:todoapp/src/utils/text_styles.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> choices = ['Search', 'About', 'Logout'];

  void _select(String choice) {
    print(choice);
    switch (choice) {
      case 'Logout':
        _handleSignOut(context);
        break;
    }
  }

  void refreshUI() {
    if (mounted) {
      setState(() {});
    }
  }

  void eventChecker() async {
    EventStream.getStream().listen((event) {
      if (event.eventType == EventType.DATA_ADDED) refreshUI();
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
        title: const Text('Categories'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _select(choices[0]),
          ),
          PopupMenuButton<String>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.skip(1).map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseCloudStore.retrieveData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return _categoryListView(context, snapshot.data);
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
        child: Icon(Icons.add),
        tooltip: 'Add Category',
        elevation: 5,
        onPressed: () => _handleAddCategory(context),
      ),
    );
  }

  Widget _categoryListView(BuildContext context, UserData data) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: () {
              print('Category card tap!!');
              openTaskPage(context, data.categories[index], index);
            },
            title: Text(data.categories[index].name,
                style: ButtonTextStyle.accent),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () => _handleCategoryEdit(context, index, data.categories[index].name),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _handleCategoryDelete(context, index),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: data.categories.length,
    );
  }

  void _handleCategoryDelete(BuildContext context, int index) async {
    UserData data = await FirebaseCloudStore.retrieveData();
    data.categories.removeAt(index);
    await FirebaseCloudStore.addDataToDB(data);
    ShowFlushbar.showFlushbar(context, "Successfully Deleted!!", 1500);
  }

  void _handleCategoryEdit(BuildContext context, int index, String name) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AddCategoryDialog(text: name);
      },
    );
    if (result == null) return;
    UserData data = await FirebaseCloudStore.retrieveData();
    data.categories[index].name = result;
    await FirebaseCloudStore.addDataToDB(data);
    ShowFlushbar.showFlushbar(context, "Successfully Edited", 1500);
  }

  void _handleAddCategory(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AddCategoryDialog();
      },
    );
    if (result == null) return;

    UserData data = await FirebaseCloudStore.retrieveData();
    Category category = new Category(name: result, tasks: new List());

    if (data != null && data.categories != null) {
      data.categories.add(category);
      await FirebaseCloudStore.addDataToDB(data);
      return;
    }

    UserData userData = UserData();
    userData.categories = new List();
    userData.categories.add(category);
    await FirebaseCloudStore.addDataToDB(data);
    ShowFlushbar.showFlushbar(context, "Successfully Added", 1500);
    //print('here is the data from db: ${data.categories}');
  }

  void _handleSignOut(BuildContext context) {
    FirebaseAuthService.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}
