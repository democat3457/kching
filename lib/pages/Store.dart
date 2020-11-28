import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';
import 'package:pos_system/utils/CartData.dart';
import 'package:pos_system/utils/api.dart';

import 'loading.dart';

class StoreArguments {
  final String name;
  final String id;

  StoreArguments(this.name, this.id);
}

class Store extends StatefulWidget {
  static const String ROUTE = "/store";
  @override
  State<StatefulWidget> createState() {
    return _StoreRoute();
  }
}

class _StoreRoute extends State<Store> {
  bool _loading = false;
  bool _loaded = false;
  Map<String, dynamic> _data = {};

  Widget buildProductList(String code) {
    return ListView.separated(
      itemCount: this._data["data"].length,
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemBuilder: (context, index) {
        final Map<String, dynamic> itemData = this._data["data"][index];
        return Card(
            child: ListTile(
                leading: Container(
                    height: double.infinity,
                    width: 50,
                    child: Text(
                      itemData["cost"].toDouble().toStringAsFixed(2),
                      style: Theme.of(context).textTheme.caption,
                    )),
                title: Text(itemData["name"]),
                subtitle: Text(
                  itemData["desc"],
                  style: Theme.of(context).textTheme.caption,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart_sharp,
                  ),
                  onPressed: () {
                    CartData.addItems(
                        {...itemData, "code": code.toUpperCase()}, 1);
                  },
                )));
      },
    );
  }

  void _loadProducts(String code) async {
    this._data = await getter(Tasks.Products, {"code": code.toUpperCase()});
    if (this._data == null) {
      throw UnimplementedError();
    }
    setState(() {
      this._loaded = true;
      this._loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final StoreArguments args = ModalRoute.of(context).settings.arguments;
    if (args == null) {
      Navigator.pop(context);
      return Loading();
    }
    if (!_loaded && !_loading) {
      _loadProducts(args.id);
      setState(() {
        this._loading = true;
      });
    }
    if (!_loaded && _loading) {
      return Loading();
    } else if (_loaded && !_loading) {
      if (this._data["valid"] == false) {
        return Scaffold(
            appBar: AppBar(
              title: Text(args.name),
            ),
            body: Center(child: Text(ERROR_LOADING_PRODUCTS)));
      }
      return Scaffold(
          appBar: AppBar(
            title: Text(args.name),
          ),
          body: buildProductList(args.id)
          // body: Center(child: Text(_data.toString())),
          // body: Text(args.name),
          );
    } else {
      throw UnimplementedError();
    }
  }
}
