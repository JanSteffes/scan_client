import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/widgets/opacity_wrapper.dart';

class FileActionsBottomAppBar extends StatelessWidget {
  final SelectedFiles selectedFilesRef;

  const FileActionsBottomAppBar({Key? key, required this.selectedFilesRef})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];
    var legendButton = getLegendButton();
    var selectedFilesCount = selectedFilesRef.getCount();
    if (selectedFilesCount == 1) {
      actions.add(getShowFileButton());
      actions.add(getChangeNameButton());
      actions.add(getShareFileButton());
      actions.add(const Spacer());
      actions.add(getDeleteFileButton());
      actions.add(legendButton);
      if (!selectedFilesRef.getLastActionWasRemove()) {
        actions = actions
            .map(
                (e) => e is Spacer || e == legendButton ? e : OpacityWrapper(e))
            .toList();
      }
    } else if (selectedFilesCount > 1) {
      actions.add(getMergeFilesButton());
      actions.add(const Spacer());
      actions.add(getDeleteFileButton());
      actions.add(legendButton);
    } else {
      actions.add(Container(height: 24 + 16));
      actions.add(const Spacer());
      actions.add(legendButton);
    }
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(children: actions),
      ),
    );
  }

  Widget getShowFileButton() {
    return IconButton(
      tooltip: 'Datei anzeigen',
      icon: const Icon(Icons.image_outlined),
      onPressed: () {},
    );
  }

  Widget getChangeNameButton() {
    return IconButton(
      tooltip: 'Umbenennen',
      icon: const Icon(Icons.text_fields_outlined),
      onPressed: () {},
    );
  }

  Widget getShareFileButton() {
    return IconButton(
      tooltip: 'Teilen',
      icon: const Icon(Icons.share_outlined),
      onPressed: () {},
    );
  }

  Widget getDeleteFileButton() {
    return IconButton(
      tooltip: 'Löschen',
      icon: const Icon(Icons.delete_outline),
      onPressed: () {},
    );
  }

  Widget getMergeFilesButton() {
    return IconButton(
      tooltip: 'Zusammenführen',
      icon: const Icon(Icons.add_to_photos_outlined),
      onPressed: () {},
    );
  }

  Widget getLegendButton() {
    return IconButton(
      tooltip: 'Legende',
      icon: const Icon(Icons.info_outline),
      onPressed: () {},
    );
  }
}
