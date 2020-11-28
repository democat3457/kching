import 'package:flutter/material.dart';
import 'package:pos_system/utils/CartData.dart';

import 'loading.dart';

class Cart extends StatefulWidget {
  static const String ROUTE = "/cart";
  @override
  State<StatefulWidget> createState() {
    return _CartState();
  }
}

class _CartState extends State<Cart> {
  bool _loading = false;
  bool _loaded = false;
  Map<String, dynamic> _data = {};

  void _loadItems() async {
    _data = await CartData.getItems();
    setState(() {
      this._loaded = true;
      this._loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading && !_loaded) {
      _loadItems();
    } else if (_loaded && !_loaded) {
      return Loading(title: "Shopping Cart");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Check Out"),
        onPressed: () {},
        icon: Icon(Icons.check_outlined),
      ),
      body: Center(
          child: ListView.separated(
        itemCount: _data["items"].length,
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
          );
        },
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_data["items"][index]["name"]),
            trailing: IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {},
            ),
          );
        },
      )),
    );
  }
}
