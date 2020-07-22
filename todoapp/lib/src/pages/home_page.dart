import 'package:flutter/material.dart';
import 'package:todoapp/src/components/buttons/primary_button.dart';
import 'package:todoapp/src/services/firebase_auth_service.dart';
import 'package:todoapp/src/utils/text_styles.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to Home', style: HeadingStyle.accent),
            SizedBox(height: 40),
            PrimaryButton(
              onPressed: () {
                FirebaseAuthService.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
