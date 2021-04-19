import 'package:breakfastApp/models/product.dart';
import 'package:breakfastApp/providers/productProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../add_screen.dart';
import 'product_tile.dart';

class ProductList extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return productProvider.productsInOrder.length == 0
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
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                separatorBuilder: (ctx, i) => Divider(
                  thickness: 2,
                ),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: productProvider.productsInOrder.length,
                itemBuilder: (context, index) {
                  final product = productProvider.productsInOrder[index];
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
                    key: ObjectKey(productProvider.productsInOrder[index]),

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
                              text: '${productProvider.calculateTotalPriceForOrder().toString()} ج ',
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
                     productProvider.postOrder();
                    },
                    child: Text(
                      'طلب الاوردر',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1.fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
