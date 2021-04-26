

import '../screens/userScreens/createOrderScreen.dart';
import '../screens/userScreens/myOrdersScreen.dart';

class Routes {
  static final routes = {
     MyOrderScreen.routeName: (ctx) => MyOrderScreen(),
     CreatOrderScreen.routeName: (ctx) => CreatOrderScreen()
  };
}
