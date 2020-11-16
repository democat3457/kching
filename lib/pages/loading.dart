import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$title: Loading")),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
