import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Error.dart';
import 'consts.dart';

class Charging extends StatelessWidget {
  final int cardNumber;
  final String team;
  final double chargeAmount;
  final List<dynamic> possibleItems;
  final List<dynamic> selectedItems;

  Charging(this.possibleItems, this.selectedItems, this.cardNumber, this.team,
      this.chargeAmount);

  bool _error = false;
  String _errorMsg = "";

  Future<int> getMoney() async {
    var url = "$ENDPOINT?"
              "card=$cardNumber&"
              "request=getbal";
    var test = await http.get(url);

    print(url);

    print(test.body);
    var processed = json.decode(test.body);
    print(processed["data"]);

    return processed["data"];
  }

  void loading(context) async {
    int currentBal = await getMoney();
    if (currentBal < chargeAmount) {
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => Error("Insufficent Funds.\nCurrent Balance:\n$KCHING_CURRENCY_SYM$currentBal", false)))
        .then((val) => Navigator.pop(context, val));
      return;
    }
    for (int x = 0; x < selectedItems.length; x++) {
      int id = int.parse(possibleItems[selectedItems[x]]["id"]);

      var url = Uri.encodeFull("$ENDPOINT?"
                "card=$cardNumber&"
                "team=$team&"
                "withdrawl=$id&"
                "request=withdrawl");

      var test = await http.get(url);

      print(url);
      print(test.body);
      var processed = json.decode(test.body);

      if ((processed as Map<String, dynamic>).containsKey("error")) {
        _errorMsg = processed["error"];
        break;
      }
    }

    if (!(_errorMsg?.isEmpty ?? true)) {
      await Navigator.push(
          context, 
          MaterialPageRoute(builder: 
              (context) => Error(_errorMsg, false)))
        .then((val) => Navigator.pop(context, val));
    } else {
      var bal = await http.get(
          "$ENDPOINT?"
          "card=$cardNumber&"
          "request=getbal");

      var bal2 = json.decode(bal.body);
      print(bal2);

      var bal3 = double.parse(bal2["data"].toString());

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => Error(
                  "Payment Successful\nYou Have $bal3 $KCHING_CURRENCY_STR""s left in your account", true)))
        .then((val) => Navigator.pop(context, val));
    }
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
