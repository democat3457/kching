import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';
import 'package:pos_system/pages/loading.dart';
import 'package:pos_system/utils/api.dart';

class CheckBal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CheckBalState();
  }
}

class _CheckBalState extends State<CheckBal> {
  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _context = context;
    return AlertDialog(
      title: Text("Check Balance"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              obscureText: false,
              autofocus: true,
              cursorColor: Colors.black,
              textCapitalization: TextCapitalization.characters, // Not Working
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                ),
                labelStyle: TextStyle(color: Colors.black),
                labelText: "Card ID",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Exit"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text("Get Balance"),
          onPressed: () async {
            LoadingDialog.showLoading(context, new GlobalKey<State>(),
                message: "Checking");
            var response = await getter(Tasks.Login, {"id": _controller.text});
            Navigator.pop(context);
            if (!response["valid"]) {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text("Possibly Invalid Card ID"),
                  actions: [
                    TextButton(
                      child: Text("Exit"),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              );
              Navigator.pop(_context);
              return;
            }
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Balance"),
                content: Text(
                    "You Have " + KCHING_BUCK_SYM + response["bal"].toString()),
                actions: [
                  TextButton(
                    child: Text("Exit"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            );
            Navigator.pop(_context);
          },
        )
      ],
    );
  }
}
