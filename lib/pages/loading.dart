import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';

class Loading extends StatelessWidget {
  final String title;
  Loading({this.title = TITLE});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$TITLE: Loading")),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
