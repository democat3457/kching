import 'dart:convert';

import 'package:flutter/material.dart';
import 'strings.dart' as stuff;
import 'chooseTeam.dart';
import 'package:http/http.dart' as http;
import 'Progress.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: stuff.mainTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: stuff.mainTitle),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  dynamic _data;

  void getData() async {
    if (_isLoading == true) {
      final http.Response _request = (await http.get(
          "https://script.google.com/macros/s/AKfycbwvuOs4vCjjECBZzSDnZ6kW0kv5hCvgEcDisGCMK1Pm/dev?request=teams"));

      _data = json.decode(_request.body);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();

    return _isLoading
        ? Progress()
        : ChooseTeam(_data);
  }
}
