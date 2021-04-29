import 'package:flutter/material.dart';
class OrderSummaryScreen extends StatefulWidget {
  static String routeName = 'OrderSummaryScreen';
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('admin Screen'),),
    );
  }
}