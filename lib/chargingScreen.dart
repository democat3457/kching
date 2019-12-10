import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Error.dart';

class Charging extends StatelessWidget {
  final int cardNumber;
  final String team;
  final double chargeAmmount;
  final List<dynamic> possibleItems;
  final List<dynamic> selectedItems;

  Charging(this.possibleItems, this.selectedItems, this.cardNumber, this.team,
      this.chargeAmmount);

  bool _error = false;
  String _errorMsg = "";

  Future<bool> checkIfMoneyExists() async {
    var test = await http.get(
        "https://script.google.com/macros/s/AKfycbwvuOs4vCjjECBZzSDnZ6kW0kv5hCvgEcDisGCMK1Pm/dev?"
        "card=$cardNumber&"
        "request=getbal");

    print(test.body);
    var processed = json.decode(test.body);
    print(processed["data"]);

    return processed["data"] > chargeAmmount;
  }

  void loading(context) async {
    bool moneyIsThere = await checkIfMoneyExists();
    if (!moneyIsThere) {
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Error("Insufficent Funds")));
      Navigator.pop(context);
    }
    for (int x = 0; x < selectedItems.length; x++) {
      int id = int.parse(possibleItems[selectedItems[x]]["id"]);

      var test = await http.get(
          "https://script.google.com/macros/s/AKfycbwvuOs4vCjjECBZzSDnZ6kW0kv5hCvgEcDisGCMK1Pm/dev?"
          "card=$cardNumber&"
          "team=$team&"
          "withdrawl=$id&"
          "request=withdrawl");

      print(test.body);
      var processed = json.decode(test.body);

      if ((processed as Map<String, dynamic>).containsKey("error")) {
        _error = true;
        _errorMsg = processed["error"];
        break;
      }
    }

    if (_error) {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Error(_errorMsg)));
    } else {
      var bal = await http.get(
          "https://script.google.com/macros/s/AKfycbwvuOs4vCjjECBZzSDnZ6kW0kv5hCvgEcDisGCMK1Pm/dev?"
          "card=$cardNumber&"
          "request=getbal");

      var bal2 = json.decode(bal.body);
      print(bal2);

      var bal3 = double.parse(bal2["data"].toString());

      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Error(
                  "Payment Successful\nYou Have $bal3 K`Ching left in your account")));
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
