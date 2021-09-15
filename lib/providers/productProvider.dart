import 'package:breakfastApp/apis/apisModel.dart';
import 'package:breakfastApp/models/toastMessage.dart';
import 'package:breakfastApp/screens/userScreens/myOrdersScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final String authToken;
  final String user_id;
  List<Product> _allProduct = [];
String orderRes;
  List<Product> get allProduct {
    return [..._allProduct];
  }

  List<Product> productsInOrder = [];

  ProductProvider(this.authToken, this.user_id, this.productsInOrder);
  void addProduct(Product product) {
    print('add ${product.price}');
    productsInOrder.add(product);
    notifyListeners();
  }

  void editProduct(Product product, index) {
    print('edit ${index} editProduct ${product.name}');
    productsInOrder[index] = product;
    print('edit ${product.name}');

    // task.toggleDone();
    notifyListeners();
  }

  void deleteProduct(Product product) {
    print('remove product from provider');
    productsInOrder.remove(product);
    print('productList${productsInOrder}');
    notifyListeners();
  }

  addOrder(List<Product> order) {}

  var dio = Dio();
  Future<void> getAllProduct() async {
    print('getallproduct');
    final String url = Apis.products;
    try {
      final response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': "Bearer $authToken",
          "Accept": "application/json"
        }),
      );
      List<Product> p = [];
      // print('res${response.data['products']}');
      var res = response.data['products'] as List<dynamic>;
      print('products res $res');
      p = res
          .map((e) => Product(
              id: e['id'].toString(),
              name: e['name'],
              price: e['price'].toString(),
              type: e['type'],
              shop: e['shop']!=null? Shop(
                id: e['shop']['id'].toString(),
                shop_name: e['shop']['shop_name']
              ):null))
          .toList();
           print('products p $p');
      p.add(Product(
        id: '',
        name: '',
        price: '',
      ));
      _allProduct = p;
      print('allProduct $_allProduct');
    } catch (erorr) {
      print('erorr $erorr');
      throw erorr;
    }
    notifyListeners();
  }

  String _productName = '';
  get productName {
    return _productName;
  }
calculateTotalPriceForOneProduct(quantity, productPrice) {
    print('productPrice $productPrice quantity $quantity');
    print('total ${num.parse(productPrice) * num.parse(quantity)}');
    return num.parse(productPrice) * num.parse(quantity);
  }
  calculateTotalPriceForOrder() {
    if (productsInOrder == null) {
      return;
    }
    List sumForOneProducts =[];
    for(int i=0; i<productsInOrder.length; i++){
dynamic sumForOneProduct = calculateTotalPriceForOneProduct(productsInOrder[i].quantity, productsInOrder[i].price);
    sumForOneProducts.add(sumForOneProduct);
    print('sumForOneProducts $sumForOneProducts');
    }
    print('order $productsInOrder');
    num total = sumForOneProducts.reduce((a, b) => a + b);
    return total;
  }

  Future<void> postOrder() async {
    print('creatOrder for user id $user_id , order ${createOrder()}');

    final String url = Apis.order;
    Response response;
    try {
      response = await dio.post(
        url,
        data: createOrder(),
        options: Options(headers: {
          "Accept": "application/json",
          'Authorization': "Bearer $authToken"
        }),
      );
      print(' order Res ${response.data}');
      orderRes = response.data.toString();
      
    } on DioError catch (e) {
      handleResponseError(e);
    } catch (error) {
      print(error);
    }
    notifyListeners();
    
  }




  createOrder() {
    return {
      'user_id': user_id,
      'total_price': calculateTotalPriceForOrder(),
      'products': productsInOrder
          .map((e) =>
              {'product_id': e.id, 'price': e.price, 'quantity': e.quantity,'otherProduct':e.notes, 'shop_name':e.shop.shop_name})
          .toList()
    };
  }

  void handleResponseError(DioError e) {
    if (e.response != null) {
      print(e.error);
      print(e.response.statusCode);
      print(e.response);
      throw DioError(response: e.response);
    } else {
      print(e.request);
      print(e.message);
    }
  }
}
