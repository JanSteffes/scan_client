import 'package:flutter/widgets.dart';
import 'package:scan_client/models/selection_states.dart';
import 'package:collection/collection.dart';

/// Keep track of changes on selected files
class SelectedFiles extends ChangeNotifier {
  /// Map of selected files (name to index of selection)
  Map<String, int> _selectedFiles = Map<String, int>();

  /// Folder that is selected, that the files are contained in
  String? _selectedFolder;

  /// contains count before last add/remove
  int _previousCount = 0;

  /// get current count
  int getCount() => _selectedFiles.length;

  /// get count of selected items before last change
  int getPreviousCount() => _previousCount;

  /// return if the last done action was a remove or add
  bool getLastActionWasRemove() => getPreviousCount() > getCount();

  /// return if file ist currently selected
  bool getFileContained(String fileName) =>
      _selectedFiles.containsKey(fileName);

  /// get index of file, -1 if not contained
  int getSelectedIndexOfFile(String fileName) {
    if (getFileContained(fileName)) {
      return _selectedFiles[fileName]!;
    }
    return -1;
  }

  /// return "state" of selection
  SelectionStates getSelectionState() => getCount() == 0
      ? SelectionStates.None
      : getCount() == 1
          ? SelectionStates.Single
          : SelectionStates.Multiple;

  /// retrun previous state of selection
  SelectionStates getPreviousSelectionState() => getPreviousCount() == 0
      ? SelectionStates.None
      : getPreviousCount() == 1
          ? SelectionStates.Single
          : SelectionStates.Multiple;

  /// return highest index
  int getHighestIndexOfFiles() =>
      _selectedFiles.values.fold<int>(-1, (max, e) => e > max ? e : max);

  /// returns if file is the last selected one, e.g. has the highest index
  bool getFileHasHighestIndex(String fileName) =>
      getSelectedIndexOfFile(fileName) != -1 &&
      getSelectedIndexOfFile(fileName) == getHighestIndexOfFiles();

  /// add file with now next highest index
  void addFile(String fileName) {
    _previousCount = _selectedFiles.length;
    if (_selectedFiles.isEmpty) {
      _selectedFiles[fileName] = 0;
    } else {
      var maxCurrentValues = getHighestIndexOfFiles();
      _selectedFiles[fileName] = maxCurrentValues + 1;
    }
    notifyListeners();
  }

  /// remove file and update index of those with a higher index than the removed
  void removeFile(String fileName) {
    if (_selectedFiles.containsKey(fileName)) {
      _previousCount = _selectedFiles.length;
      var removedFileIndex = _selectedFiles[fileName]!;
      _selectedFiles.remove(fileName);
      // update selection indexes where index was bigger
      _selectedFiles.updateAll((_, v) => v > removedFileIndex ? v - 1 : v);
      notifyListeners();
    }
  }

  /// clear list of selected files
  void clearFiles() {
    _previousCount = _selectedFiles.length;
    _selectedFiles.clear();
    notifyListeners();
  }

  /// set new folder and clear current selected files, if folder is different from current one
  void setFolder(String folderToSelect) {
    if (_selectedFolder != folderToSelect) {
      _selectedFolder = folderToSelect;
      // clear files already has notify Listeners, so i guess no need to call that (again)
      clearFiles();
    }
  }

  /// return the first file by index
  MapEntry<String, int>? getFirstFile() => _selectedFiles.isEmpty
      ? null
      : _selectedFiles.entries
          .firstWhereOrNull((element) => element.value == 0);

  /// return name of first file by index
  String? getNameOfFirstFile() => getFirstFile()?.key;

  /// return name of folder
  String? getSelectedFolder() => _selectedFolder;

  /// remove files that are not contained anymore
  void removeFilesNotContained(List<String>? files) {
    if (files == null) {
      clearFiles();
      return;
    }

    if (getCount() > 0) {
      var names = _selectedFiles.entries.map((e) => e.key).toList();
      names.forEach((fileName) {
        if (!files.contains(fileName)) {
          removeFile(fileName);
        }
      });
    }
  }
}
