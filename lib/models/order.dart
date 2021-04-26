import 'package:breakfastApp/models/product.dart';

class Order{
  String id,user_id,total_price,state;
List<Product> products;
Order({this.id,this.user_id,this.state,this.total_price,this.products});

}