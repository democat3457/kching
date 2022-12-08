
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

const String MAIN_TITLE = 'KChing MarketPlace Live - PoS';
const MaterialColor MAIN_COLOR = Colors.teal;

const String ENDPOINT = "https://script.google.com/macros/s/AKfycbye33YAztDI-nIEBfzplOo7DQ-Lc0MJXSAgsbo4FNfu-nxH4vU_LPgw4TELnhCq9BsCNA/exec";

const KCHING_CURRENCY_STR = "K'Ching Buck";
const KCHING_CURRENCY_SYM = "₭\$";

const ERROR_TIMEOUT = 5;

final CARD_FORMAT = new RegExp("^[a-zA-Z]{2}\\d{8}\$");

final DateTime CLOSE_TIME = DateTime.utc(2022, 12, 9, 2, 30); // 8:30 PM CST, 8 December 2022
