import 'package:flutter/material.dart';
import 'package:pos_system/cart.dart';
import 'package:pos_system/consts.dart';
import 'package:pos_system/pages/Store.dart';
import 'package:pos_system/pages/loading.dart';
import 'package:pos_system/utils/api.dart';

String _matchToID(String id) {
  switch (id.substring(0, 2).toUpperCase()) {
    case "SG":
      return "Sports Gear";
    case "HG":
      return "Home Goods";
    case "CC":
      return "Child Care";
    case "FA":
      return "Fashion & Accessories";
    case "HB":
      return "Health & Beauty";
    case "CE":
      return "Consumer Electronics";
    default:
      return "Lorem ipsum";
  }
}

class Teams extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TeamsState();
  }
}

class _TeamsState extends State<Teams> {
  bool _loading = false;
  bool _loaded = false;
  Map<String, dynamic> _data = {};

  void _loadTeams() async {
    this._data = await getter(Tasks.Teams, {});
    if (this._data == null) {
      throw UnimplementedError();
    }
    setState(() {
      this._loaded = true;
      this._loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded && !_loading) {
      _loadTeams();
      setState(() {
        this._loading = true;
      });
    }
    if (!_loaded && _loading) {
      return Loading();
    } else if (_loaded && !_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(TITLE)),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.pushNamed(context, "/cart")),
        body: GridView.count(
          shrinkWrap: true,
          crossAxisCount: STORES_WIDTH,
          childAspectRatio: STORES_ASPECT_RATIO,
          children: List.generate(this._data["teams"].length, (index) {
            var teamInfo = this._data["teams"][index];
            return Center(
              child: Card(
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, "/store",
                      arguments:
                          StoreArguments(teamInfo["name"], teamInfo["code"])),
                  child: Column(
                    children: [
                      ListTile(
                          leading: Icon(Icons.store),
                          title: Text(teamInfo["name"]),
                          subtitle: Text(_matchToID(teamInfo["code"]))),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    } else {
      throw UnimplementedError();
    }
  }
}
