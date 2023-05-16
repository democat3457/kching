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
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  dynamic _data;

  void getData() async {
    if (_isLoading == true) {
      final http.Response _request = await http.get(queryEndpoint({
        'request': 'teams'
      }));
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
    print("Current time: " + DateTime.now().toIso8601String());
    print("Close time: " + CLOSE_TIME.toIso8601String());

    return _isLoading
        ? Progress()
        : (
            DateTime.now().isAfter(CLOSE_TIME)
            ? Holding()
            : ChooseTeam(_data)
          );
  }
}
