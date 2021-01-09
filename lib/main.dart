import 'package:flutter/material.dart';
import 'package:flutter_login_application/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(),
      // home: MyHomePage(title: 'Login App'),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
