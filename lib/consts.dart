
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

const String MAIN_TITLE = 'KChing MarketPlace Live - PoS';
const MaterialColor MAIN_COLOR = Colors.teal;

final Uri endpoint = Uri.parse("https://script.google.com/macros/s/AKfycbye33YAztDI-nIEBfzplOo7DQ-Lc0MJXSAgsbo4FNfu-nxH4vU_LPgw4TELnhCq9BsCNA/exec");

Uri queryEndpoint(Map<String, dynamic> parameters) {
  return endpoint.resolveUri(Uri(queryParameters: parameters));
}

const KCHING_CURRENCY_STR = "K'Ching Buck";
const KCHING_CURRENCY_SYM = "₭\$";

const ERROR_TIMEOUT = 5;

final CARD_FORMAT = RegExp("^[a-zA-Z]{2}\\d{8}\$");

final DateTime CLOSE_TIME = DateTime.utc(2023, 12, 13, 1, 0); // 7:00 PM CST, 12 December 2023 // 4:30 PM CST, 9 December 2022 // 8:30 PM CST, 8 December 2022
