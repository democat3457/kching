import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Progress.dart';
import 'confirmPayment.dart';

class Payment extends StatefulWidget {
  final String team;
  Payment(this.team);

  @override
  State<StatefulWidget> createState() {
    return PaymentState(team);
  }
}

class PaymentState extends State<Payment> {
  final String team;
  PaymentState(this.team);

  final _formKey = GlobalKey<FormState>();

  List<dynamic> possibleItems = new List();
  List<dynamic> selectedItems = new List();

  bool _loaded = false;

  void load() async {
    if (_loaded) return;
    Response items = await get(
        "https://script.google.com/macros/s/AKfycbwvuOs4vCjjECBZzSDnZ6kW0kv5hCvgEcDisGCMK1Pm/dev?"
        "request=getItems&"
        "team=$team");

    dynamic data = json.decode(items.body)["data"];

    for (var x in data) {
      Map<String, dynamic> data = {
        "id": x["id"],
        "name": x["name"],
        "cost": x["cost"]
      };

      possibleItems.add(data);
    }

    setState(() {
      _loaded = true;
    });
  }

  void loadNewPage(cardNumber) {
    double cost = 0.0;

    for (int x = 0; x < selectedItems.length; x++) {
      cost = cost + double.parse(possibleItems[selectedItems[x]]["cost"]);
    }

    print("The cost is $cost");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmPayment(
                selectedItems, possibleItems, cardNumber, cost, team)));
  }

  @override
  Widget build(BuildContext context) {
    int cardNumber;

    load();

    return !_loaded
        ? Progress()
        : Scaffold(
            appBar: AppBar(
              title: Text("Purchasing for Team ($team)"),
            ),
            body: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: "Credit Card Number"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Credit Card Info';
                        } else if (int.tryParse(value) == null ||
                            value.length != 6) {
                          return "Incorrect Format (Please Reenter)";
                        }
                        cardNumber = int.parse(value);
                        return null;
                      },
                    ),
                    Text(
                      "Press item to add to selection",
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      height: (60.0 * possibleItems.length),
                      child: ListView.builder(
                        itemCount: possibleItems.length,
                        itemBuilder: (context, position) {
                          return Container(
                            height: 60.0,
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                  title: Text(possibleItems[position]["name"]),
                                  onTap: () {
                                    setState(() {
                                      selectedItems.add(position);
                                    });
                                  }),
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: Divider(
                      ),
                    ),
                    Container(
                      height: (60.0 * selectedItems.length),
                      child: ListView.builder(
                        itemCount: selectedItems.length,
                        itemBuilder: (context, position) {
                          return Container(
                            height: 60.0,
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(
                                    possibleItems[selectedItems[position]]
                                        ["name"]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    RaisedButton(
                      onPressed: selectedItems.length == 0
                          ? null
                          : () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState.validate()) {
                                loadNewPage(cardNumber);
                              } else {
                                print("incomplete form");
                              }
                            },
                      child: Text('Submit'),
                    )
                  ],
                )),
          );
  }
}
