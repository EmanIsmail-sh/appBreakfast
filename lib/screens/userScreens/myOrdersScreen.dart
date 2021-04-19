import 'package:breakfastApp/models/library.dart';
import 'package:flutter/material.dart';

class MyOrderScreen extends StatelessWidget {
  static String routeName = 'MyOrderScreen';
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
          child: Scaffold(
        appBar: AppBar(
          title: Text('طلباتي'),
        ),
        drawer: AppDrawer(),
      ),
    );
  }
}
