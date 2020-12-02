import 'dart:convert';
import 'dart:developer';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';
import 'package:pos_system/utils/CartData.dart';
import 'package:pos_system/utils/api.dart';

import 'loading.dart';

class CheckoutArguments {
  final List<Map<String, dynamic>> data;
  CheckoutArguments(this.data);
}

class Checkout extends StatefulWidget {
  final CheckoutArguments args;
  Checkout(this.args);
  @override
  State<StatefulWidget> createState() {
    return _CheckoutState(args);
  }
}

class _CheckoutState extends State<Checkout> {
  final CheckoutArguments args;
  _CheckoutState(this.args);
  GlobalKey<State> _keyLoader = new GlobalKey<State>();
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
              textCapitalization: TextCapitalization.characters, // Not Working
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
            LoadingDialog.showLoading(context, new GlobalKey<State>(),
                message: "Verifing");
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
            LoadingDialog.showLoading(context, new GlobalKey<State>(),
                message: "Processing");
            response = await setter(
                Tasks.Purchase, {"id": _controller.text, "data": args.data});
            log(response.toString());
            Navigator.pop(context); // Close Second Loading Screen
            if (!response["valid"]) {
              log("Detected something sly. Activate Big Chomp Protocol");
              print(json.encode(response));
              try {
                js.context.callMethod('open', ['https://youtu.be/RfiQYRn7fBg']);
              } catch (_) {}
              return;
            }
            if (response["overdraw_and_fail"]) {
              await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("Overdrawl Detected"),
                        content: Text(
                            "Current Balance is $KCHING_BUCK_SYM${response['bal']}"),
                        actions: [
                          TextButton(
                            child: Text("Exit"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(_context);
                            },
                          )
                        ],
                      ));
            } else {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Transaction Complete"),
                  content: Text(
                      "Your current balance is $KCHING_BUCK_SYM${response['bal']}"),
                  actions: [
                    TextButton(
                      child: Text("Exit"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(_context);
                      },
                    )
                  ],
                ),
              );
              CartData.clearCart();
            }
          },
        )
      ],
    );
  }
}
