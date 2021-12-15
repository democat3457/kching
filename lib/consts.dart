// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const String TITLE = "K'Ching MarketPlace Online";
const String TITLE_SHORT = "K'Ching MP Online";
const String ENDPOINT =
    // "https://cors-anywhere.herokuapp.com/" + 
    "https://script.google.com/macros/s/AKfycbxBLlFdr_Ds4FyfS40Ge8O4zBOYQA50l3aBwfvj_pHm1QgFF8FGFtQSRzEDFT2fD8Nj8g/exec";

const double STORES_HEIGHT = 60;
const double STORES_WIDTH = 250;

const double PRODUCT_IMAGE_HEIGHT = 150;

const MaterialColor PRIMARY_COLOR = Colors.lightGreen;

const String ERROR_LOADING_PRODUCTS =
    "Error loading products, try again later!\nIf you think this is an error, report to facilitators.";

const String KCHING_BUCK_SYM = "₭\$";

const double PADDING = 24;

final DateTime OPEN_TIME = DateTime.utc(2021, 12, 7, 21, 0);
final DateTime CLOSE_TIME = DateTime.utc(2021, 12, 8, 0, 30);
final DateFormat FORMATTER = DateFormat('HH:mm:ss');

const bool DEV_MODE = false;
