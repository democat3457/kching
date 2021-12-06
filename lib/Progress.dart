import 'package:flutter/material.dart';
import 'consts.dart';

class Progress extends StatelessWidget {
  String message = "";

  Progress([message]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MAIN_TITLE),
      ),
      body: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            Text(message)
          ]
        )
      )
    );
  }

  static Future<void> showLoading(BuildContext context, GlobalKey key,
      {String message = ""}) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: key,
            title:
                (message == null || message.isNotEmpty) ? Text(message) : null,
            children: [
              Center(
                child: 
                // Column( 
                //   children: [
                    CircularProgressIndicator(),
                  //   (message == null || message.isNotEmpty) ? Text(message) : null
                  // ]
                // ),
              )
            ],
          ),
        );
      },
    );
  }
}