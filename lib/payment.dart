import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    int cardNumber;
    double charge;
    return Scaffold(
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
                  } else if (int.tryParse(value) == null || value.length != 6) {
                    return "Incorrect Format (Please Reenter)";
                  }
                  cardNumber = int.parse(value);
                  return null;
                },
              ),
              // TextFormField(
              //   // The validator receives the text that the user has entered.
              //   keyboardType: TextInputType.number,
              //   decoration: const InputDecoration(
              //     hintText: "How Much to Charge",
              //   ),
              //   validator: (String value) {
              //     if (value.isEmpty) {
              //       return 'Please enter how much to charge';
              //     } else if (double.tryParse(value) == null) {
              //       return "Please enter a valid number (No symbols)";
              //     } else if (double.tryParse(value) <= 0) {
              //       return "Please enter a number greater than zero";
              //     }
              //     charge = double.parse(value);
              //     return null;
              //   },
              // ),
              Container(
                height: (30.0 * possibleItems.length) + 30.0,
                child: ListView.builder(
                  itemCount: possibleItems.length + 1,
                  itemBuilder: (context, position) {
                    if (position == 0) {
                      return Text(
                        "Press item to add to selection",
                        textAlign: TextAlign.center,);
                    }
                    return Card(
                      elevation: 10,
                      child: ListTile(title: Text("lol")),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfirmPayment(
                                      cardNumber, charge, team)));
                        }
                      },
                child: Text('Submit'),
              )
            ],
          )),
    );
  }
}
