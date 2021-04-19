import 'package:flutter/material.dart';

class Product {
  String id, name, type;
  String quantity, price;
  Shop shop;

  Product(
      {@required this.id,
      this.type,
      @required this.name,
      this.quantity,
      @required this.price,
      this.shop});

        @override
  String toString() { 
    return "{id: $id, name: $name, type: $type, price: $price, quantity: $quantity}";
  }
}

class Shop {
  String id, shop_name;
  Shop({this.id, this.shop_name});
}
