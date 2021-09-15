import 'package:breakfastApp/models/library.dart';
import 'package:breakfastApp/models/product.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  final int index;
  ProductTile({@required this.product, this.index});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  void initState() {
    print('product_tile ${widget.product}');
    super.initState();
  }
 calculateTotalPriceForOneProduct(quantity, productPrice) {
    print('productPrice $productPrice quantity $quantity');
    print('total ${num.parse(productPrice) * num.parse(quantity)}');
    return num.parse(productPrice) * num.parse(quantity);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                'حذف',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                ),
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.red),
          ],
        ),
        Expanded(
          child: ListTile(
            title: Text(widget.product.notes != null?widget.product.name +' '+ widget.product.notes:widget.product.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
              ),
            ),
            subtitle: Text(
              'الكميه :  ' + widget.product.quantity.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
              ),
            ),
            leading: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                  child: Text(
                // '${widget.product.price} ج ',
                calculateTotalPriceForOneProduct(
                                      widget.product.quantity,
                                      widget.product.price).toString(),
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                ),
              )),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'تعديل',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                ),
              ),
            ),
            Icon(Icons.arrow_back, color: Colors.green),
          ],
        ),
      ],
    );
  }
}
