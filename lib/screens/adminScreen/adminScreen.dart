import 'package:breakfastApp/models/library.dart';
import 'package:breakfastApp/screens/adminScreen/orderSummaryScreen.dart';
import 'package:flutter/material.dart';

import 'orderPlacesScreen.dart';

class AdminScreen extends StatefulWidget {
  static String routeName = 'OrderSummaryScreen';
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Text('logout'),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          appBar: AppBar(
            bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.red[900],
                isScrollable: true,
                // isScrollable: true,
                tabs: [
                  buildTab(" طلبات اليوم", context),
                  buildTab(" اماكن الطلبات", context),
                ]),
          ),
          body:
              TabBarView(children: [OrderSummaryScreen(), OrderPlacesScreen()]),
        ),
      ),
    );
  }
}

Tab buildTab(String title, BuildContext context) {
  return Tab(
    child: Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 17),
        ),
      ),
    ),
  );
}
