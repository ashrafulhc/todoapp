import 'package:flutter/material.dart';
import 'package:todoapp/src/components/buttons/primary_button.dart';
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
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to Home', style: HeadingStyle.accent),
            SizedBox(height: 40),
            PrimaryButton(
              onPressed: () {
                FirebaseCloudStore.addDataToDB();
              },
              label: 'Add Data',
            ),
            SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                FirebaseCloudStore.retrieveData();
              },
              label: 'Get Data',
            ),
          ],
        ),
      ),
    );
  }

  _handleSignOut(BuildContext context) {
    FirebaseAuthService.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}
