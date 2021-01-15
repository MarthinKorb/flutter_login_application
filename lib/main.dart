import 'package:flutter/material.dart';
import 'pages/login_page.dart';

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
        accentColor: Colors.blueGrey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomAppBarColor: Colors.deepPurple[50],
        cardColor: Colors.deepPurple[100],
      ),
      darkTheme: ThemeData(),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
