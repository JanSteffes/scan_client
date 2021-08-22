# swagger.api.FileApi

## Load the API package
```dart
import 'package:swagger/api.dart';
```

All URIs are relative to */*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiFileDeleteFileFolderFileNameDelete**](FileApi.md#apiFileDeleteFileFolderFileNameDelete) | **DELETE** /api/File/DeleteFile/{folder}/{fileName} | 
[**apiFileGet**](FileApi.md#apiFileGet) | **GET** /api/File | 
[**apiFileMergeFilesFolderResultFileNamePost**](FileApi.md#apiFileMergeFilesFolderResultFileNamePost) | **POST** /api/File/MergeFiles/{folder}/{resultFileName} | 
[**apiFileReadFilesGet**](FileApi.md#apiFileReadFilesGet) | **GET** /api/File/ReadFiles | 
[**apiFileReadFoldersGet**](FileApi.md#apiFileReadFoldersGet) | **GET** /api/File/ReadFolders | 
[**apiFileRenameFileFolderOldFileNameNewFileNamePatch**](FileApi.md#apiFileRenameFileFolderOldFileNameNewFileNamePatch) | **PATCH** /api/File/RenameFile/{folder}/{oldFileName}/{newFileName} | 

# **apiFileDeleteFileFolderFileNameDelete**
> bool apiFileDeleteFileFolderFileNameDelete(folder, fileName)



### Example
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var folder = folder_example; // String | 
var fileName = fileName_example; // String | 

try {
    var result = api_instance.apiFileDeleteFileFolderFileNameDelete(folder, fileName);
    print(result);
} catch (e) {
    print("Exception when calling FileApi->apiFileDeleteFileFolderFileNameDelete: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folder** | **String**|  | 
 **fileName** | **String**|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiFileGet**
> apiFileGet(folder, fileToRead)



### Example
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var folder = folder_example; // String | 
var fileToRead = fileToRead_example; // String | 

try {
    api_instance.apiFileGet(folder, fileToRead);
} catch (e) {
    print("Exception when calling FileApi->apiFileGet: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folder** | **String**|  | [optional] 
 **fileToRead** | **String**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiFileMergeFilesFolderResultFileNamePost**
> String apiFileMergeFilesFolderResultFileNamePost(folder, resultFileName, body)



### Example
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var folder = folder_example; // String | 
var resultFileName = resultFileName_example; // String | 
var body = [new List&lt;String&gt;()]; // List<String> | 

try {
    var result = api_instance.apiFileMergeFilesFolderResultFileNamePost(folder, resultFileName, body);
    print(result);
} catch (e) {
    print("Exception when calling FileApi->apiFileMergeFilesFolderResultFileNamePost: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folder** | **String**|  | 
 **resultFileName** | **String**|  | 
 **body** | [**List&lt;String&gt;**](String.md)|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiFileReadFilesGet**
> List<String> apiFileReadFilesGet(directory)



### Example
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var directory = directory_example; // String | 

try {
    var result = api_instance.apiFileReadFilesGet(directory);
    print(result);
} catch (e) {
    print("Exception when calling FileApi->apiFileReadFilesGet: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **directory** | **String**|  | [optional] 

### Return type

**List<String>**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiFileReadFoldersGet**
> List<String> apiFileReadFoldersGet()



### Example
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();

try {
    var result = api_instance.apiFileReadFoldersGet();
    print(result);
} catch (e) {
    print("Exception when calling FileApi->apiFileReadFoldersGet: $e\n");
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**List<String>**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiFileRenameFileFolderOldFileNameNewFileNamePatch**
> String apiFileRenameFileFolderOldFileNameNewFileNamePatch(folder, oldFileName, newFileName)



### Example
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var folder = folder_example; // String | 
var oldFileName = oldFileName_example; // String | 
var newFileName = newFileName_example; // String | 

try {
    var result = api_instance.apiFileRenameFileFolderOldFileNameNewFileNamePatch(folder, oldFileName, newFileName);
    print(result);
} catch (e) {
    print("Exception when calling FileApi->apiFileRenameFileFolderOldFileNameNewFileNamePatch: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folder** | **String**|  | 
 **oldFileName** | **String**|  | 
 **newFileName** | **String**|  | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

