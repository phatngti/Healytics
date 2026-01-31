# admin_openapi.api.AuditLogsApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**auditControllerGetAuditLogs**](AuditLogsApi.md#auditcontrollergetauditlogs) | **GET** /audit-logs | Get audit logs


# **auditControllerGetAuditLogs**
> List<Object> auditControllerGetAuditLogs(targetId, actorId, action)

Get audit logs

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AuditLogsApi();
final targetId = targetId_example; // String | Filter by Target ID
final actorId = actorId_example; // String | Filter by Actor ID
final action = action_example; // String | Filter by Action type

try {
    final result = api_instance.auditControllerGetAuditLogs(targetId, actorId, action);
    print(result);
} catch (e) {
    print('Exception when calling AuditLogsApi->auditControllerGetAuditLogs: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **targetId** | **String**| Filter by Target ID | [optional] 
 **actorId** | **String**| Filter by Actor ID | [optional] 
 **action** | **String**| Filter by Action type | [optional] 

### Return type

[**List<Object>**](Object.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

