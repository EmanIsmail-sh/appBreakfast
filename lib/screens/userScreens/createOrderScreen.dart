import 'package:breakfastApp/models/library.dart';
import 'package:breakfastApp/models/product.dart';
import 'package:breakfastApp/screens/userScreens/widges/product_list.dart';
import 'package:flutter/material.dart';

import 'add_screen.dart';

class CreatOrderScreen extends StatelessWidget {
  static String routeName = 'createOrderScreen';
  @override
  Widget build(BuildContext context) {
 final List<Product> args = ModalRoute.of(context).settings.arguments;
    print('args $args');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'اطلب فطارك',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          drawer: AppDrawer(),
          body: Container(
            color: Theme.of(context).primaryColor,
            width: width,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30, bottom: 5, right: 30,top: 10),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top:20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child:args!=null?ProductListScreen(products: args,):  ProductListScreen(),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                elevation: 0.0,
                isScrollControlled: true,
                builder: (context) => Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: AddScreen(),
                ),
              );
            },
            label: Text('هتفطر ايه؟',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                )),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ));
  }
}
