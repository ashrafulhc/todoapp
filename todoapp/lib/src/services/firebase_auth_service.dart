import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  static Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  static Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
