import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Error.dart';
import 'checkBal.dart';
import 'consts.dart';

class Charging extends StatelessWidget {
  final dynamic cardNumber;
  final String team;
  final double chargeAmount;
  final List<dynamic> possibleItems;
  final List<dynamic> selectedItems;

  Charging(this.possibleItems, this.selectedItems, this.cardNumber, this.team,
      this.chargeAmount);

  Future<double> getMoney() async {
    var url = "$ENDPOINT?"
              "card=$cardNumber&"
              "request=getbal";
    var test = await http.get(url);

    print(url);

    print(test.body);
    var processed = json.decode(test.body);
    print(processed["data"]);

    return double.parse(processed["data"].toStringAsFixed(2));
  }

  void loading(context) async {
    double currentBal = await CheckBal.getMoney(cardNumber);
    if (currentBal < chargeAmount) {
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => Error("Insufficent Funds.\nCurrent Balance:\n$KCHING_CURRENCY_SYM$currentBal", false)))
        .then((val) => Navigator.pop(context, val));
      return;
    }

    List<int> purchaseIDs = selectedItems.map(
        (item) => int.parse(possibleItems[item]["id"])
    ).toList();

    String idQuery = purchaseIDs.map((id) {
      return "purchase=$id";
    }).join("&");

    var url = Uri.encodeFull("$ENDPOINT?"
              "card=$cardNumber&"
              "team=$team&"
              "$idQuery&"
              "request=purchase");

    var test = await http.get(url);

    print(url);
    print(test.body);
    var processed = json.decode(test.body)["data"];

    // var errors = [];
    var backorders = [];
    double balAfterPurchase = currentBal;

    for (Map<String, dynamic> obj in processed) {
      if (obj.containsKey("error")) {
        // errors.add(obj["error"]);

        // All errors are terminating.
        await Navigator.push(
            context, 
            MaterialPageRoute(builder: 
                (context) => Error(processed["error"], false)))
          .then((val) => Navigator.pop(context, val));
        return;
      } else {
        balAfterPurchase = min(balAfterPurchase, double.parse(obj["bal"].toString()));

        if (obj.containsKey("warn")) {
          backorders.add(int.parse(obj["id"]));
        }

        // await Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (ctx) => Error(
        //             "Payment Successful\nYou Have $bal3 $KCHING_CURRENCY_STR""s left in your account", true)))
        //   .then((val) => Navigator.pop(context, val));
      }
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => Error(
                "Payment Successful!\n"
                "You have $balAfterPurchase $KCHING_CURRENCY_STR""s left in your account"+
                ((backorders.length > 0) ? "\n" + backorders.length.toString() + " of your products are on backorder." : ""), true)))
      .then((val) => Navigator.pop(context, val));
  }

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
