import 'dart:async';
import 'dart:io';
import 'package:delivery_app_biip/common/apifunctions/requestLogoutAPI.dart';
import 'package:delivery_app_biip/pages/about.dart';
import 'package:delivery_app_biip/pages/carrito.dart';
import 'package:delivery_app_biip/pages/dashboard.dart';
import 'package:delivery_app_biip/pages/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:delivery_app_biip/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Inicio", Icons.home),
    new DrawerItem("Carrito", Icons.shopping_basket),
    new DrawerItem("Pedidos", Icons.list),
    new DrawerItem("Acerda de", Icons.event_note),
    new DrawerItem("Cerrar Sesión", Icons.exit_to_app)

  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  String _name  = "";
  String _email = "";
  String _picture = "";

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/home");
    _loadUser();
  }

  _loadUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _name = preferences.getString("LastUser");
      _email = preferences.getString("LastEmail");
      _picture = preferences.getString("LastPicture");
    });
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DashboardPage();
      case 1:
        return new CarritoPage();
      case 2:
        return new OrdersPage();
      case 3:
        return new AboutPage();
      case 4:
        return new LoginPage();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    if (index == 4){
      requestLogoutAPI(context);
      Navigator.of(context).pushReplacementNamed('/loginScreen');
    }else{
      setState(() => _selectedDrawerIndex = index);
      Navigator.of(context).pop();
    }
    // close the drawer
  }
  //modification ends here


  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('¿Quieres salir de esta aplicación?'),
        content: new Text('Odiamos verte partir...'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Si'),
          ),
        ],
      ),
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        ),

      );
    }

    Future<bool> showLoginPage() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("LastAccessToken");
      return token == null;
    }

    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: FutureBuilder<bool>(
          future: showLoginPage(),
          builder: (buildContext, snapshot) {
            if(snapshot.hasData) {
              if(snapshot.data){
                // Return your login here
                return LoginPage();
              }

              // Return your home here
              return Scaffold(
                appBar: AppBar(
                  // Here we take the value from the MyHomePage object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: Text("BIIP delivery"),
                ),
                drawer: new Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          accountName: Text('${_name.toUpperCase()}'),
                          accountEmail: Text('${_email}'),
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: Image.network('${_picture}').image,
                            backgroundColor:
                            Theme.of(context).platform == TargetPlatform.iOS
                                ? Colors.red
                                : Colors.white,
                            child: Text(
                              '${_name.substring(0, 1)}',
                              style: TextStyle(fontSize: 40.0,),
                            ),
                          ),
                        ),
                        new Column(children: drawerOptions),
                      ],
                    )
                ),
                body: _getDrawerItemWidget(_selectedDrawerIndex),
              );
            } else {
              // Return loading screen while reading preferences
              return Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}
