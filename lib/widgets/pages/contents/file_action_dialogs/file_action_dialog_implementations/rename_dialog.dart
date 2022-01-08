import 'package:flutter/material.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_base.dart';
import 'package:scan_client/widgets/pages/contents/file_content/file_content.dart';
import 'package:scan_client/scan_server_api_code/scan_server_api.swagger.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';

class RenameDialog extends FileActionDialogBase {
  final GlobalKey<FileContentState> _fileContentStateKey;
  final SelectedFiles _selectedFilesRef;
  final ScanServerApi _scanServerApi;
  final String _folderName;
  final String _fileName;

  RenameDialog(this._fileContentStateKey, this._selectedFilesRef,
      this._scanServerApi, this._folderName, this._fileName)
      : super(_scanServerApi, _folderName);

  @override
  State<StatefulWidget> createState() {
    return RenameDialogState();
  }
}

class RenameDialogState extends FileActionDialogBaseState<RenameDialog> {
  var textFieldController = TextEditingController();

  @override
  List<Widget> doneActions() {
    return [
      TextButton(
        child: Text("Ok"),
        onPressed: () {
          Navigator.pop(context);
          widget._fileContentStateKey..currentState?.refreshFiles();
          if (resultFileName != null && resultFileName != widget._fileName) {
            widget._selectedFilesRef.addFile(resultFileName!);
          }
        },
      )
    ];
  }

  @override
  List<Widget> inputActions() {
    return [
      TextButton(
        child: Text("Abbrechen"),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
          child: Text("Umbenennen"),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            var renameFileName = textFieldController.text;
            if (!renameFileName.endsWith(".pdf")) {
              renameFileName += ".pdf";
            }
            var result = await widget._scanServerApi
                .apiFileRenameFileFolderOldFileNameNewFileNamePatch(
                    folder: widget._folderName,
                    oldFileName: widget._fileName,
                    newFileName: renameFileName);
            var newName = result.body;
            setState(() {
              loading = false;
              done = true;
              resultFileName = newName;
            });
          })
    ];
  }

  @override
  Widget inputContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Alter Name:"),
        Text(
          widget._fileName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(height: 20),
        Text("Neuer Name:"),
        TextField(
            controller: textFieldController,
            decoration: InputDecoration(suffixText: ".pdf"))
      ],
    );
  }

  @override
  String getDoneDialogName() {
    return "Datei wurde umbenannt";
  }

  @override
  String getInputDialogName() {
    return "Datei umbennen";
  }

  @override
  String getLoadingDialogName() {
    return "Datei wird umbenannt...";
  }
}
