import 'package:flutter/material.dart';
import 'strings.dart';

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mainTitle),
      ),
      body: Center(child: CircularProgressIndicator(),)
    );
  } 
}