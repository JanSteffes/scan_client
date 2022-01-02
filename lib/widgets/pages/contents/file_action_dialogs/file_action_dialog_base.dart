import 'package:flutter/material.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/scan_server_api_code/scan_server_api.swagger.dart';
import 'package:scan_client/widgets/pages/contents/file_content/file_content.dart';

abstract class FileActionDialogBase extends StatefulWidget {
  // ignore: unused_field
  final GlobalKey<FileContentState> _fileContentStateKey;
  final SelectedFiles selectedFilesRef;
  // ignore: unused_field
  final ScanServerApi _scanServerApi;
  // ignore: unused_field
  final String _folderName;

  FileActionDialogBase(this._fileContentStateKey, this.selectedFilesRef,
      this._scanServerApi, this._folderName);
}

abstract class FileActionDialogBaseState<T extends FileActionDialogBase>
    extends State<T> {
  var loading = false;
  var done = false;
  String? resultFileName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actionsPadding: EdgeInsets.all(0),
        title: Text(getDialogName()),
        scrollable: true,
        content: loading
            ? loadingContent()
            : done
                ? doneContent()
                : inputContent(),
        actions: loading
            ? loadingActions()
            : done
                ? doneActions()
                : inputActions()); // show the dial
  }

  Widget loadingContent() {
    return SizedBox(
        height: 50,
        width: 50,
        child: Center(child: CircularProgressIndicator()));
  }

  Widget doneContent() {
    return new Text(resultFileName ?? "");
  }

  Widget inputContent();

  List<Widget> loadingActions() {
    return [
      TextButton(
        child: Text("Abbrechen"),
        onPressed: () => Navigator.pop(context),
      ),
    ];
  }

  List<Widget> doneActions();

  List<Widget> inputActions();

  String getDialogName() {
    if (loading) {
      return getLoadingDialogName();
    }
    if (done) {
      return getDoneDialogName();
    }
    return getInputDialogName();
  }

  String getLoadingDialogName();

  String getDoneDialogName();

  String getInputDialogName();
}
