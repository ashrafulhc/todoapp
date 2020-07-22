import 'package:flutter/material.dart';
import 'package:todoapp/src/pages/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //fontFamily: 'Rubik',
        primaryColor: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //onGenerateRoute: buildRouter,
      home: HomePage(),
    );
  }
}
