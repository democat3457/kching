import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pos_system/consts.dart';
import 'dart:developer';

enum Tasks { Login, Teams, Products }

extension TaskAPI on Tasks {
  String get api {
    switch (this) {
      case Tasks.Login:
        return "credit_card";
        break;
      case Tasks.Teams:
        return "teams";
        break;
      case Tasks.Products:
        return "products";
      default:
        return "err";
    }
  }
}

String _buildGetHeader(Map<String, String> data) {
  String buf = "";
  data.forEach((key, value) {
    buf += key + "=" + value + "&";
    // buf += "$key=$value&";
  });
  if (buf.length != 0) {
    buf = buf.substring(0, buf.length - 1); // Remove final &
  }
  return buf;
}

Future<Map<String, dynamic>> getter(
    Tasks task, Map<String, String> data) async {
  String _processedData = _buildGetHeader(data);
  String _task = task.api;
  http.Response respose =
      await http.get("$ENDPOINT?task=$_task&$_processedData");
  assert(respose.statusCode == 200);
  log(respose.body);
  return convert.json.decode(respose.body);
}

Future<Map<String, dynamic>> setter(
    Tasks task, Map<String, String> data) async {
  http.Response response =
      await http.post(ENDPOINT + "?" + task.api, body: data);
  assert(response.statusCode == 200);
  return convert.json.decode(response.body);
}
