import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scan_client/pages/contents/icontent.dart';
import 'package:scan_client/scan_server_api_code/client_index.dart';
import 'package:dropdown_search/dropdown_search.dart';

class FileContent extends StatefulWidget implements IContent {
  FileContent({Key? key}) : super(key: key);

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
  var _fileApi = ScanServerApi.create();
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [getFolderSelection(), getFileList(), getMergeSection()]);
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
        // decoration: BoxDecoration(
        //     border: Border(
        //         bottom: BorderSide(
        //             width: 1, color: Colors.blue, style: BorderStyle.solid))),
        // color: Colors.orange,
        child: getDefaultPadding(
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(
      //   "Ordner:",
      //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      // ),
      // Container(height: 5),
      Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Icon(
            //   Icons.folder,
            //   color: Colors.blue,
            // ),
            // Container(width: 5),
            _folders != null && _folders!.isNotEmpty
                ? getFolderDropdown()
                : CircularProgressIndicator(),
            _folders != null && _folders!.isNotEmpty
                ? getFolderRefresh()
                : Container()
          ]),
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
      // color: Color.fromRGBO(
      //     Colors.grey.red, Colors.grey.green, Colors.grey.blue, 0.3),
      // padding: getPaddingInsets(factorVertical: 0),
      child: DropdownSearch<String>(
          popupItemBuilder: folderItemsBuilder,
          dropdownButtonBuilder: (_) => Container(),
          // Padding(
          //     padding: const EdgeInsets.all(1.0),
          //     child: const Icon(
          //       Icons.arrow_drop_down_outlined,
          //       color: Colors.blue,
          //     )),
          mode: Mode.MENU,
          showSelectedItems: true,
          items: List.generate(_folders!.length, (index) => _folders![index]),
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
    // print("$item: $isSelected");
    return Container(
        color: isSelected
            ? Color.fromRGBO(
                Colors.grey.red, Colors.grey.green, Colors.grey.blue, 0.3)
            : Colors.transparent,
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
            // color: Colors.green,
            child: _files != null
                ? ListView.builder(
                    itemBuilder: _fileItemsBuilder,
                    itemCount: _files!.length,
                  )
                : Container(
                    // color: Colors.yellow
                    )));
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

  Widget getFolderRefresh() {
    return IconButton(
        onPressed: () async {
          refreshFolders();
        },
        icon: Icon(Icons.refresh, color: Colors.blue));
  }

  /// refresh folders and set selected folder to previously selected one if it still exists
  Future refreshFolders() async {
    // set folders null to trigger refresh sign
    setState(() {
      _folders = null;
      _files = null;
    });
    // get folders and set
    var foldersResponse = await _fileApi.apiFileReadFoldersGet();
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
    });
    refreshFiles();
  }

  /// Load all files from current selected folder
  Future refreshFiles() async {
    if (_selectedFolder == null || _selectedFolder!.isEmpty) {
      return;
    }
    var folder = _selectedFolder as String;
    var filesResponse = await _fileApi.apiFileReadFilesGet(directory: folder);
    var files = filesResponse.body;
    setState(() {
      _files = files;
    });
  }

  Widget _fileItemsBuilder(BuildContext context, int index) {
    final current = _files?[index];
    if (current!.isEmpty) {
      return Text("Fehler beim Laden der Daten!");
    }
    return Stack(children: [
      Image.network(
        getFileThumbnailUrl(current),
        errorBuilder: _fileItemThumbnailErrorBuilder,
      ),
      Text(current)
    ]);
  }

  String getFileThumbnailUrl(String? current) {
    return "http://raspberrypi/api/File/GetThumbnailOfFile/$_selectedFolder/$current";
  }

  Widget _fileItemThumbnailErrorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
    print("_fileItemThumbnailErrorBuilder: $error");
    return Text("Failed to load!");
  }
}
