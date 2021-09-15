import 'package:breakfastApp/apis/apisModel.dart';
import 'package:breakfastApp/models/order.dart';
import 'package:breakfastApp/models/product.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final String authToken;
  final String user_id;
  List<Order> _orders = [];
  List<Order> get orders {
    return [..._orders];
  }

  OrderProvider(this.authToken, this.user_id, this._orders);

  var dio = Dio();
  Future<void> getOrderByDate(date) async {
    print("${date.toLocal()}".split(' ')[0]);
    final dateFormate = "${date.toLocal()}".split(' ')[0];
    final String url = Apis.orderByDate;
    Response response;
    try {
      print('$authToken');
      response = await dio.post(
        url,
        data: {'today': dateFormate},
        options: Options(headers: {
          "Accept": "application/json",
          'Authorization': "Bearer $authToken"
        }),
      );
      // print(' orderByDate Res ${response.data}');
      List<Order> orderList = [];
      // print('res${response.data['products']}');
      var res = response.data['order'] as List<dynamic>;
      print('get order res $res');
      orderList = res
          .map(
            (e) => Order(
              id: e['id'].toString(),
              user_id: e['user_id'].toString(),
              total_price: e['total_price'].toString(),
              state: e['state'],
              products: (e['products'] as List<dynamic>)
                  .map(
                    (p) => Product(
                      id: p['id'].toString(),
                      name: p['name'],
                      price: p['pivot']['price'].toString(),
                      quantity: p['pivot']['quantity'].toString(),
                      type: p['type'],
                      notes: p['pivot']['otherProduct'],
                      shop: Shop(
                        id: p['shop']['id'].toString(),
                        shop_name: p['shop']['shop_name'],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ).toList();

      _orders = orderList;
      print('order $_orders');
    } on DioError catch (e) {
      handleResponseError(e);
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  
  
  
  
   Future<void> updateOrder(order_id,order) async {
    print('update for user id $order_id , order $order');

    final String url = Apis.order +'/'+ order_id;
    Response response;
    try {
      response = await dio.put(
        url,
        data: order,
        options: Options(headers: {
          "Accept": "application/json",
          'Authorization': "Bearer $authToken"
        }),
      );
      print('update order Res ${response.data}');
    } on DioError catch (e) {
      handleResponseError(e);
    } catch (error) {
      print(error);
    }
    notifyListeners();
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
