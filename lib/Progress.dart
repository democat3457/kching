import 'package:flutter/material.dart';
import 'consts.dart';

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MAIN_TITLE),
      ),
      body: Center(child: CircularProgressIndicator(),)
    );
  } 
}