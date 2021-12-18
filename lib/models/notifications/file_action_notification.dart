import 'package:flutter/widgets.dart';
import 'package:scan_client/models/file_actions/file_actions.dart';

///Notification to handle simple actions like see, share and delete
class FileActionNotification extends Notification {
  final String folderName;
  final String fileName;
  final FileActions fileAction;

  FileActionNotification(this.fileAction, this.folderName, this.fileName);
}

/// more specified notification to handle renaming
class FileActionNotificationRename extends FileActionNotification {
  final String newFileName;

  FileActionNotificationRename(FileActions fileAction, String folderName,
      String fileName, this.newFileName)
      : super(fileAction, folderName, fileName);
}
