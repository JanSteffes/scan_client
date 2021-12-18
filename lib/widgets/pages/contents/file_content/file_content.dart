import 'dart:developer';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scan_client/models/file_actions/file_actions.dart';
import 'package:scan_client/models/notifications/file_action_notification.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/scan_server_api_code/client_index.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:scan_client/widgets/pages/contents/file_content/file_content_file_item.dart';
import 'package:scan_client/widgets/pages/contents/icontent.dart';
import 'package:scan_client/widgets/rotating_iconbutton.dart';

class FileContent extends StatefulWidget implements IContent {
  ///access to api methods
  final ScanServerApi scanServerApi;

  ///cache
  final Map<String, dynamic> cache;

  FileContent({Key? key, required this.scanServerApi, required this.cache})
      : super(key: key);

  @override
  Icon getIcon() {
    return Icon(Icons.folder);
  }

  @override
  String getTitle() {
    return "Dateien";
  }

  @override
  BottomNavigationBarItem getNavItem() {
    return BottomNavigationBarItem(
      icon: getIcon(),
      label: getTitle(),
    );
  }

  @override
  FileContentState createState() => FileContentState();
}

class FileContentState extends State<FileContent> {
  List<String> _folders = <String>[];
  List<String> _files = <String>[];
  late SelectedFiles _selectedFilesRef;

  @override
  void initState() {
    super.initState();
    refreshFolders();
  }

  @override
  Widget build(BuildContext context) {
    _selectedFilesRef = Provider.of<SelectedFiles>(context, listen: true);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [getFolderSelection(), getFileList()]);
  }

  Widget getDefaultPadding(Widget child,
      {double factorVertical = 1, double factorHorizontal = 1}) {
    return Padding(
        child: child,
        padding: getPaddingInsets(
            factorVertical: factorVertical,
            factorHorizontal: factorHorizontal));
  }

  EdgeInsets getPaddingInsets(
      {double factorVertical = 1, double factorHorizontal = 1}) {
    return EdgeInsets.symmetric(
        vertical: factorVertical * 10.0, horizontal: factorHorizontal * 10.0);
  }

  /// dropdown with folders (latest selected by default, placeholder while loading)
  Widget getFolderSelection() {
    return Container(
        child: getDefaultPadding(
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [getFolderDropdown(), getFolderRefresh()]),
    ])));
  }

  /// dropdown for folderlist
  Widget getFolderDropdown() {
    return Expanded(
        child: Container(
      padding: getPaddingInsets(
        factorVertical: 0.5,
      ),
      decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      child: DropdownSearch<String>(
          popupItemBuilder: folderItemsBuilder,
          dropdownButtonBuilder: (_) => Container(),
          mode: Mode.MENU,
          showSelectedItems: true,
          items: _folders,
          dropdownSearchDecoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.folder_open,
                color: Colors.blue,
              )),
          onChanged: (String? newValue) {
            setSetlectedFolder(newValue);
          },
          selectedItem: _selectedFilesRef.getSelectedFolder()),
    ));
  }

  /// build folderItems
  Widget folderItemsBuilder(
      BuildContext context, String item, bool isSelected) {
    return Container(
        color: isSelected ? Colors.grey.withOpacity(0.3) : Colors.transparent,
        child: getDefaultPadding(Row(children: [
          Icon(isSelected ? Icons.folder_open : Icons.folder,
              color: Colors.blue),
          Container(width: 5),
          Text(item)
        ])));
  }

  /// list of files (placeholder while loading)
  Widget getFileList() {
    return Expanded(
        child: Container(
            width: double.infinity,
            padding: getPaddingInsets(),
            child: _files.isNotEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        mainAxisExtent: 282),
                    itemBuilder: _fileItemsBuilder,
                    itemCount: _files.length,
                  )
                : Container()));
  }

  /// refresh button for the folder dropdown
  Widget getFolderRefresh() {
    return RotatingIconButton(
      icon: Icons.refresh,
      onPressed: refreshFolders,
      iconColor: Colors.blue,
    );
  }

  /// refresh folders and set selected folder to previously selected one if it still exists
  Future refreshFolders() async {
    // set folders null to trigger refresh sign
    setState(() {
      _folders = <String>[];
      _files = <String>[];
    });
    // get folders and set
    var foldersResponse = await widget.scanServerApi.apiFileReadFoldersGet();
    var folders = foldersResponse.body;
    setState(() {
      _folders = folders?.toList() ?? <String>[];
    });
    // if last selected folder still in the list, keep it, else take first (like in initial loading)
    if (_folders.isNotEmpty &&
        !_folders.contains(_selectedFilesRef.getSelectedFolder())) {
      setSetlectedFolder(_folders.first);
    } else if (_folders.isEmpty) {
      throw FlutterError("Keine Ordner erhalten!");
    } else {
      setSetlectedFolder(_selectedFilesRef.getSelectedFolder()!);
    }
    // folder refresh should trigger filelist refresh
  }

  /// set given folder as selected folder and refresh files
  setSetlectedFolder(String? folderName) {
    if (folderName == null) {
      throw FlutterError("Gültiger Ordner ausgewählt!");
    }
    setState(() {
      _selectedFilesRef.setFolder(folderName);
      _files = <String>[];
    });
    refreshFiles();
  }

  /// Load all files from current selected folder
  Future refreshFiles() async {
    if (_selectedFilesRef.getSelectedFolder() == null ||
        _selectedFilesRef.getSelectedFolder()!.isEmpty) {
      return;
    }
    var folder = _selectedFilesRef.getSelectedFolder()!;
    var filesResponse =
        await widget.scanServerApi.apiFileReadFilesGet(directory: folder);
    List<String>? files;
    if (filesResponse.isSuccessful) {
      files = filesResponse.body!
          .where((element) => element.endsWith(".pdf"))
          .toList();
    }
    setState(() {
      _files = files ?? <String>[];
      _selectedFilesRef.removeFilesNotContained(files);
    });
  }

  ///Builder to build fileWidgets
  Widget _fileItemsBuilder(BuildContext context, int index) {
    var fileName = _files[index];
    var isSelected = _selectedFilesRef.getFileContained(fileName);
    var selectionIndex =
        isSelected ? _selectedFilesRef.getSelectedIndexOfFile(fileName) : null;
    bool fadeInPageHint = false;
    // or current item is newly last selected one (not on remove action)
    var lastSelectionWasRemove = _selectedFilesRef.getLastActionWasRemove();
    if (!lastSelectionWasRemove) {
      var isMaxSelectionIndex =
          _selectedFilesRef.getFileHasHighestIndex(fileName);
      fadeInPageHint = isMaxSelectionIndex;
    }
    return GestureDetector(
        child: FileItem(
            fileName: fileName,
            isSelected: isSelected,
            fadeInPageHint: fadeInPageHint,
            selectFunction: selectItem,
            thumbnailDataFuture: getThumbnailData(fileName),
            selectionIndex: selectionIndex,
            paddingInsets: getPaddingInsets()),
        onLongPress: () => FileActionNotification(FileActions.see,
                _selectedFilesRef.getSelectedFolder()!, fileName)
            .dispatch(context));
  }

  // retrieve thumbnaildata and save it to caches
  Future<Uint8List?> getThumbnailData(String fileName) async {
    var cacheKey = "${_selectedFilesRef.getSelectedFolder()}_$fileName";
    if (widget.cache.containsKey(cacheKey)) {
      var data = widget.cache[cacheKey];
      if (data == null) {
        return Future.error("No data available", StackTrace.current);
      }
      return data;
    }

    Response<String>? data;
    try {
      data = await widget.scanServerApi
          .apiFileGetThumbnailOfFileFolderFileNameGet(
              folder: _selectedFilesRef.getSelectedFolder(),
              fileName: fileName);
    } on Exception catch (e) {
      log("Errpr while getting tumbnaildata of '$fileName': ${e.toString()}");
    }
    if (data != null && data.isSuccessful) {
      widget.cache[cacheKey] = data.bodyBytes;
    } else {
      widget.cache[cacheKey] = null;
    }
    return getThumbnailData(fileName);
  }

  /// Select item at index
  void selectItem(String fileName) {
    if (_selectedFilesRef.getFileContained(fileName)) {
      _selectedFilesRef.removeFile(fileName);
    } else {
      _selectedFilesRef.addFile(fileName);
    }
  }
}
