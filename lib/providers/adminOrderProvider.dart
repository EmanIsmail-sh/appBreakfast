import 'package:breakfastApp/apis/apisModel.dart';
import 'package:breakfastApp/models/order.dart';
import 'package:breakfastApp/models/product.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AdminOrderProvider extends ChangeNotifier {
  final String authToken;
  final String user_id;
  List<Order> _allOrdersForAllUsers = [];
  List<Order> get allOrdersForAllUsers {
    return [..._allOrdersForAllUsers];
  }

  AdminOrderProvider(this.authToken, this.user_id, this._allOrdersForAllUsers);

  var dio = Dio();
  Future<void> getAllOrdersForAllUsers() async {
    print('getadmin ordercrgv');
    final String url = Apis.orders;
    Response response;
    try {
      print('$authToken');
      response = await dio.get(
        url,
        options: Options(headers: {
          "Accept": "application/json",
          'Authorization': "Bearer $authToken"
        }),
      );
      // print(' orderByDate Res ${response.data}');
      List<Order> orderList = [];
      // print('res${response.data['products']}');
      var res = response.data['orders'] as List<dynamic>;
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
                      shop: Shop(
                        id: p['shop']['id'].toString(),
                        shop_name: p['shop']['shop_name'],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ).toList();

      _allOrdersForAllUsers = orderList;
      print('_allOrdersForAllUsers $_allOrdersForAllUsers');
    } on DioError catch (e) {
      handleResponseError(e);
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  
  
  
  
   Future<void> updateOrderState(order_id,state) async {
    print('update state for order $state');

    final String url = Apis.updateState +'/'+ order_id;
    Response response;
    try {
      response = await dio.put(
        url,
        data: {state:state},
        options: Options(headers: {
          "Accept": "application/json",
          'Authorization': "Bearer $authToken"
        }),
      );
      print('update state order Res ${response.data}');
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
