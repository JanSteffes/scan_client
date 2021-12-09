import 'package:flutter/widgets.dart';

/// Keep track of changes on selected files
class SelectedFiles extends ChangeNotifier {
  Map<String, int> _selectedFiles = Map<String, int>();

  /// contains count before last add/remove
  int _lastCount = 0;

  /// get current count
  int getCount() => _selectedFiles.length;

  /// get count of selected items before last change
  int getLastCount() => _lastCount;

  /// return if the last done action was a remove or add
  bool getLastActionWasRemove() => getLastCount() > getCount();

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

  /// return highest index
  int getHighestIndexOfFiles() =>
      _selectedFiles.values.fold<int>(-1, (max, e) => e > max ? e : max);

  /// returns if file is the last selected one, e.g. has the highest index
  bool getFileHasHighestIndex(String fileName) =>
      getSelectedIndexOfFile(fileName) != -1 &&
      getSelectedIndexOfFile(fileName) == getHighestIndexOfFiles();

  /// add file with now next highest index
  void addFile(String fileName) {
    _lastCount = _selectedFiles.length;
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
      _lastCount = _selectedFiles.length;
      var removedFileIndex = _selectedFiles[fileName]!;
      _selectedFiles.remove(fileName);
      // update selection indexes where index was bigger
      _selectedFiles.updateAll((_, v) => v > removedFileIndex ? v - 1 : v);
      notifyListeners();
    }
  }

  /// clear list of selected files
  void clearFiles() {
    _lastCount = _selectedFiles.length;
    _selectedFiles.clear();
    notifyListeners();
  }
}
