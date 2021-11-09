import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';

class Error extends StatelessWidget {
  final String msg;
  final int timeout;
  final bool success;
  Error(this.msg, this.success, [this.timeout = ERROR_TIMEOUT]);

  Timer timer;

  @override
  Widget build(BuildContext context) {
    if (timer == null) {
      timer = Timer(Duration(seconds: timeout), () {
        print("Popping error off with success ($success)");
        Navigator.pop(context, success);
      });
    }
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            msg,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            "\nThis message will close in $timeout seconds...",
            textAlign: TextAlign.center,
            
          )
        ],
      )),
    );
  }
}
