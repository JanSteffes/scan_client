import 'dart:developer';
import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/scan_server_api_code/scan_server_api.swagger.dart';

class FileHelper {
  // retrieve thumbnaildata and save it to caches
  static Future<Uint8List?> getThumbnailData(
      SelectedFiles selectedFilesRef,
      Map<String, dynamic> cache,
      ScanServerApi scanServerApi,
      String fileName) async {
    var cacheKey = "${selectedFilesRef.getSelectedFolder()}_$fileName";
    if (cache.containsKey(cacheKey)) {
      var data = cache[cacheKey];
      if (data == null) {
        return Future.error("No data available", StackTrace.current);
      }
      return data;
    }

    Response<String>? data;
    try {
      data = await scanServerApi.apiFileGetThumbnailOfFileFolderFileNameGet(
          folder: selectedFilesRef.getSelectedFolder(), fileName: fileName);
    } on Exception catch (e) {
      log("Errpr while getting tumbnaildata of '$fileName': ${e.toString()}");
    }
    if (data != null && data.isSuccessful) {
      cache[cacheKey] = data.bodyBytes;
    } else {
      cache[cacheKey] = null;
    }
    return getThumbnailData(selectedFilesRef, cache, scanServerApi, fileName);
  }

  /// load file data
  static Future<Uint8List?> getFileData(
      ScanServerApi scanServerApi, String folder, String fileName) async {
    Response<String>? data;
    try {
      data =
          await scanServerApi.apiFileGet(folder: folder, fileToRead: fileName);
    } on Exception catch (e) {
      log("Error while getting tumbnaildata of '$fileName': ${e.toString()}");
      return null;
    }
    return data.bodyBytes;
  }
}
