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
      color: Color.fromRGBO(
          Colors.grey.red, Colors.grey.green, Colors.grey.blue, 0.3),
      padding: getPaddingInsets(factorVertical: 0),
      child: DropdownSearch<String>(
          dropdownBuilder: customDropDownExample,
          dropdownButtonBuilder: (_) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                  color: Colors.blue,
                ),
              ),
          mode: Mode.MENU,
          items: List.generate(_folders!.length, (index) => _folders![index]),
          dropdownSearchDecoration: InputDecoration(
              // labelText: "Menu mode",
              // hintText: "country in menu mode",
              ),
          onChanged: (String? newValue) {
            setSetlectedFolder(newValue);
          },
          selectedItem: _selectedFolder),
    ));
  }

  Widget customDropDownExample(BuildContext context, String? item) {
    if (item == null) {
      return Container();
    }
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(2),
        leading: Icon(
          Icons.folder, color: Colors.blue,
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
        ),
        title: Text(item),
      ),
    );
  }

  /// list of files (placeholder while loading)
  Widget getFileList() {
    var fileWidgets = _files?.map((f) => Text(f)).toList() ?? <Text>[];
    return Expanded(
        child: Container(
            width: double.infinity,
            padding: getPaddingInsets(),
            // color: Colors.green,
            child: _files != null
                ? Column(
                    children: fileWidgets,
                    crossAxisAlignment: CrossAxisAlignment.start,
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

  setSetlectedFolder(String? folderName) {
    setState(() {
      _selectedFolder = folderName;
    });
    refreshFiles();
  }

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
}
