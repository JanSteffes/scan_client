import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scan_client/api/api.dart';
import 'package:scan_client/pages/contents/icontent.dart';

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
  var _fileApi = FileApi();
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
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [getFolderSelection(), getFileList(), getMergeSection()])
        // dropdown with folders (latest selected by default, placeholder while loading)
        // list of files (placeholder while loading)
        // mergestuff if one of the files got selected for merging
        );
  }

  Widget getFolderSelection() {
    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Ordner:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(width: 10),
          _folders != null && _folders!.isNotEmpty
              ? Expanded(
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
                ))
              : CircularProgressIndicator(),
          _folders != null && _folders!.isNotEmpty
              ? getFolderRefresh()
              : Container()
        ]);
  }

  Widget getFileList() {
    return Expanded(
        child: _files != null
            ? Text("Dateien da!")
            : Container(color: Colors.green));
  }

  Widget getMergeSection() {
    return Container(height: 50, color: Colors.red);
  }

  Widget getFolderRefresh() {
    return IconButton(
        onPressed: () async {
          refreshFolders();
        },
        icon: Icon(Icons.refresh, color: Colors.green));
  }

  Future refreshFolders() async {
    // set folders null to trigger refresh sign
    setState(() {
      _folders = null;
      _files = null;
    });
    // get folders and set
    var folders = await _fileApi.fileReadFolders();
    setState(() {
      _folders = folders;
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
    var files = await _fileApi.fileReadFiles(directory: folder);
    setState(() {
      _files = files;
    });
  }
}
