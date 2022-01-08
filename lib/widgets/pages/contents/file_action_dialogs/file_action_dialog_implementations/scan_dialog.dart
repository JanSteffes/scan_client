import 'dart:developer';

import 'package:chopper/src/response.dart';
import 'package:flutter/material.dart';
import 'package:scan_client/models/extensions/scan_quality_extension.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/scan_server_api_code/scan_server_api.swagger.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_base.dart';
import 'package:scan_client/widgets/pages/contents/file_content/file_content.dart';

class ScanDialog extends FileActionDialogBase {
  final GlobalKey<FileContentState> _fileContentStateKey;
  // ignore: unused_field
  final SelectedFiles _selectedFilesRef;
  final ScanServerApi _scanServerApi;
  final String _folderName;

  ScanDialog(this._fileContentStateKey, this._selectedFilesRef,
      this._scanServerApi, this._folderName)
      : super(_scanServerApi, _folderName);

  @override
  State<StatefulWidget> createState() {
    return ScanDialogState();
  }
}

class ScanDialogState extends FileActionDialogBaseState<ScanDialog> {
  var success = false;
  var textFieldController = TextEditingController();
  ScanQuality scanQuality = ScanQuality.fast;

  @override
  List<Widget> doneActions() {
    return [
      TextButton(
        child: Text("Ok"),
        onPressed: () {
          Navigator.pop(context);
          widget._fileContentStateKey..currentState?.refreshFiles();
          if (resultFileName != null) {
            widget._selectedFilesRef.addFile(resultFileName!);
          }
        },
      )
    ];
  }

  @override
  String getDoneDialogName() {
    return success ? "Scan abgeschlossen" : "Fehler beim Scannen aufgetreten!";
  }

  @override
  Widget doneContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Scan von"),
      Text("'$resultFileName'", style: TextStyle(fontWeight: FontWeight.bold)),
      Text("${success ? "abgeschlossen" : "fehlgeschlagen"}")
    ]);
  }

  @override
  String getInputDialogName() {
    return "Scannen";
  }

  @override
  String getLoadingDialogName() {
    return "Scanvorgang läuft...";
  }

  @override
  List<Widget> inputActions() {
    return [
      TextButton(
        child: Text("Abbrechen"),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
          child: Text("Scannen"),
          onPressed: () async {
            setState(() {
              loading = true;
            });
            var scanFileName = textFieldController.text;
            if (!scanFileName.endsWith(".pdf")) {
              scanFileName += ".pdf";
            }
            Response<String>? result = null;
            try {
              result = await widget._scanServerApi.apiScanPost(
                  folderName: widget._folderName,
                  fileName: scanFileName,
                  scanQuality: scanQuality);
            } catch (e) {
              log('Error while scanning: ${e}');
            }
            setState(() {
              loading = false;
              done = true;
              success =
                  result != null && result.isSuccessful && result.body != null;
              resultFileName = result != null ? result.body : "";
            });
          })
    ];
  }

  @override
  Widget inputContent() {
    var scanQualityItems = ScanQuality.values
        .map((scanQualityOption) => DropdownMenuItem<ScanQuality>(
            child: Text(scanQualityOption.caption), value: scanQualityOption))
        .toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Odner:"),
      Text(widget._folderName, style: TextStyle(fontWeight: FontWeight.bold)),
      Container(
        height: 20,
      ),
      Text("Scanqualität:"),
      DropdownButton<ScanQuality>(
          items: scanQualityItems,
          value: scanQuality,
          onChanged: (ScanQuality? newValue) {
            if (newValue != null) {
              setState(() {
                scanQuality = newValue;
              });
            }
          }),
      Container(
        height: 20,
      ),
      Text("Scannen als:"),
      TextField(
        controller: textFieldController,
        decoration: InputDecoration(suffixText: ".pdf"),
      )
    ]);
  }
}
