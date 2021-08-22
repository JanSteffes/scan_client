part of swagger.api;

class FileApi {
  final ApiClient apiClient;

  FileApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  ///
  ///
  ///
  Future<bool?> fileDeleteFile(String folder, String fileName) async {
    Object postBody = Object();

    // verify required params are set
    if (folder.isEmpty) {
      throw new ApiException(400, "Missing required param: folder");
    }
    if (fileName.isEmpty) {
      throw new ApiException(400, "Missing required param: fileName");
    }

    // create path and map variables
    String path = "/api/File/DeleteFile/{folder}/{fileName}"
        .replaceAll("{format}", "json")
        .replaceAll("{" + "folder" + "}", folder.toString())
        .replaceAll("{" + "fileName" + "}", fileName.toString());

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};

    List<String> contentTypes = [];

    String contentType =
        contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    var response = await apiClient.invokeAPI(path, 'DELETE', queryParams,
        postBody, headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      return apiClient.deserialize(response.body, 'bool') as bool;
    } else {
      return null;
    }
  }

  ///
  ///
  ///
  Future<String?> fileMergeFiles(
      {required String folder,
      required String resultFileName,
      required List<String> filesToMerge}) async {
    Object postBody = filesToMerge;

    // create path and map variables
    String path = "/api/File/MergeFiles/{folder}/{resultFileName}"
        .replaceAll("{format}", "json")
        .replaceAll("{" + "folder" + "}", folder.toString())
        .replaceAll("{" + "resultFileName" + "}", resultFileName.toString());

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};

    List<String> contentTypes = [
      "application/json",
      "text/json",
      "application/_*+json"
    ];

    String contentType =
        contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    var response = await apiClient.invokeAPI(path, 'POST', queryParams,
        postBody, headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      return apiClient.deserialize(response.body, 'String') as String;
    } else {
      return null;
    }
  }

  ///
  ///
  ///
  Future<MultipartFile?> fileReadFile(
      {required String folder, required String fileName}) async {
    Object postBody = Object();

    // verify required params are set
    if (folder.isEmpty) {
      throw new ApiException(400, "Missing required param: folder");
    }
    if (fileName.isEmpty) {
      throw new ApiException(400, "Missing required param: fileName");
    }

    // create path and map variables
    String path = "/api/File".replaceAll("{format}", "json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};

    queryParams
        .addAll(_convertParametersForCollectionFormat("", "folder", folder));

    queryParams.addAll(
        _convertParametersForCollectionFormat("", "fileToRead", fileName));

    List<String> contentTypes = [];

    String contentType =
        contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    var response = await apiClient.invokeAPI(path, 'GET', queryParams, postBody,
        headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      return apiClient.deserialize(response.body, 'MultipartFile')
          as MultipartFile;
    } else {
      return null;
    }
  }

  ///
  ///
  ///
  Future<List<String>?> fileReadFiles({required String directory}) async {
    Object? postBody;

    // create path and map variables
    String path = "/api/File/ReadFiles".replaceAll("{format}", "json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};

    queryParams.addAll(
        _convertParametersForCollectionFormat("", "directory", directory));

    List<String> contentTypes = [];

    String contentType =
        contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    var response = await apiClient.invokeAPI(path, 'GET', queryParams, null,
        headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      return (apiClient.deserialize(response.body, 'List<String>') as List)
          .map((item) => item as String)
          .toList();
    } else {
      return null;
    }
  }

  ///
  ///
  ///
  Future<List<String>?> fileReadFolders() async {
    Object postBody = Object();

    // verify required params are set

    // create path and map variables
    String path = "/api/File/ReadFolders".replaceAll("{format}", "json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};

    List<String> contentTypes = [];

    String contentType =
        contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    var response = await apiClient.invokeAPI(path, 'GET', queryParams, postBody,
        headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      return (apiClient.deserialize(response.body, 'List<String>') as List)
          .map((item) => item as String)
          .toList();
    } else {
      return null;
    }
  }

  ///
  ///
  ///
  Future<String?> fileRenameFile(
      {required String folder,
      required String oldFileName,
      required String newFileName}) async {
    Object postBody = Object;

    // create path and map variables
    String path = "/api/File/RenameFile/{folder}/{oldFileName}/{newFileName}"
        .replaceAll("{format}", "json")
        .replaceAll("{" + "folder" + "}", folder.toString())
        .replaceAll("{" + "oldFileName" + "}", oldFileName.toString())
        .replaceAll("{" + "newFileName" + "}", newFileName.toString());

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};

    List<String> contentTypes = [];

    String contentType =
        contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    var response = await apiClient.invokeAPI(path, 'PATCH', queryParams,
        postBody, headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      return apiClient.deserialize(response.body, 'String') as String;
    } else {
      return null;
    }
  }
}
