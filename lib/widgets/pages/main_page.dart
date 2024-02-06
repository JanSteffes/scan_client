import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scan_client/helpers/file_helper.dart';
import 'package:scan_client/models/file_actions/file_actions.dart';
import 'package:scan_client/models/notifications/file_action_notification.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/scan_server_api_code/client_index.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_implementations/delete_dialog.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_implementations/merge_dialog.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_implementations/rename_dialog.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_implementations/scan_dialog.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_implementations/show_dialog.dart';
import 'package:scan_client/widgets/pages/contents/file_content/file_content.dart';
import 'package:scan_client/widgets/pages/contents/file_content/file_content_actionbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

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
  late ScanServerApi _scanServerApi;

  /// keep tract of current selected endpoint
  String? _currentEndPoint;

  /// State of FileContent (refresh after rename/delete/scan)
  late GlobalKey<FileContentState> _fileContentStateKey;

  /// reselect after rename (scan?)
  late SelectedFiles selectedFilesRef;

  @override
  void initState() {
    _currentEndPoint = globals.defaultEndpoint;
    _scanServerApi = ScanServerApi.create(_currentEndPoint!);
    _cache = Map<String, dynamic>();
    _fileContentStateKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedFilesRef = Provider.of<SelectedFiles>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: buildAppBarActions(),
        ),
        body: Builder(builder: (fileContentContext) {
          return NotificationListener<FileActionNotification>(
              child: FileContent(
                  key: _fileContentStateKey,
                  scanServerApi: _scanServerApi,
                  cache: _cache),
              onNotification: (notification) =>
                  handleSingeFileActionNotification(
                      notification, fileContentContext));
        }),
        floatingActionButton: Builder(builder: (floatingActionButtonContext) {
          return getScanButton(floatingActionButtonContext);
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Builder(builder: (bottomAppBarContext) {
          return NotificationListener<FileActionNotification>(
              child: FileActionsBottomAppBar(
                  selectedFilesRef: selectedFilesRef,
                  scanServerApi: _scanServerApi),
              onNotification: (notification) =>
                  handleSingeFileActionNotification(
                      notification, bottomAppBarContext));
        }));
  }

  ///build scan button
  Widget getScanButton(BuildContext floatingActionButtonContext) {
    return FloatingActionButton(
        onPressed: () {
          var date = DateTime.now();
          var dateFormat = DateFormat('yyyy-MM-dd');
          var folder = dateFormat.format(date);
          showDialog(
              context: floatingActionButtonContext,
              builder: (BuildContext alertContext) {
                return ScanDialog(_fileContentStateKey, selectedFilesRef,
                    _scanServerApi, folder);
              });
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
    _scanServerApi.client = ScanServerApi.createClient(_currentEndPoint!);
  }

  /// handle action
  bool handleSingeFileActionNotification(
      FileActionNotification notification, BuildContext buildContext) {
    switch (notification.fileAction) {
      case FileActions.see:
        showFile(notification);
        break;
      case FileActions.rename:
        renameFileDialog(notification);
        break;
      case FileActions.share:
        if (Platform.isLinux ||
            Platform.isMacOS ||
            Platform.isWindows ||
            kIsWeb) {
          final snackBar = SnackBar(
              content:
                  Text("Funktion wird auf diesem System nicht unterstützt"));
          ScaffoldMessenger.of(buildContext).showSnackBar(snackBar);
          return false;
        }
        shareFile(notification);
        break;
      case FileActions.delete:
        deleteFileDialog(notification);
        break;
      case FileActions.merge:
        mergeFilesDialog(notification);
        break;
    }
    return true;
  }

  /// Present file in pdf viewer
  showFile(FileActionNotification notification) {
    var fileName = notification.fileName;
    var folder = notification.folderName;
    showDialog(
        context: context,
        builder: (BuildContext alertContext) {
          return ShowDialog(_scanServerApi, folder, fileName);
        });
  }

  /// Present simple dialog with original filename and new filename
  renameFileDialog(FileActionNotification notification) {
    var fileName = notification.fileName;
    var folderName = notification.folderName;
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return RenameDialog(_fileContentStateKey, selectedFilesRef,
            _scanServerApi, folderName, fileName);
      },
    );
  }

  /// Present share file
  shareFile(FileActionNotification notification) async {
    var folder = notification.folderName;
    var fileName = notification.fileName;
    var fileData =
        await FileHelper.getFileData(_scanServerApi, folder, fileName);
    final appDir = await syspaths.getTemporaryDirectory();
    var file = File('${appDir.path}/${fileName}');
    await file.writeAsBytes(fileData!);
    Share.shareFiles([file.path],
        mimeTypes: ["application/pdf"],
        subject: "Teilen",
        text: "Datei '$fileName' teilen");
  }

  /// Present validation of delete action dialog and result
  deleteFileDialog(FileActionNotification notification) {
    var folderName = notification.folderName;
    var fileName = notification.fileName;
    showDialog(
        context: context,
        builder: (BuildContext alertContext) {
          return DeleteDialog(_fileContentStateKey, selectedFilesRef,
              _scanServerApi, folderName, fileName);
        });
  }

  /// Present dialog to show files and mergename field
  mergeFilesDialog(FileActionNotification notification) {
    var folderName = notification.folderName;
    var files = selectedFilesRef.getFiles();
    final valesAsc = files.values.toList()..sort((a, b) => a.compareTo(b));
    var mergeOrder = <String>[];
    valesAsc.forEach((v) => mergeOrder
        .add(files.entries.firstWhere((element) => element.value == v).key));
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return MergeDialog(_fileContentStateKey, selectedFilesRef,
            _scanServerApi, folderName, mergeOrder);
      },
    );
  }
}
