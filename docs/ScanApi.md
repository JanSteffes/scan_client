# swagger.api.ScanApi

## Load the API package
```dart
import 'package:swagger/api.dart';
```

All URIs are relative to *https://localhost:44309*

Method | HTTP request | Description
------------- | ------------- | -------------
[**scanScan**](ScanApi.md#scanScan) | **POST** /api/Scan | 


# **scanScan**
> String scanScan(folderName, fileName, scanQuality)



### Example 
```dart
import 'package:swagger/api.dart';

var api_instance = new ScanApi();
var folderName = folderName_example; // String | 
var fileName = fileName_example; // String | 
var scanQuality = scanQuality_example; // String | 

try { 
    var result = api_instance.scanScan(folderName, fileName, scanQuality);
    print(result);
} catch (e) {
    print("Exception when calling ScanApi->scanScan: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **folderName** | **String**|  | [optional] 
 **fileName** | **String**|  | [optional] 
 **scanQuality** | **String**|  | [optional] 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

