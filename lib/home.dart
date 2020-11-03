import 'package:flutter/material.dart';
import 'package:pos_system/strings.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mainTitle),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.pushNamed(context, "/cart"),
            ),
          )
        ],
      ),
    );
  }
}
