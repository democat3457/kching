import 'dart:async';
import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String msg;
  Error(this.msg);

  bool timerStart = false;

  @override
  Widget build(BuildContext context) {
    if (timerStart == false) {
      timerStart = true;
      Timer(Duration(seconds: 5), () {
        Navigator.pop(context);
      });
    }
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            msg,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "This Message will close in 5 seconds",
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }
}
