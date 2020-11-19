import 'package:flutter/material.dart';
import 'cart.dart';
import 'consts.dart';
import 'pages/Store.dart';
import 'pages/Teams.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      theme: ThemeData(
        primarySwatch: PRIMARY_COLOR,
      ),
      routes: {
        "/": (context) => Teams(),
        Cart.ROUTE: (context) => Cart(),
        Store.ROUTE: (context) => Store(),
      },
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
    );
  }
}
