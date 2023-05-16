import 'dart:core';

import 'package:flutter/material.dart';
import 'consts.dart';

class Holding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HoldingState();
  }
}

class _HoldingState extends State<Holding> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MAIN_TITLE + " - CLOSED"),
      ),
      body: Center(
        child: Text('Thanks for participating!\n\nThe store is now closed, and new\ntransactions are no longer accepted.')
      ),
    );
  }
}
