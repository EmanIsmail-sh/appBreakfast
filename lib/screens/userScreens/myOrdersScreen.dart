import 'package:breakfastApp/models/library.dart';
import 'package:breakfastApp/models/order.dart';
import 'package:breakfastApp/models/product.dart';
import 'package:breakfastApp/providers/orderProvider.dart';
import 'package:breakfastApp/providers/productProvider.dart';
import 'package:breakfastApp/screens/userScreens/createOrderScreen.dart';
import 'package:flutter/material.dart';


class MyOrderScreen extends StatefulWidget {
  static String routeName = 'MyOrderScreen';

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  bool isSearching = false;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    print('my order');
    selectOrderByDate(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        print('change date');
        selectedDate = picked;
        selectOrderByDate(picked);
      });
  }

  selectOrderByDate(date) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.getOrderByDate(date);
  }
calculateTotalPriceForOneProduct(quantity, productPrice) {
    print('productPrice $productPrice quantity $quantity');
    print('total ${num.parse(productPrice) * num.parse(quantity)}');
    return num.parse(productPrice) * num.parse(quantity);
  }
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: !isSearching
              ? Text('طلباتي')
              : Text("${selectedDate.toLocal()}".split(' ')[0]),
          actions: [
            IconButton(
                icon: !isSearching
                    ? IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _selectDate(context);
                          setState(() {
                            this.isSearching = true;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            this.isSearching = false;
                          });
                        },
                      ),
                onPressed: () {
                  // setState(() {
                  //   this.isSearching = !this.isSearching;
                  // });
                })
          ],
        ),
        drawer: AppDrawer(),
        body: Consumer<OrderProvider>(
          builder: (ctx, orderProvider, _) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('طلب اليوم :',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.fontFamily,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Text("${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.fontFamily,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (ctx, i) {
                    final List<Order> list = orderProvider.orders.reversed.toList();
                    final order = list[i];
                    print('my order screen $order');
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('اوردر رقم ${i + 1}   ',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .fontFamily,
                                      )),
                                  Divider(
                                    thickness: 1,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Container(
                                    height: 200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: order.products.length,
                                            itemBuilder: (ctx, i) => Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(order.products[i].notes!=null? order.products[i].name +' '+ order.products[i].notes:order.products[i].name,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                          fontFamily:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .fontFamily,
                                                        )),
                                                    Text(order
                                                        .products[i].quantity),
                                                    Text(calculateTotalPriceForOneProduct(order.products[i].quantity,order.products[i].price).toString(),
                                                        // '${order.products[i].price}ج',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                          fontFamily:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .fontFamily,
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              child: Center(
                                                child: RichText(
                                                  textAlign: TextAlign.right,
                                                  text: TextSpan(
                                                      text: 'الاجمالي :  ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .fontFamily,
                                                          fontSize: 18),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text:
                                                              '${order.total_price} ج ',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent,
                                                              fontFamily: Theme
                                                                      .of(context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .fontFamily,
                                                              fontSize: 18),
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            ),
                                            order.state == 'unpaid'
                                                ? RaisedButton.icon(
                                                    onPressed: () {
                                               Provider.of<ProductProvider>(context,listen: false).productsInOrder.clear();
                                               for(var i in order.products){
                                              Provider.of<ProductProvider>(context,listen: false).addProduct(i);

                                               }

                                              // Navigator.of(context).pushNamed(CreatOrderScreen.routeName,arguments:order.products );
                                              Navigator.of(context).pushNamed(CreatOrderScreen.routeName,arguments: order );

                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                    label: Text(
                                                      'تعديل',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .fontFamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )
                                                : Row(
                                                  children: [
                                                    Icon(Icons.check,color: Colors.green,),
                                                    Text(
                                                        'تم التحصيل',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                Theme.of(context)
                                                                    .textTheme
                                                                    .bodyText1
                                                                    .fontFamily,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            ),
                                                      ),
                                                  ],
                                                )
                                          ],
                                        ),
                                      ],
                                    ),
                                    //   child: ListView.separated(
                                    //     // shrinkWrap: true,
                                    //     // physics: NeverScrollableScrollPhysics(),
                                    //     itemCount: order.products.length,
                                    //     itemBuilder: (ctx, i) {
                                    //       final pro = order.products[i];
                                    //       return Text(pro.name);
                                    //     },
                                    //     separatorBuilder: (ctx, i) => Divider(
                                    //       thickness: 2,
                                    //     ),
                                    //   ),
                                  ),
                                ],

                                // subtitle: Text(order.price,
                                //     style: TextStyle(
                                //       fontSize: 17,
                                //       fontWeight: FontWeight.bold,
                                //       fontFamily: Theme.of(context)
                                //           .textTheme
                                //           .bodyText1
                                //           .fontFamily,
                                //     )),
                                // trailing: Text(order.quantity,
                                //     style: TextStyle(
                                //       fontSize: 17,
                                //       fontWeight: FontWeight.bold,
                                //       fontFamily: Theme.of(context)
                                //           .textTheme
                                //           .bodyText1
                                //           .fontFamily,
                                //     )),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
