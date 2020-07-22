import 'package:flutter/material.dart';
import 'package:todoapp/router.dart';
import 'package:todoapp/src/components/buttons/primary_button.dart';
import 'package:todoapp/src/components/show_flushbar/show_flushbar.dart';
import 'package:todoapp/src/services/firebase_auth_service.dart';
import 'package:todoapp/src/utils/colors.dart';
import 'package:todoapp/src/utils/text_styles.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              _buildMainLogo(),
              SizedBox(height: 15),
              _buildHeading(),
              SizedBox(height: 15),
              _buildSubHeading(),
              SizedBox(height: 50),
              _buildEmail(context),
              SizedBox(height: 15),
              _buildPassword(context),
              SizedBox(height: 20),
              _buildSubmitButton(context),
              SizedBox(height: 20),
              _buildSignUpButton(context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Already have an account?'),
        SizedBox(height: 10),
        GestureDetector(
          child: Text('Signin', style: ButtonTextStyle.accent),
          onTap: () {
            openLoginPage(context);
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return PrimaryButton(
      onPressed: () => _handleSignup(context),
      label: 'Signup',
    );
  }

  Widget _buildMainLogo() {
    return Text('Todo App', style: HeadingStyle.accent);
  }

  Widget _buildHeading() {
    return Text('Signin', style: HeadingStyle.primary);
  }

  Widget _buildSubHeading() {
    return Text(
      'Be a part of us by entering all of the details',
      textAlign: TextAlign.center,
      style: TextStyle(color: MyColors.primary),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width - 32,
      height: 43,
      decoration: new BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextField(
        controller: _emailController,
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.email, color: Colors.black),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 9),
          hintText: 'Email Address',
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildPassword(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width - 32,
      height: 43,
      decoration: new BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextField(
        obscureText: true,
        controller: _passwordController,
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.black),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 9),
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void _handleSignup(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email == '' || email == null) {
      ShowFlushbar.showFlushbar(context, 'Email Can\'t be Empty', 1500);
      return;
    }

    if (password == '' || password == null) {
      ShowFlushbar.showFlushbar(context, 'Password Can\'t be Empty', 1500);
      return;
    }

    if (password.length < 6) {
      ShowFlushbar.showFlushbar(
          context, 'Password\'s length is less than 6', 1500);
      return;
    }

    showAlertDialog(context);

    var result = await FirebaseAuthService.signUpWithEmail(email, password);

    Navigator.pop(context);

    if (result is bool) {
      if (result) {
        openMainPage(context);
      } else {
        ShowFlushbar.showFlushbar(context, 'Something Went Wrong!!', 1500);
      }
    } else {
      ShowFlushbar.showFlushbar(context, 'Something Went Wrong!!', 1500);
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
