import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_system/utils/api.dart';

import 'loading.dart';

class CheckoutArguments {
  final List<Map<String, dynamic>> data;
  CheckoutArguments(this.data);
}

class Checkout extends StatefulWidget {
  static const ROUTE = "/cart/checkout";
  @override
  State<StatefulWidget> createState() {
    return _CheckoutState();
  }
}

class _CheckoutState extends State<Checkout> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _context = context;
    CheckoutArguments args = ModalRoute.of(context).settings.arguments;

    return AlertDialog(
      title: Text("Checkout"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              obscureText: false,
              autofocus: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelStyle: TextStyle(color: Colors.black),
                labelText: "Yer Card Number `Eh?",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Exit",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(
            "Checkout",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            log(_controller.text);
            LoadingDialog.showLoading(context, _keyLoader);
            var response = await getter(Tasks.Login, {"id": _controller.text});
            bool valid = response["valid"];
            if (!valid) {
              Navigator.pop(context);
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Invalid Card ID"),
                  content: Text("Try Again"),
                  actions: [
                    TextButton(
                      child: Text(
                        "Exit",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              );
              // Navigator.pop(_context);
              return;
            }
            Navigator.pop(context); // Close First Loading Screen
            LoadingDialog.showLoading(context, _keyLoader);
            Navigator.pop(context); // Close Second Loading Screen
            // TODO: Send to API to commit transaction.
            // TODO: Show transaction complete.
            // TODO: Show if there is any errors.
            await Future.delayed(Duration(seconds: 2), () => null);
            Navigator.pop(_context);
          },
        )
      ],
    );
  }
}
