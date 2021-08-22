part of swagger.api;



class FileApi {
  final ApiClient apiClient;

  FileApi([ApiClient apiClient]) : apiClient = apiClient ?? defaultApiClient;

  /// 
  ///
  /// 
  Future<bool> apiFileDeleteFileFolderFileNameDelete(String folder, String fileName) async {
    Object postBody = null;

    // verify required params are set
    if(folder == null) {
     throw new ApiException(400, "Missing required param: folder");
    }
    if(fileName == null) {
     throw new ApiException(400, "Missing required param: fileName");
    }

    // create path and map variables
    String path = "/api/File/DeleteFile/{folder}/{fileName}".replaceAll("{format}","json").replaceAll("{" + "folder" + "}", folder.toString()).replaceAll("{" + "fileName" + "}", fileName.toString());

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};
    
    List<String> contentTypes = [];

    String contentType = contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    if(contentType.startsWith("multipart/form-data")) {
      bool hasFields = false;
      MultipartRequest mp = new MultipartRequest(null, null);
      if(hasFields)
        postBody = mp;
    }
    else {
          }

    var response = await apiClient.invokeAPI(path,
                                             'DELETE',
                                             queryParams,
                                             postBody,
                                             headerParams,
                                             formParams,
                                             contentType,
                                             authNames);

    if(response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if(response.body != null) {
      return
          apiClient.deserialize(response.body, 'bool') as bool ;
    } else {
      return null;
    }
  }
  /// 
  ///
  /// 
  Future apiFileGet({ String folder, String fileToRead }) async {
    Object postBody = null;

    // verify required params are set

    // create path and map variables
    String path = "/api/File".replaceAll("{format}","json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};
    if(folder != null) {
      queryParams.addAll(_convertParametersForCollectionFormat("", "folder", folder));
    }
    if(fileToRead != null) {
      queryParams.addAll(_convertParametersForCollectionFormat("", "fileToRead", fileToRead));
    }
    
    List<String> contentTypes = [];

    String contentType = contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    if(contentType.startsWith("multipart/form-data")) {
      bool hasFields = false;
      MultipartRequest mp = new MultipartRequest(null, null);
      if(hasFields)
        postBody = mp;
    }
    else {
          }

    var response = await apiClient.invokeAPI(path,
                                             'GET',
                                             queryParams,
                                             postBody,
                                             headerParams,
                                             formParams,
                                             contentType,
                                             authNames);

    if(response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if(response.body != null) {
      return
          ;
    } else {
      return ;
    }
  }
  /// 
  ///
  /// 
  Future<String> apiFileMergeFilesFolderResultFileNamePost(String folder, String resultFileName, { List<String> body }) async {
    Object postBody = body;

    // verify required params are set
    if(folder == null) {
     throw new ApiException(400, "Missing required param: folder");
    }
    if(resultFileName == null) {
     throw new ApiException(400, "Missing required param: resultFileName");
    }

    // create path and map variables
    String path = "/api/File/MergeFiles/{folder}/{resultFileName}".replaceAll("{format}","json").replaceAll("{" + "folder" + "}", folder.toString()).replaceAll("{" + "resultFileName" + "}", resultFileName.toString());

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};
    
    List<String> contentTypes = ["application/json","text/json","application/_*+json"];

    String contentType = contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    if(contentType.startsWith("multipart/form-data")) {
      bool hasFields = false;
      MultipartRequest mp = new MultipartRequest(null, null);
      if(hasFields)
        postBody = mp;
    }
    else {
          }

    var response = await apiClient.invokeAPI(path,
                                             'POST',
                                             queryParams,
                                             postBody,
                                             headerParams,
                                             formParams,
                                             contentType,
                                             authNames);

    if(response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if(response.body != null) {
      return
          apiClient.deserialize(response.body, 'String') as String ;
    } else {
      return null;
    }
  }
  /// 
  ///
  /// 
  Future<List<String>> apiFileReadFilesGet({ String directory }) async {
    Object postBody = null;

    // verify required params are set

    // create path and map variables
    String path = "/api/File/ReadFiles".replaceAll("{format}","json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};
    if(directory != null) {
      queryParams.addAll(_convertParametersForCollectionFormat("", "directory", directory));
    }
    
    List<String> contentTypes = [];

    String contentType = contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    if(contentType.startsWith("multipart/form-data")) {
      bool hasFields = false;
      MultipartRequest mp = new MultipartRequest(null, null);
      if(hasFields)
        postBody = mp;
    }
    else {
          }

    var response = await apiClient.invokeAPI(path,
                                             'GET',
                                             queryParams,
                                             postBody,
                                             headerParams,
                                             formParams,
                                             contentType,
                                             authNames);

    if(response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if(response.body != null) {
      return
        (apiClient.deserialize(response.body, 'List<String>') as List).map((item) => item as String).toList();
    } else {
      return null;
    }
  }
  /// 
  ///
  /// 
  Future<List<String>> apiFileReadFoldersGet() async {
    Object postBody = null;

    // verify required params are set

    // create path and map variables
    String path = "/api/File/ReadFolders".replaceAll("{format}","json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};
    
    List<String> contentTypes = [];

    String contentType = contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    if(contentType.startsWith("multipart/form-data")) {
      bool hasFields = false;
      MultipartRequest mp = new MultipartRequest(null, null);
      if(hasFields)
        postBody = mp;
    }
    else {
          }

    var response = await apiClient.invokeAPI(path,
                                             'GET',
                                             queryParams,
                                             postBody,
                                             headerParams,
                                             formParams,
                                             contentType,
                                             authNames);

    if(response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if(response.body != null) {
      return
        (apiClient.deserialize(response.body, 'List<String>') as List).map((item) => item as String).toList();
    } else {
      return null;
    }
  }
  /// 
  ///
  /// 
  Future<String> apiFileRenameFileFolderOldFileNameNewFileNamePatch(String folder, String oldFileName, String newFileName) async {
    Object postBody = null;

    // verify required params are set
    if(folder == null) {
     throw new ApiException(400, "Missing required param: folder");
    }
    if(oldFileName == null) {
     throw new ApiException(400, "Missing required param: oldFileName");
    }
    if(newFileName == null) {
     throw new ApiException(400, "Missing required param: newFileName");
    }

    // create path and map variables
    String path = "/api/File/RenameFile/{folder}/{oldFileName}/{newFileName}".replaceAll("{format}","json").replaceAll("{" + "folder" + "}", folder.toString()).replaceAll("{" + "oldFileName" + "}", oldFileName.toString()).replaceAll("{" + "newFileName" + "}", newFileName.toString());

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};
    
    List<String> contentTypes = [];

    String contentType = contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    if(contentType.startsWith("multipart/form-data")) {
      bool hasFields = false;
      MultipartRequest mp = new MultipartRequest(null, null);
      if(hasFields)
        postBody = mp;
    }
    else {
          }

    var response = await apiClient.invokeAPI(path,
                                             'PATCH',
                                             queryParams,
                                             postBody,
                                             headerParams,
                                             formParams,
                                             contentType,
                                             authNames);

    if(response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if(response.body != null) {
      return
          apiClient.deserialize(response.body, 'String') as String ;
    } else {
      return null;
    }
  }
}
