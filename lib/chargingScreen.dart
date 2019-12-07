import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Error.dart';

class Charging extends StatelessWidget {
  final int cardNumber;
  final double chargeAmmount;
  final String team;

  Charging(this.cardNumber, this.chargeAmmount, this.team);

  void loading(context) async {
    var test = await http.get(
        "https://script.google.com/macros/s/AKfycbwvuOs4vCjjECBZzSDnZ6kW0kv5hCvgEcDisGCMK1Pm/dev?"
        "card=$cardNumber&"
        "team=$team&"
        "withdrawl=$chargeAmmount&"
        "request=withdrawl");

    print(test.body);
    var processed = json.decode(test.body);
    
    if ((processed as Map<String, dynamic>).containsKey("error")) {
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Error(processed["error"])));
    }
    else {
      var bal = await http.get(
        "https://script.google.com/macros/s/AKfycbwvuOs4vCjjECBZzSDnZ6kW0kv5hCvgEcDisGCMK1Pm/dev?"
        "card=$cardNumber&"
        "request=getbal");

      var bal2 = json.decode(bal.body);
      print(bal2);
      
      var bal3 = double.parse(bal2["data"].toString());

      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Error("Payment Successful\nYou Have $bal3 K`Ching left in your account")));
    }
    Navigator.pop(context);
  }

  bool loadingSet = true;

  @override
  Widget build(BuildContext context) {
    loading(context);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
