import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:todo_v3/common_widgets/form_submit_button.dart';
import 'package:todo_v3/constants.dart';
import 'package:todo_v3/services/auth.dart';
import 'package:todo_v3/sign_in/email_sign_in_change_model.dart';

class EmailSignInChangeNotifier extends StatefulWidget {
  EmailSignInChangeNotifier({@required this.model});

  final EmailSigninChangeModel model;
  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSigninChangeModel>(
      create: (context) => EmailSigninChangeModel(auth: auth),
      child: Consumer<EmailSigninChangeModel>(
        builder: (context, model, _) => EmailSignInChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInChangeNotifierState createState() =>
      _EmailSignInChangeNotifierState();
}

class _EmailSignInChangeNotifierState extends State<EmailSignInChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameContoller = TextEditingController();
  final TextEditingController _passwordContoller = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  EmailSigninChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameContoller.dispose();
    _usernameContoller.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  List<Widget> _buildChildren() {
    return [
      buildEmailTextField(),
      SizedBox(height: 8.0),
      model.isSignin ? Container() : buildUsernameTextField(),
      SizedBox(height: 8.0),
      buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: !model.isLoading ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      )
    ];
  }

  void _toggleFormType() {
    /// führt die toggleFormType methode im email_sign_in_bloc aus
    model.toggleFormType();

    /// leer die eingaben im textfield
    _emailController.clear();
    _usernameContoller.clear();
  }

  TextField buildPasswordTextField() {
    return TextField(
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      controller: _passwordContoller,
      decoration: InputDecoration(
        labelText: "Password",
      ),
      obscureText: true,

      /// führt die submit methode aus
      onEditingComplete: _submit,

      /// setzt das eingegebene password so gelangt es in den stream
      onChanged: model.updatePassword,
    );
  }

  TextField buildUsernameTextField() {
    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.name,
      focusNode: _usernameFocusNode,
      controller: _usernameContoller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Name",
      ),

      /// setzt die eingegebene email so gelangt sie in den stream
      onChanged: model.updateUserName,
    );
  }

  TextField buildEmailTextField() {
    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      focusNode: _emailFocusNode,
      controller: _emailController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "test@test.com",
      ),

      /// setzt die eingegebene email so gelangt sie in den stream
      onChanged: model.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: model.isLoading
          ? Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: SpinKitFadingFour(
                  color: DARK_BLUE,
                  size: 50,
                ),
              ),
            )
          : Column(
              children: _buildChildren(),
            ),
    );
  }
}
