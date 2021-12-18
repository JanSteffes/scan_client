//Generated code

part of 'scan_server_api.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ScanServerApi extends ScanServerApi {
  _$ScanServerApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ScanServerApi;

  @override
  Future<Response<String>> apiFileMergeFilesFolderResultFileNamePost(
      {required String? folder,
      required String? resultFileName,
      required List<String>? filesToMerge}) {
    final $url = '/api/File/MergeFiles/$folder/$resultFileName';
    final $body = filesToMerge;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<bool>> apiFileDeleteFileFolderFileNameDelete(
      {required String? folder, required String? fileName}) {
    final $url = '/api/File/DeleteFile/$folder/$fileName';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<bool, bool>($request);
  }

  @override
  Future<Response<String>> apiFileGet({String? folder, String? fileToRead}) {
    final $url = '/api/File';
    final $params = <String, dynamic>{
      'folder': folder,
      'fileToRead': fileToRead
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<List<String>>> apiFileReadFilesGet({String? directory}) {
    final $url = '/api/File/ReadFiles';
    final $params = <String, dynamic>{'directory': directory};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<List<String>, String>($request);
  }

  @override
  Future<Response<String>> apiFileRenameFileFolderOldFileNameNewFileNamePatch(
      {required String? folder,
      required String? oldFileName,
      required String? newFileName}) {
    final $url = '/api/File/RenameFile/$folder/$oldFileName/$newFileName';
    final $request = Request('PATCH', $url, client.baseUrl);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<List<String>>> apiFileReadFoldersGet() {
    final $url = '/api/File/ReadFolders';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<String>, String>($request);
  }

  @override
  Future<Response<String>> apiFileGetThumbnailOfFileFolderFileNameGet(
      {required String? folder, required String? fileName}) {
    final $url = '/api/File/GetThumbnailOfFile/$folder/$fileName';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> apiScanPost(
      {String? folderName, String? fileName, String? scanQuality}) {
    final $url = '/api/Scan';
    final $params = <String, dynamic>{
      'folderName': folderName,
      'fileName': fileName,
      'scanQuality': scanQuality
    };
    final $request = Request('POST', $url, client.baseUrl, parameters: $params);
    return client.send<String, String>($request);
  }
}
