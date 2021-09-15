import 'package:flutter/material.dart';

class Product {
  String id, name, type;
  String quantity, price,notes;
  Shop shop;

  Product(
      {@required this.id,
      this.type,
      @required this.name,
      this.quantity,
       this.notes,
      @required this.price,
      this.shop});

        @override
  String toString() { 
    return "{id: $id, name: $name, type: $type, price: $price, quantity: $quantity, notes:$notes, shop:$shop}";
  }
}

class Shop {
  String id, shop_name;
  Shop({this.id, this.shop_name});
         @override
  String toString() { 
    return "{id: $id, shop_name: $shop_name}";
  }
}
