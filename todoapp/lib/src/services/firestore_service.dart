import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/src/services/firebase_auth_service.dart';

class FirebaseCloudStore {
  static Firestore firestoreInstance = Firestore.instance;

  static Future addDataToDB() async {
    FirebaseUser user = await FirebaseAuthService.getCurrentUser();
    if (user != null) {
      firestoreInstance.collection('users').document(user.uid).setData({
        'userData': 'Hello World!',
      }).then((value) => print('Successfully added data to DB!!'));
    }
  }

  static Future retrieveData() async {
    FirebaseUser user = await FirebaseAuthService.getCurrentUser();
    firestoreInstance
        .collection('users')
        .document(user.uid)
        .get()
        .then((value) async {
      print('Here is the data: ${value.data}');
    });
  }
}
