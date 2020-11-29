import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartData {
  static const String _dataVar = "/cart_data";
  static Future<void> clearCart() async {
    var _runtime = await SharedPreferences.getInstance();
    _runtime.setString(_dataVar, json.encode({"items": []}));
  }

  static Future<Map<String, dynamic>> getItems() async {
    var _runtime = await SharedPreferences.getInstance();

    final data = _runtime.getString(_dataVar);
    try {
      return Map.of(json.decode(data));
    } catch (Exception) {
      await clearCart();
      return await getItems();
    }
  }

  static Future<void> removeItem(int position) async {
    var _runtime = await SharedPreferences.getInstance();
    var _current = await getItems();
    _current["items"].removeAt(position);
    _runtime.setString(_dataVar, json.encode(_current));
  }

  static Future<void> addItems(Map<String, dynamic> item, int count) async {
    var _runtime = await SharedPreferences.getInstance();
    var data = await getItems();
    data.putIfAbsent("items", () => List<dynamic>());
    for (int i = 0; i < count; ++i) {
      assert(data["items"] is List);
      data["items"].add(item);
    }
    // data.addAll({""});
    final String encodedData = json.encode(data);
    log(encodedData);
    _runtime.setString(_dataVar, encodedData);
  }
}
