import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  static const String ROUTE = "/cart";
  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping Cart")),
    );
  }
}
