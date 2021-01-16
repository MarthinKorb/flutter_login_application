import 'package:flutter/material.dart';
import 'package:flutter_login_application/components/horizontal_list_view.dart';
import 'package:flutter_login_application/pages/user_pages/products_list.dart';
import 'package:flutter_login_application/pages/user_pages/product_form.dart';
import 'package:flutter_login_application/services/product_service.dart';
import 'package:flutter_login_application/utils/theme_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var productServices = ProductService();
  SharedPreferences sharedPreferences;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var tabs = [
      Center(child: HorizontalListView()),
      Center(child: ProductsList()),
      Center(child: ProductForm()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rancho dos Guri',
          style: TextStyle(color: ThemeColor.headers),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              checkLoginStatus();
            },
            child: Icon(
              Icons.logout,
              color: ThemeColor.headers,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Theme.of(context).bottomAppBarColor,
        unselectedIconTheme: IconThemeData(color: ThemeColor.unselectedIcons),
        unselectedItemColor: ThemeColor.unselectedIcons,
        selectedFontSize: 14,
        fixedColor: ThemeColor.primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt,
            ),
            label: "Ver Produtos",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_to_photos,
            ),
            label: "Cadastrar",
          ),
        ],
      ),
      body: tabs[_currentIndex],
    );
  }
}
