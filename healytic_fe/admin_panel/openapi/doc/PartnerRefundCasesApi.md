# admin_openapi.api.PartnerRefundCasesApi

## Load the API package
```dart
import 'package:admin_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerRefundCasesControllerApprove**](PartnerRefundCasesApi.md#partnerrefundcasescontrollerapprove) | **POST** /partner/refund-cases/{caseId}/approve | Approve a refund or dispute case
[**partnerRefundCasesControllerGetRefundCases**](PartnerRefundCasesApi.md#partnerrefundcasescontrollergetrefundcases) | **GET** /partner/refund-cases | List refund and dispute cases
[**partnerRefundCasesControllerReject**](PartnerRefundCasesApi.md#partnerrefundcasescontrollerreject) | **POST** /partner/refund-cases/{caseId}/reject | Reject a refund or dispute case


# **partnerRefundCasesControllerApprove**
> PartnerRefundCaseRecordDto partnerRefundCasesControllerApprove(caseId, refundCaseActionDto)

Approve a refund or dispute case

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerRefundCasesApi();
final caseId = caseId_example; // String | 
final refundCaseActionDto = RefundCaseActionDto(); // RefundCaseActionDto | 

try {
    final result = api_instance.partnerRefundCasesControllerApprove(caseId, refundCaseActionDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerRefundCasesApi->partnerRefundCasesControllerApprove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  | 
 **refundCaseActionDto** | [**RefundCaseActionDto**](RefundCaseActionDto.md)|  | 

### Return type

[**PartnerRefundCaseRecordDto**](PartnerRefundCaseRecordDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerRefundCasesControllerGetRefundCases**
> partnerRefundCasesControllerGetRefundCases(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency, page, limit)

List refund and dispute cases

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerRefundCasesApi();
final search = BK-240408; // String | Free-text search (max 120 chars)
final startDate = 2026-04-01; // String | Inclusive start date (ISO 8601)
final endDate = 2026-04-30; // String | Inclusive end date (ISO 8601)
final period = ; // PartnerFinancePeriod | Relative time window (ignored when both startDate and endDate are set)
final sourceType = ; // PartnerCommerceSourceType | Filter by commerce source
final transactionType = ; // PartnerTransactionType | Filter by transaction type
final transactionStatus = ; // PartnerTransactionStatus | Filter by transaction status
final settlementStatus = ; // PartnerSettlementStatus | Filter by settlement status
final payoutStatus = ; // PartnerPayoutStatus | Filter by payout status
final currency = VND; // String | ISO 4217 currency code
final page = 1; // num | Page number (1-indexed)
final limit = 10; // num | Items per page (1-100)

try {
    api_instance.partnerRefundCasesControllerGetRefundCases(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency, page, limit);
} catch (e) {
    print('Exception when calling PartnerRefundCasesApi->partnerRefundCasesControllerGetRefundCases: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**| Free-text search (max 120 chars) | [optional] 
 **startDate** | **String**| Inclusive start date (ISO 8601) | [optional] 
 **endDate** | **String**| Inclusive end date (ISO 8601) | [optional] 
 **period** | [**PartnerFinancePeriod**](.md)| Relative time window (ignored when both startDate and endDate are set) | [optional] 
 **sourceType** | [**PartnerCommerceSourceType**](.md)| Filter by commerce source | [optional] 
 **transactionType** | [**PartnerTransactionType**](.md)| Filter by transaction type | [optional] 
 **transactionStatus** | [**PartnerTransactionStatus**](.md)| Filter by transaction status | [optional] 
 **settlementStatus** | [**PartnerSettlementStatus**](.md)| Filter by settlement status | [optional] 
 **payoutStatus** | [**PartnerPayoutStatus**](.md)| Filter by payout status | [optional] 
 **currency** | **String**| ISO 4217 currency code | [optional] 
 **page** | **num**| Page number (1-indexed) | [optional] [default to 1]
 **limit** | **num**| Items per page (1-100) | [optional] [default to 10]

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **partnerRefundCasesControllerReject**
> PartnerRefundCaseRecordDto partnerRefundCasesControllerReject(caseId, refundCaseActionDto)

Reject a refund or dispute case

### Example
```dart
import 'package:admin_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerRefundCasesApi();
final caseId = caseId_example; // String | 
final refundCaseActionDto = RefundCaseActionDto(); // RefundCaseActionDto | 

try {
    final result = api_instance.partnerRefundCasesControllerReject(caseId, refundCaseActionDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerRefundCasesApi->partnerRefundCasesControllerReject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  | 
 **refundCaseActionDto** | [**RefundCaseActionDto**](RefundCaseActionDto.md)|  | 

### Return type

[**PartnerRefundCaseRecordDto**](PartnerRefundCaseRecordDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

