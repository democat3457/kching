import 'package:flutter/material.dart';

import 'chargingScreen.dart';

class ConfirmPayment extends StatelessWidget {
  final int cardNumber;
  final double chargeAmmount;
  final String team;
  
  final List<dynamic> possibleItems;
  final List<dynamic> selectedItems;

  ConfirmPayment(this.selectedItems, this.possibleItems, this.cardNumber, this.chargeAmmount, this.team);

  void chargeUser(context) async {
    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Charging(possibleItems, selectedItems, cardNumber, team, chargeAmmount)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: <Widget>[
          Text(
            "Confirm Payment of ($chargeAmmount) Ka`Ching\n"
            "To the card number ($cardNumber)?",
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            child: Text("Accept"),
            onPressed: () {
              chargeUser(context);
            },
            color: Colors.green,
          ),
          RaisedButton(
            child: Text("Deny"),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
          )
        ],
      )),
    );
  }
}
