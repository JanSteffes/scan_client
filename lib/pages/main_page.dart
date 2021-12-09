import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/pages/contents/file_content/file_content.dart';
import 'package:scan_client/scan_server_api_code/client_index.dart';
import 'package:scan_client/widgets/file_content_actionbar.dart';
import 'contents/globals.dart' as globals;

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const String switchEndpointCommand = "switchEndpoint";
  static const String clearCacheCommand = "clearCache";

  // late List<IContent> _children;
  late Map<String, dynamic> _cache;

  ///Api/endpoint to use
  ScanServerApi? _scanServerApi;

  /// keep tract of current selected endpoint
  String? _currentEndPoint;

  @override
  void initState() {
    _currentEndPoint = globals.defaultEndpoint;
    _scanServerApi = ScanServerApi.create(_currentEndPoint!);
    _cache = Map<String, dynamic>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedFilesRef = Provider.of<SelectedFiles>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: buildAppBarActions(),
        ),
        body: FileContent(scanServerApi: _scanServerApi!, cache: _cache),
        floatingActionButton: getScanButton(),
        floatingActionButtonLocation:
            // selectedFilesRef.getCount() == 0
            //     ? FloatingActionButtonLocation.centerFloat            :
            FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar:
            FileActionsBottomAppBar(selectedFilesRef: selectedFilesRef));
  }

  ///build scan button
  Widget getScanButton() {
    return FloatingActionButton(
        onPressed: () {
          // TODO create dialog with can quality, checkbox (default current date folder to save to) and filename text field
        },
        child: const Icon(Icons.scanner_rounded),
        tooltip: 'Scannen');
  }

  /// build global actions
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

  /// handle global actions
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

  /// clear the _cache map
  void clearCache() {
    _cache.clear();
  }

  /// switch to other endpoint (see globals)
  void switchEndpoint() {
    _currentEndPoint = _currentEndPoint == globals.defaultEndpoint
        ? globals.debugEndpont
        : globals.defaultEndpoint;
    _scanServerApi!.client = ScanServerApi.createClient(_currentEndPoint!);
  }
}
