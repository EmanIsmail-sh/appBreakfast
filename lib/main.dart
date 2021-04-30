import 'package:breakfastApp/providers/adminOrderProvider.dart';
import 'package:breakfastApp/providers/orderProvider.dart';
import 'package:breakfastApp/providers/productProvider.dart';
import './screens/userScreens/createOrderScreen.dart';
import 'screens/adminScreen/adminScreen.dart';
import 'package:device_preview/device_preview.dart';
import 'models/routes.dart';
import 'screens/authScreens/signIn.dart';
import './models/library.dart';

void main() {
  runApp(
    //  DevicePreview(
    // builder: (context) =>
    MyApp(),

    // ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: (_) => null,
          update: (ctx, auth, previousProduct) => ProductProvider(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.productsInOrder,
          ),
        ),
         ChangeNotifierProxyProvider<Auth, OrderProvider>(
          create: (_) => null,
          update: (ctx, auth, previousProduct) => OrderProvider(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.orders,
          ),
        ),
           ChangeNotifierProxyProvider<Auth, AdminOrderProvider>(
          create: (_) => null,
          update: (ctx, auth, previousProduct) => AdminOrderProvider(
            auth.token,
            auth.userId,
            previousProduct == null ? [] : previousProduct.allOrdersForAllUsers,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          // builder: DevicePreview.appBuilder,
          title: 'فطارك',

          theme: ThemeData(
              primarySwatch: Colors.red,
              primaryColor: Color(0xFFf75802),
              // iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              iconTheme: IconThemeData(color: Color(0xFFf75802)),
              textTheme: TextTheme(bodyText1: TextStyle(fontFamily: 'cairo'))),
          home: auth.isAuth 
              ? auth.gender == 0?  AdminScreen(): CreatOrderScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) => SignInScreen(),
                ),
          routes: Routes.routes,
        ),
      ),
    );
  }
}
