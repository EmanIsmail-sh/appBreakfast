import 'package:breakfastApp/providers/productProvider.dart';
import 'package:breakfastApp/screens/userScreens/myOrdersScreen.dart';

import '../models/library.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Consumer<Auth>(
            builder: (ctx, auth, ch) => 
                buildDrawerHeader(context, auth),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
         
                ListTile(
                  leading: Icon(
                    Icons.request_page,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    'اطلب فطارك',
                    style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily:Theme.of(context).textTheme.bodyText1.fontFamily,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Provider.of<ProductProvider>(context,listen: false).productsInOrder.clear();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_basket,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    'طلباتي',
                    style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily:
                          Theme.of(context).textTheme.bodyText1.fontFamily,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SignInScreen()),
                    //   ModalRoute.withName("/"),
                    // );
                    Navigator.of(context)
                        .pushReplacementNamed(MyOrderScreen.routeName);
                   
                  },
                ),
                    Consumer<Auth>(
                  builder: (ctx, auth, ch) => ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      'تسجيل خروج',
                      style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1.fontFamily,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SignInScreen()),
                      //   ModalRoute.withName("/"),
                      // );
                      Navigator.of(context).pushReplacementNamed('/');
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Directionality buildAppBar() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          border: Border(bottom: BorderSide(width: 2, color: Colors.grey[350])),
        ),
        child: Image.asset('assets/logo.webp'),
        width: 80,
        height: 90,
      ),
    );
  }

  DrawerHeader buildDrawerHeader(BuildContext context, Auth auth) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: auth.isAuth
                      ? CircleAvatar(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          backgroundColor: Colors.white,
                        )
                      : Image.asset(
                          'assets/logo.webp',
                          color: Colors.white,
                        ),
                ),
                // FlatButton.icon(
                //   padding: EdgeInsets.all(0),
                //   onPressed: () {
                //     print('setting');
                //   },
                //   icon: Icon(
                //     Icons.settings,
                //     color: Colors.white,
                //   ),
                //   label: Text(''),
                // ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              auth.isAuth ? '${auth.userInformation['name']}' : '',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              auth.isAuth ? '${auth.userInformation['email']}' : '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
