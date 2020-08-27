import 'package:delivery_app_biip/models/json/appShopModel.dart';
import 'package:delivery_app_biip/pages/carrito.dart';
import 'package:delivery_app_biip/pages/home.dart';
import 'package:delivery_app_biip/pages/item.dart';
import 'package:delivery_app_biip/pages/items.dart';
import 'package:delivery_app_biip/pages/orders.dart';
import 'package:delivery_app_biip/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app_biip/pages/login.dart';
import 'package:provider/provider.dart';

import 'common/providers/cart.dart';
import 'common/providers/orders.dart';
import 'models/json/appShopItemModel.dart';

void main() => runApp(BigShopApp());

// ignore: must_be_immutable
class BigShopApp extends StatelessWidget {
  int shopId;
  int itemId;
  String shopName;
  String itemName;
  Shop shop;
  Item item;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Carrito(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BIIP delivery',
        routes: <String, WidgetBuilder>{
          "/loginScreen": (BuildContext context) => LoginPage(),
          "/home": (BuildContext context) => HomePage(),
          "/items": (BuildContext context) => ItemsPage(shopId,shopName,shop),
          "/item": (BuildContext context) => ItemPage(itemId,itemName,shop,item),
          "/cart": (BuildContext context) => CarritoPage(),
          "/orders": (BuildContext context) => OrdersPage(),
          "/splash": (BuildContext context) => SplashPage(),
        },
        home: LoginPage(),
      ),
    );
  }
}
