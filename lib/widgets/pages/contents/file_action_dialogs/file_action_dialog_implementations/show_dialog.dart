import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scan_client/helpers/file_helper.dart';
import 'package:scan_client/widgets/pages/contents/file_action_dialogs/file_action_dialog_base.dart';
import 'package:scan_client/scan_server_api_code/scan_server_api.swagger.dart';
import 'package:scan_client/widgets/pages/contents/file_content/file_content_show_file.dart';

class ShowDialog extends FileActionDialogBase {
  final ScanServerApi _scanServerApi;
  final String _folderName;
  final String _fileName;

  ShowDialog(this._scanServerApi, this._folderName, this._fileName)
      : super(_scanServerApi, _folderName);

  @override
  State<StatefulWidget> createState() {
    return ShowDialogState();
  }
}

class ShowDialogState extends FileActionDialogBaseState<ShowDialog> {
  var textFieldController = TextEditingController();
  Uint8List? fileData;

  @override
  void initState() {
    super.initState();
    // starts directly in loading, there's no input here
    loading = true;
    loadFileData();
  }

  @override
  Widget doneContent() {
    if (fileData != null) {
      try {
        return FileContentShowFile(
            fileName: widget._fileName, documentData: fileData!);
      } on Exception catch (e) {
        log("Error while creating image preview of '${widget._fileName}': ${e.toString()}");
      }
    }
    return Icon(Icons.error, color: Colors.red);
  }

  @override
  List<Widget> doneActions() {
    return [
      TextButton(
        child: Text("Ok"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ];
  }

  @override
  List<Widget> inputActions() {
    throw UnimplementedError("Input is not to be used in ShowDialog!");
  }

  @override
  Widget inputContent() {
    throw UnimplementedError("Input is not to be used in ShowDialog!");
  }

  @override
  String getDoneDialogName() {
    return "Datei '${widget._fileName}'";
  }

  @override
  String getInputDialogName() {
    throw UnimplementedError("Input is not to be used in showDialog!");
  }

  @override
  String getLoadingDialogName() {
    return "Datei '${widget._fileName}' wird geladen...";
  }

  Future loadFileData() async {
    try {
      var data = await FileHelper.getFileData(
          widget._scanServerApi, widget._folderName, widget._fileName);
      fileData = data;
    } on Exception catch (e) {
      log("Error while creating image preview of '${widget._fileName}': ${e.toString()}");
    }
    setState(() {
      loading = false;
      done = true;
    });
  }
}
