import 'package:flutter/material.dart';

class ErrorDialog {
 static void showErrorDialog(String message,context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
          title: Text('حدث خطأ ما!' ),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('تم'),
              onPressed: () {
               Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}