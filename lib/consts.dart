
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

const String MAIN_TITLE = 'KChing MarketPlace Live - PoS';
const MaterialColor MAIN_COLOR = Colors.lightGreen;

const String ENDPOINT = "https://script.google.com/macros/s/AKfycbwCV8e6tV0rKxOj6fXARrAEXfh3OorZv9ioD8uYAR8kpT4j6d1YLDMEPyN42a678fbnbQ/exec";

const KCHING_CURRENCY_STR = "K'Ching Buck";
const KCHING_CURRENCY_SYM = "₭\$";

const ERROR_TIMEOUT = 5;

final CARD_FORMAT = new RegExp("^[a-zA-Z]{2}\\d{8}\$");

final DateTime CLOSE_TIME = DateTime.utc(2021, 12, 8, 4, 0); // 10 PM CST, 8 December 2021
