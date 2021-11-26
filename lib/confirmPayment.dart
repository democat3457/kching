import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';

import 'chargingScreen.dart';

class ConfirmPayment extends StatelessWidget {
  final dynamic cardNumber;
  final double chargeAmount;
  final String team;
  
  final List<dynamic> possibleItems;
  final List<dynamic> selectedItems;

  ConfirmPayment(this.selectedItems, this.possibleItems, this.cardNumber, this.chargeAmount, this.team);

  void chargeUser(context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Charging(possibleItems, 
            selectedItems, cardNumber, team, chargeAmount)))
      .then((val) => Navigator.pop(context, val));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Confirm Payment of ($chargeAmount) $KCHING_CURRENCY_STR""s\n"
            "to the card number ($cardNumber)?\n",
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("Accept"),
                onPressed: () {
                  chargeUser(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)
                )
              ),
              ElevatedButton(
                child: Text("Deny"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)
                )
              )
            ]
          )
        ],
      )),
    );
  }
}
