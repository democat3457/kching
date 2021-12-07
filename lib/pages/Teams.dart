import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_system/consts.dart';
import 'package:pos_system/pages/Holding.dart';
import 'package:pos_system/pages/Store.dart';
import 'package:pos_system/pages/loading.dart';
import 'package:pos_system/utils/api.dart';

import 'CheckBal.dart';

String _matchToID(String id) {
  switch (id.substring(0, 3).trim().toUpperCase()) {
    case "SOG":
      return "Sports & Outdoor Gear";
    case "HID":
      return "Home Improvement & Decor";
    case "CPC":
      return "Child & Pet Care";
    case "FA":
      return "Fashion & Accessories";
    case "HB":
      return "Health & Beauty";
    default:
      return "Lorem ipsum";
  }
}

Map<String, List<Map<String, dynamic>>> _sortTeams(List<dynamic> data) {
  List<String> uniqueSections = [];
  for (final x in data) {
    var name = _matchToID(x["code"]);
    if (!uniqueSections.contains(name)) {
      uniqueSections.add(name);
      log(name);
    }
  }
  Map<String, List<Map<String, dynamic>>> items = {};
  for (final x in uniqueSections) {
    for (final y in data) {
      if (_matchToID(y["code"]) == x) {
        if (items[x] == null) {
          items[x] = [];
        }
        items[x].add(y);
        // items[x] = y;
      }
    }
  }
  return Map.from(items);
}

class Teams extends StatefulWidget {
  static const String ROUTE = "/";
  @override
  State<StatefulWidget> createState() {
    return _TeamsState();
  }
}

class _TeamsState extends State<Teams> {
  bool _loading = false;
  bool _loaded = false;
  bool _inHolding = false;
  Map<String, dynamic> _data = {};

  void _loadTeams() async {
    this._inHolding = await Holding.inHolding();

    print(this._inHolding);

    this._data = await getter(Tasks.Teams, {});
    if (this._data == null) {
      throw UnimplementedError();
    }
    setState(() {
      this._loaded = true;
      this._loading = false;
    });
  }

  Widget _getTeamCard(BuildContext context, Map<String, String> teamInfo) {
    final String name = teamInfo["name"];
    final String code = teamInfo["code"];
    log(teamInfo.toString());
    return SizedBox(
      height: STORES_HEIGHT,
      width: STORES_WIDTH,
      child: Card(
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, Store.ROUTE,
              arguments: StoreArguments(name, code)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: Icon(Icons.store),
                title: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                // subtitle: Text(_matchToID(code)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSectionRow(
      BuildContext context, final List<Map<String, dynamic>> internalTeams) {
    return SizedBox(
      height: STORES_HEIGHT,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.from(
                internalTeams.map((e) => _getTeamCard(context, Map.from(e))),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Building");
    if (!_loaded && !_loading) {
      _loadTeams();
      setState(() {
        this._loading = true;
      });
    }
    if (!_loaded && _loading) {
      return Loading();
    } else if (_loaded && !_loading) {
      if (_inHolding) {
        return Holding();
      }
      final teams = _sortTeams(_data["teams"]);
      final keys = List<String>.from(teams.keys);
      return Scaffold(
          appBar: AppBar(
            title: Text(TITLE),
            actions: [
              TextButton(
                child: Row(
                  children: [ 
                    Icon(
                      Icons.attach_money_outlined,
                    ),
                    Text(
                      "Check Balance",
                    ),
                  ],
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black)
                ),
                onPressed: () async => await showDialog(
                    context: context, builder: (context) => CheckBal())
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton.extended(
            heroTag: "team_cartbtn",
            icon: Icon(
              Icons.shopping_bag_outlined,
            ),
            label: Text("Cart"),
            onPressed: () => Navigator.pushNamed(context, "/cart")
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: PADDING, right: PADDING),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.from(keys.map<Widget>((e) {
                    // The Garbage Collector probably hates this
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(e,
                              style: Theme.of(context).textTheme.headline2),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _getSectionRow(context, teams[e]),
                        ),
                      ],
                    );
                  }))
              ),
            ),
          )
        );
    } else {
      throw UnimplementedError();
    }
  }
}
