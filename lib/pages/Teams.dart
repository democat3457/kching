import 'package:flutter/material.dart';
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
  static const String ROUTE = "/";
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

  Widget _getTeamCard(BuildContext context, int index) {
    final teamInfo = Map<String, String>.from(this._data["teams"][index]);
    final String name = teamInfo["name"];
    final String code = teamInfo["code"];
    return Center(
      child: Card(
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, Store.ROUTE,
              arguments: StoreArguments(name, code)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.store),
                title: Text(name),
                subtitle: Text(_matchToID(code)),
              ),
            ],
          ),
        ),
      ),
    );
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
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(
              Icons.shopping_bag_outlined,
            ),
            label: Text("Cart"),
            onPressed: () => Navigator.pushNamed(context, "/cart")),
        body: GridView.count(
          shrinkWrap: true,
          crossAxisCount: STORES_WIDTH,
          // childAspectRatio: MediaQuery.of(context).size.height / 300,
          childAspectRatio: STORES_ASPECT_RATIO,
          children: List.generate(this._data["teams"].length,
              (index) => _getTeamCard(context, index)),
        ),
      );
    } else {
      throw UnimplementedError();
    }
  }
}
