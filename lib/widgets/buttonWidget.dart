import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  final String title;
  final bool hasBorder;
  final Function onTap;
  ButtonWidget({
    this.title,
    this.hasBorder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: hasBorder ? Colors.white : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60.0,
            width: 150,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: hasBorder ? Color(0XFF109544) : Colors.white,
                  fontWeight: FontWeight.bold,
                    fontFamily:
                              Theme.of(context).textTheme.bodyText1.fontFamily,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}