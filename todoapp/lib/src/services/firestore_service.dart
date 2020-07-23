import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/src/services/firebase_auth_service.dart';
import 'package:todoapp/src/model/user_data.dart';
import 'dart:convert';

class FirebaseCloudStore {
  static Firestore firestoreInstance = Firestore.instance;

  static Future addDataToDB(UserData userData) async {
    FirebaseUser user = await FirebaseAuthService.getCurrentUser();
    if (user != null) {
      String userJsonData = json.encode(userData.toJson());
      await firestoreInstance.collection('users').document(user.uid).setData({
        'userData': userJsonData,
      }).then((value) => print('Successfully added data to DB!!'));
    }
  }

  static Future<UserData> retrieveData() async {
    FirebaseUser user = await FirebaseAuthService.getCurrentUser();
    UserData data;
    await firestoreInstance
        .collection('users')
        .document(user.uid)
        .get()
        .then((value) {
      print('Here is the data: ${value.data}');
      try {
        if (value.data != null) {
          String jsonData = value.data['userData'];
          print('Give my user data: $jsonData');
          data = UserData.fromJson(json.decode(jsonData));
        }
      } catch (e) {
        print('error: ${e.message}');
      }
    });
    return data;
  }
}
