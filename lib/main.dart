import 'package:flutter/material.dart';
import 'package:pos_system/cart.dart';
import 'package:pos_system/home.dart';
import 'strings.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => Home(),
  "/cart": (context) => Cart()
};

void main() {
  runApp(MaterialApp(
    title: mainTitle,
    themeMode: ThemeMode.dark,
    initialRoute: '/',
    routes: routes,
  ));
}
