# user_openapi.api.AdminAuditLogsApi

## Load the API package
```dart
import 'package:user_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**auditControllerGetAuditLogs**](AdminAuditLogsApi.md#auditcontrollergetauditlogs) | **GET** /admin/audit-logs | Get audit logs with optional filters


# **auditControllerGetAuditLogs**
> List<Object> auditControllerGetAuditLogs(targetId, actorId, action)

Get audit logs with optional filters

### Example
```dart
import 'package:user_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AdminAuditLogsApi();
final targetId = targetId_example; // String | Filter by Target ID
final actorId = actorId_example; // String | Filter by Actor ID
final action = PARTNER_REVIEW; // String | Filter by Action type

try {
    final result = api_instance.auditControllerGetAuditLogs(targetId, actorId, action);
    print(result);
} catch (e) {
    print('Exception when calling AdminAuditLogsApi->auditControllerGetAuditLogs: $e\n');
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

