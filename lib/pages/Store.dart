import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_system/consts.dart';
import 'package:pos_system/utils/CartData.dart';
import 'package:pos_system/utils/api.dart';
import 'package:url_launcher/url_launcher.dart';

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
        print(itemData);
        return Card(
          child: ListTile(
            minVerticalPadding: 17,
            minLeadingWidth: 80,
            leading: Text(
              KCHING_BUCK_SYM + double.parse(itemData["cost"]).toStringAsFixed(2),
              style: Theme.of(context).textTheme.caption,
            ),
            title: Text(itemData["name"]),
            subtitle: (itemData["img"] == "") 
              ? Text(
                  itemData["desc"],
                  style: Theme.of(context).textTheme.caption,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemData["desc"] + "\n",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    CachedNetworkImage(
                      imageUrl: itemData["img"],
                      placeholder: (conttext, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Row(
                        children: [
                          Icon(Icons.error),
                          Text("Error loading image")
                        ]
                      ),
                      height: PRODUCT_IMAGE_HEIGHT,
                    )
                  ],
                ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_shopping_cart_sharp,
              ),
              onPressed: () async {
                await CartData.addItems(
                  {...itemData, "code": code.toUpperCase()},
                  1,
                );
                await Fluttertoast.showToast(
                  msg: "Added Item to Cart",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                  webPosition: "center",
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _loadProducts(String code) async {
    this._data = await getter(Tasks.Products, {"code": code.toUpperCase()});
    if (this._data == null) {
      throw UnimplementedError();
    }
    print(this._data["site"]);
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
        body: Padding(
          padding:
              const EdgeInsets.only(top: 16, left: PADDING, right: PADDING),
          child: buildProductList(args.id),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (_data["site"] == "")
            ? null
            : Container (
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton.extended(
                    heroTag: "cartbtn",
                    icon: Icon(Icons.shopping_bag_outlined),
                    label: Text("Cart"),
                    onPressed: () => Navigator.pushNamed(context, "/cart")
                  ),
                  FloatingActionButton.extended(
                    heroTag: "sitebtn",
                    icon: Icon(Icons.web),
                    label: Text("Open Store's Website"),
                    onPressed: () => launch(_data["site"]),
                  )
                ]
              )
            )
      );
    } else {
      throw UnimplementedError();
    }
  }
}
