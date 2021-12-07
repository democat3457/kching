import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:ntp/ntp.dart';
import 'package:pos_system/consts.dart';
import 'package:pos_system/pages/loading.dart';

class Holding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HoldingState();
  }

  static Future<bool> inHolding() async {
    // DateTime now = await NTP.now();

    print("called inHolding");
    return DateTime.now().isBefore(OPEN_TIME);
  }
}

class _HoldingState extends State<Holding> {
  Duration _timeLeft;
  Timer _timer;

  void _refreshTime() async {
    // DateTime now = await NTP.now();
    DateTime now = DateTime.now();
    if (now == null) {
      throw UnimplementedError();
    }
    setState(() {
      print("Setting time");
      this._timeLeft = OPEN_TIME.difference(now);
      this._timer = Timer.periodic(this._timeLeft, (timer) { _refreshTime(); });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Holding");
    if (_timeLeft == null) {
      _refreshTime();
    }
    if (_timeLeft == null) {
      return Loading();
    } else if (_timeLeft != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(TITLE + " - LOCKED!"),
        ),
        body: Center(
          child: Column(
              children: [
                Container(
                  height: 150,
                  width: 300,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Center(
                      child: Text(
                        _timeLeft.toString(),
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    )
                  )
                )
              ]
          ),
        ),
      );
    } else {
      throw UnimplementedError();
    }
  }
}
