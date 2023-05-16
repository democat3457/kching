import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';
import 'package:http/http.dart' as http;
import 'Progress.dart';
import 'payment.dart';

class CheckBal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CheckBalState();
  }

  static Future<double> getMoney(dynamic cardNumber) async {
    var cardExists = await http.get(queryEndpoint({
      'request': 'cardExist',
      'card': cardNumber.toString(),
      'team': 'online'
    }));

    if (!json.decode(cardExists.body)["data"])
      return -1.0;

    var url = queryEndpoint({
      'card': cardNumber.toString(),
      'request': 'getbal'
    });
    var test = await http.get(url);

    print(url);

    print(test.body);
    var processed = json.decode(test.body);
    print(processed["data"]);

    return processed["data"];
  }
}

class _CheckBalState extends State<CheckBal> {
  late TextEditingController _controller;

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

    void checkBal(String value) async {
      Progress.showLoading(context, new GlobalKey<State>(),
          message: "Checking");
      var bal = await CheckBal.getMoney(_controller.text);
      Navigator.pop(context);
      if (bal == -1.0) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Invalid Card ID"),
            actions: [
              TextButton(
                child: Text("Exit"),
                autofocus: true,
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
        Navigator.pop(_context);
        return;
      }
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Balance"),
          content: Text(
              "You have " + KCHING_CURRENCY_SYM + bal.toString()),
          actions: [
            TextButton(
              child: Text("Exit"),
              autofocus: true,
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
      Navigator.pop(_context);
    }

    return AlertDialog(
      title: Text("Check Balance"),
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
                labelText: "Card ID",
              ),
              onSubmitted: (val) => checkBal(val),
              inputFormatters: [UpperCaseTextFormatter()],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Exit"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text("Get Balance"),
          onPressed: () => checkBal(_controller.text),
        )
      ],
    );
  }
}