import 'package:flutter/material.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/scan_server_api_code/scan_server_api.swagger.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_base.dart';
import 'package:scan_client/widgets/pages/contents/file_content/file_content.dart';

class DeleteDialog extends FileActionDialogBase {
  final GlobalKey<FileContentState> _fileContentStateKey;
  // ignore: unused_field
  final SelectedFiles _selectedFilesRef;
  final ScanServerApi _scanServerApi;
  final String _folderName;
  final String _fileName;

  DeleteDialog(this._fileContentStateKey, this._selectedFilesRef,
      this._scanServerApi, this._folderName, this._fileName)
      : super(_fileContentStateKey, _selectedFilesRef, _scanServerApi,
            _folderName);

  @override
  State<StatefulWidget> createState() {
    return DeleteDialogState();
  }
}

class DeleteDialogState extends FileActionDialogBaseState<DeleteDialog> {
  var success = false;

  @override
  List<Widget> doneActions() {
    return [
      TextButton(
        child: Text("Ok"),
        onPressed: () {
          Navigator.pop(context);
          widget._fileContentStateKey..currentState?.refreshFiles();
        },
      )
    ];
  }

  @override
  String getDoneDialogName() {
    return success ? "Datei gelöscht" : "Fehler beim Löschen der Datei";
  }

  @override
  Widget doneContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Datei"),
      Text(widget._fileName, style: TextStyle(fontWeight: FontWeight.bold)),
      Text("wurde ${success ? "" : "nicht "}gelöscht")
    ]);
  }

  @override
  String getInputDialogName() {
    return "Datei löschen";
  }

  @override
  String getLoadingDialogName() {
    return "Datei wird gelöscht...";
  }

  @override
  List<Widget> inputActions() {
    return [
      TextButton(
        child: Text("Abbrechen"),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
          child: Text("Löschen"),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            var result = await widget._scanServerApi
                .apiFileDeleteFileFolderFileNameDelete(
                    folder: widget._folderName, fileName: widget._fileName);
            setState(() {
              loading = false;
              done = true;
              success = result.isSuccessful && (result.body ?? false);
            });
          })
    ];
  }

  @override
  Widget inputContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Soll die Datei"),
      Text(widget._fileName, style: TextStyle(fontWeight: FontWeight.bold)),
      Text("wirklich gelöscht werden?")
    ]);
  }
}
