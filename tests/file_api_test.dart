import 'package:swagger/api.dart';
import 'package:test/test.dart';


/// tests for FileApi
void main() {
  var instance = new FileApi();

  group('tests for FileApi', () {
    //Future<bool> apiFileDeleteFileFolderFileNameDelete(String folder, String fileName) async
    test('test apiFileDeleteFileFolderFileNameDelete', () async {
      // TODO
    });

    //Future apiFileGet({ String folder, String fileToRead }) async
    test('test apiFileGet', () async {
      // TODO
    });

    //Future<String> apiFileMergeFilesFolderResultFileNamePost(String folder, String resultFileName, { List<String> body }) async
    test('test apiFileMergeFilesFolderResultFileNamePost', () async {
      // TODO
    });

    //Future<List<String>> apiFileReadFilesGet({ String directory }) async
    test('test apiFileReadFilesGet', () async {
      // TODO
    });

    //Future<List<String>> apiFileReadFoldersGet() async
    test('test apiFileReadFoldersGet', () async {
      // TODO
    });

    //Future<String> apiFileRenameFileFolderOldFileNameNewFileNamePatch(String folder, String oldFileName, String newFileName) async
    test('test apiFileRenameFileFolderOldFileNameNewFileNamePatch', () async {
      // TODO
    });

  });
}
