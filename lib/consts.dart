// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const String TITLE = "K'Ching MarketPlace Online";
const String TITLE_SHORT = "K'Ching MP Online";
const String ENDPOINT =
    // "https://cors-anywhere.herokuapp.com/" +
    "https://script.google.com/macros/s/AKfycbyTkaBKhg7rB0yjG6Ae9CUpsYAyQRrSwqPA8o_man9lRg0Gpz35jAt7HJG8FuHiDyIp3A/exec";

const double STORES_HEIGHT = 60;
const double STORES_WIDTH = 250;

const double PRODUCT_IMAGE_HEIGHT = 150;

const MaterialColor PRIMARY_COLOR = Colors.teal;

const String ERROR_LOADING_PRODUCTS =
    "Error loading products, try again later!\nIf you think this is an error, report to facilitators.";

const String KCHING_BUCK_SYM = "₭\$";

const double PADDING = 24;

final DateTime OPEN_TIME =
    DateTime.utc(2022, 12, 3, 9, 0); // devtime: 2022/12/03 3:00PM
// final DateTime OPEN_TIME  = DateTime.utc(2022, 12, 8, 23, 0); // 2022/12/08 5:00PM
final DateTime CLOSE_TIME =
    DateTime.utc(2022, 12, 9, 2, 10); // 2022/12/08 8:10PM
final DateFormat FORMATTER = DateFormat('HH:mm:ss');

const bool DEV_MODE = false;
