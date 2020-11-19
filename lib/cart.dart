import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  static const String ROUTE = "/cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping Cart")),
    );
  }
}
