# employee_openapi.api.PartnerPayoutsApi

## Load the API package
```dart
import 'package:employee_openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**partnerPayoutsControllerGetPayouts**](PartnerPayoutsApi.md#partnerpayoutscontrollergetpayouts) | **GET** /partner/payouts | List partner payouts with filters and pagination
[**partnerPayoutsControllerRetryPayout**](PartnerPayoutsApi.md#partnerpayoutscontrollerretrypayout) | **POST** /partner/payouts/{payoutId}/retry | Retry a failed payout


# **partnerPayoutsControllerGetPayouts**
> partnerPayoutsControllerGetPayouts(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency, page, limit)

List partner payouts with filters and pagination

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerPayoutsApi();
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
    api_instance.partnerPayoutsControllerGetPayouts(search, startDate, endDate, period, sourceType, transactionType, transactionStatus, settlementStatus, payoutStatus, currency, page, limit);
} catch (e) {
    print('Exception when calling PartnerPayoutsApi->partnerPayoutsControllerGetPayouts: $e\n');
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

# **partnerPayoutsControllerRetryPayout**
> PartnerPayoutRecordDto partnerPayoutsControllerRetryPayout(payoutId, retryPayoutDto)

Retry a failed payout

### Example
```dart
import 'package:employee_openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearer
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearer').setAccessToken(yourTokenGeneratorFunction);

final api_instance = PartnerPayoutsApi();
final payoutId = payoutId_example; // String | 
final retryPayoutDto = RetryPayoutDto(); // RetryPayoutDto | 

try {
    final result = api_instance.partnerPayoutsControllerRetryPayout(payoutId, retryPayoutDto);
    print(result);
} catch (e) {
    print('Exception when calling PartnerPayoutsApi->partnerPayoutsControllerRetryPayout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **payoutId** | **String**|  | 
 **retryPayoutDto** | [**RetryPayoutDto**](RetryPayoutDto.md)|  | 

### Return type

[**PartnerPayoutRecordDto**](PartnerPayoutRecordDto.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

