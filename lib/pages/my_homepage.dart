import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scan_client/pages/contents/file_content.dart';
import 'package:scan_client/pages/contents/icontent.dart';
import 'package:scan_client/pages/contents/scan_content.dart';
import 'package:scan_client/scan_server_api_code/client_index.dart';
import 'contents/state.dart' as globals;

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;
  static const String switchEndpointCommand = "switchEndpoint";
  static const String clearCacheCommand = "clearCache";

  // late List<IContent> _children;
  late Map<String, dynamic> _cache;
  ScanServerApi? _scanServerApi;

  String? _currentEndPoint;

  @override
  void initState() {
    _currentEndPoint = globals.defaultEndpoint;
    _scanServerApi = ScanServerApi.create(_currentEndPoint!);
    _cache = Map<String, dynamic>();
    // _children = [
    //   FileContent(scanServerApi: _scanServerApi!, cache: _cache),
    //   ScanContent()
    // ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: buildAppBarActions(),
        ),
        body: FileContent(scanServerApi: _scanServerApi!, cache: _cache));
    // IndexedStack(index: _currentIndex, children: _children),
    // bottomNavigationBar: BottomNavigationBar(
    //     onTap: onTabTapped, // new
    //     currentIndex: _currentIndex, // new
    //     items: _children.map((e) => e.getNavItem()).toList()));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> buildAppBarActions() {
    return [
      PopupMenuButton(
          onSelected: handleSelect,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                child: Text("Wechsel Server"),
                value: switchEndpointCommand,
              ),
              PopupMenuItem<String>(
                child: Text("Cache leeren"),
                value: clearCacheCommand,
              )
            ];
          })
    ];
  }

  void handleSelect(String value) {
    switch (value) {
      case switchEndpointCommand:
        switchEndpoint();
        break;
      case clearCacheCommand:
        clearCache();
        break;
    }
  }

  void clearCache() {
    _cache.clear();
  }

  void switchEndpoint() {
    _currentEndPoint = _currentEndPoint == globals.defaultEndpoint
        ? globals.debugEndpont
        : globals.defaultEndpoint;
    _scanServerApi!.client = ScanServerApi.createClient(_currentEndPoint!);
  }
}
