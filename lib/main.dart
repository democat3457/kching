import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'consts.dart';
import 'pages/Cart.dart';
import 'pages/Store.dart';
import 'pages/Teams.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  print("Running");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE_SHORT,
      theme: ThemeData(
          primarySwatch: PRIMARY_COLOR,
          // fontFamily: '.SF Pro Display',
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.41,
                color: Colors.black),
            headline2: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.41,
                color: Colors.black),
            subtitle1: TextStyle(
                fontSize: 16,
                letterSpacing: 0.41,
                fontWeight: FontWeight.w400,
                color: Colors.black),
            caption: TextStyle(
                fontSize: 14,
                letterSpacing: 0.41,
                fontWeight: FontWeight.w200,
                color: Colors.black),
          )),
      routes: {
        Teams.ROUTE: (context) => Teams(),
        Cart.ROUTE: (context) => Cart(),
        Store.ROUTE: (context) => Store(),
      },
      initialRoute: Teams.ROUTE,
      debugShowCheckedModeBanner: false,
    );
  }
}
