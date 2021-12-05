import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scan_client/pages/contents/icontent.dart';
import 'package:scan_client/scan_server_api_code/client_index.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:scan_client/widgets/rotating_iconbutton.dart';

class FileContent extends StatefulWidget implements IContent {
  final ScanServerApi scanServerApi;
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
  _FileContentState createState() => _FileContentState();
}

class _FileContentState extends State<FileContent> {
  String? _selectedFolder;
  List<String>? _folders;
  List<String>? _files;

  @override
  void initState() {
    super.initState();
    refreshFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      getFolderSelection(), getFileList(),
      // getMergeSection()
    ]);
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
          selectedItem: _selectedFolder),
    ));
  }

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
            child: _files != null
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        mainAxisExtent: 282),
                    itemBuilder: _fileItemsBuilder,
                    itemCount: _files?.length ?? 0,
                  )
                : Container()));
  }

  /// mergestuff if one of the files got selected for merging
  Widget getMergeSection() {
    // todo
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.red,
      child: Text("TODO Dateien zusammenfügen"),
      alignment: Alignment.center,
    );
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
      _folders = null;
      _files = null;
    });
    // get folders and set
    var foldersResponse = await widget.scanServerApi.apiFileReadFoldersGet();
    var folders = foldersResponse.body;
    setState(() {
      _folders = folders?.toList();
    });
    // if last selected folder still in the list, keep it, else take first (like in initial loading)
    if (!folders!.contains(_selectedFolder)) {
      setSetlectedFolder(_folders!.first);
    } else {
      setSetlectedFolder(_selectedFolder);
    }
    // folder refresh should trigger filelist refresh
  }

  /// set given folder as selected folder and refresh files
  setSetlectedFolder(String? folderName) {
    setState(() {
      _selectedFolder = folderName;
      _files = null;
    });
    refreshFiles();
  }

  /// Load all files from current selected folder
  Future refreshFiles() async {
    if (_selectedFolder == null || _selectedFolder!.isEmpty) {
      return;
    }
    var folder = _selectedFolder as String;
    var filesResponse =
        await widget.scanServerApi.apiFileReadFilesGet(directory: folder);
    var files = filesResponse.body;
    setState(() {
      _files = files;
    });
  }

  Widget _fileItemsBuilder(BuildContext context, int index) {
    final current = _files?[index];
    if (current == null || current.isEmpty) {
      return Text("Fehler beim Laden der Daten!");
    }
    return Stack(
      children: [
        getFileThumbnailWidget(current),
        Container(
            alignment: AlignmentDirectional.bottomStart,
            child: Container(
                width: double.infinity,
                padding: getPaddingInsets(),
                color: Colors.blue.withOpacity(0.5),
                child: Text(
                  current,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )))
      ],
      alignment: AlignmentDirectional.bottomStart,
      fit: StackFit.expand,
    );
  }

  ///build widget for files
  Widget getFileThumbnailWidget(String current) {
    return FutureBuilder<Uint8List?>(
        future: getThumbnailData(
            current), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              try {
                return
                    // Opacity(
                    //   opacity: 1.0,
                    //   child:
                    Image.memory(
                  snapshot.data!,
                  fit: BoxFit.fill,
                  // ),
                );
              } on Exception catch (e) {
                log("Error while creating image preview of '$current': ${e.toString()}");
                return Icon(Icons.error, color: Colors.red);
              }
            }
            return Container(child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Icon(Icons.error, color: Colors.red);
          } else {
            return Container(child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  // retrieve thumbnaildata and save it to caches
  Future<Uint8List?> getThumbnailData(String fileName) async {
    var cacheKey = "${_selectedFolder}_$fileName";
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
              folder: _selectedFolder, fileName: fileName);
    } on Exception catch (e) {
      log("Errpr while getting tumbnaildata of '$fileName': ${e.toString()}");
    }
    // await Future.delayed(Duration(milliseconds: Random().nextInt(250)));
    if (data != null && data.isSuccessful) {
      widget.cache[cacheKey] = data.bodyBytes;
    } else {
      widget.cache[cacheKey] = null;
    }
    return getThumbnailData(fileName);
  }
}
