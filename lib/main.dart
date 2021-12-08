import 'dart:convert';

import 'package:flutter/material.dart';
import 'holding.dart';
import 'consts.dart';
import 'chooseTeam.dart';
import 'package:http/http.dart' as http;
import 'Progress.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MAIN_TITLE,
      theme: ThemeData(
        primarySwatch: MAIN_COLOR,
      ),
      home: MyHomePage(title: MAIN_TITLE),
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
          "$ENDPOINT?request=teams"));
      print(_request.body);
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
        : (
            DateTime.now().isAfter(CLOSE_TIME)
            ? Holding()
            : ChooseTeam(_data)
          );
  }
}
