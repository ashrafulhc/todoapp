import 'package:flutter/material.dart';
import 'package:todoapp/router.dart';
import 'package:todoapp/src/components/buttons/primary_button.dart';
import 'package:todoapp/src/services/firebase_auth_service.dart';
import 'package:todoapp/src/utils/colors.dart';
import 'package:todoapp/src/utils/text_styles.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              SizedBox(height: 40),
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
        Text('Don\'t have an account?'),
        SizedBox(height: 10),
        GestureDetector(
          child: Text('Signup', style: ButtonTextStyle.accent),
          onTap: () {
            openSignupPage(context);
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return PrimaryButton(
      onPressed: () => _handleLogin(context),
      label: 'Login',
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
      'Enter your Login Credentials to continue',
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

  void _handleLogin(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    var result = await FirebaseAuthService.loginWithEmail(email, password);

    if (result is bool) {
      if (result) {
        openMainPage(context);
      } else {
        print('Something went wrong to login!!');
      }
    } else {
      print('Something went wrong to login!!');
    }
  }
}
