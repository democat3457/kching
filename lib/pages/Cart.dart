import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';
import 'package:pos_system/pages/CheckBal.dart';
import 'package:pos_system/utils/CartData.dart';

import 'Checkout.dart';
import 'loading.dart';

class _CartList extends StatelessWidget {
  final _CartState state;
  _CartList(this.state);
  @override
  Widget build(BuildContext context) {
    int position = 0;
    final data = state.getData();
    List<Widget> widgets = List.from(data.map((i) {
      final int curr = position;
      position++;
      return ListTile(
        leading: Text(KCHING_BUCK_SYM + i["cost"].toStringAsFixed(2)),
        title: Text(i["name"]),
        trailing: IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            CartData.removeItem(curr).then((_) => state.reload());
          },
        ),
      );
    }).cast<Widget>());
    return SingleChildScrollView(
      child: Column(
        children: widgets,
      ),
    );
  }
}

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
  List<Map<String, dynamic>> _data = [];

  void _loadItems() async {
    _data = List.from((await CartData.getItems())["items"]);
    setState(() {
      this._loaded = true;
      this._loading = false;
    });
  }

  void reload() {
    setState(() {
      _loading = false;
      _loaded = false;
    });
  }

  List<Map<String, dynamic>> getData() {
    return _data;
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading && !_loaded) {
      _loadItems();
    } else if (_loaded && !_loaded) {
      return Loading(title: "Shopping Cart");
    }
    double total = 0.0;
    for (final x in _data) {
      total += x["cost"];
    }
    total = double.parse(total.toStringAsFixed(2));
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async => await showDialog(
                context: context, builder: (context) => CheckBal()),
          )
        ],
      ),
      floatingActionButton: (_data.length == 0)
          ? null
          : FloatingActionButton.extended(
              label: Text("Check Out"),
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Checkout(CheckoutArguments(_data));
                  },
                );
                setState(() {
                  _loading = false;
                  _loaded = false;
                });
                // Navigator.pushNamed(context, Checkout.ROUTE);
              },
              icon: Icon(Icons.check_outlined),
            ),
      body: (_data.length == 0)
          ? Center(
              child: Text(
              "It appears there is nothing in the cart,\n"
              "try checking out the products that the many stores are selling "
              "on the previous page",
              textAlign: TextAlign.center,
            ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: _CartList(this)),
                SizedBox(
                  height: 100.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total: $KCHING_BUCK_SYM$total",
                          style: Theme.of(context).textTheme.headline2,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
