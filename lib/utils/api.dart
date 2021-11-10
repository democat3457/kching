import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_system/consts.dart';

enum Tasks { Login, Teams, Products, Purchase }

extension TaskAPI on Tasks {
  String get api {
    switch (this) {
      case Tasks.Login:
        return "login";
        break;
      case Tasks.Teams:
        return "teams";
        break;
      case Tasks.Products:
        return "products";
      case Tasks.Purchase:
        return "purchase";
      default:
        return "err";
    }
  }
}

Future<Map<String, dynamic>> getter(
    Tasks task, Map<String, String> data) async {
  String _processedData = data.entries.map((e) => e.key + "=" + e.value).toList().join("&");
  String _task = task.api;
  final response = await http.get("$ENDPOINT?task=$_task&$_processedData");
  print("$ENDPOINT?task=$_task&$_processedData");
  // print((await http.get("$ENDPOINT?task=sheetName")).body);
  assert(response.statusCode == 200);
  print(response.body);
  return convert.json.decode(response.body);
}

Future<Map<String, dynamic>> setter(
    Tasks task, Map<String, dynamic> data) async {
  print(json.encode(data));
  final response = await http
      .get(ENDPOINT + "?task=" + task.api + "&data=" + json.encode(data));
  assert(response.statusCode == 200);
  print(response.body);
  return convert.json.decode(response.body);
}
