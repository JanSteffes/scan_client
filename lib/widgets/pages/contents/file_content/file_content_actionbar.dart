import 'package:flutter/material.dart';
import 'package:scan_client/models/file_actions/file_actions.dart';
import 'package:scan_client/models/notifications/file_action_notification.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/models/selection_states.dart';
import 'package:scan_client/scan_server_api_code/scan_server_api.swagger.dart';
import 'package:scan_client/widgets/opacity_wrapper.dart';

class FileActionsBottomAppBar extends StatelessWidget {
  final SelectedFiles selectedFilesRef;
  final ScanServerApi scanServerApi;

  const FileActionsBottomAppBar(
      {Key? key, required this.selectedFilesRef, required this.scanServerApi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];
    var legendButton = getLegendButton(context);
    var selectionState = selectedFilesRef.getSelectionState();
    var selectionStateChanged =
        selectedFilesRef.getPreviousSelectionState() != selectionState;
    switch (selectionState) {
      case SelectionStates.None:
        actions.add(const Spacer());
        break;
      case SelectionStates.Single:
        var singleActions =
            FileActions.values.where((element) => element.singleUseCase);
        actions.addAll(getActionButtonsSided(context, singleActions));
        break;
      case SelectionStates.Multiple:
        var multipleActions =
            FileActions.values.where((element) => element.multipleUseCase);
        actions.addAll(getActionButtonsSided(context, multipleActions));
        break;
    }
    if (selectionStateChanged) {
      actions = actions
          .map((e) => e is Spacer || e == legendButton
              ? e
              : OpacityWrapper(
                  e,
                  milliseconds: 500,
                ))
          .toList();
    }
    actions.add(legendButton);

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(children: actions),
      ),
    );
  }

  /// for list of action, get list of iconbuttons parted by a spacer to their sides
  List<Widget> getActionButtonsSided(
      BuildContext context, Iterable<FileActions> fileActions) {
    var resultList = <Widget>[];
    var leftSide = fileActions
        .where((element) => element.sideToUse == FileActionSide.left)
        .map((e) => getFileActionIconButton(context, e))
        .toList();
    resultList.addAll(leftSide);
    resultList.add(const Spacer());
    var rightSide = fileActions
        .where((element) => element.sideToUse == FileActionSide.right)
        .map((e) => getFileActionIconButton(context, e))
        .toList();
    resultList.addAll(rightSide);
    return resultList;
  }

  /// return iconbutton for fileAction
  Widget getFileActionIconButton(BuildContext context, FileActions fileAction) {
    return IconButton(
        onPressed: () => handleFileAction(context, fileAction),
        icon: Icon(fileAction.icon),
        tooltip: fileAction.caption);
  }

  /// handle action depending on pressed icon
  void handleFileAction(BuildContext context, FileActions fileActions) {
    var fileName = selectedFilesRef.getNameOfFirstFile();
    if (fileName == null) {
      final snackBar = SnackBar(content: Text("Ungültige Datei!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    var folder = selectedFilesRef.getSelectedFolder();
    if (folder == null) {
      final snackBar = SnackBar(content: Text("Ungültiger Ordner!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    FileActionNotification(fileActions, folder!, fileName!).dispatch(context);
  }

  /// Return legend button
  Widget getLegendButton(BuildContext context) {
    return IconButton(
      tooltip: 'Legende',
      icon: const Icon(Icons.info_outline),
      onPressed: () => showLegendDialog(context),
    );
  }

  /// show dialog "explaining" the actions
  void showLegendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
            title: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Icon(Icons.info_outline),
              Container(width: 10),
              Text("Legende")
            ]),
            content: Column(
              children: getLegendDialogChildrens(),
              mainAxisSize: MainAxisSize.min,
            ),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () => Navigator.pop(alertContext),
              )
            ]); // show the dial
      },
    );
  }

  /// Create children for legend dialog
  List<Widget> getLegendDialogChildrens() {
    var actions = <Widget>[];
    FileActions.values.forEach((e) {
      actions.add(getLegendDialogEntry(e.icon, e.caption));
      actions.add(Container(height: 5));
    });
    actions
        .add(getLegendDialogEntry(Icons.scanner_rounded, "Neue Datei scannen"));
    return actions;
  }

  /// single entry of legend dialog listing
  Widget getLegendDialogEntry(IconData icon, String text) {
    return Row(
      children: [Icon(icon), Container(width: 10), Text(text)],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
