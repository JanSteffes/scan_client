import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scan_client/pages/contents/icontent.dart';
import 'package:scan_client/scan_server_api_code/client_index.dart';

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

  Widget getDefaultPadding(Widget child) {
    return Padding(child: child, padding: getDefaultPaddingInsets());
  }

  EdgeInsets getDefaultPaddingInsets(
      {double factorVertical = 1, double factorHorizontal = 1}) {
    return EdgeInsets.symmetric(
        vertical: factorVertical * 10.0, horizontal: factorHorizontal * 10.0);
  }

  /// dropdown with folders (latest selected by default, placeholder while loading)
  Widget getFolderSelection() {
    return Container(
        color: Colors.orange,
        child: getDefaultPadding(
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Ordner:",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          Container(height: 5),
          Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _folders != null && _folders!.isNotEmpty
                    ? Expanded(
                        child: Container(
                        padding: getDefaultPaddingInsets(),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text("Order für Dateianzeige"),
                            isExpanded: true,
                            value: _selectedFolder,
                            icon: const Icon(Icons.arrow_circle_down),
                            onChanged: (String? newValue) {
                              setSetlectedFolder(newValue);
                            },
                            items: List.generate(
                              _folders!.length,
                              (index) => DropdownMenuItem(
                                child: Text(_folders![index]),
                                value: _folders![index],
                              ),
                            ),
                          ),
                        ),
                      ))
                    : CircularProgressIndicator(),
                _folders != null && _folders!.isNotEmpty
                    ? getFolderRefresh()
                    : Container()
              ]),
        ])));
  }

  /// list of files (placeholder while loading)
  Widget getFileList() {
    var fileWidgets = _files?.map((f) => Text(f)).toList() ?? <Text>[];
    return Expanded(
        child: Container(
            width: double.infinity,
            padding: getDefaultPaddingInsets(),
            color: Colors.green,
            child: _files != null
                ? Column(
                    children: fileWidgets,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                : Container(color: Colors.yellow)));
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
      _folders = folders?.take(5).toList();
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
