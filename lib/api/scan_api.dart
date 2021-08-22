part of swagger.api;



class ScanApi {
  final ApiClient apiClient;

  ScanApi([ApiClient apiClient]) : apiClient = apiClient ?? defaultApiClient;

  /// 
  ///
  /// 
  Future<String> apiScanPost({ String folderName, String fileName, ScanQuality scanQuality }) async {
    Object postBody = null;

    // verify required params are set

    // create path and map variables
    String path = "/api/Scan".replaceAll("{format}","json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};
    if(folderName != null) {
      queryParams.addAll(_convertParametersForCollectionFormat("", "folderName", folderName));
    }
    if(fileName != null) {
      queryParams.addAll(_convertParametersForCollectionFormat("", "fileName", fileName));
    }
    if(scanQuality != null) {
      queryParams.addAll(_convertParametersForCollectionFormat("", "scanQuality", scanQuality));
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
}
