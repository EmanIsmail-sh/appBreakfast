import '../../../models/order.dart';
import '../../../models/product.dart';
import 'package:breakfastApp/providers/orderProvider.dart';
import 'package:breakfastApp/providers/productProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../add_screen.dart';
import '../myOrdersScreen.dart';
import 'product_tile.dart';

class ProductListScreen extends StatefulWidget {
 final Order myOrder ;
  ProductListScreen({this.myOrder});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  void showModalToEditProduct(Product product, context, index) {
    print('edit showModalToEditProduct ${product.id}');
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      elevation: 0.0,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AddScreen(product: product, index: index),
      ),
    );
  }

  // List<Product> productts = [];

  List<Product> productProvider=[];

  // setProductList(context) {
  //   productProvider = Provider.of<ProductProvider>(context).productsInOrder;

  //   // if (widget.products == null) {
  //   //   productts = productProvider;
  //   //   return;
  //   // }
  //   //    productts =widget.products;
  // }

  @override
  Widget build(BuildContext context) {
   print('myorder in product_list ${widget.myOrder}');
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    print('productProvider.productsInOrder ${productProvider.productsInOrder}');
    return productProvider.productsInOrder.length == 0

        // products.length==0
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/hangry.png',
                  fit: BoxFit.cover,
                  height: 130,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'لا يوجد طلبات',
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.bodyText1.fontFamily,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        : Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: ListView(
              children: [
                ListView.separated(
                  separatorBuilder: (ctx, i) => Divider(
                    thickness: 2,
                  ),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: productProvider.productsInOrder.length,
                  // products != []
                  //     ? products.length
                  //     : productProvider.productsInOrder.length,
                  itemBuilder: (context, index) {
                    // var product;
                    // products != []
                    //     ? product = products[index]
                    //     : product = productProvider.productsInOrder[index];
                    // product = products[index];
                    Product product = productProvider.productsInOrder[index];
                    print('products in itembuilder$product');
                    return Dismissible(
                      onDismissed: (DismissDirection direction) {
                        print('onDismissed');
                        if (direction == DismissDirection.endToStart) {
                          print('end edit oon disssss');
                        }
                      },
                      background: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),

                      secondaryBackground: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        color: Colors.green,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      key: ObjectKey(product),

                      // ignore: missing_return
                      confirmDismiss: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          print('direction ${direction}');
                          print('end edit');
                          showModalToEditProduct(product, context, index);
                          return;
                        }
                        print('end remove');
                        productProvider.deleteProduct(product);
                      },

                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: ProductTile(product: product, index: index),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'الاجمالي :  ',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${productProvider.calculateTotalPriceForOrder().toString()} ج ',
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 18),
                              )
                            ]),
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green)))),
                      onPressed: () {
                  widget.myOrder != null?orderProvider.updateOrder(widget.myOrder.id, {
      'user_id':widget.myOrder.id ,
      'total_price':productProvider. calculateTotalPriceForOrder(),
      'products': productProvider.productsInOrder
            .map((e) =>
                {'product_id': e.id, 'price': e.price, 'quantity': e.quantity})
            .toList()
    })  :     productProvider.postOrder();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              content:widget.myOrder!=null? Text('تم تعديل طلبك'): Text('تم تأكيد الطلب'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('ok'),
                                  onPressed: () {
                                  Navigator.pop(context);
                                    Navigator.of(context)
                                        .pushNamed(MyOrderScreen.routeName);
                                        Provider.of<ProductProvider>(context,listen: false).productsInOrder.clear();
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      child:widget.myOrder!=null? Text(
                        'تعديل الاوردر',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.fontFamily,
                        ),
                      ):
                      Text(
                        'طلب الاوردر',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.fontFamily,
                        ),
                      )
                      
                      
                      ,
                    ),
                  ],
                ),
              ],
            ),
        );
  }
}
