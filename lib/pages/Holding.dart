import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:ntp/ntp.dart';
import 'package:pos_system/consts.dart';
import 'package:pos_system/pages/Teams.dart';

class Holding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HoldingState();
  }

  static bool inHolding() {
    // DateTime now = await NTP.now();

    // print("called inHolding");
    return DateTime.now().isBefore(OPEN_TIME);
  }
}

class _HoldingState extends State<Holding> {
  // Duration _timeLeft;
  Timer _timer;

  // void _refreshTime() async {
  //   // DateTime now = await NTP.now();
  //   DateTime now = DateTime.now();
  //   if (now == null) {
  //     throw UnimplementedError();
  //   }
  //   setState(() {
  //     print("Setting time");
  //     this._timeLeft = OPEN_TIME.difference(now);
  //     this._timer = Timer.periodic(this._timeLeft, (timer) { _refreshTime(); });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // print("Holding");
    if (_timer == null) {
      this._timer = Timer.periodic(Duration(seconds: 1), (timer) { 
        if (!Holding.inHolding()) {
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (_) => new Teams()));
          timer.cancel();
        }
        setState(() { });
      });
    }
    // if (_timeLeft == null) {
    //   _refreshTime();
    // }
    // if (_timeLeft == null) {
    //   return Loading();
    // } else if (_timeLeft != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(TITLE + " - LOCKED!"),
        ),
        body: Center(
          child: Container(
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
                  OPEN_TIME.difference(DateTime.now()).toString().split('.').first.padLeft(8, "0") + "\nuntil launch!",
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
              )
            )
          )
        ),
      );
    // } else {
    //   throw UnimplementedError();
    // }
  }
}
