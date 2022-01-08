import 'package:flutter/material.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/scan_server_api_code/scan_server_api.swagger.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_base.dart';
import 'package:scan_client/widgets/pages/contents/file_content/file_content.dart';

class MergeDialog extends FileActionDialogBase {
  final GlobalKey<FileContentState> _fileContentStateKey;
  final SelectedFiles selectedFilesRef;
  final ScanServerApi _scanServerApi;
  final String _folderName;
  final List<String> _mergeFiles;

  MergeDialog(this._fileContentStateKey, this.selectedFilesRef,
      this._scanServerApi, this._folderName, this._mergeFiles)
      : super(_scanServerApi, _folderName);

  @override
  MergeDialogState createState() => MergeDialogState();
}

class MergeDialogState extends FileActionDialogBaseState<MergeDialog> {
  var textFieldController = TextEditingController();

  Widget doneContent() {
    return new Text(resultFileName ?? "");
  }

  Widget inputContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dateiname:"),
        TextField(
          controller: textFieldController,
          decoration: InputDecoration(suffixText: ".pdf"),
        )
      ],
    );
  }

  List<Widget> loadingActions() {
    return [
      TextButton(
        child: Text("Abbrechen"),
        onPressed: () => Navigator.pop(context),
      ),
    ];
  }

  List<Widget> doneActions() {
    return [
      TextButton(
        child: Text("Ok"),
        onPressed: () {
          Navigator.pop(context);
          widget._fileContentStateKey..currentState?.refreshFiles();
          if (resultFileName != null && resultFileName != "fileName") {
            widget.selectedFilesRef.clearFiles();
            widget.selectedFilesRef.addFile(resultFileName!);
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
          child: Text("Zusammenführen"),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            var mergeFileName = textFieldController.text;
            if (!mergeFileName.endsWith(".pdf")) {
              mergeFileName += ".pdf";
            }
            var result = await widget._scanServerApi
                .apiFileMergeFilesFolderResultFileNamePost(
                    folder: widget._folderName,
                    resultFileName: mergeFileName,
                    filesToMerge: widget._mergeFiles);
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
  String getDoneDialogName() {
    return "Dateien wurden zusammengeführt";
  }

  @override
  String getInputDialogName() {
    return "Dateien zusammenführen";
  }

  @override
  String getLoadingDialogName() {
    return "Dateien werden zusammangelegt...";
  }
}
