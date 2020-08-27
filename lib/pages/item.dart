import 'dart:io';

import 'package:delivery_app_biip/common/providers/cart.dart';
import 'package:delivery_app_biip/common/widgets/pleaseWaitWidget.dart';
import 'package:delivery_app_biip/models/json/appShopItemModel.dart';
import 'package:delivery_app_biip/models/json/appShopModel.dart';
import 'package:delivery_app_biip/common/widgets/badge.dart';
import 'package:getflutter/getflutter.dart';
import 'package:delivery_app_biip/pages/carrito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemPage extends StatefulWidget {
  int _itemId;
  String _itemName;
  Shop shop;
  Item item;

  ItemPage(this._itemId, this._itemName, this.shop, this.item);

  @override
  _ItemPageState createState() =>
      _ItemPageState(this._itemId, this._itemName, this.shop, this.item);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PleaseWaitWidget _pleaseWaitWidget =
      PleaseWaitWidget(key: ObjectKey("pleaseWaitWidget"));
}

class _ItemPageState extends State<ItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _itemId;
  String _itemName;
  Shop shop;
  Item item;
  int qty = 1;
  int rmQty = 0;

  _ItemPageState(this._itemId, this._itemName, this.shop, this.item);

  void _incrementQty() {
    setState(() {
      qty++;
    });
  }

  void _decrementQty() {
    setState(() {
      if (qty == 1 || qty < 1) {
      } else {
        qty--;
      }
    });
  }

  void _resetQty() {
    setState(() {
      rmQty = qty;
      qty = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final cart = Provider.of<Carrito>(context, listen: false);
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    void launchWhatsAppItem(
        {@required String phone,
          @required String message,
        }
        ) async {

      String url() {
        phone = shop.phone;
        message = "Bigshop Ref: \nHi ${shop.name} \nI would like to inquire about: ${item.name} for \$${item.price}";
        if (Platform.isIOS) {
          return "whatsapp://wa.me/$phone/?text=${Uri.encodeFull(message)}";
        } else {
          return "whatsapp://send?phone=$phone&text=${Uri.encodeFull(message)}";
        }
      }

      if (await canLaunch(url())) {
        await launch(url());
      } else {
        throw 'Could not launch ${url()}';
      }
    }


    IconData _backIcon() {
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          return Icons.arrow_back;
        case TargetPlatform.iOS:
          return Icons.arrow_back_ios;
      }
      assert(false);
      return null;
    }

    IconData _add_icon() {
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          return Icons.add_circle;
        case TargetPlatform.iOS:
          return Icons.add_circle;
      }
      assert(false);
      return null;
    }

    IconData _sub_icon() {
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          return Icons.remove_circle;
        case TargetPlatform.iOS:
          return Icons.remove_circle;
      }
      assert(false);
      return null;
    }

    // set up the button
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(_backIcon()),
            alignment: Alignment.centerLeft,
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: FittedBox(
              child: Text(
            '${shop.name} | ${item.name}',
          )),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Container(
                height: 150.0,
                width: 30.0,
                child: new GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: <Widget>[
                      new IconButton(
                          icon: new Icon(
                            Icons.shopping_cart,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            //Navigator.push(context, MaterialPageRoute(builder: (context) =>Checkout()));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CarritoPage()));
                          }),
                      cart.itemCount == 0
                          ? new Container()
                          : new Positioned(
                              child: new Stack(
                              children: <Widget>[
                                new Icon(Icons.brightness_1,
                                    size: 20.0, color: Colors.orange.shade500),
                                new Positioned(
                                    top: 4.0,
                                    right: 5.5,
                                    child: new Center(
                                      child: new Text(
                                        cart.itemCount.toString(),
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            )),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Card(
                elevation: 4.0,
                child: Container(
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // photo and title
                        SizedBox(
                          height: 250.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              new Container(
                                child: Image.network('${item.image}'),
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: DefaultTextStyle(
                      style: descriptionStyle,
                      child: FittedBox(
                          child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // three line description
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              item.name,
                              style: descriptionStyle.copyWith(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ),
                        ],
                      )))),
              Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: DefaultTextStyle(
                      style: descriptionStyle,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Precio: ',
                              style: descriptionStyle.copyWith(
                                  fontSize: 20.0, color: Colors.black54),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '\$${item.price}',
                              style: descriptionStyle.copyWith(
                                  fontSize: 20.0, color: Colors.black54),
                            ),
                          ),
                        ],
                      ))),
                  GFButton(
                    onPressed: () async{
                      if (await canLaunch('tel:+501${shop.phone.toString().substring(3)}')) {
                        await launch('tel:+501${shop.phone.toString().substring(3)}');
                      } else {
                        throw 'Could not launch ${shop.phone}';
                      }
                    },
                    text: "¿Llamar y preguntar sobre esto?",
                    shape: GFButtonShape.pills,
                    blockButton: true,
                    icon: Icon(Icons.call),
                    color: Colors.blueAccent,
                  ),
                  GFButton(
                    onPressed: launchWhatsAppItem,
                    text: "¿Preguntar al Wsp sobre esto?",
                    shape: GFButtonShape.pills,
                    blockButton: true,
                    icon: Icon(Icons.message),
                    color: Colors.green,
                  ),
              Container(
                  margin: EdgeInsets.all(10.0),
                  child: Card(
                      child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                          child: DefaultTextStyle(
                              style: descriptionStyle,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // three line description
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          new IconButton(
                                            icon: Icon(_add_icon(),
                                                color: Colors.amber.shade500),
                                            onPressed: () {
                                              _incrementQty();
                                            },
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 2.0),
                                          ),
                                          Text(
                                            '$qty',
                                            style: descriptionStyle.copyWith(
                                                fontSize: 20.0,
                                                color: Colors.black87),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right: 2.0),
                                          ),
                                          new IconButton(
                                            icon: Icon(_sub_icon(),
                                                color: Colors.amber.shade500),
                                            onPressed: () {
                                              _decrementQty();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: OutlineButton(
                                          borderSide: BorderSide(
                                              color: Colors.amber.shade500),
                                          child: const Text('Agregar'),
                                          textColor: Colors.amber.shade500,
                                          onPressed: () {
                                            if ((cart.currentshopId == null) ||
                                                (cart.currentshopId ==
                                                    shop.id)) {
                                              if (qty == 1) {
                                                cart.addItem(
                                                    item.id.toString(),
                                                    shop.id,
                                                    shop.phone,
                                                    item.price,
                                                    item.name,
                                                    qty,
                                                    shop);
                                                _resetQty();
                                                _scaffoldKey.currentState
                                                    .hideCurrentSnackBar();
                                                _scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Articulo agregado al carrito $rmQty'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                  action: SnackBarAction(
                                                    label: 'Deshacer',
                                                    onPressed: () {
                                                      cart.removeSingleItem(
                                                          item.id.toString(),
                                                          rmQty);
                                                    },
                                                  ),
                                                ));
                                              } else {
                                                cart.addItem(
                                                    item.id.toString(),
                                                    shop.id,
                                                    shop.phone,
                                                    item.price,
                                                    item.name,
                                                    qty,
                                                    shop);
                                                _resetQty();
                                                _scaffoldKey.currentState
                                                    .hideCurrentSnackBar();
                                                _scaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Productos agregados al carrito $rmQty'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                  action: SnackBarAction(
                                                    label: 'Deshacer',
                                                    onPressed: () {
                                                      cart.removeSingleItem(
                                                          item.id.toString(),
                                                          rmQty);
                                                    },
                                                  ),
                                                ));
                                              }
                                            } else {
                                              _scaffoldKey.currentState
                                                  .hideCurrentSnackBar();
                                              _scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Está agregando productos de otra tienda, ¿le gustaría limpiar su carrito para este restaurant actual y agregar estos productos para este restaurant en su carrito?'),
                                                duration: Duration(seconds: 5),
                                                action: SnackBarAction(
                                                  label: 'Restablecer Carrito',
                                                  onPressed: () {
                                                    cart.clear();
//                                                            cart.addItem(item.id.toString(), shop.id, item.price, item.name, qty);
//                                                            _resetQty();
//                                                            _scaffoldKey.currentState.hideCurrentSnackBar();
//                                                            _scaffoldKey.currentState.showSnackBar(SnackBar(
//                                                              content: Text('Added item to cart'),
//                                                              duration: Duration(seconds: 2),
//                                                              action: SnackBarAction(
//                                                                label: 'UNDO',
//                                                                onPressed: () {
//                                                                  cart.removeSingleItem(item.id.toString());
//                                                                },
//                                                              ),
                                                    if (qty == 1) {
                                                      cart.addItem(
                                                          item.id.toString(),
                                                          shop.id,
                                                          shop.phone,
                                                          item.price,
                                                          item.name,
                                                          qty,
                                                          shop);
                                                      _resetQty();
                                                      _scaffoldKey.currentState
                                                          .hideCurrentSnackBar();
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Producto agregado al carrito $rmQty'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        action: SnackBarAction(
                                                          label: 'Deshacer',
                                                          onPressed: () {
                                                            cart.removeSingleItem(
                                                                item.id
                                                                    .toString(),
                                                                rmQty);
                                                          },
                                                        ),
                                                      ));
                                                    } else {
                                                      cart.addItem(
                                                          item.id.toString(),
                                                          shop.id,
                                                          shop.phone,
                                                          item.price,
                                                          item.name,
                                                          qty,
                                                          shop);
                                                      _resetQty();
                                                      _scaffoldKey.currentState
                                                          .hideCurrentSnackBar();
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                            'Productos agregados al carrito $rmQty'),
                                                        duration: Duration(
                                                            seconds: 2),
                                                        action: SnackBarAction(
                                                          label: 'Deshacer',
                                                          onPressed: () {
                                                            cart.removeSingleItem(
                                                                item.id
                                                                    .toString(),
                                                                rmQty);
                                                          },
                                                        ),
                                                      ));
                                                    }
//                                                            ));
                                                  },
                                                ),
                                              ));
                                            }
                                          },
                                          shape: new OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          )),
                                    ),
                                  ),
                                ],
                              ))))),
              Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: DefaultTextStyle(
                      style: descriptionStyle,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // three line description
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Detalles',
                              style: descriptionStyle.copyWith(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ),
                        ],
                      ))),
              Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),
                  child: Text("${item.shortDescription}",
                      maxLines: 10,
                      style: TextStyle(fontSize: 13.0, color: Colors.black38))),
            ]))));
    //return Container();
  }

//  void dispose(){
//    rmQty = 0;
//  }
}
