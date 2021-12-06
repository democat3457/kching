import 'dart:core';

import 'package:flutter/material.dart';
import 'checkBal.dart';
import 'consts.dart';
import 'payment.dart';

class ChooseTeam extends StatefulWidget {
  @required
  final Map<String, dynamic> data;
  ChooseTeam(this.data);

  @override
  State<StatefulWidget> createState() {
    return ChooseTeamState(data);
  }
}

class ChooseTeamState extends State<ChooseTeam> {
  @required
  final Map<String, dynamic> data;
  ChooseTeamState(this.data);

  String dropdownValue;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MAIN_TITLE),
        actions: [
          TextButton(
            child: Row(
              children: [ 
                Icon(
                  Icons.attach_money_outlined,
                ),
                Text(
                  "Check Balance",
                ),
              ],
            ),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black)
            ),
            onPressed: () async => await showDialog(
                context: context, builder: (context) => CheckBal())
          )
        ],
      ),
      body: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          hint: Text("Select A Team"),
          icon: Icon(Icons.arrow_downward),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              selected = true;
            });
          },
          items: (data["data"].map<DropdownMenuItem<String>>((dynamic value) {
            return DropdownMenuItem<String>(
              value: value.toString(),
              child: Text(value.toString()),
            );
          }).toList()),
        ),
      ),
      floatingActionButton: selected
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Payment(
                          dropdownValue.toString()
                          )));
              },
              child: Icon(Icons.navigate_next),
              backgroundColor: MAIN_COLOR,
            )
          : null,
    );
  }
}
