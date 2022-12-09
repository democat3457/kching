import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'Progress.dart';
import 'confirmPayment.dart';
import 'consts.dart';
import 'Error.dart';

class Payment extends StatefulWidget {
  final String team;
  Payment(this.team);

  @override
  State<StatefulWidget> createState() {
    return PaymentState(team);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class PaymentState extends State<Payment> {
  final String team;
  PaymentState(this.team);

  final _formKey = GlobalKey<FormState>();

  List<dynamic> possibleItems = [];
  List<dynamic> selectedItems = [];

  bool _loaded = false;
  TextEditingController _cardNumberController = new TextEditingController();

  void load() async {
    if (_loaded) return;
    Response items = await get(
        "$ENDPOINT?"
        "request=getItems&"
        "team=$team");

    dynamic data = json.decode(items.body)["data"];

    for (var x in data) {
      Map<String, dynamic> data = {
        "id": x["id"],
        "name": x["name"],
        "cost": x["cost"],
        "stock": x["stock"],
        "backorders": x["backorders"]
      };

      possibleItems.add(data);
    }

    setState(() {
      _loaded = true;
    });
  }

  Future<bool> checkCardExists(cardNumber) async {
    Response rCardExists = await get(
        "$ENDPOINT?"
        "request=cardExist&"
        "card=$cardNumber&"
        "team=$team");

    return json.decode(rCardExists.body)["data"];
  }

  void loadNewPage(cardNumber) async {
    var url = Uri.encodeFull("$ENDPOINT?"
              "request=cardExist&"
              "card=$cardNumber&"
              "team=$team");
    print(url);
    Response rCardExists = await get(url);
    print(rCardExists.body);
    bool cardExists = json.decode(rCardExists.body)["data"];

    if (!cardExists) {
      print("Invalid card $cardNumber");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Error("Card number $cardNumber is invalid!", false, 3)
          )
      );
    } else {
      double cost = 0.0;

      for (int x = 0; x < selectedItems.length; x++) {
        cost = cost + double.parse(possibleItems[selectedItems[x]]["cost"]);
      }

      print("The cost is $cost");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmPayment(
                  selectedItems, possibleItems, cardNumber, cost, team)
          )
      ).then((successful) {
        if (successful) {
          setState(() {
            _cardNumberController.clear();
            selectedItems.clear();
          });
          // _loaded = false;
          // possibleItems.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic cardNumber;

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
                      keyboardType: TextInputType.streetAddress,
                      decoration:
                          const InputDecoration(hintText: "Credit Card Number"),
                      validator: (value) {
                        value = value.trim();
                        if (value.isEmpty) {
                          return 'Please enter Credit Card Info';
                        } else if (!CARD_FORMAT.hasMatch(value)) {
                          return "Incorrect Format (Please re-enter)";
                        }
                        cardNumber = value;

                        return null;
                      },
                      inputFormatters: [
                        UpperCaseTextFormatter()
                      ],
                      controller: _cardNumberController,
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
                                  // subtitle: Text.rich(TextSpan(text: "Price: "+
                                  //         possibleItems[position]["cost"] +"\tIn Stock: "+possibleItems[position]["stock"]+"\tBackordered: "+
                                  //     possibleItems[position]["backorders"])),
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
                    Text(
                      "Press item to remove from selection",
                      textAlign: TextAlign.center,
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
                                    onTap: () {
                                      setState(() {
                                        selectedItems.remove(selectedItems[position]);
                                      });
                                    }
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: selectedItems.length == 0
                          ? null
                          : () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState.validate()) {
                                // Workaround for validator not running always
                                loadNewPage(cardNumber == null ? _cardNumberController.text : cardNumber);
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
