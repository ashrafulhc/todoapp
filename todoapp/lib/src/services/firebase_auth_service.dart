import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future loginWithEmail(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result != null;
    } catch (e) {
      return e.message;
    }
  }

  static Future signUpWithEmail(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user != null;
    } catch (e) {
      return e.message;
    }
  }

  static Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  static Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
