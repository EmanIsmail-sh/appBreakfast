import 'package:breakfastApp/apis/apisModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final String authToken;
  final String user_id;
  List<Product> _allProduct = [];

  List<Product> get allProduct {
    return [..._allProduct];
  }

  List<Product> productsInOrder = [];
  ProductProvider(this.authToken, this.user_id, this.productsInOrder);
  void addProduct(Product product) {
    print('add ${product.name}');
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
      p = res
          .map((e) => Product(
              id: e['id'].toString(),
              name: e['name'],
              price: e['price'].toString(),
              type: e['type'],
              shop: Shop(
                id: e['shop']['id'],
                shop_name: e['shop']['shop_name']
              )))
          .toList();
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

  calculateTotalPriceForOrder() {
    if (productsInOrder == null) {
      return;
    }
    print('order $productsInOrder');
    num total =
        productsInOrder.fold(0, (sum, item) => sum + num.parse(item.price));
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
              {'product_id': e.id, 'price': e.price, 'quantity': e.quantity})
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
