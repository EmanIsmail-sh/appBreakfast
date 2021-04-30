import 'package:breakfastApp/models/order.dart';
import 'package:breakfastApp/models/toastMessage.dart';
import 'package:breakfastApp/providers/adminOrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSummaryScreen extends StatefulWidget {
  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  Future _allOrders;

  Future<void> getApiAllOrders() {
    print('fun getapiproduct ');
    return _allOrders = Provider.of<AdminOrderProvider>(context, listen: false)
        .getAllOrdersForAllUsers();
  }

  @override
  void initState() {
    getApiAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider =
        Provider.of<AdminOrderProvider>(context, listen: false);
    return Scaffold(
        body:
            //  Consumer<AdminOrderProvider>(
            //   builder: (ctx, adminProvider, _) {
            //     return
            FutureBuilder(
      future: _allOrders,
      builder: (ctx, snapshot) => ListView.builder(
          itemCount: adminProvider.allOrdersForAllUsers.length,
          itemBuilder: (context, index) {
            final order = adminProvider.allOrdersForAllUsers[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                              child: ExpansionTile(
                  // trailing: Text(order.user_id),
                  leading: 
                  IconButton(
                    icon: order.state == 'paid'
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.attach_money,
                            color: Theme.of(context).primaryColor,
                          ),
                    onPressed: () async {
                      if (order.state == 'paid') {
                        return;
                      }
                    await  adminProvider.updateOrderState(order.id, 'paid');
                    getApiAllOrders();

                      ToastMessage.showToast('تم التحصيل');
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text('ايمان اسماعيل شعبان',
                         overflow: TextOverflow.ellipsis,
                        //  maxLines: 1,
                        // softWrap: false,
                         style: TextStyle(
                          color:Theme.of(context).primaryColor ,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                          )),
                      ),
                       
                       
                         Text('${order.total_price.toString()} ج' , style: TextStyle(
                        color:Theme.of(context).primaryColor ,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                        )),
                       
                    ],
                  ),
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height *.5,
                        child: ListView.builder(
                          itemCount: order.products.length,
                          itemBuilder: (ctx, i) {
                            final product = order.products[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              child: Text(product.name,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .fontFamily,
                                  ),),
                            );
                          },
                        )),
                  ],
                ),
              ),
            );
          }),
    )
        // },

        );
  }
}
