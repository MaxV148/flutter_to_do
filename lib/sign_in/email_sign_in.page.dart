import 'package:flutter/material.dart';
import 'package:todo_v3/constants.dart';
import 'package:todo_v3/sign_in/email_sign_in_changeNotifier.dart';

class EmailSigninPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BG_BLUE,
      appBar: AppBar(
        backgroundColor: BG_BLUE,
        centerTitle: true,
        elevation: 0.0,
        title: Text("Email Sign in"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            child: EmailSignInChangeNotifier.create(context),
          ),
        ),
      ),
    );
  }
}
