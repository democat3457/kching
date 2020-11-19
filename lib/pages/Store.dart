import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final StoreArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
      ),
      // body: Text(args.name),
    );
  }
}
