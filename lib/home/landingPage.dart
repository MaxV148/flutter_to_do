import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_v3/home/home_page.dart';
import 'package:todo_v3/services/auth.dart';
import 'package:todo_v3/services/data_base.dart';
import 'package:todo_v3/sign_in/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          AppUser user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          } else {
            return Provider<DataBase>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: HomePage(),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
