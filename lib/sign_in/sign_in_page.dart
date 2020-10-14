import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_v3/constants.dart';
import 'package:todo_v3/services/auth.dart';
import 'package:todo_v3/sign_in/email_sign_in.page.dart';
import 'package:todo_v3/sign_in/sign_in_button.dart';
import 'package:todo_v3/sign_in/sign_in_manager.dart';
import 'package:todo_v3/sign_in/social_sign_in_buttom.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.manager, @required this.isLoading});
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (context) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (context, isLoading, _) => Provider<SignInManager>(
          create: (context) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInAnonymously() async {
    try {
      await manager.signInAnonymously();
    } catch (error) {
      print(error.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => EmailSigninPage(),
    ));
  }

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     await manager.signInWithGoogle();
  //   } catch (error) {
  //     print(error.toString());
  //   }
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BG_BLUE,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: _buildHeader(),
            ),
            SizedBox(height: 20),
            SocialSignInButton(
              assetName: "images/google-logo.png",
              text: "Sign in with Google",
              textColor: Colors.black,
              color: Colors.white,
              onPressed: () {
                //..
              },
            ),
            SizedBox(height: 20),
            SignInButton(
              text: "Sign in with email.",
              textColor: Colors.white,
              color: DARK_BLUE,
              onPressed: () => _signInWithEmail(context),
            ),
            SizedBox(height: 20),
            SignInButton(
              text: "Go anonymous",
              textColor: Colors.white,
              color: DARK_BLUE,
              onPressed: _signInAnonymously,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    /// loading indicator
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
