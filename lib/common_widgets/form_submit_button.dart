import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_v3/common_widgets/custom_raised_button.dart';
import 'package:todo_v3/constants.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({@required String text, VoidCallback onPressed})
      : super(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            height: 44.0,
            color: DARK_BLUE,
            borderRadius: 4.0,
            onPressed: onPressed);
}
