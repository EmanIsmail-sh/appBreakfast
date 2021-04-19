import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final String textbutton;
  final Function onPressed;
  Color color, TextColor;
  CustomButtonWidget(
      {@required this.textbutton,
      @required this.onPressed,
      @required this.color,
      @required this.TextColor});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text(
        textbutton,
        style: TextStyle(color: TextColor, fontSize: 20, letterSpacing: 1),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: color,
    );
  }
}
