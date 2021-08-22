# swagger.api.ScanApi

## Load the API package
```dart
import 'package:swagger/api.dart';
```

All URIs are relative to */*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiScanPost**](ScanApi.md#apiScanPost) | **POST** /api/Scan | 

# **apiScanPost**
> String apiScanPost(folderName, fileName, scanQuality)



### Example
```dart
import 'package:swagger/api.dart';

var api_instance = new ScanApi();
var folderName = folderName_example; // String | 
var fileName = fileName_example; // String | 
var scanQuality = ; // ScanQuality | 

try {
    var result = api_instance.apiScanPost(folderName, fileName, scanQuality);
    print(result);
} catch (e) {
    print("Exception when calling ScanApi->apiScanPost: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folderName** | **String**|  | [optional] 
 **fileName** | **String**|  | [optional] 
 **scanQuality** | [**ScanQuality**](.md)|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

