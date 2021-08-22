# swagger.api.FileApi

## Load the API package
```dart
import 'package:swagger/api.dart';
```

All URIs are relative to *https://localhost:44309*

Method | HTTP request | Description
------------- | ------------- | -------------
[**fileDeleteFile**](FileApi.md#fileDeleteFile) | **DELETE** /api/File/DeleteFile/{folder}/{fileName} | 
[**fileMergeFiles**](FileApi.md#fileMergeFiles) | **POST** /api/File/MergeFiles/{folder}/{resultFileName} | 
[**fileReadFile**](FileApi.md#fileReadFile) | **GET** /api/File | 
[**fileReadFiles**](FileApi.md#fileReadFiles) | **GET** /api/File/ReadFiles | 
[**fileReadFolders**](FileApi.md#fileReadFolders) | **GET** /api/File/ReadFolders | 
[**fileRenameFile**](FileApi.md#fileRenameFile) | **PATCH** /api/File/RenameFile/{folder}/{oldFileName}/{newFileName} | 


# **fileDeleteFile**
> bool fileDeleteFile(folder, fileName)



### Example 
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var folder = folder_example; // String | 
var fileName = fileName_example; // String | 

try { 
    var result = api_instance.fileDeleteFile(folder, fileName);
    print(result);
} catch (e) {
    print("Exception when calling FileApi->fileDeleteFile: $e\n");
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

# **fileMergeFiles**
> String fileMergeFiles(folder, resultFileName, filesToMerge)



### Example 
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var folder = folder_example; // String | 
var resultFileName = resultFileName_example; // String | 
var filesToMerge = [new List&lt;String&gt;()]; // List<String> | 

try { 
    var result = api_instance.fileMergeFiles(folder, resultFileName, filesToMerge);
    print(result);
} catch (e) {
    print("Exception when calling FileApi->fileMergeFiles: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folder** | **String**|  | 
 **resultFileName** | **String**|  | 
 **filesToMerge** | **List&lt;String&gt;**|  | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/_*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **fileReadFile**
> MultipartFile fileReadFile(folder, fileToRead)



### Example 
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var folder = folder_example; // String | 
var fileToRead = fileToRead_example; // String | 

try { 
    var result = api_instance.fileReadFile(folder, fileToRead);
    print(result);
} catch (e) {
    print("Exception when calling FileApi->fileReadFile: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folder** | **String**|  | [optional] 
 **fileToRead** | **String**|  | [optional] 

### Return type

[**MultipartFile**](File.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **fileReadFiles**
> List<String> fileReadFiles(directory)



### Example 
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var directory = directory_example; // String | 

try { 
    var result = api_instance.fileReadFiles(directory);
    print(result);
} catch (e) {
    print("Exception when calling FileApi->fileReadFiles: $e\n");
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

# **fileReadFolders**
> List<String> fileReadFolders()



### Example 
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();

try { 
    var result = api_instance.fileReadFolders();
    print(result);
} catch (e) {
    print("Exception when calling FileApi->fileReadFolders: $e\n");
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

# **fileRenameFile**
> String fileRenameFile(folder, oldFileName, newFileName)



### Example 
```dart
import 'package:swagger/api.dart';

var api_instance = new FileApi();
var folder = folder_example; // String | 
var oldFileName = oldFileName_example; // String | 
var newFileName = newFileName_example; // String | 

try { 
    var result = api_instance.fileRenameFile(folder, oldFileName, newFileName);
    print(result);
} catch (e) {
    print("Exception when calling FileApi->fileRenameFile: $e\n");
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

