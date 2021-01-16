import 'package:flutter/material.dart';
import 'package:flutter_login_application/pages/user_pages/home_page.dart';
import 'package:flutter_login_application/utils/theme_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '!Shopping List',
      theme: ThemeData(
        primaryColor: ThemeColor.color[700],
        canvasColor: ThemeColor.canvasColor[50],
        accentColor: ThemeColor.secundaryColor,
        bottomAppBarColor: ThemeColor.bottomAppBarColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        errorColor: ThemeColor.warningColor[400],
      ),
      darkTheme: ThemeData(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
    );
  }
}
