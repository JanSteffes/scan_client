part of swagger.api;

class ScanApi {
  final ApiClient apiClient;

  ScanApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  ///
  ///
  ///
  Future<String?> scanScan(
      {required String folderName,
      required String fileName,
      required ScanQuality scanQuality}) async {
    Object postBody = Object();

    // verify required params are set

    // create path and map variables
    String path = "/api/Scan".replaceAll("{format}", "json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {};
    Map<String, String> formParams = {};
    queryParams.addAll(
        _convertParametersForCollectionFormat("", "folderName", folderName));
    queryParams.addAll(
        _convertParametersForCollectionFormat("", "fileName", fileName));
    queryParams.addAll(
        _convertParametersForCollectionFormat("", "scanQuality", scanQuality));

    List<String> contentTypes = [];

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
}
